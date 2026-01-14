import 'package:flutter/material.dart';
import '../models/water_level_model.dart';

/// Widget hiển thị biểu đồ mực nước đơn giản
class WaterLevelChart extends StatelessWidget {
  final List<DataPoint> dataPoints;
  final double warningThreshold;
  final double floodThreshold;

  const WaterLevelChart({
    Key? key,
    required this.dataPoints,
    required this.warningThreshold,
    required this.floodThreshold,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (dataPoints.isEmpty) {
      return const Center(
        child: Text('Không có dữ liệu biểu đồ'),
      );
    }

    // Tính min/max để scale
    final levels = dataPoints.map((p) => p.waterLevel).toList();
    final minLevel = levels.reduce((a, b) => a < b ? a : b);
    final maxLevel = levels.reduce((a, b) => a > b ? a : b);
    final range = maxLevel - minLevel;
    final padding = range * 0.1; // 10% padding

    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      child: CustomPaint(
        painter: _WaterLevelChartPainter(
          dataPoints: dataPoints,
          minLevel: minLevel - padding,
          maxLevel: maxLevel + padding,
          warningThreshold: warningThreshold,
          floodThreshold: floodThreshold,
        ),
        child: Container(),
      ),
    );
  }
}

class _WaterLevelChartPainter extends CustomPainter {
  final List<DataPoint> dataPoints;
  final double minLevel;
  final double maxLevel;
  final double warningThreshold;
  final double floodThreshold;

  _WaterLevelChartPainter({
    required this.dataPoints,
    required this.minLevel,
    required this.maxLevel,
    required this.warningThreshold,
    required this.floodThreshold,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (dataPoints.isEmpty) return;

    // Vẽ ngưỡng cảnh báo
    _drawThresholdLine(
      canvas,
      size,
      warningThreshold,
      Colors.orange.withOpacity(0.3),
      'Cảnh báo',
    );

    // Vẽ ngưỡng ngập
    _drawThresholdLine(
      canvas,
      size,
      floodThreshold,
      Colors.red.withOpacity(0.3),
      'Ngập',
    );

    // Vẽ đường mực nước
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    final pointPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    for (int i = 0; i < dataPoints.length; i++) {
      final x = (i / (dataPoints.length - 1)) * size.width;
      final normalizedY = (dataPoints[i].waterLevel - minLevel) / (maxLevel - minLevel);
      final y = size.height - (normalizedY * size.height);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }

      // Vẽ điểm
      if (i == dataPoints.length - 1) {
        // Điểm cuối cùng to hơn
        canvas.drawCircle(Offset(x, y), 5, pointPaint);
      }
    }

    canvas.drawPath(path, paint);
  }

  void _drawThresholdLine(
    Canvas canvas,
    Size size,
    double threshold,
    Color color,
    String label,
  ) {
    if (threshold < minLevel || threshold > maxLevel) return;

    final normalizedY = (threshold - minLevel) / (maxLevel - minLevel);
    final y = size.height - (normalizedY * size.height);

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Vẽ đường nét đứt
    const dashWidth = 5;
    const dashSpace = 3;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, y),
        Offset(startX + dashWidth, y),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

