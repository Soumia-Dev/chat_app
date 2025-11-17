import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/repositories/user_repository.dart';
import '../models/invitation_model.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  UserRepositoryImpl();

  @override
  Stream<List<UserModel>> getAllUsers() {
    final currentUser = FirebaseAuth.instance.currentUser!.uid;
    final allUsers = firestore
        .collection("users")
        .orderBy("fullName")
        .snapshots();
    final receivesUsers = firestore
        .collection("users")
        .doc(currentUser)
        .collection("receiveRequests")
        .snapshots();
    final sentUsers = firestore
        .collection("users")
        .doc(currentUser)
        .collection("sentRequests")
        .snapshots();
    final friendsUsers = firestore
        .collection("users")
        .doc(currentUser)
        .collection("friends")
        .snapshots();

    return Rx.combineLatest4(allUsers, sentUsers, receivesUsers, friendsUsers, (
      QuerySnapshot usersSnap,
      QuerySnapshot sentSnap,
      QuerySnapshot receiveSnap,
      QuerySnapshot friendsSnap,
    ) {
      final sentIds = sentSnap.docs.map((d) => d.id).toSet();
      final receiveIds = receiveSnap.docs.map((d) => d.id).toSet();
      final friendIds = friendsSnap.docs.map((d) => d.id).toSet();

      final userStreams = usersSnap.docs
          .where((doc) => doc.id != currentUser)
          .map((doc) {
            String state = "none";
            if (friendIds.contains(doc.id)) {
              state = "friend";
            } else if (sentIds.contains(doc.id)) {
              state = "sent";
            } else if (receiveIds.contains(doc.id)) {
              state = "receive";
            }

            final data = doc.data() as Map<String, dynamic>;
            return firestore
                .collection("users")
                .doc(doc.id)
                .collection("friends")
                .snapshots()
                .map((friendsSnap) {
                  final friendsCount = friendsSnap.size;
                  return UserModel.fromJson(
                    data,
                    doc.id,
                    state,
                    friendsCount: friendsCount,
                  );
                });
          })
          .toList();

      return Rx.combineLatestList(userStreams);
      // Rx.combineLatestList(userStreams) → combine all per-user streams into one list stream.
    }).switchMap((usersStream) => usersStream);
    // .switchMap((usersStream) => usersStream) → flatten the nested streams, so you end up with one clean Stream<List<UserModel>>.
  }

  @override
  Future<void> sendFriendRequest(InvitationModel invitationModel) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(invitationModel.fromId)
        .collection("sentRequests")
        .doc(invitationModel.toId)
        .set(invitationModel.toMap());
    await FirebaseFirestore.instance
        .collection("users")
        .doc(invitationModel.toId)
        .collection("receiveRequests")
        .doc(invitationModel.fromId)
        .set(invitationModel.toMap());
  }

  @override
  Future<void> cancelFriend(InvitationModel invitationModel) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(invitationModel.fromId)
        .collection("friends")
        .doc(invitationModel.toId)
        .delete();
    await FirebaseFirestore.instance
        .collection("users")
        .doc(invitationModel.toId)
        .collection("friends")
        .doc(invitationModel.fromId)
        .delete();
    final ids = [invitationModel.fromId, invitationModel.toId];
    ids.sort();
    final chatRoomId = ids.join("_");
    final chatRoomRef = FirebaseFirestore.instance
        .collection("chatsRoom")
        .doc(chatRoomId);

    await chatRoomRef.update({"isFriend": false});
  }

  @override
  Future<void> cancelSentReceiveRequest(InvitationModel invitationModel) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(invitationModel.toId)
        .collection("receiveRequests")
        .doc(invitationModel.fromId)
        .delete();
    await FirebaseFirestore.instance
        .collection("users")
        .doc(invitationModel.fromId)
        .collection("sentRequests")
        .doc(invitationModel.toId)
        .delete();
  }

  @override
  Future<void> acceptReceiveInvitation(InvitationModel invitationModel) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(invitationModel.toId)
        .collection("receiveRequests")
        .doc(invitationModel.fromId)
        .delete();
    await FirebaseFirestore.instance
        .collection("users")
        .doc(invitationModel.fromId)
        .collection("sentRequests")
        .doc(invitationModel.toId)
        .delete();
    await FirebaseFirestore.instance
        .collection("users")
        .doc(invitationModel.fromId)
        .collection("friends")
        .doc(invitationModel.toId)
        .set(invitationModel.toMap());
    await FirebaseFirestore.instance
        .collection("users")
        .doc(invitationModel.toId)
        .collection("friends")
        .doc(invitationModel.fromId)
        .set(invitationModel.toMap());

    final ids = [invitationModel.fromId, invitationModel.toId];
    ids.sort();
    final chatRoomId = ids.join("_");
    final chatRoomRef = FirebaseFirestore.instance
        .collection("chatsRoom")
        .doc(chatRoomId);
    final chatRoomSnapshot = await chatRoomRef.get();
    if (chatRoomSnapshot.exists) {
      await chatRoomRef.update({"isFriend": true});
      return;
    }

    await chatRoomRef.set({
      "memberIds": [invitationModel.fromId, invitationModel.toId],
      "lastMessage": "",
      "lastMessageTime": 0000,
      "from": {"id": "", "noReadMess": 0},
      "isFriend": true,
    });
  }
}
