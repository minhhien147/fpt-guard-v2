import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../models/user_model.dart';

class AuthService {
  static String get baseUrl => dotenv.env['API_BASE_URL'] ?? 'https://web-production-dd806.up.railway.app';
  
  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();
  
  String? _token;
  String? _refreshToken;
  UserModel? _currentUser;
  
  String? get token => _token;
  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _token != null;

  /// Gọi khi server trả 401/403 (token hết hạn hoặc tài khoản bị khóa) → app sẽ logout và chuyển về màn login.
  void Function()? onUnauthorized;

  // Initialize - Load token from storage
  Future<bool> init() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    _refreshToken = prefs.getString('refresh_token');
    
    if (_token != null) {
      // Verify token and load user
      return await loadCurrentUser();
    }
    
    return false;
  }
  
  // Register
  Future<Map<String, dynamic>> register({
    required String fullName,
    required String studentId,
    required String phone,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'full_name': fullName,
          'student_id': studentId,
          'phone': phone,
          'email': email,
          'password': password,
        }),
      );
      
      final data = jsonDecode(response.body);
      
      if (response.statusCode == 201 && data['success']) {
        await _saveAuthData(
          data['data']['token'],
          data['data']['refresh_token'],
          data['data']['user'],
        );
        return {'success': true, 'user': _currentUser};
      } else {
        return {'success': false, 'error': data['error'] ?? 'Đăng ký thất bại'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Lỗi kết nối: ${e.toString()}'};
    }
  }
  
  // Login
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );
      
      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200 && data['success']) {
        await _saveAuthData(
          data['data']['token'],
          data['data']['refresh_token'],
          data['data']['user'],
        );
        return {'success': true, 'user': _currentUser};
      } else if (response.statusCode == 403 && data['requires_verification'] == true) {
        return {
          'success': false,
          'requires_verification': true,
          'email': data['email'] ?? '',
          'error': data['error'] ?? 'Email chưa xác thực',
        };
      } else {
        return {'success': false, 'error': data['error'] ?? 'Đăng nhập thất bại'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Lỗi kết nối: ${e.toString()}'};
    }
  }

  // Verify email with OTP
  Future<Map<String, dynamic>> verifyEmail({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/verify-email'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp': otp}),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success']) {
        await _saveAuthData(
          data['data']['token'],
          data['data']['refresh_token'],
          data['data']['user'],
        );
        return {'success': true};
      }
      return {'success': false, 'error': data['error'] ?? 'Xác thực thất bại'};
    } catch (e) {
      return {'success': false, 'error': 'Lỗi kết nối: ${e.toString()}'};
    }
  }

  // Resend OTP
  Future<Map<String, dynamic>> resendOtp({required String email}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/resend-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success']) {
        return {'success': true, 'message': data['message']};
      }
      return {'success': false, 'error': data['error'] ?? 'Gửi lại thất bại'};
    } catch (e) {
      return {'success': false, 'error': 'Lỗi kết nối: ${e.toString()}'};
    }
  }

  // Group code login
  Future<Map<String, dynamic>> groupLogin({
    required String code,
    required String nickname,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/group-login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'code': code, 'nickname': nickname}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success']) {
        await _saveAuthData(
          data['data']['token'],
          data['data']['refresh_token'],
          data['data']['user'],
        );
        return {'success': true, 'user': _currentUser};
      } else {
        return {'success': false, 'error': data['error'] ?? 'Đăng nhập thất bại'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Lỗi kết nối: ${e.toString()}'};
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      if (_token != null) {
        await http.post(
          Uri.parse('$baseUrl/api/auth/logout'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $_token',
          },
        );
      }
    } catch (e) {
      print('Error during logout: $e');
    } finally {
      await _clearAuthData();
    }
  }
  
  // Load current user
  Future<bool> loadCurrentUser() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/auth/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          _currentUser = UserModel.fromMap(data['data']);
          return true;
        }
      }

      if (response.statusCode == 401 || response.statusCode == 403) {
        await _clearAuthData();
        onUnauthorized?.call();
      } else {
        await _clearAuthData();
      }
      return false;
    } catch (e) {
      print('Error loading current user: $e');
      return false;
    }
  }
  
  // Update profile
  Future<Map<String, dynamic>> updateProfile({
    String? fullName,
    String? phone,
    String? studentId,
  }) async {
    try {
      final Map<String, dynamic> updates = {};
      if (fullName != null) updates['full_name'] = fullName;
      if (phone != null) updates['phone'] = phone;
      if (studentId != null) updates['student_id'] = studentId;
      
      final response = await http.put(
        Uri.parse('$baseUrl/api/auth/update'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: jsonEncode(updates),
      );
      
      final data = jsonDecode(response.body);

      if (response.statusCode == 401 || response.statusCode == 403) {
        await _clearAuthData();
        onUnauthorized?.call();
        return {'success': false, 'error': data['error'] ?? 'Phiên đăng nhập đã hết hạn hoặc tài khoản bị khóa'};
      }
      if (response.statusCode == 200 && data['success']) {
        _currentUser = UserModel.fromMap(data['data']);
        return {'success': true, 'user': _currentUser};
      }
      return {'success': false, 'error': data['error'] ?? 'Cập nhật thất bại'};
    } catch (e) {
      return {'success': false, 'error': 'Lỗi kết nối: ${e.toString()}'};
    }
  }

  // Track activity
  Future<void> trackActivity(String action, Map<String, dynamic>? details) async {
    try {
      if (_token == null) return;
      
      await http.post(
        Uri.parse('$baseUrl/api/activity/track'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: jsonEncode({
          'action': action,
          'details': details,
        }),
      );
    } catch (e) {
      print('Error tracking activity: $e');
    }
  }
  
  // Create SOS report
  Future<Map<String, dynamic>> createSOSReport({
    required double latitude,
    required double longitude,
    String? message,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/sos'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: jsonEncode({
          'latitude': latitude,
          'longitude': longitude,
          'message': message,
        }),
      );
      
      final data = jsonDecode(response.body);

      if (response.statusCode == 401 || response.statusCode == 403) {
        await _clearAuthData();
        onUnauthorized?.call();
        return {'success': false, 'error': data['error'] ?? 'Phiên đăng nhập đã hết hạn hoặc tài khoản bị khóa'};
      }
      if (response.statusCode == 201 && data['success']) {
        return {'success': true, 'report_id': data['data']['report_id']};
      }
      return {'success': false, 'error': data['error'] ?? 'Gửi báo cáo thất bại'};
    } catch (e) {
      return {'success': false, 'error': 'Lỗi kết nối: ${e.toString()}'};
    }
  }

  // Private methods
  
  Future<void> _saveAuthData(String token, String refreshToken, Map<String, dynamic> userData) async {
    _token = token;
    _refreshToken = refreshToken;
    _currentUser = UserModel.fromMap(userData);
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    await prefs.setString('refresh_token', refreshToken);
    await prefs.setString('user_data', jsonEncode(userData));

    // Upload FCM token to server for push notifications
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken != null) await uploadFcmToken(fcmToken);
    } catch (_) {}
  }
  
  Future<void> _clearAuthData() async {
    _token = null;
    _refreshToken = null;
    _currentUser = null;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('refresh_token');
    await prefs.remove('user_data');
  }

  /// Gửi FCM token lên server (gọi sau khi login/register thành công)
  Future<void> uploadFcmToken(String fcmToken) async {
    if (_token == null) return;
    try {
      await http.post(
        Uri.parse('$baseUrl/api/auth/fcm-token'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'},
        body: jsonEncode({'token': fcmToken}),
      );
    } catch (_) {}
  }

  // Refresh token
  Future<bool> refreshAccessToken() async {
    try {
      if (_refreshToken == null) return false;
      
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/refresh'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh_token': _refreshToken}),
      );
      
      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200 && data['success']) {
        _token = data['data']['token'];
        _refreshToken = data['data']['refresh_token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', _token!);
        await prefs.setString('refresh_token', _refreshToken!);
        return true;
      }
      if (response.statusCode == 401 || response.statusCode == 403) {
        await _clearAuthData();
        onUnauthorized?.call();
      }
      return false;
    } catch (e) {
      print('Error refreshing token: $e');
      return false;
    }
  }
}
