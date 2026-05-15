class ProgressModel {
  final DateTime date;
  final double? weight;
  final double? bodyFatPercentage;
  final int? caloriesConsumed;
  final int? caloriesBurned;
  final int? workoutDurationMinutes;
  final int? steps;
  final double? waterIntake;

  ProgressModel({
    required this.date,
    this.weight,
    this.bodyFatPercentage,
    this.caloriesConsumed,
    this.caloriesBurned,
    this.workoutDurationMinutes,
    this.steps,
    this.waterIntake,
  });
}

class WeeklyProgress {
  final DateTime weekStart;
  final int workoutsCompleted;
  final int totalWorkouts;
  final int totalCaloriesBurned;
  final int totalDurationMinutes;

  WeeklyProgress({
    required this.weekStart,
    required this.workoutsCompleted,
    required this.totalWorkouts,
    required this.totalCaloriesBurned,
    required this.totalDurationMinutes,
  });
}
