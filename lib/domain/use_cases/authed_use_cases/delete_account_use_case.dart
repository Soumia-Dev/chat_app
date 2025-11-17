import 'package:flutter/cupertino.dart';

import '../../repositories/authed_repository.dart';

class DeleteAccountUseCase {
  final AuthedRepository authedRepository;
  final BuildContext context;
  DeleteAccountUseCase(this.authedRepository, this.context);
  Future<String?> call() {
    return authedRepository.deleteAccount(context);
  }
}
