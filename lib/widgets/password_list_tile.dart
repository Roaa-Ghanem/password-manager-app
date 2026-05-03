// lib/widgets/password_list_tile.dart
import 'package:flutter/material.dart';
import '../models/password_item.dart';

class PasswordListTile extends StatefulWidget {
  final PasswordItem passwordItem;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const PasswordListTile({
    super.key,
    required this.passwordItem,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<PasswordListTile> createState() => _PasswordListTileState();
}

class _PasswordListTileState extends State<PasswordListTile> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: widget.passwordItem.category.color.withOpacity(0.2),
              child: Icon(
                widget.passwordItem.category.icon,
                color: widget.passwordItem.category.color,
                size: 24,
              ),
            ),
            title: Text(
              widget.passwordItem.accountName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _obscurePassword ? '•' * 12 : widget.passwordItem.password,
                        style: TextStyle(
                          fontFamily: _obscurePassword ? null : 'monospace',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ],
                ),
                if (widget.passwordItem.website != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.language, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          widget.passwordItem.website!,
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            trailing: SizedBox(
              height: 20,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Color.fromARGB(255, 98, 154, 181)),
                    onPressed: widget.onEdit,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Color.fromARGB(255, 98, 154, 181)),
                    onPressed: widget.onDelete,
                  ),
                ],
              ),
            ),
          ),
          // Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          //   alignment: Alignment.centerLeft,
          //   child: Container(
          //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          //     decoration: BoxDecoration(
          //       color: widget.passwordItem.category.color.withOpacity(0.1),
          //       borderRadius: BorderRadius.circular(12),
          //     ),
          //     child: Row(
          //       mainAxisSize: MainAxisSize.min,
          //       children: [
          //         Icon(
          //           widget.passwordItem.category.icon,
          //           size: 14,
          //           color: widget.passwordItem.category.color,
          //         ),
          //         const SizedBox(width: 4),
          //         Text(
          //           widget.passwordItem.category.displayName,
          //           style: TextStyle(
          //             fontSize: 11,
          //             color: widget.passwordItem.category.color,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}