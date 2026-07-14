import 'dart:convert';

import 'package:celta_inventario/features/sale_request/data/datasource/datasource.dart';
import 'package:celta_inventario/features/sale_request/data/models/models.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter_esc_pos_network/flutter_esc_pos_network.dart';

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
      timeout: const Duration(seconds: 30),
    );

    final PosPrintResult res = await printer.connect(
      timeout: const Duration(seconds: 30),
    );

    if (res != PosPrintResult.success) {
      throw Exception(
        'Ocorreu um erro para conectar com a impressora\n\n"${res.msg}"\n\nConfirme se o IP da impressora está correto, se ela está com bobina e se ela está ligada. Caso não resolva, reinicie ela e tente novamente'
            .hardcoded,
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
      throw Exception('Ocorreu um erro ao imprimir o pedido\n\n$e'.hardcoded);
    } finally {
      await printer.disconnect();
    }
  }

  static String _formatDate(DateTime? date) {
    if (date == null) return 'Nao informada'.hardcoded;
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    final hour = date.hour.toString().padLeft(2, '0');
    final minutes = date.minute.toString().padLeft(2, '0');
    return '$day/$month/$year $hour:$minutes';
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
      "PEDIDO DE VENDA $lastFourNumbers".hardcoded,
      styles: const PosStyles(align: PosAlign.center),
    );

    bytes += generator.text(
      "Impresso em ${DateTime.now().formatDate()}"
          .hardcoded,
      styles: const PosStyles(align: PosAlign.center),
    );
    bytes += generator.text(
      'Pedido: $saleRequestNumber'.hardcoded,
    );

    // Request type
    final requestTypeName = saleRequest.requestType?.name;
    final requestTypeCode = saleRequest.requestType?.code?.toString();
    final requestTypeStr = switch ((requestTypeCode, requestTypeName)) {
      (final c?, final n?) => '$c - $n',
      (final c?, null) => c,
      (null, final n?) => n,
      (null, null) => 'Nao informado'.hardcoded,
    };
    bytes += generator.text(
      'Modelo de Pedido: $requestTypeStr'.hardcoded,
    );

    // Date of emission
    bytes += generator.text(
      'Data de Emissao: ${_formatDate(saleRequest.dateOfEmission)}'.hardcoded,
    );

    bytes += generator.text(
      'Cliente: ${saleRequest.customer?.name ?? "N/A"}'.hardcoded,
    );
    bytes += generator.text(
      'Usuario: $userName'.hardcoded,
    );

    // Sale-level increment
    final increment = saleRequest.increment;
    if (increment?.value != null && increment!.value! > 0) {
      final formatted = increment.value.toString().toBrazilianNumber();
      final incrementStr = increment.type == PercentageOrValue.percentage
          ? '$formatted%'
          : 'R\$ $formatted';
      bytes += generator.text(
        'Acrescimo: $incrementStr'.hardcoded,
      );
    }

    // Sale-level financial discount
    final financialDiscount = saleRequest.financialDiscount;
    if (financialDiscount?.value != null && financialDiscount!.value! > 0) {
      final formatted = financialDiscount.value.toString().toBrazilianNumber();
      final discStr = financialDiscount.type == PercentageOrValue.percentage
          ? '$formatted%'
          : 'R\$ $formatted';
      bytes += generator.text(
        'Desconto Financeiro: $discStr'.hardcoded,
      );
    }

    // Sale-level financial increment
    final financialIncrement = saleRequest.financialIncrement;
    if (financialIncrement?.value != null && financialIncrement!.value! > 0) {
      final formatted = financialIncrement.value.toString().toBrazilianNumber(
        
      );
      final incStr = financialIncrement.type == PercentageOrValue.percentage
          ? '$formatted%'
          : 'R\$ $formatted';
      bytes += generator.text(
        'Acrescimo Financeiro: $incStr'.hardcoded,
      );
    }

    // Delivery tax
    final deliveryTax = saleRequest.deliveryTax?.deliveryTax;
    if (deliveryTax?.value != null && deliveryTax!.value! > 0) {
      final formatted = deliveryTax.value.toString().toBrazilianNumber();
      final freightStr = deliveryTax.type == PercentageOrValue.percentage
          ? '$formatted%'
          : 'R\$ $formatted';
      bytes += generator.text(
        'Frete: $freightStr'.hardcoded,
      );
    }

    // Total Liquid
    final totalLiquidStr = saleRequest.totalLiquid
        ?.toStringAsFixed(2)
        .toBrazilianNumber();
    if (totalLiquidStr != null) {
      bytes += generator.text(
        'Total Liquido: R\$ $totalLiquidStr'.hardcoded,
      );
    }

    bytes += generator.hr();

    // PAYMENT METHODS - before products, only if there are payments
    if (saleRequest.financials?.isNotEmpty ?? false) {
      bool hasPayments = false;
      for (final financial in saleRequest.financials!) {
        if (financial.paymentFinalizations != null &&
            financial.paymentFinalizations!.isNotEmpty) {
          hasPayments = true;
          break;
        }
      }

      if (hasPayments) {
        bytes += generator.text(
          'Formas de Pagamento'.hardcoded,
          styles: const PosStyles(bold: true, align: PosAlign.center),
        );

        for (final financial in saleRequest.financials!) {
          final payments = financial.paymentFinalizations;
          if (payments == null) continue;

          for (final payment in payments) {
            final name = payment.paymentFinalization?.Description ?? 'N/A';
            final value =
                payment.value?.toString().toBrazilianNumber() ?? '0,00';
            final portions = payment.quantityOfPortions ?? 1;
            final disc = payment.financialDiscount ?? 0;
            final inc = payment.financialIncrement ?? 0;

            final StringBuffer buffer = StringBuffer();
            buffer.write(name);
            buffer.write(' (R\$ $value)');
            if (portions > 1) buffer.write(' em ${portions}x'.hardcoded);

            bytes += generator.text(
              buffer.toString().removeAccents(),
            );

            if (disc > 0) {
              bytes += generator.text(
                "  (-) Desconto: R\$ ${disc.toString().toBrazilianNumber()}"
                    .hardcoded,
              );
            }
            if (inc > 0) {
              bytes += generator.text(
                "  (+) Acrescimo: R\$ ${inc.toString().toBrazilianNumber()}"
                    .hardcoded,
              );
            }
          }
        }

        bytes += generator.hr();
      }
    }

    // PRODUCTS
    if (saleRequest.products?.isNotEmpty ?? false) {
      for (final cartProduct
          in saleRequest.products ?? <BSFProductItemModel>[]) {
        final itemGrossValue =
            (cartProduct.value ?? 0) * (cartProduct.quantity ?? 0);
        final ean = cartProduct.product?.productPackingEanString;
        final plu = cartProduct.product?.productPackingPriceLookUpString;
        final productDiscount = cartProduct.toEntity().totalDiscountValue;
        final productIncrement = cartProduct.toEntity().totalIncrement;
        final productFreight = cartProduct.toEntity().totalDeliveryTax;
        final productTotalLiquid = cartProduct.toEntity().totalLiquid;
        bytes += generator.row([
          PosColumn(
            textEncoded: latin1.encode("($plu) ${cartProduct.product?.name}"),
            width: 12,
            styles: const PosStyles(bold: true),
          ),
        ]);

        bytes += generator.row([
          PosColumn(
            text: (ean?.isNotEmpty ?? false) ? ean! : "",
            width: 3,
            styles: PosStyles(
              align: (ean?.isNotEmpty ?? false)
                  ? PosAlign.left
                  : PosAlign.right,
            ),
          ),
          PosColumn(
            text: cartProduct.quantity.toString().toBrazilianNumber(3, true),
            styles: const PosStyles(align: PosAlign.center),
          ),
          PosColumn(
            text: "x",
            width: 1,
            styles: const PosStyles(align: PosAlign.center),
          ),
          PosColumn(
            text: cartProduct.toEntity().value.toString().toBrazilianNumber(),
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

        if (productDiscount > 0) {
          bytes += generator.text(
            "Desconto -${productDiscount.toString().toBrazilianNumber()}"
                .hardcoded,
            styles: const PosStyles(align: PosAlign.right),
          );
        }
        if (productIncrement > 0) {
          bytes += generator.text(
            "Acrescimo +${productIncrement.toString().toBrazilianNumber()}"
                .hardcoded,
            styles: const PosStyles(align: PosAlign.right),
          );
        }
        if (productFreight > 0) {
          bytes += generator.text(
            "Frete +${productFreight.toString().toBrazilianNumber()}".hardcoded,
            styles: const PosStyles(align: PosAlign.right),
          );
        }
        if (productIncrement > 0 || productDiscount > 0 || productFreight > 0) {
          bytes += generator.row([
            PosColumn(
              textEncoded: latin1.encode('Total do item'.hardcoded),
              width: 8,
              styles: const PosStyles(align: PosAlign.right),
            ),
            PosColumn(
              text: "=",
              width: 1,
              styles: const PosStyles(align: PosAlign.center),
            ),
            PosColumn(
              text: productTotalLiquid.toString().toBrazilianNumber(),
              width: 3,
              styles: const PosStyles(align: PosAlign.right),
            ),
          ]);
        }
      }
    }

    bytes += generator.hr();

    final totalDiscount = saleRequest.toEntity().totalDiscount;
    final totalIncrement = saleRequest.toEntity().totalIncrement;
    final totalFreight = saleRequest.toEntity().totalFreight;

    if (totalDiscount > 0 || totalIncrement > 0 || totalFreight > 0) {
      bytes += generator.row([
        PosColumn(
          textEncoded: latin1.encode('Subtotal R\$'.hardcoded),
          width: 6,
        ),
        PosColumn(
          text: totalDiscount.toString().toBrazilianNumber(),
          width: 6,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
      bytes += generator.row([
        PosColumn(
          textEncoded: latin1.encode('Total descontos R\$'.hardcoded),
          width: 6,
        ),
        PosColumn(
          text: totalDiscount.toStringAsFixed(2).toBrazilianNumber(),
          width: 6,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
      bytes += generator.row([
        PosColumn(
          textEncoded: latin1.encode('Total acrescimos R\$'.hardcoded),
          width: 6,
        ),
        PosColumn(
          text: totalIncrement.toStringAsFixed(2).toBrazilianNumber(),
          width: 6,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
      bytes += generator.row([
        PosColumn(
          textEncoded: latin1.encode('Total frete R\$'.hardcoded),
          width: 6,
        ),
        PosColumn(
          text: totalFreight.toStringAsFixed(2).toBrazilianNumber(),
          width: 6,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
    }

    bytes += generator.row([
      PosColumn(
        textEncoded: latin1.encode('TOTAL R\$ '.hardcoded),
        width: 6,
        styles: const PosStyles(bold: true, height: PosTextSize.size2),
      ),
      PosColumn(
        text: saleRequest.totalLiquid!.toStringAsFixed(2).toBrazilianNumber(),
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
        'Observacoes '.hardcoded,
        styles: const PosStyles(bold: true),
      );
      bytes += generator.text(
        observations.removeAccents(),
      );
    }
    if (instructions.isNotEmpty) {
      bytes += generator.text(
        'Instrucoes '.hardcoded,
        styles: const PosStyles(bold: true),
      );
      bytes += generator.text(
        instructions.removeAccents(),
      );
    }

    bytes += generator.feed(2);
    bytes += generator.cut();
    return bytes;
  }
}
