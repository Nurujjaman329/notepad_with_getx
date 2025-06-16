class BajarItemModel {
  final String name;
  final String unit; // gm or kg
  final double weight;
  final double amount;
  bool isMarked;
  final DateTime createdAt;
  DateTime updatedAt;

  BajarItemModel({
    required this.name,
    required this.unit,
    required this.weight,
    required this.amount,
    this.isMarked = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) :
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'name': name,
    'unit': unit,
    'weight': weight,
    'amount': amount,
    'isMarked': isMarked,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory BajarItemModel.fromJson(Map<String, dynamic> json) {
    return BajarItemModel(
      name: json['name'] ?? 'Unknown',
      unit: json['unit'] ?? 'kg',
      weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      isMarked: json['isMarked'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : (json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now()),
    );
  }
}