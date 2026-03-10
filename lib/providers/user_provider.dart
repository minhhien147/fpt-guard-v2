import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/database_service.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get hasUser => _user != null;

  // Tải thông tin user từ database
  Future<void> loadUser() async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = await DatabaseService.instance.getUser();
    } catch (e) {
      print('Error loading user: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Lưu hoặc cập nhật user
  Future<bool> saveUser(UserModel user) async {
    try {
      // Load user hiện tại nếu chưa có
      if (_user == null) {
        await loadUser();
      }

      if (_user != null && _user!.id != null) {
        // Update existing user
        final updatedUser = user.copyWith(id: _user!.id, createdAt: _user!.createdAt);
        final result = await DatabaseService.instance.updateUser(updatedUser);
        if (result > 0) {
          _user = updatedUser;
          notifyListeners();
          return true;
        } else {
          print('Update failed: No rows affected');
          return false;
        }
      } else {
        // Insert new user
        final id = await DatabaseService.instance.insertUser(user);
        if (id > 0) {
          _user = user.copyWith(id: id);
          notifyListeners();
          return true;
        } else {
          print('Insert failed: No ID returned');
          return false;
        }
      }
    } catch (e) {
      print('Error saving user: $e');
      return false;
    }
  }

  /// Cập nhật user trong bộ nhớ từ dữ liệu API (không đọc lại SQLite).
  void setFromApiUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  // Xóa user (đăng xuất)
  void clearUser() {
    _user = null;
    notifyListeners();
  }
}

