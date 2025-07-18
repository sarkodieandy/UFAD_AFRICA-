import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ufad/core/constants/colors.dart';
import 'package:ufad/providers/auth_provider.dart';
import 'package:ufad/widgets/loader.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context);
    final user = provider.user;

    if (provider.loading || user == null) {
      return const Scaffold(body: Loader());
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppColors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              provider.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            CircleAvatar(
              radius: 50,
              // ignore: deprecated_member_use
              backgroundColor: AppColors.green.withOpacity(0.1),
              backgroundImage:
                  user.profileImage != null && user.profileImage!.isNotEmpty
                      ? MemoryImage(base64Decode(user.profileImage!))
                      : null,
              child:
                  user.profileImage == null || user.profileImage!.isEmpty
                      ? const Icon(Icons.person, size: 40)
                      : null,
            ),
            const SizedBox(height: 16),
            _infoTile("Name", "${user.firstName} ${user.lastName}"),
            _infoTile("Email", user.email),
            _infoTile("Mobile", user.mobileNumber),
            _infoTile("Gender", user.gender),
            _infoTile("Age Group", user.ageGroup),
            const Divider(height: 32),
            _infoTile("Business", user.business?.name ?? "-"),
            _infoTile("Sector", user.business?.mainProductService ?? "-"),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(String title, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: const TextStyle(color: Colors.grey)),
      subtitle: Text(value, style: const TextStyle(fontSize: 16)),
    );
  }
}
