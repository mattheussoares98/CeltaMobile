enum PrintLabelReportValidationFailure {
  unsupportedSchema("Unsupported schema version"),
  invalidIdempotencyKey("Idempotency key must be a UUID"),
  supabaseEnterpriseRequired("Supabase enterprise must be informed"),
  erpEnterpriseRequired("ERP enterprise must be informed"),
  erpUserRequired("ERP user name must be informed"),
  erpUserTooLong("ERP user name must contain at most 200 characters"),
  erpCompanyRequired("ERP enterprise name must be informed"),
  erpCompanyTooLong("ERP enterprise name must contain at most 200 characters"),
  reportDescriptionRequired("Description must be informed"),
  reportDescriptionTooLong("Description must contain at most 2000 characters"),
  savedLayoutRequired("Only a saved layout can be reported"),
  environmentRequired("Environment must be complete"),
  physicalImageTooLarge("Physical label must contain at most 5 MiB"),
  physicalImageDimensionsInvalid("Physical label dimensions are invalid"),
  canvasImageTooLarge("Canvas preview must contain at most 5 MiB"),
  canvasImageDimensionsInvalid("Canvas preview dimensions are invalid"),
  capturesNotConfirmed("Both captures must be confirmed");

  const PrintLabelReportValidationFailure(this.message);
  final String message;
}
