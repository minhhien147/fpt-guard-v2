import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/location_provider.dart';
import '../providers/user_provider.dart';
import '../services/email_service.dart';
import '../widgets/custom_drawer.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  @override
  void initState() {
    super.initState();
    // Bật tracking vị trí liên tục
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LocationProvider>().startLocationTracking();
    });
  }

  @override
  void dispose() {
    context.read<LocationProvider>().stopLocationTracking();
    super.dispose();
  }

  void _shareLocation() {
    final emailController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chia sẻ vị trí'),
        content: TextField(
          controller: emailController,
          decoration: const InputDecoration(
            labelText: 'Email người nhận',
            prefixIcon: Icon(Icons.email),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (emailController.text.isEmpty) {
                return;
              }

              final userProvider = context.read<UserProvider>();
              final locationProvider = context.read<LocationProvider>();

              if (!userProvider.hasUser || locationProvider.latitude == null) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Thiếu thông tin'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              final success = await EmailService.sendLocationEmail(
                userName: userProvider.user!.fullName,
                userEmail: userProvider.user!.email,
                address: locationProvider.currentAddress,
                latitude: locationProvider.latitude!,
                longitude: locationProvider.longitude!,
                recipientEmail: emailController.text,
              );

              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success
                        ? 'Đã gửi vị trí đến ${emailController.text}'
                        : 'Có lỗi xảy ra'),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );
              }
            },
            child: const Text('Gửi'),
          ),
        ],
      ),
    );
  }

  Future<void> _openInMaps(double lat, double lng) async {
    final url = Uri.parse('https://www.google.com/maps?q=$lat,$lng');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationProvider = context.watch<LocationProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vị trí & Bản đồ'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareLocation,
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: locationProvider.latitude == null
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text('Đang lấy vị trí...'),
                ],
              ),
            )
          : ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // Current location info
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.my_location, color: Colors.orange),
                                  SizedBox(width: 8),
                                  Text(
                                    'Vị trí hiện tại',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(locationProvider.currentAddress),
                              const SizedBox(height: 4),
                              Text(
                                'Tọa độ: ${locationProvider.latitude!.toStringAsFixed(6)}, ${locationProvider.longitude!.toStringAsFixed(6)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton.icon(
                                onPressed: () => _openInMaps(
                                  locationProvider.latitude!,
                                  locationProvider.longitude!,
                                ),
                                icon: const Icon(Icons.map, size: 18),
                                label: const Text('Mở Google Maps'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Safe locations
                      const Text(
                        'Địa điểm an toàn gần đây',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      
                      ...locationProvider.safeLocations.map((location) {
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: Text(
                              location.getIcon(),
                              style: const TextStyle(fontSize: 24),
                            ),
                            title: Text(location.name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (location.address != null)
                                  Text(location.address!),
                                if (location.distance != null)
                                  Text(
                                    '~${location.distance}m',
                                    style: const TextStyle(
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.directions),
                              onPressed: () => _openInMaps(
                                location.latitude,
                                location.longitude,
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await locationProvider.getCurrentLocation();
          await locationProvider.loadSafeLocations();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

