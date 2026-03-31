class ModuleIsFreeUntil {
  ModuleIsFreeUntil._();

  static final now = DateTime.now();

  static DateTime get stockReplacementDate => DateTime(2026, 4, 1);
  static bool get stockReplacementIsFree =>
      now.isBefore(stockReplacementDate.add(const Duration(days: 1)));

  static DateTime get adjustCostDate => DateTime(2026, 5, 1);
  static bool get adjustCostIsFree =>
      now.isBefore(adjustCostDate.add(const Duration(days: 1)));
  //TODO delete this code after this date
}
