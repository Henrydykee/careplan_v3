import 'get_patients_note.dart';
import 'update_user_number.dart';
import 'verify_update_user_number.dart';

class AccountUseCases {
  final UpdateUserNumber updateUserNumber;
  final VerifyUpdateUserNumber verifyUpdateUserNumber;
  final GetPatientsNote getPatientsNote;

  AccountUseCases(
    this.updateUserNumber,
    this.verifyUpdateUserNumber,
    this.getPatientsNote,
  );
}
