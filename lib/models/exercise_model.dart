enum ExerciseLevel { beginner, intermediate, advanced }
enum ExerciseCategory { strength, cardio, flexibility, balance }

class ExerciseModel {
  final String id;
  final String name;
  final String description;
  final String? imageUrl;
  final ExerciseLevel level;
  final ExerciseCategory category;
  final int durationMinutes;
  final int caloriesBurn;
  final List<String> equipment;
  final List<String> instructions;
  final bool isFavourite;

  ExerciseModel({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    required this.level,
    required this.category,
    required this.durationMinutes,
    required this.caloriesBurn,
    this.equipment = const [],
    this.instructions = const [],
    this.isFavourite = false,
  });

  ExerciseModel copyWith({bool? isFavourite}) => ExerciseModel(
    id: id,
    name: name,
    description: description,
    imageUrl: imageUrl,
    level: level,
    category: category,
    durationMinutes: durationMinutes,
    caloriesBurn: caloriesBurn,
    equipment: equipment,
    instructions: instructions,
    isFavourite: isFavourite ?? this.isFavourite,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'imageUrl': imageUrl,
    'level': level.name,
    'category': category.name,
    'durationMinutes': durationMinutes,
    'caloriesBurn': caloriesBurn,
    'equipment': equipment,
    'instructions': instructions,
    'isFavourite': isFavourite,
  };

  factory ExerciseModel.fromJson(Map<String, dynamic> json) => ExerciseModel(
    id: json['id'] as String,
    name: json['name'] as String,
    description: json['description'] as String,
    imageUrl: json['imageUrl'] as String?,
    level: ExerciseLevel.values.firstWhere((e) => e.name == json['level']),
    category: ExerciseCategory.values.firstWhere((e) => e.name == json['category']),
    durationMinutes: json['durationMinutes'] as int,
    caloriesBurn: json['caloriesBurn'] as int,
    equipment: (json['equipment'] as List<dynamic>?)?.cast<String>() ?? [],
    instructions: (json['instructions'] as List<dynamic>?)?.cast<String>() ?? [],
    isFavourite: json['isFavourite'] as bool? ?? false,
  );
}
