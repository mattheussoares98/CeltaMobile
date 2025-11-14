import 'dart:convert';

import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter_esc_pos_network/flutter_esc_pos_network.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:intl/intl.dart';

import '../models/models.dart';
import 'datasource.dart';

class PrintLastSavedSaleRequestDatasource
    implements IPrintLastSavedSaleRequestDatasource {
  @override
  Future<bool> print({
    required LastSavedSaleRequestModel saleRequest,
    required String ip,
    required String userName,
  }) async {
    final printer = PrinterNetworkManager(ip, port: 9100);

    final PosPrintResult res = await printer.connect(
      timeout: const Duration(seconds: 5),
    );

    if (res != PosPrintResult.success) {
      throw Exception(
        'Ocorreu um erro para conectar com a impressora\n\n"${res.msg}"\n\nConfirme se o IP da impressora está correto, se ela está com bobina e se ela está ligada. Caso não resolva, reinicie ela e tente novamente',
      );
    }

    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    List<int> bytes = [];

    final saleRequestNumber = saleRequest.saleRequestNumber.replaceAll(
      RegExp(r'\D'),
      '',
    );
    final lastFourNumbers = saleRequestNumber.substring(8);

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
      'Cliente: ${saleRequest.pendingSaleRequestModel.customer?.Name ?? "N/A"}',
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

    if (saleRequest.pendingSaleRequestModel.cart.values.isNotEmpty) {
      for (final cartProduct
          in saleRequest.pendingSaleRequestModel.cart.values) {
        final itemLiquidValue = cartProduct.toEntity().getTotalLiquid;
        final itemGrossValue = cartProduct.Value * cartProduct.Quantity;
        final eans = cartProduct.product?.EANs ?? [];
        final eanOrPlu = eans.isNotEmpty && eans.first.isNotEmpty
            ? eans.first
            : cartProduct.product?.PLU;

        totalDiscount += cartProduct.DiscountValue ?? 0;
        totalLiquid += itemLiquidValue;
        totalGross += itemGrossValue;

        bytes += generator.row([
          PosColumn(
            textEncoded: latin1.encode(
              "($eanOrPlu) ${cartProduct.product?.Name}",
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
            text: cartProduct.Quantity.toString().toBrazilianNumber(3, true),
            width: 3,
            styles: const PosStyles(align: PosAlign.center),
          ),
          PosColumn(
            text: "x",
            width: 1,
            styles: const PosStyles(align: PosAlign.center),
          ),
          PosColumn(
            text: cartProduct.toEntity().Value.toString().toBrazilianNumber(),
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
                  "- ${cartProduct.DiscountValue.toString().toBrazilianNumber()} de desconto",
              width: 8,
              styles: const PosStyles(align: PosAlign.right),
            ),
            PosColumn(
              text: "=",
              width: 1,
              styles: const PosStyles(align: PosAlign.center),
            ),
            PosColumn(
              text: cartProduct.TotalLiquid.toString().toBrazilianNumber(),
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

    final observations = saleRequest.pendingSaleRequestModel.observations ?? '';
    final instructions = saleRequest.pendingSaleRequestModel.instructions ?? '';

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

    await printer.printTicket(bytes);
    await printer.disconnect();
    return true;
  }
}
