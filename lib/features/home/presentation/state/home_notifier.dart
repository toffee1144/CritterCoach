import 'package:flutter/foundation.dart';
import '../../domain/entities/dashboard.dart';
import '../../domain/usecases/get_dashboard_summary.dart';

class HomeNotifier extends ChangeNotifier {
  final GetDashboardSummary getSummary;
  HomeNotifier(this.getSummary);

  bool loading = false;
  Dashboard? dashboard;
  String? error;

  Future<void> load({required int userId, DateTime? date}) async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      dashboard = await getSummary(userId: userId, date: date);
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
