import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/tide_model.dart';
import '../services/tide_service.dart';
import '../widgets/custom_drawer.dart';

class TideScreen extends StatefulWidget {
  const TideScreen({super.key});

  @override
  State<TideScreen> createState() => _TideScreenState();
}

class _TideScreenState extends State<TideScreen> {
  List<TideModel> _tides = [];
  bool _isLoading = false;
  TideModel? _todayTide;

  @override
  void initState() {
    super.initState();
    _loadTideData();
  }

  Future<void> _loadTideData() async {
    setState(() => _isLoading = true);

    try {
      final tides = await TideService.getTideData(days: 7);
      setState(() {
        _tides = tides;
        _todayTide = tides.isNotEmpty ? tides.first : null;
      });
    } catch (e) {
      print('Error loading tide data: $e');
    }

    setState(() => _isLoading = false);
  }

  String _formatTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  String _getDayName(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return 'Hôm nay';
    }
    return DateFormat('EEEE', 'vi').format(date);
  }

  Color _getWarningColor(String level) {
    switch (level) {
      case 'Đỏ':
        return Colors.red;
      case 'Cam':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Triều Cường Cần Thơ'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadTideData,
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadTideData,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Card hôm nay
                  if (_todayTide != null) ...[
                    _buildTodayCard(_todayTide!),
                    const SizedBox(height: 20),
                  ],

                  // Tiêu đề
                  const Text(
                    'Dự báo 7 ngày tới',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Danh sách các ngày
                  ..._tides.map((tide) => _buildTideCard(tide)),
                ],
              ),
            ),
    );
  }

  Widget _buildTodayCard(TideModel tide) {
    return Card(
      elevation: 4,
      color: Colors.orange[50],
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.water_drop, color: Colors.blue[700], size: 32),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Triều Cường Hôm Nay',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Mực nước cao nhất
            _buildTideInfoRow(
              icon: Icons.arrow_upward,
              label: 'Nước lên cao nhất',
              value: '${tide.highTideLevel.toStringAsFixed(0)} cm',
              time: _formatTime(tide.highTideTime),
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            
            // Mực nước thấp nhất
            _buildTideInfoRow(
              icon: Icons.arrow_downward,
              label: 'Nước xuống thấp nhất',
              value: '${tide.lowTideLevel.toStringAsFixed(0)} cm',
              time: _formatTime(tide.lowTideTime),
              color: Colors.blue,
            ),
            
            // Cảnh báo
            if (tide.hasWarning) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getWarningColor(tide.warningColor).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _getWarningColor(tide.warningColor),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning,
                      color: _getWarningColor(tide.warningColor),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        tide.warning!,
                        style: TextStyle(
                          color: _getWarningColor(tide.warningColor),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTideCard(TideModel tide) {
    final isToday = tide.date.year == DateTime.now().year &&
        tide.date.month == DateTime.now().month &&
        tide.date.day == DateTime.now().day;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isToday ? 4 : 2,
      color: isToday ? Colors.orange[50] : null,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _getDayName(tide.date),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isToday ? Colors.orange[900] : null,
                  ),
                ),
                Text(
                  _formatDate(tide.date),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: _buildMiniTideInfo(
                    icon: Icons.arrow_upward,
                    label: 'Cao',
                    value: '${tide.highTideLevel.toStringAsFixed(0)}cm',
                    time: _formatTime(tide.highTideTime),
                    color: Colors.red,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMiniTideInfo(
                    icon: Icons.arrow_downward,
                    label: 'Thấp',
                    value: '${tide.lowTideLevel.toStringAsFixed(0)}cm',
                    time: _formatTime(tide.lowTideTime),
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            
            if (tide.hasWarning) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.warning_amber,
                    size: 16,
                    color: _getWarningColor(tide.warningColor),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      tide.warning!,
                      style: TextStyle(
                        fontSize: 12,
                        color: _getWarningColor(tide.warningColor),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTideInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required String time,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'lúc $time',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMiniTideInfo({
    required IconData icon,
    required String label,
    required String value,
    required String time,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

