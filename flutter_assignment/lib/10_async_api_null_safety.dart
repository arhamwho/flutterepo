import 'dart:async';

class User {
  final int id;
  final String name;
  final String? email;
  final String? phone;

  User({
    required this.id,
    required this.name,
    this.email,
    this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
    );
  }
}

// Mock API function
Future<Map<String, dynamic>> fetchMockUser() async {
  await Future.delayed(const Duration(seconds: 2));

  return {
    'id': 101,
    'name': 'arham khan',
    'email': null,
    'phone': '+91 9876543210',
  };
}

// Fetch and display user data
Future<void> displayUser() async {
  try {
    print('Fetching user data...');

    final data = await fetchMockUser();

    final user = User.fromJson(data);

    print('\n--- User Data ---');
    print('ID: ${user.id}');
    print('Name: ${user.name}');
    print('Email: ${user.email ?? 'Email not available'}');
    print('Phone: ${user.phone ?? 'Phone not available'}');

  } catch (e) {
    print('Error fetching user data: $e');
  }
}

Future<void> main() async {
  await displayUser();
}