import '../../data/models/invitation_model.dart';
import '../../data/models/user_model.dart';

abstract class UserRepository {
  Stream<List<UserModel>> getAllUsers();
  Future<void> sendFriendRequest(InvitationModel invitationModel);
  Future<void> cancelFriend(InvitationModel invitationModel);
  Future<void> cancelSentReceiveRequest(InvitationModel invitationModel);
  Future<void> acceptReceiveInvitation(InvitationModel invitationModel);
}
