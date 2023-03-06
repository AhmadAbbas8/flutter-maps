import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps/business_logic/phone_auth/phone_auth_cubit.dart';
import 'package:flutter_maps/constants/my_colors.dart';
import 'package:flutter_maps/presentation/screens/map_screen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../business_logic/phone_auth/phone_auth_state.dart';

// ignore: must_be_immutable
class OtpScreen extends StatelessWidget {
  OtpScreen({Key? key, this.phoneNumber}) : super(key: key);
  final String? phoneNumber;
  late String otpCode;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocConsumer<PhoneAuthCubit, PhoneAuthState>(
        listener: (context, state) {
          if (state is PhoneAuthLoad) {
            showProgresIndicator(context);
          }
          if (state is PhoneAuthVerified) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const MapScreen(),
                ),
                (route) => false);
          }
          if (state is PhoneAuthError) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.error,
                ),
                backgroundColor: Colors.black,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: MyColors.myWhite,
            body: Container(
              margin: const EdgeInsets.symmetric(
                vertical: 88,
                horizontal: 33,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text(
                      'Verify your phone number',
                      style: TextStyle(
                        fontSize: 25,
                        color: MyColors.myBlack,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      child: RichText(
                        text: TextSpan(
                          text: 'Enter your 6 digits code number sent to ',
                          style: const TextStyle(
                            color: MyColors.myBlack,
                            fontSize: 16,
                            height: 1.4,
                          ),
                          children: [
                            TextSpan(
                              text: '$phoneNumber',
                              style: const TextStyle(
                                color: MyColors.myBlue,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildPinCodeFields(context),
                    const SizedBox(height: 60),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(110, 50),
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          showProgresIndicator(context);
                          PhoneAuthCubit.get(context).submitOTP(otpCode);
                        },
                        child: const Text(
                          'Verify',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  Widget _buildPinCodeFields(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      autoFocus: true,
      cursorColor: MyColors.myBlack,
      keyboardType: TextInputType.number,
      length: 6,
      obscureText: false,
      animationType: AnimationType.scale,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(5),
        fieldHeight: 50,
        fieldWidth: 40,
        activeFillColor: MyColors.myLightBlue,
        borderWidth: 1,
        activeColor: MyColors.myBlue,
        inactiveColor: MyColors.myBlue,
        inactiveFillColor: MyColors.myWhite,
        selectedColor: MyColors.myBlue,
        selectedFillColor: MyColors.myWhite,
      ),
      animationDuration: const Duration(milliseconds: 300),
      backgroundColor: MyColors.myWhite,
      enableActiveFill: true,
      onCompleted: (code) {
        otpCode = code;
      },
      onChanged: (value) {
      },
    );
  }

  void showProgresIndicator(BuildContext context) {
    AlertDialog alertDialog = const AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
        ),
      ),
    );
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: MyColors.myWhite.withOpacity(0),
      builder: (context) {
        return alertDialog;
      },
    );
  }
}
