import 'package:flutter/material.dart';
import '../models/water_level_model.dart';

/// Card hiển thị thông tin mực nước của một trạm
class WaterLevelCard extends StatelessWidget {
  final WaterLevelStation station;
  final VoidCallback? onTap;

  const WaterLevelCard({
    Key? key,
    required this.station,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: _getAlertColor(station.alert.level),
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Tên trạm và alert indicator
              Row(
                children: [
                  Expanded(
                    child: Text(
                      station.stationName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _buildAlertBadge(station.alert.level),
                ],
              ),
              const SizedBox(height: 12),
              
              // Mực nước hiện tại
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    station.current.waterLevel.toStringAsFixed(2),
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: _getAlertColor(station.alert.level),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      station.current.unit,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              
              // Xu hướng
              Row(
                children: [
                  Icon(
                    _getTrendIcon(station.trend.direction),
                    color: _getTrendColor(station.trend.direction),
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    station.trend.directionVn,
                    style: TextStyle(
                      color: _getTrendColor(station.trend.direction),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '(${station.trend.rateDescription})',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Thời gian cập nhật
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    station.current.timestampVn,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              
              // Message cảnh báo (nếu có)
              if (station.alert.level != 'NORMAL') ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getAlertColor(station.alert.level).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        station.alert.isCritical
                            ? Icons.warning_rounded
                            : Icons.info_outline,
                        color: _getAlertColor(station.alert.level),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          station.alert.message,
                          style: TextStyle(
                            color: _getAlertColor(station.alert.level),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
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
      ),
    );
  }

  Widget _buildAlertBadge(String level) {
    String text;
    IconData icon;
    
    switch (level) {
      case 'CRITICAL':
        text = 'NGUY HIỂM';
        icon = Icons.warning_rounded;
        break;
      case 'WARNING':
        text = 'CẢNH BÁO';
        icon = Icons.warning_amber_rounded;
        break;
      default:
        text = 'BÌN THƯỜNG';
        icon = Icons.check_circle;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getAlertColor(level),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Color _getAlertColor(String level) {
    switch (level) {
      case 'CRITICAL':
        return Colors.red;
      case 'WARNING':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  IconData _getTrendIcon(String direction) {
    switch (direction) {
      case 'rising':
        return Icons.trending_up;
      case 'falling':
        return Icons.trending_down;
      default:
        return Icons.trending_flat;
    }
  }

  Color _getTrendColor(String direction) {
    switch (direction) {
      case 'rising':
        return Colors.red;
      case 'falling':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}

