import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dandd_sales_app/features/auth/presentation/providers/auth_provider.dart';

/// User profile page
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navigate to edit profile
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Text(
                      user?.name.substring(0, 1).toUpperCase() ?? 'U',
                      style: const TextStyle(
                        fontSize: 48,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user?.name ?? 'User',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.role ?? 'User',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            
            // Profile information
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Personal Information',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  
                  _InfoCard(
                    icon: Icons.email,
                    title: 'Email',
                    value: user?.email ?? 'Not available',
                  ),
                  const SizedBox(height: 12),
                  
                  _InfoCard(
                    icon: Icons.phone,
                    title: 'Phone',
                    value: user?.phone ?? 'Not available',
                  ),
                  const SizedBox(height: 12),
                  
                  _InfoCard(
                    icon: Icons.business,
                    title: 'Company',
                    value: user?.company ?? 'Not available',
                  ),
                  const SizedBox(height: 12),
                  
                  _InfoCard(
                    icon: Icons.badge,
                    title: 'User ID',
                    value: user?.id ?? 'Not available',
                  ),
                  const SizedBox(height: 24),
                  
                  // Settings section
                  Text(
                    'Settings',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  
                  _SettingsCard(
                    icon: Icons.notifications,
                    title: 'Notifications',
                    onTap: () {
                      // Navigate to notifications settings
                    },
                  ),
                  const SizedBox(height: 12),
                  
                  _SettingsCard(
                    icon: Icons.lock,
                    title: 'Change Password',
                    onTap: () {
                      // Navigate to change password
                    },
                  ),
                  const SizedBox(height: 12),
                  
                  _SettingsCard(
                    icon: Icons.dark_mode,
                    title: 'Theme',
                    onTap: () {
                      // Show theme selection
                    },
                  ),
                  const SizedBox(height: 12),
                  
                  _SettingsCard(
                    icon: Icons.language,
                    title: 'Language',
                    onTap: () {
                      // Show language selection
                    },
                  ),
                  const SizedBox(height: 12),
                  
                  _SettingsCard(
                    icon: Icons.info,
                    title: 'About',
                    onTap: () {
                      showAboutDialog(
                        context: context,
                        applicationName: 'D&D Sales App',
                        applicationVersion: '1.0.0',
                        applicationLegalese: '© 2024 D&D Sales App',
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  
                  // Logout button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        await ref.read(authProvider.notifier).logout();
                        if (context.mounted) {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            '/login',
                            (route) => false,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Logout'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).primaryColor),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  
  const _SettingsCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, color: Theme.of(context).primaryColor),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
