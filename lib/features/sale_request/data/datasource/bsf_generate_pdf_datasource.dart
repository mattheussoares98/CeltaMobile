import 'dart:typed_data';

import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/features/sale_request/data/datasource/datasource.dart';
import 'package:celta_inventario/features/sale_request/data/models/models.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class BSFGeneratePdfDatasource implements IBSFGeneratePdfDatasource {
  @override
  Future<Uint8List> generate(BSFSaleRequestModel saleRequest) async {
    final pdf = pw.Document();

    final fontData = await rootBundle.load(
      "lib/core/assets/fonts/Roboto-Regular.ttf",
    );
    final boldFontData = await rootBundle.load(
      "lib/core/assets/fonts/Roboto-Bold.ttf",
    );

    final ttfFont = pw.Font.ttf(fontData);
    final ttfBoldFont = pw.Font.ttf(boldFontData);

    final baseTheme = pw.ThemeData.withFont(base: ttfFont, bold: ttfBoldFont);

    pdf.addPage(
      pw.MultiPage(
        theme: baseTheme,
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),
        header: (context) => _buildHeader(saleRequest),
        footer: (context) => _buildFooter(),
        build: (context) => [
          _buildRequestInfo(saleRequest),
          pw.SizedBox(height: 10),
          _buildCustomerInfo(saleRequest),
          pw.SizedBox(height: 10),
          _buildPaymentSection(saleRequest.financials ?? []),
          pw.SizedBox(height: 10),
          _buildProductTable(saleRequest.products ?? []),
        ],
      ),
    );

    return await pdf.save();
  }

  static pw.Widget _buildHeader(BSFSaleRequestModel saleRequest) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      margin: const pw.EdgeInsets.only(bottom: 10.0),
      child: pw.Text(
        'Pedido Nº: ${saleRequest.personalizedCode}',
        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      ),
    );
  }

  static pw.Widget _buildFooter() {
    return pw.Container(
      alignment: pw.Alignment.center,
      margin: const pw.EdgeInsets.only(top: 20.0),
      child: pw.Text(
        'Desenvolvido por Celtaware'.hardcoded,
        style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey),
      ),
    );
  }

  static String _formatDate(DateTime? date) {
    if (date == null) return 'Não informada'.hardcoded;
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    final hour = date.hour.toString();
    final minutes = date.minute.toString();
    return '$day/$month/$year $hour:$minutes';
  }

  static String _formatValueType(BSFValueTypeModel? valueType) {
    if (valueType?.value == null || valueType!.value == 0) return '';
    final formatted = valueType.value.toString().toBrazilianNumber(2);
    if (valueType.type == PercentageOrValue.percentage) {
      return '$formatted%';
    }
    return 'R\$ $formatted';
  }

  static pw.Widget _buildRequestInfo(BSFSaleRequestModel saleRequest) {
    final requestTypeName = saleRequest.requestType?.name;
    final requestTypeCode = saleRequest.requestType?.code?.toString();
    final requestTypeStr = switch ((requestTypeCode, requestTypeName)) {
      (final c?, final n?) => '$c - $n',
      (final c?, null) => c,
      (null, final n?) => n,
      (null, null) => 'Não informado'.hardcoded,
    };

    final dateStr = _formatDate(saleRequest.dateOfEmission);

    final incrementStr = _formatValueType(saleRequest.increment);
    final financialDiscountStr = _formatValueType(
      saleRequest.financialDiscount,
    );
    final financialIncrementStr = _formatValueType(
      saleRequest.financialIncrement,
    );

    final deliveryTax = saleRequest.deliveryTax?.deliveryTax;
    final deliveryTaxStr = _formatValueType(deliveryTax);

    final totalLiquidStr = saleRequest.totalLiquid.toString().toBrazilianNumber(
      2,
    );

    final items = <pw.Widget>[
      _infoRow('Modelo de Pedido:'.hardcoded, requestTypeStr),
      _infoRow('Data de Emissão:'.hardcoded, dateStr),
    ];

    if (financialDiscountStr.isNotEmpty) {
      items.add(
        _infoRow('Desconto Financeiro:'.hardcoded, financialDiscountStr),
      );
    }
    if (financialIncrementStr.isNotEmpty) {
      items.add(
        _infoRow('Acréscimo Financeiro:'.hardcoded, financialIncrementStr),
      );
    }
    final discount = saleRequest.toEntity().saleRequestDiscount;
    if (discount > 0) {
      items.add(
        _infoRow(
          'Desconto:'.hardcoded,
          discount.toString().toBrazilianNumber().addBrazilianCoin(),
        ),
      );
    }
    if (incrementStr.isNotEmpty) {
      items.add(_infoRow('Acréscimo:'.hardcoded, incrementStr));
    }
    if (deliveryTaxStr.isNotEmpty) {
      items.add(_infoRow('Frete:'.hardcoded, deliveryTaxStr));
    }
    items.add(_infoRow('Total Líquido:'.hardcoded, 'R\$ $totalLiquidStr'));

    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(4),
      ),
      padding: const pw.EdgeInsets.all(8),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: items,
      ),
    );
  }

  static pw.Widget _infoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 1),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 140,
            child: pw.Text(
              label,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
            ),
          ),
          pw.Text(value, style: const pw.TextStyle(fontSize: 10)),
        ],
      ),
    );
  }

  static pw.Widget _buildCustomerInfo(BSFSaleRequestModel saleRequest) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Cliente: ${saleRequest.customer?.name ?? "Não informado".hardcoded}',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14),
        ),
        pw.Text(
          'Vendedor: ${saleRequest.seller?.name ?? "Não informado".hardcoded}',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14),
        ),
        pw.SizedBox(height: 12),
        if (saleRequest.instructions?.isNotEmpty ?? false) ...[
          _buildInfoSection('Instruções:'.hardcoded, saleRequest.instructions!),
          pw.SizedBox(height: 8),
        ],
        if (saleRequest.observations?.isNotEmpty ?? false)
          _buildInfoSection(
            'Observações:'.hardcoded,
            saleRequest.observations!,
          ),
      ],
    );
  }

  static pw.Widget _buildInfoSection(String title, String content) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(title, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.Container(
          padding: const pw.EdgeInsets.all(8),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey300),
            borderRadius: pw.BorderRadius.circular(4),
          ),
          child: pw.Text(content, style: const pw.TextStyle(fontSize: 10)),
        ),
      ],
    );
  }

  static pw.Widget _buildPaymentSection(List<BSFFinancialModel> financials) {
    // Flatten all payment finalizations from all financials
    final payments = <BSFPaymentFinalizationWrapperModel>[];
    for (final financial in financials) {
      if (financial.paymentFinalizations != null) {
        payments.addAll(financial.paymentFinalizations!);
      }
    }

    if (payments.isEmpty) return pw.SizedBox.shrink();

    // Check if any payment has discount or increment to show those columns dynamically
    bool hasDiscount = payments.any((p) => (p.financialDiscount ?? 0) > 0);
    bool hasIncrement = payments.any((p) => (p.financialIncrement ?? 0) > 0);

    // Column order: Pagamento | Parcelas | (Desc?) | (Acrés?) | Valor
    final List<pw.TableColumnWidth> activeWidths = [
      const pw.FlexColumnWidth(5), // Pagamento
      const pw.FlexColumnWidth(2), // Parcelas
      if (hasDiscount) const pw.FlexColumnWidth(2),
      if (hasIncrement) const pw.FlexColumnWidth(2),
      const pw.FlexColumnWidth(3), // Valor (always last)
    ];

    final int dynamicColumnsCount = activeWidths.length;

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Formas de Pagamento'.hardcoded,
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12),
        ),
        pw.SizedBox(height: 6),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300),
          columnWidths: {
            for (int i = 0; i < dynamicColumnsCount; i++) i: activeWidths[i],
          },
          children: [
            // Header row
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey200),
              children: [
                _tableHeaderCell('Pagamento'.hardcoded),
                if (hasDiscount)
                  _tableHeaderCell(
                    'Desc'.hardcoded,
                    align: pw.Alignment.center,
                  ),
                if (hasIncrement)
                  _tableHeaderCell(
                    'Acrés'.hardcoded,
                    align: pw.Alignment.center,
                  ),
                _tableHeaderCell(
                  'Parcelas'.hardcoded,
                  align: pw.Alignment.center,
                ),
                _tableHeaderCell('Valor'.hardcoded, align: pw.Alignment.center),
              ],
            ),
            // Payment rows
            for (final payment in payments)
              pw.TableRow(
                children: [
                  _tableDataCell(
                    payment.paymentFinalization?.Description ?? 'N/A',
                    align: pw.Alignment.centerLeft,
                  ),
                  if (hasDiscount)
                    _tableDataCell(
                      (payment.financialDiscount ?? 0) > 0
                          ? (payment.financialDiscount ?? 0)
                                .toString()
                                .toBrazilianNumber(2)
                          : '-',
                      isPrice: (payment.financialDiscount ?? 0) > 0,
                      color: PdfColors.red,
                    ),
                  if (hasIncrement)
                    _tableDataCell(
                      (payment.financialIncrement ?? 0) > 0
                          ? (payment.financialIncrement ?? 0)
                                .toString()
                                .toBrazilianNumber(2)
                          : '-',
                      isPrice: (payment.financialIncrement ?? 0) > 0,
                      color: PdfColors.orange,
                    ),
                  _tableDataCell(
                    (payment.quantityOfPortions ?? 1) > 1
                        ? '${payment.quantityOfPortions}x'
                        : 'À vista'.hardcoded,
                  ),

                  _tableDataCell(
                    (payment.value ?? 0).toString().toBrazilianNumber(2),
                    isPrice: true,
                  ),
                ],
                verticalAlignment: pw.TableCellVerticalAlignment.middle,
              ),
          ],
        ),
      ],
    );
  }

  /// PERFORMANCE: Built using manual TableRow logic to allow for column spanning.
  /// Columns for Discount, Increment, and Freight are built dynamically
  /// only if there is at least one item with a value in the list.
  static pw.Widget _buildProductTable(List<BSFProductItemModel> products) {
    // PERFORMANCE: Pre-calculating existence of financial adjustments to
    // determine column count and visibility in a single O(n) pass.
    bool hasDiscount = false;
    bool hasIncrement = false;
    bool hasFreight = false;

    for (final p in products) {
      if (!hasDiscount && p.toEntity().unitDiscountValue > 0) {
        hasDiscount = true;
      }
      if (!hasIncrement && p.toEntity().unitIncrement > 0) hasIncrement = true;
      if (!hasFreight && p.toEntity().unitDeliveryTax > 0) hasFreight = true;
      // Short-circuit if all possible dynamic columns are already found
      if (hasDiscount && hasIncrement && hasFreight) break;
    }

    // Dynamic column configuration list
    final List<pw.TableColumnWidth> activeWidths = [
      const pw.FlexColumnWidth(6), // Name
      const pw.FlexColumnWidth(2), // Qty
      const pw.FlexColumnWidth(3), // Price
      if (hasDiscount) const pw.FlexColumnWidth(2),
      if (hasIncrement) const pw.FlexColumnWidth(2),
      if (hasFreight) const pw.FlexColumnWidth(2),
      const pw.FlexColumnWidth(3), // Total
    ];

    final int dynamicColumnsCount = activeWidths.length;

    // Calculate totals for the summary row
    double totalQuantity = 0;
    double totalLiquid = 0;
    for (final item in products) {
      totalQuantity += item.quantity ?? 0;
      totalLiquid += item.toEntity().totalLiquid;
    }

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300),
      columnWidths: {
        for (int i = 0; i < dynamicColumnsCount; i++) i: activeWidths[i],
      },
      children: [
        // TABLE HEADER ROW
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey200),
          children: [
            _tableHeaderCell('Produto'.hardcoded),
            _tableHeaderCell('Qtd'.hardcoded, align: pw.Alignment.center),
            _tableHeaderCell('Preço'.hardcoded, align: pw.Alignment.center),
            if (hasDiscount)
              _tableHeaderCell('Desc'.hardcoded, align: pw.Alignment.center),
            if (hasIncrement)
              _tableHeaderCell('Acrés'.hardcoded, align: pw.Alignment.center),
            if (hasFreight)
              _tableHeaderCell('Frete'.hardcoded, align: pw.Alignment.center),
            _tableHeaderCell(
              'Total'.hardcoded,
              align: pw.Alignment.centerRight,
            ),
          ],
        ),

        // PRODUCT DATA ROWS
        for (var item in products) ...[
          // Row 1: Product Identity (Name + PLU + Packing)
          pw.TableRow(
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 2,
                ),
                child: pw.Column(
                  children: [
                    pw.Text(
                      '${item.product?.name ?? "N/A"} ',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 9,
                      ),
                    ),
                    pw.RichText(
                      textAlign: pw.TextAlign.center,
                      text: pw.TextSpan(
                        children: [
                          pw.TextSpan(
                            text:
                                'PLU: ${item.product?.productPackingPriceLookUpString} ',
                            style: const pw.TextStyle(
                              fontSize: 8,
                              color: PdfColors.grey700,
                            ),
                          ),
                          pw.TextSpan(
                            text:
                                '| (${item.product?.productPackingTypeString} ${item.product?.productPackingQuantity.toString().toBrazilianNumber(3, true)})',
                            style: const pw.TextStyle(
                              fontSize: 8,
                              color: PdfColors.grey700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Empty cells for the rest of the row.
              // We fill exactly (N - 1) cells where N is the total active columns.
              _tableDataCell(
                item.quantity.toString().toBrazilianNumber(3, true),
              ),
              _tableDataCell(
                item.value.toString().toBrazilianNumber(2),
                isPrice: true,
              ),
              if (hasDiscount)
                _tableDataCell(
                  item.toEntity().totalDiscountValue == 0
                      ? ''
                      : item
                            .toEntity()
                            .totalDiscountValue
                            .toString()
                            .toBrazilianNumber(2),
                  isPrice: true,
                  color: PdfColors.red,
                ),
              if (hasIncrement)
                _tableDataCell(
                  item.toEntity().totalIncrement == 0
                      ? ''
                      : item
                            .toEntity()
                            .totalIncrement
                            .toString()
                            .toBrazilianNumber(2),
                  isPrice: true,
                  color: PdfColors.orange,
                ),
              if (hasFreight)
                _tableDataCell(
                  item.toEntity().totalDeliveryTax == 0
                      ? ''
                      : item
                            .toEntity()
                            .totalDeliveryTax
                            .toString()
                            .toBrazilianNumber(2),
                  isPrice: true,
                  color: PdfColors.blue,
                ),
              _tableDataCell(
                item.toEntity().totalLiquid.toString().toBrazilianNumber(2),
                isPrice: true,
                align: pw.Alignment.centerRight,
                bold: true,
              ),
            ],
            repeat: false,
            verticalAlignment: pw.TableCellVerticalAlignment.middle,
          ),
        ],

        // TOTAL SUMMARY ROW
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey100),
          children: [
            _tableDataCell(
              ''.hardcoded,
              align: pw.Alignment.centerLeft,
              bold: true,
            ),
            _tableDataCell(
              totalQuantity.toString().toBrazilianNumber(3, true),
              bold: true,
            ),
            _tableDataCell(''),
            if (hasDiscount) _tableDataCell(''),
            if (hasIncrement) _tableDataCell(''),
            if (hasFreight) _tableDataCell(''),
            _tableDataCell(
              totalLiquid.toString().toBrazilianNumber(2),
              isPrice: true,
              align: pw.Alignment.centerRight,
              bold: true,
            ),
          ],
          verticalAlignment: pw.TableCellVerticalAlignment.middle,
        ),
      ],
    );
  }

  static pw.Widget _tableHeaderCell(
    String text, {
    pw.Alignment align = pw.Alignment.centerLeft,
  }) {
    return pw.Container(
      alignment: align,
      padding: const pw.EdgeInsets.all(4),
      child: pw.Text(
        text,
        style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
      ),
    );
  }

  static pw.Widget _tableDataCell(
    String text, {
    bool isPrice = false,
    pw.Alignment align = pw.Alignment.center,
    PdfColor color = PdfColors.black,
    bool bold = false,
  }) {
    if (text.isEmpty) {
      return pw.Container(
        alignment: align,
        padding: const pw.EdgeInsets.all(4),
        child: pw.Text(''),
      );
    }
    return pw.Container(
      alignment: align,
      padding: const pw.EdgeInsets.all(4),
      child: pw.Text(
        isPrice ? 'R\$ $text' : text,
        style: pw.TextStyle(
          fontSize: 8,
          color: color,
          fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }
}
