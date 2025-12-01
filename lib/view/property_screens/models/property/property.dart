class Property {
  final String imagePath;
  final String rent;
  final String deposit;
  final String flatType;
  final String area;
  final String furnished;
  final String security;
  final String childrenPlayArea;
  late final bool isFavorite;
  Property({
    required this.imagePath,
    required this.rent,
    required this.deposit,
    required this.flatType,
    required this.area,
    required this.furnished,
    required this.security,
    required this.childrenPlayArea,
    bool isFavorite = false,
  }) : isFavorite = isFavorite;



}
