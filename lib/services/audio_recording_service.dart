import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

/// Service ghi âm audio cho SOS khẩn cấp
class AudioRecordingService {
  static final AudioRecordingService _instance = AudioRecordingService._internal();
  factory AudioRecordingService() => _instance;
  AudioRecordingService._internal();

  final AudioRecorder _recorder = AudioRecorder();
  bool _isRecording = false;

  /// Ghi âm trong X giây và trả về file audio
  /// 
  /// [durationSeconds] - Thời gian ghi âm (mặc định: 5 giây)
  /// Returns: File audio hoặc null nếu lỗi
  Future<File?> recordAudio({int durationSeconds = 5}) async {
    if (_isRecording) {
      debugPrint('Already recording, skipping...');
      return null;
    }

    try {
      // Kiểm tra quyền microphone
      if (!await _recorder.hasPermission()) {
        debugPrint('Microphone permission denied');
        return null;
      }

      // Tạo file tạm để lưu audio
      final directory = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath = '${directory.path}/sos_audio_$timestamp.m4a';
      final file = File(filePath);

      _isRecording = true;
      debugPrint('🎤 Starting audio recording for $durationSeconds seconds...');

      // Bắt đầu ghi âm
      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: filePath,
      );

      // Đợi X giây
      await Future.delayed(Duration(seconds: durationSeconds));

      // Dừng ghi âm
      final path = await _recorder.stop();
      _isRecording = false;

      if (path != null && await file.exists()) {
        debugPrint('✅ Audio recorded successfully: $path');
        return file;
      } else {
        debugPrint('❌ Failed to save audio file');
        return null;
      }
    } catch (e) {
      _isRecording = false;
      debugPrint('❌ Error recording audio: $e');
      return null;
    }
  }

  /// Dừng ghi âm ngay lập tức (nếu đang ghi)
  Future<void> stopRecording() async {
    if (_isRecording) {
      try {
        await _recorder.stop();
        _isRecording = false;
        debugPrint('🛑 Recording stopped');
      } catch (e) {
        debugPrint('Error stopping recording: $e');
      }
    }
  }

  /// Kiểm tra đang ghi âm không
  bool get isRecording => _isRecording;

  /// Dọn dẹp
  Future<void> dispose() async {
    await stopRecording();
    await _recorder.dispose();
  }
}
