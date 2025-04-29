import 'package:flutter/foundation.dart';

class MonitoringState with ChangeNotifier {
  bool _isMonitoringActive = true;

  bool get isMonitoringActive => _isMonitoringActive;

  void toggleMonitoring() {
    _isMonitoringActive = !_isMonitoringActive;
    notifyListeners();
  }
}
