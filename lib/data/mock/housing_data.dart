class HousingModel {
  final String id;
  final String title;
  final String type;
  final String address;
  final int price;
  final String image;
  final String desc;
  final List<String> facilities;

  HousingModel({
    required this.id,
    required this.title,
    this.type = 'Sewa',
    required this.address,
    required this.price,
    required this.image,
    required this.desc,
    required this.facilities,
  });
}

class HousingDataStore {
  static List<HousingModel> sampleHousings = [
    HousingModel(
      id: 'h1',
      title: 'Rumah Kotak',
      type: 'Sewa',
      address: 'Jl. Veteran No.8A, Kota Malang',
      price: 15000000,
      image: 'assets/images/rumahKotak.png',
      desc:
          'Hunian minimalis modern dengan pencahayaan alami yang baik, dekat pusat kota dan kampus.',
      facilities: [
        'WiFi',
        'Kamar Mandi Dalam',
        'Parkir Motor & Mobil',
        'Dapur Bersama',
      ],
    ),
    HousingModel(
      id: 'h2',
      title: 'Rumah Nanas',
      type: 'Sewa',
      address: 'Jl. Jakarta No.8A, Kota Malang',
      price: 30000000,
      image: 'assets/images/rumahNanas.png',
      desc:
          'Rumah asri 2 lantai dengan ventilasi udara segar dan lingkungan tenang.',
      facilities: ['AC', 'WiFi Cepat', 'Security 24 Jam', 'Water Heater'],
    ),
    HousingModel(
      id: 'h3',
      title: 'Rumah Mawar',
      type: 'Sewa',
      address: 'Jl. Pagi No.8A, Kota Malang',
      price: 25000000,
      image: 'assets/images/rumahMawar.png',
      desc:
          'Desain klasik estetik dengan taman hijau, siap huni dan dekat fasilitas umum.',
      facilities: ['Full Furnished', 'Parkir Luas', 'Dapur', 'Balkon'],
    ),
  ];

  static List<HousingModel> savedHousings = [];

  static void saveHousing(HousingModel item) {
    if (!savedHousings.any((h) => h.id == item.id)) {
      savedHousings.insert(0, item);
    }
  }
}
