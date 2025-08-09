import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/repositories/notification_repository.dart';
import '../../../../core/models/notification_model.dart' as notification_models;
import '../../logic/notification_bloc.dart';
import '../../logic/notification_event.dart';
import '../../logic/notification_state.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          NotificationBloc(notificationRepository: NotificationRepository())
            ..add(const LoadNotificationSettings()),
      child: const NotificationSettingsView(),
    );
  }
}

class NotificationSettingsView extends StatefulWidget {
  const NotificationSettingsView({super.key});

  @override
  State<NotificationSettingsView> createState() =>
      _NotificationSettingsViewState();
}

class _NotificationSettingsViewState extends State<NotificationSettingsView> {
  // Local state for settings
  bool emailNotifications = true;
  bool pushNotifications = true;
  bool orderNotifications = true;
  bool userRegistration = true;
  bool sellerNotifications = true;
  bool systemAlerts = true;
  bool marketingEmails = false;
  bool weeklyReports = false;
  bool monthlyReports = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
        actions: [
          TextButton(
            onPressed: () => _saveSettings(context),
            child: const Text('Save'),
          ),
        ],
      ),
      body: BlocConsumer<NotificationBloc, NotificationState>(
        listener: (context, state) {
          if (state is NotificationSettingsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is NotificationSettingsLoaded) {
            _loadSettingsFromState(state.settings);
          } else if (state is NotificationSettingsUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Settings updated successfully'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop();
          } else if (state is NotificationSettingsCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Settings created successfully'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          if (state is NotificationSettingsLoading ||
              state is NotificationSettingsCreating ||
              state is NotificationSettingsUpdating) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // General notification methods
                _buildSectionHeader('Notification Methods'),
                _buildSettingsTile(
                  title: 'Email Notifications',
                  subtitle: 'Receive notifications via email',
                  value: emailNotifications,
                  onChanged: (value) =>
                      setState(() => emailNotifications = value),
                  icon: Icons.email,
                ),
                _buildSettingsTile(
                  title: 'Push Notifications',
                  subtitle: 'Receive push notifications on your device',
                  value: pushNotifications,
                  onChanged: (value) =>
                      setState(() => pushNotifications = value),
                  icon: Icons.notifications,
                ),

                const SizedBox(height: 24),

                // Order and transaction notifications
                _buildSectionHeader('Order & Transaction'),
                _buildSettingsTile(
                  title: 'Order Notifications',
                  subtitle:
                      'Order confirmations, shipping updates, and delivery notifications',
                  value: orderNotifications,
                  onChanged: (value) =>
                      setState(() => orderNotifications = value),
                  icon: Icons.shopping_bag,
                ),
                _buildSettingsTile(
                  title: 'System Alerts',
                  subtitle: 'Account security and system notifications',
                  value: systemAlerts,
                  onChanged: (value) => setState(() => systemAlerts = value),
                  icon: Icons.security,
                ),

                const SizedBox(height: 24),

                // User and seller notifications
                _buildSectionHeader('User & Seller'),
                _buildSettingsTile(
                  title: 'User Registration',
                  subtitle: 'New user registration notifications',
                  value: userRegistration,
                  onChanged: (value) =>
                      setState(() => userRegistration = value),
                  icon: Icons.person_add,
                ),
                _buildSettingsTile(
                  title: 'Seller Notifications',
                  subtitle: 'Seller-related updates and notifications',
                  value: sellerNotifications,
                  onChanged: (value) =>
                      setState(() => sellerNotifications = value),
                  icon: Icons.store,
                ),

                const SizedBox(height: 24),

                // Marketing and reports
                _buildSectionHeader('Marketing & Reports'),
                _buildSettingsTile(
                  title: 'Marketing Emails',
                  subtitle: 'Newsletter and marketing content',
                  value: marketingEmails,
                  onChanged: (value) => setState(() => marketingEmails = value),
                  icon: Icons.campaign,
                ),
                _buildSettingsTile(
                  title: 'Weekly Reports',
                  subtitle: 'Weekly summary of activities and statistics',
                  value: weeklyReports,
                  onChanged: (value) => setState(() => weeklyReports = value),
                  icon: Icons.summarize,
                ),
                _buildSettingsTile(
                  title: 'Monthly Reports',
                  subtitle: 'Monthly summary and analytics reports',
                  value: monthlyReports,
                  onChanged: (value) => setState(() => monthlyReports = value),
                  icon: Icons.analytics,
                ),

                const SizedBox(height: 32),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _resetToDefaults(),
                        child: const Text('Reset to Defaults'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _saveSettings(context),
                        child: const Text('Save Settings'),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Additional info
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.blue[600],
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Important',
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(
                                  color: Colors.blue[600],
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Some notifications like security alerts and order confirmations cannot be disabled for your account safety.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.blue[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required IconData icon,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: SwitchListTile(
        title: Text(title),
        subtitle: Text(
          subtitle,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
        ),
        value: value,
        onChanged: onChanged,
        secondary: Icon(icon, color: Theme.of(context).primaryColor),
        activeColor: Theme.of(context).primaryColor,
      ),
    );
  }

  void _loadSettingsFromState(
    notification_models.NotificationSettings settings,
  ) {
    setState(() {
      emailNotifications = settings.emailNotifications;
      pushNotifications = settings.pushNotifications;
      orderNotifications = settings.orderNotifications;
      userRegistration = settings.userRegistration;
      sellerNotifications = settings.sellerNotifications;
      systemAlerts = settings.systemAlerts;
      marketingEmails = settings.marketingEmails;
      weeklyReports = settings.weeklyReports;
      monthlyReports = settings.monthlyReports;
    });
  }

  void _resetToDefaults() {
    setState(() {
      emailNotifications = true;
      pushNotifications = true;
      orderNotifications = true;
      userRegistration = true;
      sellerNotifications = true;
      systemAlerts = true;
      marketingEmails = false;
      weeklyReports = false;
      monthlyReports = false;
    });
  }

  void _saveSettings(BuildContext context) {
    final state = context.read<NotificationBloc>().state;

    if (state is NotificationSettingsLoaded) {
      // Update existing settings
      final request = notification_models.UpdateNotificationSettingsRequest(
        emailNotifications: emailNotifications,
        pushNotifications: pushNotifications,
        orderNotifications: orderNotifications,
        userRegistration: userRegistration,
        sellerNotifications: sellerNotifications,
        systemAlerts: systemAlerts,
        marketingEmails: marketingEmails,
        weeklyReports: weeklyReports,
        monthlyReports: monthlyReports,
      );

      context.read<NotificationBloc>().add(
        UpdateNotificationSettings(state.settings.id, request),
      );
    } else {
      // Create new settings
      final request = notification_models.CreateNotificationSettingsRequest(
        userId: 1, // This should be obtained from the current user context
        emailNotifications: emailNotifications,
        pushNotifications: pushNotifications,
        orderNotifications: orderNotifications,
        userRegistration: userRegistration,
        sellerNotifications: sellerNotifications,
        systemAlerts: systemAlerts,
        marketingEmails: marketingEmails,
        weeklyReports: weeklyReports,
        monthlyReports: monthlyReports,
      );

      context.read<NotificationBloc>().add(CreateNotificationSettings(request));
    }
  }
}
