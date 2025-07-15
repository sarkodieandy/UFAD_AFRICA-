class BusinessModel {
  final int id;
  final String name;
  final String mainProductService;

  BusinessModel({
    required this.id,
    required this.name,
    required this.mainProductService,
  });

  factory BusinessModel.fromJson(Map<String, dynamic> json) {
    return BusinessModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['business_name'] ?? '',
      mainProductService: json['main_product_service'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'business_name': name,
      'main_product_service': mainProductService,
    };
  }
}
