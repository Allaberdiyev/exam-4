import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

class TipViewModel extends ChangeNotifier {
  final String rideId;
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  double? _tip;
  double? get tip => _tip;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  TipViewModel({required this.rideId}) {
    fetchTip();
  }

  Future<void> fetchTip() async {
    _isLoading = true;
    notifyListeners();
    try {
      final snapshot = await _db.child('exam/rides/$rideId/tip').get();
      if (snapshot.exists) {
        _tip = (snapshot.value as num).toDouble();
      } else {
        _tip = null;
      }
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> setTip(double value) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _db.child('exam/rides/$rideId/tip').set(value);
      _tip = value;
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }
}
