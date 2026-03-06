import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

/// Service ghi âm audio cho SOS khẩn cấp.
///
/// Luồng chính:
///   1. Gọi [startBackground()] ngay khi màn hình SOS mở → bắt đầu ghi, không block.
///   2. Gọi [stopAndGetFile()] khi user nhấn "Gửi" → dừng ghi, trả về File.
class AudioRecordingService {
  static final AudioRecordingService _instance = AudioRecordingService._internal();
  factory AudioRecordingService() => _instance;
  AudioRecordingService._internal();

  final AudioRecorder _recorder = AudioRecorder();
  bool _isRecording = false;
  bool _isStarting = false;
  String? _currentFilePath;

  bool get isRecording => _isRecording;

  // ── Background recording (non-blocking) ──────────────────────────────────

  /// Bắt đầu ghi âm ngay, không chờ – trả về ngay lập tức.
  /// Nếu đang ghi thì bỏ qua.
  Future<void> startBackground() async {
    if (_isRecording || _isStarting) return;
    _isStarting = true;
    try {
      if (!await _recorder.hasPermission()) {
        debugPrint('🎤 Microphone permission denied');
        return;
      }
      final dir = await getTemporaryDirectory();
      final ts  = DateTime.now().millisecondsSinceEpoch;
      _currentFilePath = '${dir.path}/sos_audio_$ts.m4a';
      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: _currentFilePath!,
      );
      // Set _isRecording AFTER start() completes to avoid race condition
      _isRecording = true;
      debugPrint('🎤 Background recording started → $_currentFilePath');
    } catch (e) {
      _isRecording = false;
      _currentFilePath = null;
      debugPrint('❌ startBackground error: $e');
    } finally {
      _isStarting = false;
    }
  }

  /// Dừng ghi âm và trả về file đã ghi.
  /// Nếu không đang ghi thì trả về null.
  Future<File?> stopAndGetFile() async {
    // If still starting up (race condition on Samsung), abort cleanly
    if (_isStarting) {
      debugPrint('⚠️ stopAndGetFile called while still starting – aborting');
      return null;
    }
    if (!_isRecording) return null;
    try {
      final path = await _recorder.stop();
      _isRecording = false;
      final resolvedPath = path ?? _currentFilePath;
      _currentFilePath = null;
      if (resolvedPath != null) {
        final f = File(resolvedPath);
        if (await f.exists() && await f.length() > 0) {
          debugPrint('✅ Audio saved: $resolvedPath (${await f.length()} bytes)');
          return f;
        }
      }
      debugPrint('❌ Audio file not found or empty');
      return null;
    } catch (e) {
      _isRecording = false;
      _currentFilePath = null;
      debugPrint('❌ stopAndGetFile error: $e');
      return null;
    }
  }

  // ── Legacy API (kept for compatibility) ──────────────────────────────────

  /// Ghi âm trong [durationSeconds] giây (blocking). Dùng khi cần ghi cố định.
  Future<File?> recordAudio({int durationSeconds = 5}) async {
    if (_isRecording || _isStarting) return null;
    _isStarting = true;
    try {
      if (!await _recorder.hasPermission()) return null;
      final dir = await getTemporaryDirectory();
      final ts  = DateTime.now().millisecondsSinceEpoch;
      _currentFilePath = '${dir.path}/sos_audio_$ts.m4a';
      await _recorder.start(
        const RecordConfig(encoder: AudioEncoder.aacLc, bitRate: 128000, sampleRate: 44100),
        path: _currentFilePath!,
      );
      _isRecording = true;
      _isStarting = false;
      await Future.delayed(Duration(seconds: durationSeconds));
      return await stopAndGetFile();
    } catch (e) {
      _isRecording = false;
      _currentFilePath = null;
      debugPrint('❌ recordAudio error: $e');
      return null;
    } finally {
      _isStarting = false;
    }
  }

  /// Dừng ngay (không trả file).
  Future<void> stopRecording() async {
    if (_isStarting) {
      // Wait briefly for start to finish before stopping
      await Future.delayed(const Duration(milliseconds: 300));
    }
    if (_isRecording) {
      try {
        await _recorder.stop();
      } catch (_) {}
      _isRecording = false;
      _currentFilePath = null;
    }
  }

  Future<void> dispose() async {
    await stopRecording();
    await _recorder.dispose();
  }
}
