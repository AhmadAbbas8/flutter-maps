import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps/business_logic/phone_auth/phone_auth_state.dart';

class PhoneAuthCubit extends Cubit<PhoneAuthState> {
  PhoneAuthCubit() : super(PhoneAuthInitial());

  static PhoneAuthCubit get(context) => BlocProvider.of(context);
  late String verificationId;

  Future<void> submitPhoneNumber(String phoneNumber) async {
    emit(PhoneAuthLoad());

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+2$phoneNumber',
      timeout: const Duration(seconds: 14),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  void verificationCompleted(PhoneAuthCredential credential) async {
    print('All Done');
    await signIn(credential);
  }

  Future<void> signIn(PhoneAuthCredential credential) async {
    emit(PhoneAuthLoad());
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      emit(PhoneAuthVerified());
    } catch (e) {
      print('error in sign in method ${e.toString()}');
      emit(PhoneAuthError(e.toString()));
    }
  }

  void verificationFailed(FirebaseAuthException e) {
    print(e.toString());
    print('verificationFailed');
    emit(PhoneAuthError(e.toString()));
  }

  void codeSent(String verificationId, int? resendToken) {
    this.verificationId = verificationId;
    emit(PhoneAuthSubmited());
  }

  void codeAutoRetrievalTimeout(String verificationId) {}

  Future<void> submitOTP(String otpCode) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: this.verificationId,
      smsCode: otpCode,
    );

    await signIn(credential);
  }

  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
  }

  User getLoggedInUser() {
    return FirebaseAuth.instance.currentUser!;
  }



}
