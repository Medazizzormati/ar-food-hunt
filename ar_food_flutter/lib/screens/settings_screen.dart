import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../main.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;
  bool _emailAlerts = false;
  bool _autoRefresh = true;
  String _language = 'English';
  String _timezone = 'UTC';
  String _itemsPerPage = '25';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader('Appearance'),
          _buildSwitchTile(
            'Dark Mode',
            'Toggle dark theme for the app',
            isDark,
            (value) {
              ARFoodApp.themeNotifier.value = value ? ThemeMode.dark : ThemeMode.light;
            },
          ),
          const SizedBox(height: 24),
          
          _buildSectionHeader('Notifications'),
          _buildSwitchTile(
            'Push Notifications',
            'Receive notifications for important events',
            _notifications,
            (value) => setState(() => _notifications = value),
          ),
          _buildSwitchTile(
            'Email Alerts',
            'Receive email summaries of activities',
            _emailAlerts,
            (value) => setState(() => _emailAlerts = value),
          ),
          const SizedBox(height: 24),
          
          _buildSectionHeader('General'),
          _buildSelectTile(
            'Language',
            'Select your preferred language',
            _language,
            ['English', 'French', 'Spanish', 'German', 'Arabic'],
            (value) => setState(() => _language = value),
          ),
          _buildSelectTile(
            'Timezone',
            'Set your timezone for reports',
            _timezone,
            ['UTC', 'EST', 'PST', 'CET', 'GMT'],
            (value) => setState(() => _timezone = value),
          ),
          const SizedBox(height: 24),
          
          _buildSectionHeader('Display'),
          _buildSelectTile(
            'Items Per Page',
            'Number of items to display in lists',
            _itemsPerPage,
            ['10', '25', '50', '100'],
            (value) => setState(() => _itemsPerPage = value),
          ),
          const SizedBox(height: 24),
          
          _buildSectionHeader('Data'),
          _buildSwitchTile(
            'Auto Refresh',
            'Automatically refresh data every 30 seconds',
            _autoRefresh,
            (value) => setState(() => _autoRefresh = value),
          ),
          _buildActionTile(
            'Clear Cache',
            'Clear application cache and reload data',
            Icons.delete_outline,
            AppTheme.danger,
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cache cleared successfully')),
              );
            },
          ),
          _buildActionTile(
            'Export Data',
            'Export all app data as JSON backup',
            Icons.download,
            AppTheme.primary,
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Data exported successfully')),
              );
            },
          ),
          const SizedBox(height: 24),
          
          _buildSectionHeader('About'),
          _buildInfoTile('Version', '1.0.0'),
          _buildInfoTile('Build', '2024.07.16'),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkBgElevated : AppTheme.lightBgElevated,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? AppTheme.darkTextMuted : AppTheme.lightTextMuted,
          ),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppTheme.primary,
        ),
      ),
    );
  }

  Widget _buildSelectTile(
    String title,
    String subtitle,
    String value,
    List<String> options,
    Function(String) onChanged,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkBgElevated : AppTheme.lightBgElevated,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? AppTheme.darkTextMuted : AppTheme.lightTextMuted,
          ),
        ),
        trailing: DropdownButton<String>(
          value: value,
          items: options.map((String option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(option),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              onChanged(newValue);
            }
          },
          dropdownColor: isDark ? AppTheme.darkBgCard : AppTheme.lightBgCard,
        ),
      ),
    );
  }

  Widget _buildActionTile(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    Function() onTap,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkBgElevated : AppTheme.lightBgElevated,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? AppTheme.darkTextMuted : AppTheme.lightTextMuted,
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkBgElevated : AppTheme.lightBgElevated,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
          ),
        ),
        trailing: Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
          ),
        ),
      ),
    );
  }
}
