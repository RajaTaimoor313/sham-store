import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/auth/logic/auth_bloc.dart';
import '../core/models/auth_model.dart';

/// Example widget demonstrating how to use the new GET /api/user endpoint
/// This endpoint fetches the currently authenticated user's profile data
class UserApiExample extends StatelessWidget {
  const UserApiExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User API Example'),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'GET /api/user Endpoint Example',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'This example demonstrates how to fetch the currently authenticated user\'s profile using the new GET /api/user endpoint.',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    // Trigger the new getUser API call
                    context.read<AuthBloc>().add(AuthGetUserRequested());
                  },
                  child: const Text('Fetch User Profile (GET /api/user)'),
                ),
                const SizedBox(height: 24),
                if (state is AuthLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  )
                else if (state is AuthAuthenticated)
                  _buildUserInfo(state.user)
                else if (state is AuthError)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      border: Border.all(color: Colors.red),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Error:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        Text(
                          state.message,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  )
                else
                  const Text(
                    'No user data available. Please login first.',
                    style: TextStyle(fontSize: 16),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserInfo(User user) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        border: Border.all(color: Colors.green),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'User Profile Data:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 12),
          _buildInfoRow('ID', user.id.toString()),
          _buildInfoRow('Name', user.name),
          _buildInfoRow('Email', user.email),
          if (user.phone != null) _buildInfoRow('Phone', user.phone!),
          if (user.address != null) _buildInfoRow('Address', user.address!),
          _buildInfoRow('Email Verified', user.emailVerifiedAt != null ? 'Yes' : 'No'),
          _buildInfoRow('Created At', user.createdAt?.toString() ?? 'N/A'),
          _buildInfoRow('Updated At', user.updatedAt?.toString() ?? 'N/A'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}

/// Usage Instructions:
/// 
/// 1. Add this widget to your app's routing or navigation
/// 2. Make sure the user is authenticated before using this endpoint
/// 3. The AuthBloc will handle the API call and state management
/// 4. Listen to AuthState changes to handle loading, success, and error states
/// 
/// Example usage in a route:
/// ```dart
/// '/user-api-example': (context) => const UserApiExample(),
/// ```
/// 
/// Example usage in navigation:
/// ```dart
/// Navigator.push(
///   context,
///   MaterialPageRoute(builder: (context) => const UserApiExample()),
/// );
/// ```