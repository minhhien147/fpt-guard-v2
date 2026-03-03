import 'package:flutter/material.dart';
import '../services/geofence_service.dart';
import '../services/location_service.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../widgets/custom_drawer.dart';

class GeofenceScreen extends StatefulWidget {
  const GeofenceScreen({super.key});

  @override
  State<GeofenceScreen> createState() => _GeofenceScreenState();
}

class _GeofenceScreenState extends State<GeofenceScreen> {
  bool _enabled    = false;
  bool _isLoading  = true;
  bool _isSaving   = false;
  bool _isFetching = false;
  int  _emailContactCount = 0;

  final _nameCtrl = TextEditingController(text: 'Khu vực an toàn');
  final _latCtrl  = TextEditingController();
  final _lngCtrl  = TextEditingController();
  double _radiusM  = 200;

  @override
  void initState() {
    super.initState();
    _loadSaved();
    _loadEmailContactCount();
  }

  Future<void> _loadEmailContactCount() async {
    final contacts = await DatabaseService.instance.getContacts();
    final count = contacts
        .where((c) => c.contactEmail != null && c.contactEmail!.isNotEmpty)
        .length;
    if (mounted) setState(() => _emailContactCount = count);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _latCtrl.dispose();
    _lngCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadSaved() async {
    final cfg = await GeofenceService.load();
    if (cfg != null && mounted) {
      setState(() {
        _enabled   = cfg['enabled'] as bool;
        _nameCtrl.text = cfg['name'] as String;
        _latCtrl.text  = (cfg['lat'] as double).toStringAsFixed(6);
        _lngCtrl.text  = (cfg['lng'] as double).toStringAsFixed(6);
        _radiusM   = cfg['radiusM'] as double;
      });
    }
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _useCurrentLocation() async {
    setState(() => _isFetching = true);
    final pos = await LocationService.getCurrentPosition();
    if (pos != null && mounted) {
      setState(() {
        _latCtrl.text = pos.latitude.toStringAsFixed(6);
        _lngCtrl.text = pos.longitude.toStringAsFixed(6);
      });
    } else if (mounted) {
      _snack('Không lấy được vị trí. Hãy bật GPS và thử lại.', error: true);
    }
    if (mounted) setState(() => _isFetching = false);
  }

  Future<void> _save() async {
    final lat = double.tryParse(_latCtrl.text.trim());
    final lng = double.tryParse(_lngCtrl.text.trim());
    if (lat == null || lng == null) {
      _snack('Tọa độ không hợp lệ', error: true);
      return;
    }
    setState(() => _isSaving = true);
    await GeofenceService.save(
      enabled: _enabled,
      name: _nameCtrl.text.trim().isEmpty ? 'Khu vực an toàn' : _nameCtrl.text.trim(),
      lat: lat,
      lng: lng,
      radiusM: _radiusM,
    );
    // Restart monitoring
    GeofenceService().stop();
    if (_enabled) await GeofenceService().start();
    if (mounted) {
      setState(() => _isSaving = false);
      _snack(_enabled ? 'Đã bật giám sát khu vực an toàn' : 'Đã lưu (tắt giám sát)');
    }
  }

  Future<void> _delete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xóa khu vực an toàn?'),
        content: const Text('Geofence sẽ bị xóa và tắt giám sát.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Hủy')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
    if (ok == true) {
      GeofenceService().stop();
      await GeofenceService.clear();
      if (mounted) {
        setState(() {
          _enabled = false;
          _latCtrl.clear();
          _lngCtrl.clear();
          _nameCtrl.text = 'Khu vực an toàn';
          _radiusM = 200;
        });
        _snack('Đã xóa khu vực an toàn');
      }
    }
  }

  void _snack(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: error ? Colors.red : Colors.green,
    ));
  }

  String _radiusLabel(double r) {
    if (r >= 1000) return '${(r / 1000).toStringAsFixed(1)} km';
    return '${r.toInt()} m';
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService().currentUser;
    final isPro = user?.isPro ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Khu vực an toàn'),
        actions: [
          if (!_isLoading && _latCtrl.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Xóa geofence',
              onPressed: _delete,
            ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : !isPro
              ? _buildProGate()
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoBanner(),
                      const SizedBox(height: 12),
                      _buildAlertInfoCard(),
                      const SizedBox(height: 20),
                      _buildEnableToggle(),
                      const SizedBox(height: 20),
                      _buildZoneForm(),
                      const SizedBox(height: 24),
                      _buildRadiusPicker(),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _isSaving ? null : _save,
                          icon: _isSaving
                              ? const SizedBox(
                                  width: 18, height: 18,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : const Icon(Icons.save),
                          label: Text(_isSaving ? 'Đang lưu...' : 'Lưu cài đặt'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildProGate() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock, size: 72, color: Colors.amber[600]),
            const SizedBox(height: 16),
            const Text(
              'Tính năng Pro',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'Geofence – Khu vực an toàn chỉ dành cho tài khoản Pro.\n\nKhi bật, app sẽ tự cảnh báo nếu bạn ra khỏi vùng đã định.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: const Row(
        children: [
          Icon(Icons.my_location, color: Colors.blue),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Khi bật, app theo dõi GPS và tự động cảnh báo khi bạn rời khỏi khu vực an toàn đã cấu hình.',
              style: TextStyle(fontSize: 13, color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertInfoCard() {
    final user = AuthService().currentUser;
    final selfEmail = user?.email ?? '';
    final totalRecipients = _emailContactCount + (selfEmail.isNotEmpty ? 1 : 0);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.orange[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.notifications_active, color: Colors.orange),
              SizedBox(width: 8),
              Text(
                'Khi vi phạm sẽ tự động:',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _alertRow(Icons.phone_android, 'Hiện cảnh báo ngay trên điện thoại'),
          _alertRow(
            Icons.email_outlined,
            totalRecipients > 0
                ? 'Gửi email cảnh báo tới $totalRecipients người nhận'
                : 'Gửi email cảnh báo (thêm email liên hệ trong Danh bạ)',
            highlight: totalRecipients == 0,
          ),
          _alertRow(Icons.history, 'Tạo báo cáo SOS trong lịch sử'),
          if (totalRecipients == 0) ...[
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/contacts'),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add_circle_outline, size: 16, color: Colors.orange),
                    SizedBox(width: 6),
                    Text(
                      'Thêm liên hệ có email ngay',
                      style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _alertRow(IconData icon, String text, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Row(
        children: [
          Icon(icon, size: 16, color: highlight ? Colors.red[400] : Colors.orange[700]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: highlight ? Colors.red[400] : Colors.grey[800],
                fontStyle: highlight ? FontStyle.italic : FontStyle.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnableToggle() {
    return Card(
      child: SwitchListTile(
        title: const Text('Bật giám sát geofence', style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(_enabled ? 'Đang giám sát khu vực' : 'Tắt – không theo dõi vị trí'),
        value: _enabled,
        onChanged: (v) => setState(() => _enabled = v),
        secondary: Icon(
          _enabled ? Icons.shield : Icons.shield_outlined,
          color: _enabled ? Colors.green : Colors.grey,
        ),
      ),
    );
  }

  Widget _buildZoneForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Thông tin khu vực', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 12),
        TextField(
          controller: _nameCtrl,
          decoration: const InputDecoration(
            labelText: 'Tên khu vực',
            prefixIcon: Icon(Icons.label_outline),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _latCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                decoration: const InputDecoration(
                  labelText: 'Vĩ độ (Latitude)',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _lngCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                decoration: const InputDecoration(
                  labelText: 'Kinh độ (Longitude)',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _isFetching ? null : _useCurrentLocation,
            icon: _isFetching
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.my_location),
            label: Text(_isFetching ? 'Đang lấy vị trí...' : 'Dùng vị trí hiện tại làm tâm'),
          ),
        ),
      ],
    );
  }

  Widget _buildRadiusPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Bán kính cảnh báo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _radiusLabel(_radiusM),
                style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        Slider(
          value: _radiusM,
          min: 50,
          max: 5000,
          divisions: 98,
          label: _radiusLabel(_radiusM),
          onChanged: (v) => setState(() => _radiusM = v),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('50 m', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            Text('5 km', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          ],
        ),
      ],
    );
  }
}
