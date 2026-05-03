// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../services/password_service.dart';
import '../services/biometric_service.dart';
import '../models/password_item.dart';
import '../widgets/password_list_tile.dart';
import '../widgets/password_dialog.dart';
import '../widgets/custom_search_bar.dart';
import 'category_screen.dart';

// تعريف Enum خارج الـ class
enum AuthState { checking, needsRegistration, needsAuthentication, authenticated }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final PasswordService _passwordService = PasswordService();
  final BiometricService _biometricService = BiometricService();
  final TextEditingController _searchController = TextEditingController();
  List<PasswordItem> _passwords = [];
  List<PasswordItem> _filteredPasswords = [];
  bool _isAuthenticating = false;

  AuthState _authState = AuthState.checking;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkBiometricStatus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // لا تعيد المصادقة إذا كانت جارية أو تمت بالفعل
      if (!_isAuthenticating && _authState != AuthState.authenticated) {
        _authenticate();
      }
    }
  }

  Future<void> _checkBiometricStatus() async {
    setState(() {
      _isLoading = true;
      _authState = AuthState.checking;
    });

    final isRegistered = await _biometricService.isBiometricRegistered();

    if (!isRegistered) {
      setState(() {
        _authState = AuthState.needsRegistration;
        _isLoading = false;
      });
    } else {
      await _authenticate();
    }
  }

  Future<void> _registerBiometric() async {
    setState(() {
      _isLoading = true;
    });

    final success = await _biometricService.registerBiometric();

    if (success) {
      await _authenticate();
    } else {
      setState(() {
        _authState = AuthState.needsRegistration;
        _isLoading = false;
      });
      _showErrorDialog('فشل تسجيل البصمة، الرجاء المحاولة مرة أخرى');
    }
  }

  Future<void> _authenticate() async {
    if (_isAuthenticating) return;

    _isAuthenticating = true;

    setState(() {
      _isLoading = true;
      _authState = AuthState.needsAuthentication;
    });

    final success = await _biometricService.authenticate();

    if (success) {
      setState(() {
        _authState = AuthState.authenticated;
        _isLoading = false;
      });
      await _loadPasswords();
    } else {
      setState(() {
        _authState = AuthState.needsAuthentication;
        _isLoading = false;
      });
      _showAuthFailedDialog();
    }

    _isAuthenticating = false;
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('خطأ', style: TextStyle(fontFamily: 'Tajawal')),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _registerBiometric();
            },
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  void _showAuthFailedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('فشل المصادقة', style: TextStyle(fontFamily: 'Tajawal')),
        content: const Text('لم يتم التعرف على البصمة. الرجاء المحاولة مرة أخرى.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _authenticate();
            },
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  Future<void> _loadPasswords() async {
    try {
      final passwords = await _passwordService.getAllPasswords();
      if (mounted) {
        setState(() {
          _passwords = passwords;
          _filteredPasswords = passwords;
        });
      }
    } catch (e) {
      print('Error loading passwords: $e');
    }
  }

  void _searchPasswords(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredPasswords = _passwords;
      });
    } else {
      _passwordService.searchPasswords(query).then((results) {
        if (mounted) {
          setState(() {
            _filteredPasswords = results;
          });
        }
      });
    }
  }

  void _showAddPasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => PasswordDialog(
        onSave: (passwordItem) async {
          await _passwordService.insertPassword(passwordItem);
          _loadPasswords();
        },
      ),
    );
  }

  void _showEditPasswordDialog(PasswordItem passwordItem) {
    showDialog(
      context: context,
      builder: (context) => PasswordDialog(
        passwordItem: passwordItem,
        onSave: (updatedItem) async {
          await _passwordService.updatePassword(updatedItem);
          _loadPasswords();
        },
      ),
    );
  }

  void _showDeleteDialog(PasswordItem passwordItem) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('تأكيد الحذف', style: TextStyle(fontFamily: 'Tajawal')),
        content: Text('هل أنت متأكد من حذف حساب "${passwordItem.accountName}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء', style: TextStyle(color: Color.fromARGB(255, 98, 154, 181))),
          ),
          TextButton(
            onPressed: () async {
              await _passwordService.deletePassword(passwordItem.id!);
              _loadPasswords();
              if (mounted) Navigator.of(context).pop();
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showCategoriesDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'اختر التصنيف',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Tajawal',
                ),
              ),
              const SizedBox(height: 16),
              ...PasswordCategory.values.map((category) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: category.lightColor,
                    child: Icon(category.icon, color: category.color),
                  ),
                  title: Text(category.displayName),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryScreen(category: category),
                      ),
                    );
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F6FA),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Color.fromARGB(255, 98, 154, 181)),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _authState == AuthState.checking ? 'جاري التحقق...' : 'جاري المصادقة...',
                style: const TextStyle(fontFamily: 'Tajawal', fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    if (_authState == AuthState.needsRegistration) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F6FA),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color.fromARGB(255, 98, 154, 181), Color.fromARGB(255, 68, 127, 152)],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.fingerprint,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'تسجيل البصمة',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',
                    color: Color.fromARGB(255, 98, 154, 181),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'لأول مرة، يرجى تسجيل بصمتك لحماية كلمات المرور الخاصة بك',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Tajawal', fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 48),
                ElevatedButton(
                  onPressed: _registerBiometric,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 98, 154, 181),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'تسجيل البصمة',
                    style: TextStyle(fontSize: 18, fontFamily: 'Tajawal'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_authState == AuthState.needsAuthentication) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F6FA),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 98, 154, 181).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.fingerprint,
                    size: 50,
                    color: Color.fromARGB(255, 98, 154, 181),
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'المصادقة مطلوبة',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',
                    color: Color.fromARGB(255, 98, 154, 181),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'الرجاء استخدام بصمة الإصبع للوصول إلى كلمات المرور',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Tajawal', fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 48),
                ElevatedButton.icon(
                  onPressed: _authenticate,
                  icon: const Icon(Icons.fingerprint),
                  label: const Text('محاولة المصادقة'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 98, 154, 181),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text('مدير كلمات المرور', style: TextStyle(
          fontFamily: 'Tajawal',
          fontWeight: FontWeight.bold,
        )),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: const Color.fromARGB(255, 98, 154, 181),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.category),
            onPressed: _showCategoriesDialog,
            tooltip: 'التصنيفات',
          ),
        ],
      ),
      body: Column(
        children: [
          CustomSearchBar(
            controller: _searchController,
            onSearchChanged: _searchPasswords,
          ),
          Expanded(
            child: _filteredPasswords.isEmpty
                ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock_outline, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'لا توجد حسابات مضافة',
                    style: TextStyle(fontSize: 18, fontFamily: 'Tajawal', color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'اضغط على زر + لإضافة كلمة مرور جديدة',
                    style: TextStyle(fontSize: 14, fontFamily: 'Tajawal', color: Colors.grey),
                  ),
                ],
              ),
            )
                : ListView.builder(
              itemCount: _filteredPasswords.length,
              itemBuilder: (context, index) {
                final password = _filteredPasswords[index];
                return PasswordListTile(
                  passwordItem: password,
                  onEdit: () => _showEditPasswordDialog(password),
                  onDelete: () => _showDeleteDialog(password),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 98, 154, 181),
        onPressed: _showAddPasswordDialog,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}