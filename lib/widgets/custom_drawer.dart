import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/user_provider.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final l10n = AppLocalizations.of(context)!;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.orange[700]!,
                  Colors.orange[500]!,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage('assets/images/app_icon.jpg'),
                ),
                const SizedBox(height: 10),
                Text(
                  userProvider.hasUser
                      ? userProvider.user!.fullName
                      : l10n.appTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (userProvider.hasUser)
                  Text(
                    userProvider.user!.studentId,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
              ],
            ),
          ),
          _DrawerItem(
            icon: Icons.home,
            title: l10n.home,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          _DrawerItem(
            icon: Icons.contacts,
            title: l10n.contacts,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/contacts');
            },
          ),
          _DrawerItem(
            icon: Icons.newspaper,
            title: l10n.news,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/news');
            },
          ),
          const Divider(),
          _DrawerItem(
            icon: Icons.settings,
            title: l10n.settings,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/settings');
            },
          ),
          const Divider(),
          _DrawerItem(
            icon: Icons.info,
            title: 'About', // TODO: Add to l10n
            onTap: () {
              Navigator.pop(context);
              _showAboutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'FPT Guard 2.0',
      applicationVersion: '2.0.0',
      applicationIcon: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.shield,
          size: 30,
          color: Colors.white,
        ),
      ),
      children: [
        const SizedBox(height: 10),
        const Text(
          'Ứng dụng bảo vệ an toàn sinh viên FPT University Cần Thơ.',
        ),
        const SizedBox(height: 10),
        const Text(
          '© 2024 FPT University. All rights reserved.',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.orange[700]),
      title: Text(title),
      onTap: onTap,
    );
  }
}

