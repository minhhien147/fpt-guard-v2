import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/water_level_provider.dart';
import '../widgets/water_level_card.dart';
import 'station_detail_screen.dart';

/// Màn hình hiển thị danh sách mực nước các trạm
class WaterLevelScreen extends StatefulWidget {
  const WaterLevelScreen({Key? key}) : super(key: key);

  @override
  State<WaterLevelScreen> createState() => _WaterLevelScreenState();
}

class _WaterLevelScreenState extends State<WaterLevelScreen> {
  @override
  void initState() {
    super.initState();
    // Load dữ liệu khi màn hình khởi tạo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WaterLevelProvider>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mực nước Sông Mekong'),
        elevation: 2,
        actions: [
          // Refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<WaterLevelProvider>().refresh();
            },
            tooltip: 'Làm mới',
          ),
          // Trigger manual update
          IconButton(
            icon: const Icon(Icons.cloud_sync),
            onPressed: () async {
              final provider = context.read<WaterLevelProvider>();
              final success = await provider.triggerUpdate();
              
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Đã yêu cầu cập nhật dữ liệu'
                          : 'Không thể cập nhật dữ liệu',
                    ),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );
              }
            },
            tooltip: 'Cập nhật từ server',
          ),
        ],
      ),
      body: Consumer<WaterLevelProvider>(
        builder: (context, provider, child) {
          // Hiển thị loading
          if (provider.isLoading && provider.stations.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Đang tải dữ liệu mực nước...'),
                ],
              ),
            );
          }

          // Hiển thị lỗi nếu backend không hoạt động
          if (!provider.isBackendHealthy) {
            return _buildBackendErrorWidget(context);
          }

          // Hiển thị lỗi khác
          if (provider.error != null && provider.stations.isEmpty) {
            return _buildErrorWidget(context, provider.error!);
          }

          // Hiển thị thông báo nếu không có dữ liệu
          if (provider.stations.isEmpty) {
            return _buildEmptyWidget(context);
          }

          // Hiển thị danh sách trạm
          return RefreshIndicator(
            onRefresh: () => provider.refresh(),
            child: Column(
              children: [
                // Header với thống kê
                _buildHeaderStats(provider),
                
                // Danh sách các trạm
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 16),
                    itemCount: provider.stations.length,
                    itemBuilder: (context, index) {
                      final station = provider.stations.values.elementAt(index);
                      return WaterLevelCard(
                        station: station,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StationDetailScreen(
                                stationId: station.stationId,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderStats(WaterLevelProvider provider) {
    final hasCritical = provider.hasCriticalAlerts;
    final alertCount = provider.alertStations.length;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: hasCritical
              ? [Colors.red.shade400, Colors.red.shade600]
              : alertCount > 0
                  ? [Colors.orange.shade400, Colors.orange.shade600]
                  : [Colors.blue.shade400, Colors.blue.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                hasCritical
                    ? Icons.warning_rounded
                    : alertCount > 0
                        ? Icons.warning_amber_rounded
                        : Icons.check_circle,
                color: Colors.white,
                size: 32,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasCritical
                          ? 'CÓ CẢNH BÁO NGHIÊM TRỌNG!'
                          : alertCount > 0
                              ? 'CÓ CẢNH BÁO'
                              : 'TẤT CẢ BÌNH THƯỜNG',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      alertCount > 0
                          ? '$alertCount/${provider.stations.length} trạm có cảnh báo'
                          : '${provider.stations.length} trạm đang theo dõi',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (provider.lastUpdated != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.access_time,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Cập nhật: ${_formatTime(provider.lastUpdated!)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBackendErrorWidget(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            const Text(
              'Không thể kết nối Backend',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Vui lòng đảm bảo Python backend đang chạy tại:\nhttp://localhost:5000',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<WaterLevelProvider>().initialize();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Thử lại'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red[300],
            ),
            const SizedBox(height: 24),
            const Text(
              'Đã xảy ra lỗi',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              error,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<WaterLevelProvider>().refresh();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyWidget(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.water_drop_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            const Text(
              'Chưa có dữ liệu',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Kéo xuống để làm mới',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'Vừa xong';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} phút trước';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} giờ trước';
    } else {
      return '${time.day}/${time.month} ${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    }
  }
}

