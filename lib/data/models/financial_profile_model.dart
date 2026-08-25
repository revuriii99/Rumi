class FinancialProfileModel {
  final double income;
  final double transport;
  final double dailyNeeds;
  final double bills;
  final double savingsTarget;
  final double otherExpenses;
  final double? emergencyFund;

  FinancialProfileModel({
    required this.income,
    required this.transport,
    required this.dailyNeeds,
    required this.bills,
    required this.savingsTarget,
    required this.otherExpenses,
    this.emergencyFund,
  });

  double get routineExpenses =>
      transport + dailyNeeds + bills + savingsTarget + otherExpenses;
}
