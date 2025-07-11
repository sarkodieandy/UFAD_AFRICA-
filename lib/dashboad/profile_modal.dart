// lib/screens/profile_modal.dart
import 'package:flutter/material.dart';
import 'package:ufad/dashboad/model/busines_profile_model.dart';
import 'package:ufad/dashboad/utils/styles.dart';


class ProfileModal extends StatelessWidget {
  final BusinessProfile profile;

  const ProfileModal({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Business Profile', style: Styles.modalTitleStyle),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildProfileRow('Name', profile.name),
            const Divider(),
            _buildProfileRow('Phone', profile.phone),
            const Divider(),
            _buildProfileRow('Location', profile.location),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text('$label:', style: Styles.profileLabelStyle),
          const SizedBox(width: 16),
          Text(value, style: Styles.profileValueStyle),
        ],
      ),
    );
  }
}