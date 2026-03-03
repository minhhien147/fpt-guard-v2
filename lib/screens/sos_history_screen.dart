import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../widgets/custom_drawer.dart';

class SOSHistoryScreen extends StatefulWidget {
  const SOSHistoryScreen({super.key});

  @override
  State<SOSHistoryScreen> createState() => _SOSHistoryScreenState();
}

class _SOSHistoryScreenState extends State<SOSHistoryScreen> {
  static const _pageSize = 20;

  List<Map<String, dynamic>> _reports = [];
  int _total    = 0;
  int _offset   = 0;
  bool _loading = false;
  bool _loadingMore = false;
  bool _hasMore = true;

  int _thisMonth = 0;
  bool _isPro    = false;
  String? _resetAt;

  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _load(reset: true);
    _scrollCtrl.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollCtrl.position.pixels >= _scrollCtrl.position.maxScrollExtent - 150
        && !_loadingMore && _hasMore) {
      _loadMore();
    }
  }

  Future<void> _load({bool reset = false}) async {
    setState(() { _loading = true; if (reset) { _reports = []; _offset = 0; } });
    final data = await ApiService.getSosHistory(limit: _pageSize, offset: 0);
    setState(() {
      _reports     = List<Map<String, dynamic>>.from(data['reports'] ?? []);
      _total       = data['total'] ?? 0;
      _thisMonth   = data['this_month_count'] ?? 0;
      _isPro       = data['is_pro'] ?? false;
      _resetAt     = data['reset_at'];
      _offset      = _reports.length;
      _hasMore     = _reports.length < _total;
      _loading     = false;
    });
  }

  Future<void> _loadMore() async {
    setState(() => _loadingMore = true);
    final data = await ApiService.getSosHistory(limit: _pageSize, offset: _offset);
    final more = List<Map<String, dynamic>>.from(data['reports'] ?? []);
    setState(() {
      _reports.addAll(more);
      _offset += more.length;
      _hasMore = _reports.length < _total;
      _loadingMore = false;
    });
  }

  Future<void> _openMap(double lat, double lng) async {
    final uri = Uri.parse('https://www.google.com/maps?q=$lat,$lng');
    if (await canLaunchUrl(uri)) launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  String _formatDate(String? s) {
    if (s == null) return '';
    try {
      final d = DateTime.parse(s).toLocal();
      return '${d.day.toString().padLeft(2,'0')}/${d.month.toString().padLeft(2,'0')}/${d.year}  ${d.hour.toString().padLeft(2,'0')}:${d.minute.toString().padLeft(2,'0')}';
    } catch (_) { return s; }
  }

  Color _statusColor(String? s) {
    switch (s) {
      case 'resolved': return Colors.green;
      case 'pending':  return Colors.orange;
      default:         return Colors.blue;
    }
  }

  String _statusLabel(String? s) {
    switch (s) {
      case 'resolved': return 'Đã xử lý';
      case 'pending':  return 'Chờ xử lý';
      default:         return s ?? 'active';
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService().currentUser;
    final isPro = user?.isPro ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch sử SOS'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _load(reset: true),
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: !isPro
          ? _buildProGate()
          : _loading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    _buildStatsBanner(),
                    Expanded(
                      child: _reports.isEmpty
                          ? _buildEmpty()
                          : RefreshIndicator(
                              onRefresh: () => _load(reset: true),
                              child: ListView.builder(
                                controller: _scrollCtrl,
                                padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
                                itemCount: _reports.length + (_loadingMore ? 1 : 0),
                                itemBuilder: (ctx, i) {
                                  if (i == _reports.length) {
                                    return const Padding(
                                      padding: EdgeInsets.symmetric(vertical: 16),
                                      child: Center(child: CircularProgressIndicator()),
                                    );
                                  }
                                  return _ReportCard(
                                    report: _reports[i],
                                    formattedDate: _formatDate(_reports[i]['created_at']),
                                    statusColor: _statusColor(_reports[i]['status']),
                                    statusLabel: _statusLabel(_reports[i]['status']),
                                    onOpenMap: _openMap,
                                  );
                                },
                              ),
                            ),
                    ),
                  ],
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
            const Text('Tính năng Pro', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text(
              'Lịch sử & thống kê SOS chỉ dành cho tài khoản Pro.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsBanner() {
    final limit = _isPro ? '∞' : '10';
    String resetInfo = '';
    if (_resetAt != null) {
      try {
        final d = DateTime.parse(_resetAt!).toLocal();
        resetInfo = 'Reset lần cuối: ${d.day}/${d.month}/${d.year}';
      } catch (_) {}
    }
    return Container(
      color: const Color(0xFF03045E),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tổng SOS đã gửi: $_total',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Tháng này: $_thisMonth / $limit lượt',
                    style: const TextStyle(color: Colors.white70, fontSize: 13)),
                if (resetInfo.isNotEmpty)
                  Text(resetInfo, style: const TextStyle(color: Colors.white54, fontSize: 11)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _isPro ? Colors.amber : Colors.white24,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _isPro ? '★ PRO' : 'FREE',
              style: TextStyle(
                color: _isPro ? Colors.black87 : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.sos, size: 72, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text('Chưa có lịch sử SOS',
              style: TextStyle(fontSize: 18, color: Colors.grey[500], fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text('Các SOS đã gửi sẽ xuất hiện ở đây',
              style: TextStyle(fontSize: 13, color: Colors.grey[400])),
        ],
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final Map<String, dynamic> report;
  final String formattedDate;
  final Color statusColor;
  final String statusLabel;
  final Future<void> Function(double, double) onOpenMap;

  const _ReportCard({
    required this.report,
    required this.formattedDate,
    required this.statusColor,
    required this.statusLabel,
    required this.onOpenMap,
  });

  @override
  Widget build(BuildContext context) {
    final lat  = report['location_lat'] as num?;
    final lng  = report['location_lon'] as num?;
    final msg  = report['message'] as String?;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.sos, color: Colors.red, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(formattedDate,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: statusColor.withAlpha(26),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: statusColor.withAlpha(128)),
                  ),
                  child: Text(statusLabel,
                      style: TextStyle(fontSize: 11, color: statusColor, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            if (msg != null && msg.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(msg, style: TextStyle(fontSize: 13, color: Colors.grey[700]), maxLines: 2,
                  overflow: TextOverflow.ellipsis),
            ],
            if (lat != null && lng != null) ...[
              const SizedBox(height: 10),
              InkWell(
                onTap: () => onOpenMap(lat.toDouble(), lng.toDouble()),
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.green[200]!),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.map, size: 15, color: Colors.green),
                      const SizedBox(width: 6),
                      Text('${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}',
                          style: const TextStyle(fontSize: 12, color: Colors.green)),
                      const SizedBox(width: 6),
                      const Text('→ Maps', style: TextStyle(fontSize: 12, color: Colors.green)),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
