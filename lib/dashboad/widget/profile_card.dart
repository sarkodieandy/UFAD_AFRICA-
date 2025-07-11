import 'package:flutter/material.dart';
import 'package:ufad/dashboad/model/busines_profile_model.dart';
import '../utils/styles.dart';

class ProfileCard extends StatelessWidget {
  final BusinessProfile profile;
  final VoidCallback onViewProfile;

  const ProfileCard({
    super.key,
    required this.profile,
    required this.onViewProfile,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(40 * (1 - value), 0),
            child: child,
          ),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Business Profile', style: Styles.sectionTitleStyle),
              const SizedBox(height: 14),
              _buildProfileRow('Business Name', profile.name),
              const Divider(),
              _buildProfileRow('Phone', profile.phone),
              const Divider(),
              _buildProfileRow('Location', profile.location),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.visibility, size: 18),
                  label: const Text('View Profile'),
                  onPressed: onViewProfile,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Styles.profileLabelStyle),
          const SizedBox(height: 2),
          Text(value, style: Styles.profileValueStyle),
        ],
      ),
    );
  }
}
