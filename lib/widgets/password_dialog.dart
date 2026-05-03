// lib/widgets/password_dialog.dart
import 'package:flutter/material.dart';
import '../models/password_item.dart';

class PasswordDialog extends StatefulWidget {
  final PasswordItem? passwordItem;
  final Function(PasswordItem) onSave;

  const PasswordDialog({
    super.key,
    this.passwordItem,
    required this.onSave,
  });

  @override
  State<PasswordDialog> createState() => _PasswordDialogState();
}

class _PasswordDialogState extends State<PasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _accountNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _notesController = TextEditingController();
  final _websiteController = TextEditingController();
  bool _obscurePassword = true;
  PasswordCategory _selectedCategory = PasswordCategory.other;

  @override
  void initState() {
    super.initState();
    if (widget.passwordItem != null) {
      _accountNameController.text = widget.passwordItem!.accountName;
      _passwordController.text = widget.passwordItem!.password;
      _notesController.text = widget.passwordItem!.notes ?? '';
      _websiteController.text = widget.passwordItem!.website ?? '';
      _selectedCategory = widget.passwordItem!.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        widget.passwordItem == null ? 'إضافة حساب' : 'تعديل حساب',
        style: const TextStyle(fontFamily: 'Tajawal'),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _accountNameController,
                decoration: InputDecoration(
                  labelText: 'اسم الحساب أو الموقع',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  prefixIcon: const Icon(Icons.account_circle),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال اسم الحساب';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'كلمة المرور',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال كلمة المرور';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<PasswordCategory>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'التصنيف',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  prefixIcon: const Icon(Icons.category),
                ),
                items: PasswordCategory.values.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Row(
                      children: [
                        Icon(category.icon, size: 20, color: category.color),
                        const SizedBox(width: 8),
                        Text(category.displayName),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
              ),
              // const SizedBox(height: 16),
              // TextFormField(
              //   controller: _websiteController,
              //   decoration: InputDecoration(
              //     labelText: 'الموقع الإلكتروني (اختياري)',
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(15),
              //     ),
              //     prefixIcon: const Icon(Icons.language),
              //   ),
              // ),
              // const SizedBox(height: 16),
              // TextFormField(
              //   controller: _notesController,
              //   decoration: InputDecoration(
              //     labelText: 'ملاحظات (اختياري)',
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(15),
              //     ),
              //     prefixIcon: const Icon(Icons.note),
              //   ),
              //   maxLines: 3,
              // ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('إلغاء', style: TextStyle(color: Color.fromARGB(255, 98, 154, 181))),
        ),
        ElevatedButton(
          onPressed: _savePassword,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 98, 154, 181),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('حفظ', style: TextStyle(fontFamily: 'Tajawal')),
        ),
      ],
    );
  }

  void _savePassword() {
    if (_formKey.currentState!.validate()) {
      final passwordItem = PasswordItem(
        id: widget.passwordItem?.id,
        accountName: _accountNameController.text,
        password: _passwordController.text,
        category: _selectedCategory,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
        website: _websiteController.text.isNotEmpty ? _websiteController.text : null,
      );
      widget.onSave(passwordItem);
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _accountNameController.dispose();
    _passwordController.dispose();
    _notesController.dispose();
    _websiteController.dispose();
    super.dispose();
  }
}