// lib/widgets/password_card.dart
import 'package:flutter/material.dart';
import '../models/password_item.dart';

class PasswordCard extends StatefulWidget {
  final PasswordItem passwordItem;
  final VoidCallback onDelete;

  const PasswordCard({
    super.key,
    required this.passwordItem,
    required this.onDelete,
  });

  @override
  State<PasswordCard> createState() => _PasswordCardState();
}

class _PasswordCardState extends State<PasswordCard> {
  bool _obscurePassword = true;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showPasswordDetails(),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    // أيقونة الموقع
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 98, 154, 181).withOpacity(0.1), // خلفية موحدة
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(
                        widget.passwordItem.category.icon,
                        color: const Color.fromARGB(255, 98, 154, 181), // لون موحد
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // معلومات الحساب
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.passwordItem.accountName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Tajawal',
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              // if (widget.passwordItem.isFavorite)
                                // const Icon(
                                //   Icons.star,
                                //   color: Colors.amber,
                                //   size: 20,
                                // ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // كلمة المرور
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _obscurePassword
                                      ? '••••••••••••'
                                      : widget.passwordItem.password,
                                  style: TextStyle(
                                    fontFamily: _obscurePassword ? null : 'monospace',
                                    fontSize: 14,
                                    letterSpacing: _obscurePassword ? 2 : 0,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                                splashRadius: 20,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (widget.passwordItem.website != null) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.language,
                        size: 16,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.passwordItem.website!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 12),
                // أزرار الإجراءات
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () => _copyToClipboard(),
                      icon: const Icon(Icons.copy, size: 18),
                      label: const Text('نسخ'),
                      style: TextButton.styleFrom(
                        foregroundColor: widget.passwordItem.category.color,
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: widget.onDelete,
                      icon: const Icon(Icons.delete_outline, size: 18),
                      label: const Text('حذف'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _copyToClipboard() {
    // نسخ كلمة المرور
    print('تم نسخ: ${widget.passwordItem.password}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم نسخ كلمة المرور لـ ${widget.passwordItem.accountName}'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showPasswordDetails() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        widget.passwordItem.category.color,
                        widget.passwordItem.category.color.withOpacity(0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    widget.passwordItem.category.icon,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.passwordItem.accountName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.passwordItem.category.displayName,
                        style: TextStyle(
                          color: widget.passwordItem.category.color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildDetailRow('كلمة المرور', widget.passwordItem.password, isPassword: true),
            if (widget.passwordItem.website != null)
              _buildDetailRow('الموقع', widget.passwordItem.website!),
            if (widget.passwordItem.notes != null)
              _buildDetailRow('ملاحظات', widget.passwordItem.notes!),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
                label: const Text('إغلاق'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.passwordItem.category.color,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    isPassword ? '••••••••••••' : value,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                if (isPassword)
                  IconButton(
                    icon: const Icon(Icons.copy, size: 20),
                    onPressed: () {
                      print('تم نسخ: $value');
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}