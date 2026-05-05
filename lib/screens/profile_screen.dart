import 'package:flutter/material.dart';
import '../services/emergency_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final EmergencyService _emergencyService = EmergencyService();
  final TextEditingController _contactController = TextEditingController();
  String _savedContact = 'Not Set';

  @override
  void initState() {
    super.initState();
    _loadContact();
  }

  Future<void> _loadContact() async {
    final contact = await _emergencyService.getContact();
    if (contact != null && mounted) {
      setState(() {
        _savedContact = contact;
        _contactController.text = contact;
      });
    }
  }

  void _showEditContactDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('EMERGENCY CONTACT', style: TextStyle(color: Color(0xFF00FF41), fontWeight: FontWeight.w900)),
        content: TextField(
          controller: _contactController,
          keyboardType: TextInputType.phone,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter phone number',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white.withOpacity(0.1))),
            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF00FF41))),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00FF41)),
            onPressed: () async {
              await _emergencyService.saveContact(_contactController.text);
              await _loadContact();
              if (mounted) Navigator.pop(context);
            },
            child: const Text('SAVE', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF151515),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF00FF41), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'USER PROFILE',
          style: TextStyle(
            color: Color(0xFF00FF41),
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // ... (rest of profile header)
            Center(
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF00FF41), width: 2),
                    ),
                    child: const CircleAvatar(
                      radius: 50,
                      backgroundColor: Color(0xFF1E1E1E),
                      child: Icon(Icons.person_rounded, size: 60, color: Color(0xFF00FF41)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Sanjana Tasnim',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
            const Text(
              'Home Owner / Admin',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 40),

            // Settings Sections
            _buildSectionHeader('SYSTEM SECURITY'),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: _showEditContactDialog,
              child: _buildSettingsItem(
                icon: Icons.security_rounded,
                title: 'Emergency Contact',
                subtitle: _savedContact,
                trailing: const Icon(Icons.edit_rounded, color: Color(0xFF00FF41), size: 16),
              ),
            ),
            _buildSettingsItem(
              icon: Icons.vibration_rounded,
              title: 'Alert Sensitivity',
              subtitle: 'Adjust gas detection threshold',
              trailing: const Text('MEDIUM', style: TextStyle(color: Color(0xFF00FF41), fontWeight: FontWeight.bold, fontSize: 12)),
            ),
            
            const SizedBox(height: 32),
            _buildSectionHeader('NOTIFICATIONS'),
            const SizedBox(height: 12),
            _buildSettingsItem(
              icon: Icons.notifications_active_rounded,
              title: 'Push Notifications',
              subtitle: 'Instant alerts on mobile',
              trailing: Switch.adaptive(value: true, onChanged: (v) {}, activeColor: const Color(0xFF00FF41)),
            ),
            _buildSettingsItem(
              icon: Icons.volume_up_rounded,
              title: 'Audible Alerts',
              subtitle: 'Play sound for warnings',
              trailing: Switch.adaptive(value: true, onChanged: (v) {}, activeColor: const Color(0xFF00FF41)),
            ),

            const SizedBox(height: 32),
            _buildSectionHeader('APP INFO'),
            const SizedBox(height: 12),
            _buildSettingsItem(
              icon: Icons.info_outline_rounded,
              title: 'Software Version',
              subtitle: 'v1.0.0 (Production Build)',
              trailing: const SizedBox(),
            ),
            
            const SizedBox(height: 40),
            // Logout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent.withOpacity(0.1),
                  foregroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Colors.redAccent, width: 1),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'LOGOUT FROM SYSTEM',
                  style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          color: const Color(0xFF00FF41).withOpacity(0.5),
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.03)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}
