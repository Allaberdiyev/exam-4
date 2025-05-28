import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

class RatingViewModel extends ChangeNotifier {
  final String rideId;
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  double? _stars;
  double? get stars => _stars;

  String? _review;
  String? get review => _review;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  RatingViewModel({required this.rideId}) {
    fetchRating();
  }

  Future<void> fetchRating() async {
    _isLoading = true;
    notifyListeners();
    try {
      final snapshot = await _db.child('exam/rides/$rideId/rating').get();
      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        _stars = (data['stars'] as num?)?.toDouble();
        _review = data['review'] as String?;
      } else {
        _stars = null;
        _review = null;
      }
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> setRating(double stars, String review) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _db.child('exam/rides/$rideId/rating').set({
        'stars': stars,
        'review': review,
      });
      _stars = stars;
      _review = review;
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }
}
