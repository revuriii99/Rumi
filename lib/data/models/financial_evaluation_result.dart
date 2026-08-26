import 'package:flutter/material.dart';

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
  ),
}
