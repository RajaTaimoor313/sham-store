import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shamstore/features/auth/logic/auth_bloc.dart';
import 'package:flutter_shamstore/features/settings/ui/widgets/profile.dart';

/// Test widget to demonstrate the Profile screen functionality
/// This shows how the Profile screen now fetches user data from the API
class ProfileTestExample extends StatelessWidget {
  const ProfileTestExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile API Test'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Profile Screen API Integration Test',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'The Profile screen now:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text('• Fetches user data from GET /api/user when opened'),
            const Text('• Uses AuthBloc instead of ProfileBloc'),
            const Text('• Shows loading state while fetching data'),
            const Text('• Displays error message if API fails'),
            const Text('• Shows user profile data when successful'),
            const Text('• Has a "Refresh Profile" button to refetch data'),
            const SizedBox(height: 24),

            // Current Auth State Display
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Current Auth State:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      if (state is AuthLoading)
                        const Text('Loading user data...')
                      else if (state is AuthError)
                        Text(
                          'Error: ${state.message}',
                          style: const TextStyle(color: Colors.red),
                        )
                      else if (state is AuthAuthenticated)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('User: ${state.user.name}'),
                            Text('Email: ${state.user.email}'),
                            Text('Phone: ${state.user.phone ?? "N/A"}'),
                            Text('Address: ${state.user.address ?? "N/A"}'),
                          ],
                        )
                      else
                        const Text('No user data available'),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // Test Buttons
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Trigger API call to fetch user data
                    context.read<AuthBloc>().add(AuthGetUserRequested());
                  },
                  child: const Text('Fetch User Data'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the actual Profile screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyProfile(),
                      ),
                    );
                  },
                  child: const Text('Open Profile Screen'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
