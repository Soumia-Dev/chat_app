import '../../data/models/invitation_model.dart';
import '../../domain/use_cases/users/accept_receive_invitation_use_case.dart';
import '../../domain/use_cases/users/cancel_friend_use_case.dart';
import '../../domain/use_cases/users/cancel_sent_receive_request_use_case.dart';
import '../../domain/use_cases/users/send_f_request_use_case.dart';

class UserController {
  final SendFRequestUseCase sendFRequestUseCase;
  final CancelFriendUseCase cancelFriendUseCase;
  final CancelSentReceiveRequestUseCase cancelSentReceiveRequestUseCase;
  final AcceptReceiveInvitationUseCase acceptReceiveInvitationUseCase;
  UserController({
    required this.sendFRequestUseCase,
    required this.cancelFriendUseCase,
    required this.cancelSentReceiveRequestUseCase,
    required this.acceptReceiveInvitationUseCase,
  });

  Future<String> addFriend(InvitationModel invitationModel) async {
    try {
      await sendFRequestUseCase(invitationModel);
      return "your request sent with successful";
    } catch (e) {
      return "please try again";
    }
  }

  Future<String> cancelFriend(InvitationModel invitationModel) async {
    try {
      await cancelFriendUseCase(invitationModel);
      return "your cancel friend request is done";
    } catch (e) {
      return "please try again";
    }
  }

  Future<String> cancelSentReceiveRequest(
    InvitationModel invitationModel,
  ) async {
    try {
      await cancelSentReceiveRequestUseCase(invitationModel);
      return "your cancel  request is done";
    } catch (e) {
      return "please try again";
    }
  }

  Future<String> acceptReceiveInvitation(
    InvitationModel invitationModel,
  ) async {
    try {
      await acceptReceiveInvitationUseCase(invitationModel);
      return "this user is now your friend";
    } catch (e) {
      return "please try again";
    }
  }
}
