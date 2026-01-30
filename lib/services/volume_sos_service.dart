import 'dart:async';
import 'package:flutter/material.dart';
import 'package:volume_controller/volume_controller.dart';

/// Service phát hiện bấm nút âm lượng 3 lần liên tiếp để kích hoạt SOS
class VolumeSOSService {
  static final VolumeSOSService _instance = VolumeSOSService._internal();
  factory VolumeSOSService() => _instance;
  VolumeSOSService._internal();

  // VolumeController là singleton factory trong v2.0.8
  final VolumeController _volumeController = VolumeController();
  StreamSubscription<double>? _volumeSubscription;

  // Callback khi phát hiện 3 lần bấm
  Function? onTriplePress;

  // Cấu hình
  final int _maxPressCount = 3; // Bấm 3 lần
  final int _resetTimeSeconds = 3; // Reset sau 3 giây

  // State
  int _pressCount = 0;
  Timer? _resetTimer;
  bool _isEnabled = true;
  double? _previousVolume;

  /// Khởi tạo và bắt đầu lắng nghe
  Future<void> initialize({required Function onTriplePress}) async {
    this.onTriplePress = onTriplePress;

    // Lắng nghe thay đổi âm lượng (API của version 2.0.8: listener)
    _volumeSubscription = _volumeController.listener((double? volume) {
      if (volume != null) {
        _onVolumeChanged(volume);
      }
    });

    _previousVolume = await _volumeController.getVolume();

    debugPrint('VolumeSOSService initialized');
  }

  /// Xử lý khi âm lượng thay đổi
  void _onVolumeChanged(double volume) {
    if (!_isEnabled) return;

    // Log cho dễ debug
    debugPrint('Volume changed: $volume (prev: $_previousVolume)');

    // Kiểm tra nếu âm lượng thay đổi (người dùng bấm nút)
    if (_previousVolume != null && volume != _previousVolume) {
      _onVolumeButtonPressed();
    }

    _previousVolume = volume;
  }

  /// Xử lý khi nút âm lượng được bấm
  void _onVolumeButtonPressed() {
    // Tăng số lần bấm
    _pressCount++;
    debugPrint('Volume button pressed: $_pressCount/$_maxPressCount');
    
    // Hủy timer reset cũ
    _resetTimer?.cancel();
    
    // Kiểm tra đã đủ số lần bấm chưa
    if (_pressCount >= _maxPressCount) {
      _triggerSOS();
      _resetCount();
    } else {
      // Đặt timer để reset sau X giây
      _resetTimer = Timer(Duration(seconds: _resetTimeSeconds), () {
        debugPrint('Reset volume button count');
        _resetCount();
      });
    }
  }

  /// Kích hoạt SOS
  void _triggerSOS() {
    debugPrint('🚨 TRIPLE PRESS DETECTED - TRIGGERING SOS!');
    
    // Tắt tạm thời để tránh trigger nhiều lần
    _isEnabled = false;
    
    // Gọi callback
    if (onTriplePress != null) {
      onTriplePress!();
    }
    
    // Bật lại sau 5 giây
    Timer(const Duration(seconds: 5), () {
      _isEnabled = true;
      debugPrint('VolumeSOSService re-enabled');
    });
  }

  /// Reset số lần bấm
  void _resetCount() {
    _pressCount = 0;
    _resetTimer?.cancel();
  }

  /// Tạm dừng lắng nghe
  void pause() {
    _isEnabled = false;
    debugPrint('VolumeSOSService paused');
  }

  /// Tiếp tục lắng nghe
  void resume() {
    _isEnabled = true;
    _resetCount();
    debugPrint('VolumeSOSService resumed');
  }

  /// Dọn dẹp
  void dispose() {
    _volumeSubscription?.cancel();
    _resetTimer?.cancel();
    debugPrint('VolumeSOSService disposed');
  }
}

