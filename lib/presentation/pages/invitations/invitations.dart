
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../l10n/app_localizations.dart';
import '../../bloc/users/users_bloc.dart';
import '../profile/profile.dart';
import 'invitation_widgets.dart';

class InvitationsPage extends StatefulWidget {
  const InvitationsPage({super.key});
  @override
  State<InvitationsPage> createState() => _InvitationsPageState();
}

void navigateToProfile(BuildContext context, String userId) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => Profile(userId: userId)),
  );
}

class _InvitationsPageState extends State<InvitationsPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: InvitationWidgets.appBar(context),
        body: TabBarView(
          children: [
            BlocBuilder<UsersBloc, UsersState>(
              builder: (context, state) {
                if (state is UsersLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is UsersLoadedState) {
                  final receives =
                      state.users.where((u) => u.state == "receive").toList();
                  if (receives.isEmpty) {
                    return Center(
                      child: Text(
                          AppLocalizations.of(context)!.noReceivedInviteFound),
                    );
                  }
                  return InvitationWidgets.usersList(
                    receives,
                    navigateToProfile,
                  );
                } else if (state is UsersErrorState) {
                  return Center(
                    child:
                        Text(AppLocalizations.of(context)!.failedToLoadUsers),
                  );
                }
                return const SizedBox();
              },
            ),
            BlocBuilder<UsersBloc, UsersState>(
              builder: (context, state) {
                if (state is UsersLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is UsersLoadedState) {
                  final sends =
                      state.users.where((u) => u.state == "sent").toList();

                  if (sends.isEmpty) {
                    return Center(
                      child:
                          Text(AppLocalizations.of(context)!.noSentInviteFound),
                    );
                  }

                  return InvitationWidgets.usersList(
                    sends,
                    navigateToProfile,
                  );
                } else if (state is UsersErrorState) {
                  return Center(
                    child:
                        Text(AppLocalizations.of(context)!.failedToLoadUsers),
                  );
                }
                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}
