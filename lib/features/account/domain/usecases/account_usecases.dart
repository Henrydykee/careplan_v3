import 'get_patients_note.dart';
import 'register_kyc.dart';
import 'update_user_number.dart';
import 'verify_update_user_number.dart';

class AccountUseCases {
  final UpdateUserNumber updateUserNumber;
  final VerifyUpdateUserNumber verifyUpdateUserNumber;
  final GetPatientsNote getPatientsNote;
  final RegisterKyc registerKyc;

  AccountUseCases(
    this.updateUserNumber,
    this.verifyUpdateUserNumber,
    this.getPatientsNote,
    this.registerKyc,
  );
}
