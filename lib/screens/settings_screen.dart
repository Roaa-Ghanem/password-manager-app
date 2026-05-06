// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import '../services/biometric_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final BiometricService _biometricService = BiometricService();
  bool _isBiometricEnabled = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final isEnabled = await _biometricService.isBiometricRegistered();
    setState(() {
      _isBiometricEnabled = isEnabled;
      _isLoading = false;
    });
  }

  Future<void> _toggleBiometric(bool value) async {
    if (value) {
      // تشغيل البصمة - تسجيل بصمة جديدة
      final success = await _biometricService.registerBiometric();
      if (success) {
        setState(() => _isBiometricEnabled = true);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم تفعيل البصمة بنجاح'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('فشل تفعيل البصمة'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      // إيقاف البصمة
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('تأكيد إيقاف البصمة'),
          content: const Text('هل أنت متأكد من إيقاف حماية البصمة؟ سيتم إلغاء قفل التطبيق.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () async {
                await _biometricService.resetBiometric();
                Navigator.pop(context);
                setState(() => _isBiometricEnabled = false);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تم إيقاف البصمة'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
              },
              child: const Text('تأكيد', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('الإعدادات'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text(
          'الإعدادات',
          style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: const Color.fromARGB(255, 98, 154, 181),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // قسم الأمان
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'الأمان',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                      color: Color.fromARGB(255, 98, 154, 181),
                    ),
                  ),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text(
                    'قفل البصمة',
                    style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    _isBiometricEnabled
                        ? 'مفعل - يتطلب بصمة الإصبع لفتح التطبيق'
                        : 'معطل - التطبيق مفتوح بدون حماية',
                    style: const TextStyle(fontFamily: 'Tajawal', fontSize: 12),
                  ),
                  value: _isBiometricEnabled,
                  onChanged: _toggleBiometric,
                  activeColor: const Color.fromARGB(255, 98, 154, 181),
                  secondary: Icon(
                    _isBiometricEnabled ? Icons.fingerprint : Icons.fingerprint_outlined,
                    color: _isBiometricEnabled
                        ? const Color.fromARGB(255, 98, 154, 181)
                        : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // معلومات التطبيق
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'حول التطبيق',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                      color: Color.fromARGB(255, 98, 154, 181),
                    ),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.info_outline, color: Colors.grey),
                  title: const Text('الإصدار', style: TextStyle(fontFamily: 'Tajawal')),
                  trailing: const Text('1.0.0', style: TextStyle(fontFamily: 'Tajawal', color: Colors.grey)),
                ),
                ListTile(
                  leading: const Icon(Icons.security, color: Colors.grey),
                  title: const Text('التشفير', style: TextStyle(fontFamily: 'Tajawal')),
                  trailing: const Text('XOR + Base64', style: TextStyle(fontFamily: 'Tajawal', color: Colors.grey)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}