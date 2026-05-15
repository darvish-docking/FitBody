enum MealType { breakfast, lunch, dinner, snack }

class MealModel {
  final String id;
  final String name;
  final String description;
  final String? imageUrl;
  final MealType type;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final List<String> ingredients;
  final List<String> instructions;
  final bool isFavourite;

  MealModel({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    required this.type,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.ingredients = const [],
    this.instructions = const [],
    this.isFavourite = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'imageUrl': imageUrl,
    'type': type.name,
    'calories': calories,
    'protein': protein,
    'carbs': carbs,
    'fat': fat,
    'ingredients': ingredients,
    'instructions': instructions,
    'isFavourite': isFavourite,
  };

  factory MealModel.fromJson(Map<String, dynamic> json) => MealModel(
    id: json['id'] as String,
    name: json['name'] as String,
    description: json['description'] as String,
    imageUrl: json['imageUrl'] as String?,
    type: MealType.values.firstWhere((e) => e.name == json['type']),
    calories: json['calories'] as int,
    protein: json['protein'] as int,
    carbs: json['carbs'] as int,
    fat: json['fat'] as int,
    ingredients: (json['ingredients'] as List<dynamic>?)?.cast<String>() ?? [],
    instructions: (json['instructions'] as List<dynamic>?)?.cast<String>() ?? [],
    isFavourite: json['isFavourite'] as bool? ?? false,
  );
}
