import 'package:celta_inventario/exceptions/exceptions.dart';
import 'dart:convert';

import 'package:celta_inventario/features/sale_request/data/datasource/datasource.dart';
import 'package:celta_inventario/features/sale_request/data/models/models.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/localization/localization.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter_esc_pos_network/flutter_esc_pos_network.dart';

class PrintBSFSaleRequestDatasource implements IPrintBSFSaleRequestDatasource {
  final AppLocalizations _l10n;

  PrintBSFSaleRequestDatasource({AppLocalizations? translations})
    : _l10n = translations ?? defaultLocalizations;

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
      throw Exception(_l10n.printerConnectionFailure(res.msg));
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
      throw Exception(
        _l10n.orderPrintingFailure(parseErrorMessage(e, translations: _l10n)),
      );
    } finally {
      await printer.disconnect();
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return _l10n.notProvided;
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
      _l10n.printedSalesOrder(lastFourNumbers ?? ''),
      styles: const PosStyles(align: PosAlign.center),
    );

    bytes += generator.text(
      _l10n.printedAt(DateTime.now().formatDate()),
      styles: const PosStyles(align: PosAlign.center),
    );
    bytes += generator.text(_l10n.printedOrder(saleRequestNumber ?? ''));

    // Request type
    final requestTypeName = saleRequest.requestType?.name;
    final requestTypeCode = saleRequest.requestType?.code?.toString();
    final requestTypeStr = switch ((requestTypeCode, requestTypeName)) {
      (final c?, final n?) => '$c - $n',
      (final c?, null) => c,
      (null, final n?) => n,
      (null, null) => _l10n.notProvided2,
    };
    bytes += generator.text(_l10n.printedOrderTemplate(requestTypeStr));

    // Date of emission
    bytes += generator.text(
      _l10n.printedIssueDate(_formatDate(saleRequest.dateOfEmission)),
    );

    bytes += generator.text(
      _l10n.printedCustomer(saleRequest.customer?.name ?? _l10n.notProvided2),
    );
    bytes += generator.text(_l10n.printedUser(userName));

    // Sale-level increment
    final increment = saleRequest.increment;
    if (increment?.value != null && increment!.value! > 0) {
      final formatted = increment.value.toString().toBrazilianNumber();
      final incrementStr = increment.type == PercentageOrValue.percentage
          ? '$formatted%'
          : 'R\$ $formatted';
      bytes += generator.text(_l10n.printedSurcharge(incrementStr));
    }

    // Sale-level financial discount
    final financialDiscount = saleRequest.financialDiscount;
    if (financialDiscount?.value != null && financialDiscount!.value! > 0) {
      final formatted = financialDiscount.value.toString().toBrazilianNumber();
      final discStr = financialDiscount.type == PercentageOrValue.percentage
          ? '$formatted%'
          : 'R\$ $formatted';
      bytes += generator.text(_l10n.printedPaymentDiscount(discStr));
    }

    // Sale-level financial increment
    final financialIncrement = saleRequest.financialIncrement;
    if (financialIncrement?.value != null && financialIncrement!.value! > 0) {
      final formatted = financialIncrement.value.toString().toBrazilianNumber();
      final incStr = financialIncrement.type == PercentageOrValue.percentage
          ? '$formatted%'
          : 'R\$ $formatted';
      bytes += generator.text(_l10n.printedPaymentSurcharge(incStr));
    }

    // Delivery tax
    final deliveryTax = saleRequest.deliveryTax?.deliveryTax;
    if (deliveryTax?.value != null && deliveryTax!.value! > 0) {
      final formatted = deliveryTax.value.toString().toBrazilianNumber();
      final freightStr = deliveryTax.type == PercentageOrValue.percentage
          ? '$formatted%'
          : 'R\$ $formatted';
      bytes += generator.text(_l10n.printedShipping(freightStr));
    }

    // Total Liquid
    final totalLiquidStr = saleRequest.totalLiquid
        ?.toStringAsFixed(2)
        .toBrazilianNumber();
    if (totalLiquidStr != null) {
      bytes += generator.text(_l10n.printedNetTotal(totalLiquidStr));
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
          _l10n.paymentMethods,
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
            if (portions > 1) {
              buffer.write(_l10n.printedInstallments(portions.toString()));
            }

            bytes += generator.text(buffer.toString().removeAccents());

            if (disc > 0) {
              bytes += generator.text(
                _l10n.printedDiscountAmount(
                  disc.toString().toBrazilianNumber(),
                ),
              );
            }
            if (inc > 0) {
              bytes += generator.text(
                _l10n.printedSurchargeAmount(
                  inc.toString().toBrazilianNumber(),
                ),
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
            _l10n.printedItemDiscount(
              productDiscount.toString().toBrazilianNumber(),
            ),
            styles: const PosStyles(align: PosAlign.right),
          );
        }
        if (productIncrement > 0) {
          bytes += generator.text(
            _l10n.printedItemSurcharge(
              productIncrement.toString().toBrazilianNumber(),
            ),
            styles: const PosStyles(align: PosAlign.right),
          );
        }
        if (productFreight > 0) {
          bytes += generator.text(
            _l10n.printedItemShipping(
              productFreight.toString().toBrazilianNumber(),
            ),
            styles: const PosStyles(align: PosAlign.right),
          );
        }
        if (productIncrement > 0 || productDiscount > 0 || productFreight > 0) {
          bytes += generator.row([
            PosColumn(
              textEncoded: latin1.encode(_l10n.itemTotal),
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
        PosColumn(textEncoded: latin1.encode(_l10n.subtotalR), width: 6),
        PosColumn(
          text: totalDiscount.toString().toBrazilianNumber(),
          width: 6,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
      bytes += generator.row([
        PosColumn(textEncoded: latin1.encode(_l10n.totalDiscountsR), width: 6),
        PosColumn(
          text: totalDiscount.toStringAsFixed(2).toBrazilianNumber(),
          width: 6,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
      bytes += generator.row([
        PosColumn(textEncoded: latin1.encode(_l10n.totalSurchargesR), width: 6),
        PosColumn(
          text: totalIncrement.toStringAsFixed(2).toBrazilianNumber(),
          width: 6,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
      bytes += generator.row([
        PosColumn(textEncoded: latin1.encode(_l10n.totalShippingR), width: 6),
        PosColumn(
          text: totalFreight.toStringAsFixed(2).toBrazilianNumber(),
          width: 6,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
    }

    bytes += generator.row([
      PosColumn(
        textEncoded: latin1.encode(_l10n.totalR),
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
        _l10n.notes3,
        styles: const PosStyles(bold: true),
      );
      bytes += generator.text(observations.removeAccents());
    }
    if (instructions.isNotEmpty) {
      bytes += generator.text(
        _l10n.instructions2,
        styles: const PosStyles(bold: true),
      );
      bytes += generator.text(instructions.removeAccents());
    }

    bytes += generator.feed(2);
    bytes += generator.cut();
    return bytes;
  }
}
