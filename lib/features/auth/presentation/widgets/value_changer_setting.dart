import 'package:flutter/material.dart';
import 'package:notepada/config/theme/colors.dart';

Container valueChangeSetter({
  required BuildContext context,
  required String title,
  required VoidCallback decrement,
  required VoidCallback increment,
  required String value,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
      color: AppColors.grey.withOpacity(.1),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: decrement,
              icon: const Icon(Icons.remove),
            ),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            IconButton(
              onPressed: increment,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ],
    ),
  );
}
