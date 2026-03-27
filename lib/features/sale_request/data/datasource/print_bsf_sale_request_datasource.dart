import 'dart:convert';

import 'package:celta_inventario/utils/utils.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter_esc_pos_network/flutter_esc_pos_network.dart';
import 'package:intl/intl.dart';

import '../models/models.dart';
import 'datasource.dart';

class PrintBSFSaleRequestDatasource implements IPrintBSFSaleRequestDatasource {
  CapabilityProfile? _cachedProfile;

  @override
  Future<void> print({
    required BSFSaleRequestModel saleRequest,
    required String ip,
    required String userName,
  }) async {
    final printer = PrinterNetworkManager(
      ip,
      port: 9100,
      timeout: const Duration(seconds: 30),
    );

    final PosPrintResult res = await printer.connect(
      timeout: const Duration(seconds: 30),
    );

    if (res != PosPrintResult.success) {
      throw Exception(
        'Ocorreu um erro para conectar com a impressora\n\n"${res.msg}"\n\nConfirme se o IP da impressora está correto, se ela está com bobina e se ela está ligada. Caso não resolva, reinicie ela e tente novamente',
      );
    }

    try {
      _cachedProfile ??= await CapabilityProfile.load();

      final List<int> bytes = _generateTicket(
        saleRequest: saleRequest,
        userName: userName,
        profile: _cachedProfile!,
      );

      await printer.printTicket(bytes);
    } catch (e) {
      throw Exception('Ocorreu um erro ao imprimir o pedido\n\n$e');
    } finally {
      await printer.disconnect();
    }
  }

  List<int> _generateTicket({
    required BSFSaleRequestModel saleRequest,
    required String userName,
    required CapabilityProfile profile,
  }) {
    final generator = Generator(PaperSize.mm80, _cachedProfile!);
    List<int> bytes = [];

    final saleRequestNumber = saleRequest.personalizedCode;
    final lastFourNumbers = saleRequestNumber?.substring(8);

    bytes += generator.text(
      'PEDIDO DE VENDA $lastFourNumbers',
      styles: const PosStyles(
        align: PosAlign.center,
        bold: true,
        height: PosTextSize.size2,
      ),
    );
    bytes += generator.text(
      "Impresso em ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}",
      styles: const PosStyles(align: PosAlign.center),
    );
    bytes += generator.text(
      'Pedido: $saleRequestNumber',
      styles: const PosStyles(align: PosAlign.left),
    );
    bytes += generator.text(
      'Cliente: ${saleRequest.customer?.name ?? "N/A"}',
      styles: const PosStyles(align: PosAlign.left),
    );
    bytes += generator.text(
      'Usuario: $userName',
      styles: const PosStyles(align: PosAlign.left),
    );
    bytes += generator.hr();

    double totalDiscount = 0;
    double totalLiquid = 0;
    double totalGross = 0;

    if (saleRequest.products?.isNotEmpty ?? false) {
      for (final cartProduct
          in saleRequest.products ?? <BSFProductItemModel>[]) {
        final itemLiquidValue = cartProduct.toEntity().totalLiquid;
        final itemGrossValue =
            (cartProduct.value ?? 0) * (cartProduct.quantity ?? 0);
        final ean = cartProduct.eanCode;
        final eanOrPlu = ean?.isNotEmpty == true
            ? ean
            : cartProduct.product?.productPackingPriceLookUpString;

        totalDiscount += cartProduct.toEntity().totalDiscountValue;
        totalLiquid += itemLiquidValue;
        totalGross += itemGrossValue;

        bytes += generator.row([
          PosColumn(
            textEncoded: latin1.encode(
              "($eanOrPlu) ${cartProduct.product?.name}",
            ),
            width: 12,
            styles: const PosStyles(bold: true),
          ),
        ]);

        bytes += generator.row([
          PosColumn(
            text: "",
            width: 2,
            styles: const PosStyles(align: PosAlign.right),
          ),
          PosColumn(
            text: cartProduct.quantity.toString().toBrazilianNumber(3, true),
            width: 3,
            styles: const PosStyles(align: PosAlign.center),
          ),
          PosColumn(
            text: "x",
            width: 1,
            styles: const PosStyles(align: PosAlign.center),
          ),
          PosColumn(
            text: cartProduct.toEntity().value.toString().toBrazilianNumber(),
            width: 2,
            styles: const PosStyles(align: PosAlign.center),
          ),
          PosColumn(
            text: "=",
            width: 1,
            styles: const PosStyles(align: PosAlign.center),
          ),
          PosColumn(
            text: itemGrossValue.toString().toBrazilianNumber(),
            width: 3,
            styles: const PosStyles(align: PosAlign.right),
          ),
        ]);

        if (totalDiscount > 0) {
          bytes += generator.row([
            PosColumn(
              text:
                  "- ${cartProduct.toEntity().totalDiscountValue.toString().toBrazilianNumber()} de desconto",
              width: 8,
              styles: const PosStyles(align: PosAlign.right),
            ),
            PosColumn(
              text: "=",
              width: 1,
              styles: const PosStyles(align: PosAlign.center),
            ),
            PosColumn(
              text: cartProduct
                  .toEntity()
                  .totalLiquid
                  .toString()
                  .toBrazilianNumber(),
              width: 3,
              styles: const PosStyles(align: PosAlign.right),
            ),
          ]);
        }
      }
    }

    bytes += generator.hr();

    if (totalDiscount > 0) {
      bytes += generator.row([
        PosColumn(textEncoded: latin1.encode('Subtotal R\$'), width: 6),
        PosColumn(
          text: totalGross.toStringAsFixed(2).toBrazilianNumber(),
          width: 6,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
      bytes += generator.row([
        PosColumn(textEncoded: latin1.encode('Total descontos R\$'), width: 6),
        PosColumn(
          text: totalDiscount.toStringAsFixed(2).toBrazilianNumber(),
          width: 6,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
    }

    bytes += generator.row([
      PosColumn(
        textEncoded: latin1.encode('TOTAL R\$ '),
        width: 6,
        styles: const PosStyles(bold: true, height: PosTextSize.size2),
      ),
      PosColumn(
        text: totalLiquid.toStringAsFixed(2).toBrazilianNumber(),
        width: 6,
        styles: const PosStyles(
          align: PosAlign.right,
          bold: true,
          height: PosTextSize.size2,
        ),
      ),
    ]);

    final observations = saleRequest.observations ?? '';
    final instructions = saleRequest.instructions ?? '';

    if (observations.isNotEmpty || instructions.isNotEmpty) {
      bytes += generator.hr();
    }

    if (observations.isNotEmpty) {
      bytes += generator.text(
        'Observacoes ',
        styles: const PosStyles(bold: true),
      );
      bytes += generator.text(
        observations.removeAccents(),
        styles: const PosStyles(align: PosAlign.left),
      );
    }
    if (instructions.isNotEmpty) {
      bytes += generator.text(
        'Instrucoes ',
        styles: const PosStyles(bold: true),
      );
      bytes += generator.text(
        instructions.removeAccents(),
        styles: const PosStyles(align: PosAlign.left),
      );
    }

    bytes += generator.feed(2);
    bytes += generator.cut();
    return bytes;
  }
}
