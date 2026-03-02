import 'package:flutter/material.dart';

class SOSButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isPro;
  final int sosUsed;
  final int sosLimit;

  const SOSButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    this.isPro = false,
    this.sosUsed = 0,
    this.sosLimit = 10,
  });

  @override
  State<SOSButton> createState() => _SOSButtonState();
}

class _SOSButtonState extends State<SOSButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.red[700]!,
                    Colors.red[900]!,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.5),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.isLoading ? null : widget.onPressed,
                  customBorder: const CircleBorder(),
                  child: Center(
                    child: widget.isLoading
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.warning_amber_rounded,
                                size: 60,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'SOS',
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 8,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'KHẨN CẤP',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.9),
                                  letterSpacing: 2,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // SOS quota indicator
          if (!widget.isPro) _buildQuotaBar(),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            decoration: BoxDecoration(
              color: const Color(0xFF00B4D8).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFF00B4D8).withOpacity(0.3),
              ),
            ),
            child: const Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.info_outline, color: Color(0xFF0077B6), size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Nhấn để gửi cảnh báo khẩn cấp',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0077B6),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Text(
                  'Email sẽ được gửi đến tất cả liên hệ',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuotaBar() {
    final remaining = (widget.sosLimit - widget.sosUsed).clamp(0, widget.sosLimit);
    final fraction = remaining / widget.sosLimit;
    final isLow = remaining <= 3;
    final color = remaining == 0
        ? Colors.red
        : isLow
            ? Colors.orange
            : Colors.green;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.sos, size: 16, color: color),
            const SizedBox(width: 6),
            Text(
              remaining == 0
                  ? 'Hết lượt SOS miễn phí — Nâng cấp Pro'
                  : 'Còn $remaining/${widget.sosLimit} lượt SOS miễn phí',
              style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 200,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: fraction,
              minHeight: 6,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
      ],
    );
  }
}

