class HousingModel {
  final String id;
  final String title;
  final String type;
  final String city;
  final String address;
  final int price;
  final String image;
  final String desc;
  final List<String> facilities;
  final int bedroom;
  final int bathroom;
  final int landArea;
  final int buildingArea;
  final String propertyType;
  final String locationDetail;
  final String electricity;
  final String certificate;
  final String orientation;
  final String furnished;

  HousingModel({
    required this.id,
    required this.title,
    this.type = 'Sewa',
    this.city = 'Kota Malang',
    required this.address,
    required this.price,
    required this.image,
    required this.desc,
    this.facilities = const [],
    this.bedroom = 3,
    this.bathroom = 2,
    this.landArea = 120,
    this.buildingArea = 100,
    this.propertyType = 'Rumah',
    this.locationDetail = 'Jawa Timur, Malang, Klojen',
    this.electricity = '10.000 Watt',
    this.certificate = 'Surat Hak Guna Bangun',
    this.orientation = 'Timur',
    this.furnished = 'Non – Furnished',
  });
}

class HousingDataStore {
  static List<HousingModel> sampleHousings = [
    HousingModel(
      id: 'h1',
      title: 'Rumah Kotak',
      type: 'Sewa',
      city: 'Kota Malang',
      address: 'Jl. Veteran No.8A, Penanggungan, Kec. Klojen',
      price: 15000000,
      image: 'assets/images/rumahKotak.png',
      desc:
          'Rumah ini memiliki 3 kamar tidur yang luas, 2 kamar mandi modern, dan ruang tamu yang nyaman. Dilengkapi dengan dapur yang fungsional dan halaman belakang yang ideal untuk berkumpul. Terletak di kawasan strategis, dekat dengan pusat perbelanjaan dan sekolah. Cocok untuk keluarga yang mencari kenyamanan dan aksesibilitas.',
      facilities: [
        'WiFi',
        'Kamar Mandi Dalam',
        'Parkir Motor & Mobil',
        'Dapur Bersama',
      ],
      bedroom: 3,
      bathroom: 2,
      landArea: 120,
      buildingArea: 100,
      propertyType: 'Rumah',
      locationDetail: 'Jawa Timur, Malang, Klojen',
      electricity: '10.000 Watt',
      certificate: 'Surat Hak Guna Bangun',
      orientation: 'Timur',
      furnished: 'Non – Furnished',
    ),
    HousingModel(
      id: 'h2',
      title: 'Rumah Nanas',
      type: 'Sewa',
      city: 'Kota Malang',
      address: 'Jl. Jakarta No.8A, Kota Malang',
      price: 30000000,
      image: 'assets/images/rumahNanas.png',
      desc:
          'Rumah asri 2 lantai dengan ventilasi udara segar dan lingkungan tenang. Cocok bagi yang membutuhkan privasi tinggi dengan akses mudah ke jalur utama.',
      facilities: ['AC', 'WiFi Cepat', 'Security 24 Jam', 'Water Heater'],
      bedroom: 4,
      bathroom: 3,
      landArea: 150,
      buildingArea: 130,
      propertyType: 'Rumah',
      locationDetail: 'Jawa Timur, Malang, Lowokwaru',
      electricity: '3.500 Watt',
      certificate: 'SHM',
      orientation: 'Utara',
      furnished: 'Semi Furnished',
    ),
    HousingModel(
      id: 'h3',
      title: 'Rumah Mawar',
      type: 'Sewa',
      city: 'Kota Malang',
      address: 'Jl. Pagi No.8A, Kota Malang',
      price: 25000000,
      image: 'assets/images/rumahMawar.png',
      desc:
          'Desain klasik estetik dengan taman hijau, siap huni dan dekat fasilitas umum. Lingkungan aman dan ramah keluarga.',
      facilities: ['Full Furnished', 'Parkir Luas', 'Dapur', 'Balkon'],
      bedroom: 3,
      bathroom: 2,
      landArea: 110,
      buildingArea: 90,
      propertyType: 'Rumah',
      locationDetail: 'Jawa Timur, Malang, Klojen',
      electricity: '2.200 Watt',
      certificate: 'SHM',
      orientation: 'Selatan',
      furnished: 'Full Furnished',
    ),
  ];

  static List<HousingModel> savedHousings = [];

  static void saveHousing(HousingModel item) {
    if (!savedHousings.any((h) => h.id == item.id)) {
      savedHousings.insert(0, item);
    }
  }

  static void removeSavedHousing(String id) {
    savedHousings.removeWhere((h) => h.id == id);
  }
}
