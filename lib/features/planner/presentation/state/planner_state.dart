import '../../domain/entities/plan.dart';

sealed class PlannerState {
  const PlannerState();
}

class PlannerInitial extends PlannerState {
  const PlannerInitial();
}

class PlannerLoading extends PlannerState {
  const PlannerLoading();
}

class PlannerLoaded extends PlannerState {
  final DateTime date;
  final List<Plan> plans;
  const PlannerLoaded({required this.date, required this.plans});
}

class PlannerError extends PlannerState {
  final String message;
  const PlannerError(this.message);
}
