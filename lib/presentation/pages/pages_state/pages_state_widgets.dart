import 'package:flutter/material.dart';

import '../../../domain/use_cases/authed_use_cases/get_num_invitations_use_case.dart';

class PagesStateWidgets {
  static inviteNotification(GetNumInvitationsUseCase getNumInvitationsUseCase) {
    return StreamBuilder<int>(
      stream: getNumInvitationsUseCase(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();
        final count = snapshot.data!;
        if (count == 0) return const SizedBox();
        return Positioned(
          bottom: 2,
          right: 2,
          child: CircleAvatar(
            radius: 8,
            backgroundColor: Colors.red,
            child: Center(
              child: Text(
                count.toString(),
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
        );
      },
    );
  }
}
