import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  bool _pushNotifications = true;
  bool _emailUpdates = false;
  bool _personalizedAds = true;
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SETTINGS'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: UI PREFERENCES
            _buildSectionHeader('DISPLAY & LANGUAGE', theme),
            _buildSwitchTile(
              'Dark Mode',
              'Toggle between light and dark backgrounds',
              _darkMode,
              (val) => setState(() => _darkMode = val),
              theme,
            ),
            _buildLanguageSelectorTile(theme, isDark),
            const Divider(),

            // Section 2: NOTIFICATIONS
            _buildSectionHeader('PUSH NOTIFICATIONS', theme),
            _buildSwitchTile(
              'Order Status Alerts',
              'Receive updates on shipments, delivery timelines, and returns',
              _pushNotifications,
              (val) => setState(() => _pushNotifications = val),
              theme,
            ),
            _buildSwitchTile(
              'Campaigns & Offers',
              'Get notified when limited edition drops or referral rewards launch',
              _emailUpdates,
              (val) => setState(() => _emailUpdates = val),
              theme,
            ),
            const Divider(),

            // Section 3: PRIVACY & DATA
            _buildSectionHeader('PRIVACY', theme),
            _buildSwitchTile(
              'Personalized Suggestions',
              'Allow Aura AI engine to analyze your wishlist and browse history',
              _personalizedAds,
              (val) => setState(() => _personalizedAds = val),
              theme,
            ),
            _buildActionTile('Data Deletion Request', Icons.delete_forever_outlined, () {}, theme, isDark, iconColor: Colors.red),
            const Divider(),

            // Section 4: ABOUT
            _buildSectionHeader('SUPPORT', theme),
            _buildActionTile('Contact Customer Concierge', Icons.support_agent_outlined, () {}, theme, isDark),
            _buildActionTile('Privacy Policy & Terms', Icons.info_outline, () {}, theme, isDark),
            
            const SizedBox(height: 32),
            Center(
              child: Text(
                'AURA v1.0.0 (Production Mock)',
                style: theme.textTheme.bodySmall?.copyWith(fontSize: 10, letterSpacing: 1.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: theme.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
    ThemeData theme,
  ) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      title: Text(title, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: theme.textTheme.bodySmall),
      activeColor: theme.brightness == Brightness.dark ? AppColors.darkAccent : AppColors.lightAccent,
    );
  }

  Widget _buildLanguageSelectorTile(ThemeData theme, bool isDark) {
    return ListTile(
      title: Text('App Language', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
      subtitle: Text(_selectedLanguage, style: theme.textTheme.bodySmall),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              title: const Text('Select Language'),
              children: ['English', 'Hindi', 'Spanish', 'French'].map((lang) {
                return SimpleDialogOption(
                  onPressed: () {
                    setState(() {
                      _selectedLanguage = lang;
                    });
                    Navigator.pop(context);
                  },
                  child: Text(lang),
                );
              }).toList(),
            );
          },
        );
      },
    );
  }

  Widget _buildActionTile(
    String title,
    IconData icon,
    VoidCallback onTap,
    ThemeData theme,
    bool isDark, {
    Color? iconColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? (isDark ? AppColors.darkAccent : AppColors.lightAccent), size: 22),
      title: Text(title, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
      onTap: onTap,
    );
  }
}
