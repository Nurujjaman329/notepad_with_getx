class BajarItemModel {
  final String name;
  final String unit; // gm or kg
  final double weight;
  final double amount;
  bool isMarked;

  BajarItemModel({
    required this.name,
    required this.unit,
    required this.weight,
    required this.amount,
    this.isMarked = false,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'unit': unit,
    'weight': weight,
    'amount': amount,
    'isMarked': isMarked,
  };

  factory BajarItemModel.fromJson(Map<String, dynamic> json) {
    return BajarItemModel(
      name: json['name'],
      unit: json['unit'],
      weight: (json['weight'] as num).toDouble(),
      amount: (json['amount'] as num).toDouble(),
      isMarked: json['isMarked'] ?? false,
    );
  }
}
