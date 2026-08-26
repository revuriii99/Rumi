import 'package:flutter/material.dart';
import 'financial_profile_model.dart';

enum FinancialStatus {
  green(
    label: 'HIJAU',
    description: 'Relatif Aman',
    color: Color(0xFF2ECC71),
    tips: 'Kondisi keuangan terkendali dan memiliki ruang sisa yang sehat.',
  ),
  yellow(
    label: 'KUNING',
    description: 'Perlu Perhatian',
    color: Color(0xFFF39C12),
    tips: 'Keuangan masih memiliki sisa, namun batas toleransi mulai terbatas.',
  ),
  red(
    label: 'RED',
    description: 'Tekanan Tinggi',
    color: Color(0xFFE74C3C),
    tips: 'Biaya hunian beresiko mengganggu kestabilan finansial bulanan.',
  );

  final String label;
  final String description;
  final Color color;
  final String tips;

  const FinancialStatus({
    required this.label,
    required this.description,
    required this.color,
    required this.tips,
  });
}

class FinancialEvaluationResult {
  final double income;
  final double propertyPrice;
  final double totalExpenses;
  final double housingRatio;
  final double breathingRoom;
  final double breathingRoomRatio;
  final FinancialStatus status;

  FinancialEvaluationResult({
    required this.income,
    required this.propertyPrice,
    required this.totalExpenses,
    required this.housingRatio,
    required this.breathingRoom,
    required this.breathingRoomRatio,
    required this.status,
  });

  factory FinancialEvaluationResult.calculate({
    required FinancialProfileModel profile,
    required double propertyPrice,
  }) {
    final double housingRatio = (propertyPrice / profile.income) * 100;
    final double totalExpenses = propertyPrice + profile.routineExpenses;
    final double breathingRoom = profile.income - totalExpenses;
    final double breathingRoomRatio = (breathingRoom / profile.income) * 100;

    FinancialStatus status;
    if (breathingRoomRatio >= 20) {
      status = FinancialStatus.green;
    } else if (breathingRoomRatio >= 10 && breathingRoomRatio < 20) {
      status = FinancialStatus.yellow;
    } else {
      status = FinancialStatus.red;
    }

    return FinancialEvaluationResult(
      income: profile.income,
      propertyPrice: propertyPrice,
      totalExpenses: totalExpenses,
      housingRatio: housingRatio,
      breathingRoom: breathingRoom,
      breathingRoomRatio: breathingRoomRatio,
      status: status,
    );
  }
}
