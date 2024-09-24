import 'package:flutter/material.dart';

Row valueChanger(BuildContext context, VoidCallback decrement,
    VoidCallback increment, String value) {
  return Row(
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
  );
}
