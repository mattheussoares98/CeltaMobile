import 'dart:typed_data';

import 'package:celta_intelligence/utils/utils.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/models.dart';
import 'datasource.dart';

class GeneratePdfDatasource implements IGeneratePdfDatasource {
  @override
  Future<Uint8List> generate(LastSavedSaleRequestModel saleRequest) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),
        header: (context) => _buildHeader(saleRequest),
        footer: (context) => _buildFooter(),
        build: (context) => [
          _buildCustomerInfo(saleRequest),
          pw.SizedBox(height: 10),
          if (saleRequest.pendingSaleRequestModel.cart.values.isNotEmpty)
            _buildProductTable(
              saleRequest.pendingSaleRequestModel.cart.values.toList(),
            ),
          if (saleRequest.pendingSaleRequestModel.cart.values.isEmpty)
            pw.Center(child: pw.Text('Nenhum produto no carrinho.')),
        ],
      ),
    );

    return await pdf.save();
  }

  /// Builds the header widget that is repeated on each page.
  static pw.Widget _buildHeader(LastSavedSaleRequestModel saleRequest) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      margin: const pw.EdgeInsets.only(bottom: 10.0),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          // pw.Text(
          //   'Código da Empresa: ${saleRequest.enterpriseCode}',
          //   style: pw.TextStyle(
          //     fontWeight: pw.FontWeight.bold,
          //   ),
          // ),
          pw.Text(
            'Pedido Nº: ${saleRequest.saleRequestNumber}',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
    );
  }

  /// Builds the footer widget that is repeated on each page.
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

  /// Builds the customer and order details section.
  static pw.Widget _buildCustomerInfo(LastSavedSaleRequestModel saleRequest) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Cliente: ${saleRequest.pendingSaleRequestModel.customer?.Name ?? "Não informado"}',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14),
        ),
        pw.SizedBox(height: 12),
        if (saleRequest.pendingSaleRequestModel.instructions?.isNotEmpty ??
            false) ...[
          _buildInfoSection(
            'Instruções:',
            saleRequest.pendingSaleRequestModel.instructions!,
          ),
          pw.SizedBox(height: 8),
        ],
        if (saleRequest.pendingSaleRequestModel.observations?.isNotEmpty ??
            false)
          _buildInfoSection(
            'Observações:',
            saleRequest.pendingSaleRequestModel.observations!,
          ),
      ],
    );
  }

  /// Helper to create a styled section for instructions or observations.
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

  static pw.Widget _buildProductTable(List<CartProductModel> cartProducts) {
    final headers = ['Produto', 'Qtd', 'Preço unit', 'Desconto', 'Total'];

    double totalDiscount = 0;
    double totalLiquid = 0;
    final data =
        cartProducts.map((cartProduct) {
          final productDiscount =
              cartProduct.toEntity().getValueOrPercentageDiscount ?? 0;
          final productTotalLiquid = cartProduct.toEntity().getValueLiquid;
          totalDiscount += productDiscount;
          totalLiquid += productTotalLiquid;

          return [
            cartProduct.product?.Name ?? 'N/A',
            cartProduct.Quantity.toString().toBrazilianNumber(2, true),
            _formatCurrency(cartProduct.Value),
            _formatCurrency(productDiscount),
            _formatCurrency(cartProduct.toEntity().getValueLiquid),
          ];
        }).toList()..add([
          "",
          "",
          "",
          _formatCurrency(totalDiscount),
          _formatCurrency(totalLiquid),
        ]);

    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: data,
      border: pw.TableBorder.all(color: PdfColors.grey400),
      headerStyle: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.white,
      ),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.blueGrey),
      cellHeight: 30,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerRight,
        2: pw.Alignment.centerRight,
        3: pw.Alignment.centerRight,
        4: pw.Alignment.centerRight,
      },
      cellPadding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 4),
    );
  }

  /// Formats a nullable double value into a currency string.
  static pw.Widget _formatCurrency(double? value) {
    // Set a default or use the provided value
    final double a = value ?? 0;

    // Use your existing .toBrazilianNumber extension to format the number
    final String formattedValue = a.toString().toBrazilianNumber(2, false);

    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.end,
      children: [
        pw.Text(
          'R\$ ',
          style: const pw.TextStyle(
            fontSize: 7, // Smaller font size
            color: PdfColors.grey600, // Lighter color
          ),
        ),
        // 2. The main currency value
        pw.Text(
          formattedValue,
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
      ],
    );
  }
}
