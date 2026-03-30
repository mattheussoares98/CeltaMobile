import 'dart:typed_data';

import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/models.dart';
import 'datasource.dart';

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
          _buildCustomerInfo(saleRequest),
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
        'Desenvolvido por Celtaware',
        style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey),
      ),
    );
  }

  static pw.Widget _buildCustomerInfo(BSFSaleRequestModel saleRequest) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Cliente: ${saleRequest.customer?.name ?? "Não informado"}',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14),
        ),
        pw.SizedBox(height: 12),
        if (saleRequest.instructions?.isNotEmpty ?? false) ...[
          _buildInfoSection('Instruções:', saleRequest.instructions!),
          pw.SizedBox(height: 8),
        ],
        if (saleRequest.observations?.isNotEmpty ?? false)
          _buildInfoSection('Observações:', saleRequest.observations!),
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
            _tableHeaderCell('Produto'),
            _tableHeaderCell('Qtd', align: pw.Alignment.center),
            _tableHeaderCell('Preço', align: pw.Alignment.center),
            if (hasDiscount)
              _tableHeaderCell('Desc', align: pw.Alignment.center),
            if (hasIncrement)
              _tableHeaderCell('Acrés', align: pw.Alignment.center),
            if (hasFreight)
              _tableHeaderCell('Frete', align: pw.Alignment.center),
            _tableHeaderCell('Total', align: pw.Alignment.centerRight),
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
