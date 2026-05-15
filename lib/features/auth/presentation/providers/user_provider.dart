import 'package:flutter/material.dart';
import 'package:fitbody/services/storage_service.dart';
import 'package:fitbody/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  StorageService? _storageService;
  UserModel? _user;
  bool _isLoading = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get hasCompletedDetails => _user?.hasCompletedDetails ?? false;

  UserProvider() {
    _init();
  }

  Future<void> _init() async {
    _storageService = await StorageService.getInstance();
    _loadUser();
  }

  void _loadUser() {
    final userData = _storageService!.getObject('user_data');
    if (userData != null) {
      _user = UserModel.fromJson(userData as Map<String, dynamic>);
    }
    notifyListeners();
  }

  Future<void> saveUserDetails({
    required double height,
    required double weight,
    required int age,
    required String goal,
    required String activityLevel,
    String? name,
    String? email,
    String? phone,
    String? gender,
  }) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    _user = UserModel(
      name: name ?? _user?.name,
      email: email ?? _user?.email,
      phone: phone ?? _user?.phone,
      height: height,
      weight: weight,
      age: age,
      goal: goal,
      activityLevel: activityLevel,
      gender: gender ?? _user?.gender,
      hasCompletedDetails: true,
    );

    await _storageService!.setObject('user_data', _user!.toJson());
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateProfile({
    String? name,
    String? email,
    String? phone,
    double? height,
    double? weight,
    int? age,
    String? goal,
    String? activityLevel,
    String? gender,
  }) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 300));

    _user = UserModel(
      name: name ?? _user?.name,
      email: email ?? _user?.email,
      phone: phone ?? _user?.phone,
      height: height ?? _user?.height ?? 0,
      weight: weight ?? _user?.weight ?? 0,
      age: age ?? _user?.age ?? 0,
      goal: goal ?? _user?.goal ?? '',
      activityLevel: activityLevel ?? _user?.activityLevel ?? '',
      gender: gender ?? _user?.gender,
      hasCompletedDetails: _user?.hasCompletedDetails ?? true,
    );

    await _storageService!.setObject('user_data', _user!.toJson());
    _isLoading = false;
    notifyListeners();
  }

  Future<void> clearUser() async {
    await _storageService!.remove('user_data');
    _user = null;
    notifyListeners();
  }
}
