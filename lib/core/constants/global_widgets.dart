import 'dart:convert';

import 'package:flutter/material.dart';

class GlobalWidgets {
  static ClipOval image(String photoUrl) {
    return ClipOval(
      child: photoUrl.isNotEmpty
          ? Image.memory(
              base64Decode(photoUrl),
              fit: BoxFit.fill,
              width: 60,
              height: 60,
            )
          : Image.asset(
              'assets/deleted_account.jpg',
              fit: BoxFit.cover,
              width: 60,
              height: 60,
            ),
    );
  }
}
