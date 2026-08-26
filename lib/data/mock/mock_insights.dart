class InsightArticle {
  final String id;
  final String category;
  final String title;
  final String hook;
  final String readTime;
  final String content;

  InsightArticle({
    required this.id,
    required this.category,
    required this.title,
    required this.hook,
    required this.readTime,
    required this.content,
  });
}

final List<InsightArticle> mockInsightArticles = [
  InsightArticle(
    id: '1',
    category: 'Mencari Tempat Tinggal',
    title: 'Jodoh-Jodohan Sama Hunian',
    hook:
        'Nyari kos/kontrakan itu kayak nyari jodoh — nggak asal cakep, harus cocok juga sama isi dompet.',
    readTime: '3 min',
    content: 'Tips menentukan kriteria dasar sebelum survei fisik...',
  ),
  InsightArticle(
    id: '2',
    category: 'Keuangan untuk Hunian',
    title: 'Dompet Aman, Tidur Nyenyak',
    hook: 'Sebelum ngebayangin dekor kamar, yuk cek dulu: dompetmu siap belum?',
    readTime: '4 min',
    content:
        'Pentingnya mengukur Financial Breathing Room sebelum tanda tangan...',
  ),
  InsightArticle(
    id: '3',
    category: 'KPR & Cicilan',
    title: 'KPR Tanpa Bikin Pusing 7 Keliling',
    hook: 'DP, tenor, bunga... serem? Tenang, kita bahas kayak lagi ngobrol.',
    readTime: '5 min',
    content: 'Mengenal istilah pokok, tenor, dan fixed vs floating rate...',
  ),
  InsightArticle(
    id: '4',
    category: 'Menabung untuk Hunian',
    title: 'Nabung Buat DP, Bukan Buat Nahan Ngopi Doang',
    hook:
        'Nabung buat rumah nggak harus derita. Ini strategi realistis buat kantong muda.',
    readTime: '3 min',
    content: 'Cara memisahkan pos tabungan DP dari uang operasional bulanan...',
  ),
  InsightArticle(
    id: '5',
    category: 'Sewa & Kontrak Hunian',
    title: 'Baca Kontrak, Jangan Cuma Tanda Tangan Doang',
    hook:
        'Klausul kecil bisa jadi masalah besar. Kenalan sama isi kontrak sebelum nyesel.',
    readTime: '4 min',
    content: 'Poin penting deposit, denda kerusakan, dan terminasi sewa...',
  ),
];
