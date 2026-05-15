class UserModel {
  final String? name;
  final String? email;
  final String? phone;
  final double height;
  final double weight;
  final int age;
  final String goal;
  final String activityLevel;
  final String? gender;
  final bool hasCompletedDetails;

  UserModel({
    this.name,
    this.email,
    this.phone,
    required this.height,
    required this.weight,
    required this.age,
    required this.goal,
    required this.activityLevel,
    this.gender,
    this.hasCompletedDetails = false,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'phone': phone,
    'height': height,
    'weight': weight,
    'age': age,
    'goal': goal,
    'activityLevel': activityLevel,
    'gender': gender,
    'hasCompletedDetails': hasCompletedDetails,
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    name: json['name'] as String?,
    email: json['email'] as String?,
    phone: json['phone'] as String?,
    height: (json['height'] as num).toDouble(),
    weight: (json['weight'] as num).toDouble(),
    age: json['age'] as int,
    goal: json['goal'] as String,
    activityLevel: json['activityLevel'] as String,
    gender: json['gender'] as String?,
    hasCompletedDetails: json['hasCompletedDetails'] as bool? ?? false,
  );
}
