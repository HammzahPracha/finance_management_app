import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import '../controllers/theme_controller.dart';
import 'login_screen.dart';
import 'edit_profile_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111827),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          // Account Section
          _buildSectionHeader('Account'),

          _buildSettingTile(
            context,
            icon: Icons.person_outline,
            title: 'Edit Profile',
            subtitle: 'Update your personal information',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditProfileScreen()),
              );
            },
          ),

          _buildSettingTile(
            context,
            icon: Icons.lock_outlined,
            title: 'Change Password',
            subtitle: 'Update your password',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ChangePasswordScreen()),
              );
            },
          ),

          const SizedBox(height: 24),

          // App Settings
          _buildSectionHeader('App Settings'),

          // Notification Toggle
          _buildSettingTile(
            context,
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            subtitle: 'Manage notification preferences',
            trailing: Switch(
              value: notificationsEnabled,
              onChanged: (value) {
                setState(() => notificationsEnabled = value);
              },
            ),
          ),

          // Dark Mode Toggle
          _buildSettingTile(
            context,
            icon: Icons.dark_mode_outlined,
            title: 'Dark Mode',
            subtitle: 'Switch app theme',
            trailing: Switch(
      onChanged: (value) => themeController.toggleDarkMode(value),
              value: themeController.isDarkMode,
            ),
          ),

          const SizedBox(height: 24),

          // About Section
          _buildSectionHeader('About'),
          _buildSettingTile(
            context,
            icon: Icons.info_outline,
            title: 'About',
            subtitle: 'App version 1.0.0',
          ),

          const SizedBox(height: 32),

          // Logout
          Consumer<AuthController>(
            builder: (context, authController, _) {
              return _buildSettingTile(
                context,
                icon: Icons.logout,
                title: 'Logout',
                textColor: Colors.red,
                iconColor: Colors.red,
                onTap: () async {
                  await authController.signOut();
                  if (mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                          (route) => false,
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8, top: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }

  Widget _buildSettingTile(
      BuildContext context, {
        required IconData icon,
        required String title,
        String? subtitle,
        Widget? trailing,
        VoidCallback? onTap,
        Color? textColor,
        Color? iconColor,
      }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: Icon(icon, color: iconColor ?? Theme.of(context).primaryColor),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: textColor ?? const Color(0xFF111827),
          ),
        ),
        subtitle: subtitle != null
            ? Text(subtitle, style: TextStyle(color: Colors.grey.shade600))
            : null,
        trailing: trailing ?? const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

// Keep your ChangePasswordScreen in a separate file or here
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Change Password')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _currentController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Current Password'),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _newController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'New Password'),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _confirmController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Confirm Password'),
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: auth.isLoading
                  ? null
                  : () async {
                if (_newController.text !=
                    _confirmController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Passwords do not match'),
                    ),
                  );
                  return;
                }

                final success = await auth.changePassword(
                  _currentController.text,
                  _newController.text,
                );

                if (success && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Password changed successfully'),
                    ),
                  );
                  Navigator.pop(context);
                } else if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                      Text(auth.errorMessage ?? 'Failed'),
                    ),
                  );
                }
              },
              child: auth.isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Update Password'),
            ),
          ],
        ),
      ),
    );
  }
}

