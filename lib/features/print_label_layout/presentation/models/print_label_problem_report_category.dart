enum PrintLabelProblemReportCategory {
  printQuality('Qualidade da impressão'),
  positioning('Posicionamento'),
  dimensions('Tamanho da etiqueta'),
  barcode('Código de barras'),
  other('Outro');

  final String label;

  const PrintLabelProblemReportCategory(this.label);
}
