class Medicine {
  final int id;
  final String name;
  final String description;
  final String manufacturer;
  final DateTime expiryDate;

  Medicine({
    required this.id,
    required this.name,
    required this.description,
    required this.manufacturer,
    required this.expiryDate,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      manufacturer: json['manufacturer'],
      expiryDate: DateTime.parse(json['expiry_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'manufacturer': manufacturer,
      'expiry_date': expiryDate.toIso8601String(),
    };
  }
}