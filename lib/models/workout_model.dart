class WorkoutPlan {
  final String id;
  final String name;
  final String description;
  final String? imageUrl;
  final int durationWeeks;
  final int sessionsPerWeek;
  final int estimatedCaloriesPerSession;
  final List<WorkoutSession> sessions;

  WorkoutPlan({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    required this.durationWeeks,
    required this.sessionsPerWeek,
    required this.estimatedCaloriesPerSession,
    this.sessions = const [],
  });
}

class WorkoutSession {
  final String id;
  final String name;
  final String? description;
  final int dayNumber;
  final int durationMinutes;
  final List<WorkoutExercise> exercises;

  WorkoutSession({
    required this.id,
    required this.name,
    this.description,
    required this.dayNumber,
    required this.durationMinutes,
    this.exercises = const [],
  });
}

class WorkoutExercise {
  final String exerciseId;
  final String name;
  final int sets;
  final int reps;
  final int restSeconds;

  WorkoutExercise({
    required this.exerciseId,
    required this.name,
    required this.sets,
    required this.reps,
    required this.restSeconds,
  });
}
