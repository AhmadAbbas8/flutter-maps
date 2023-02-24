import 'package:flutter/material.dart';
import 'package:flutter_maps/constants/my_colors.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpScreen extends StatelessWidget {
  OtpScreen({Key? key, this.phoneNumber}) : super(key: key);
  final String? phoneNumber;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: MyColors.myWhite,
        body: Container(
          margin: EdgeInsets.symmetric(
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
                      style: TextStyle(
                        color: MyColors.myBlack,
                        fontSize: 16,
                        height: 1.4,
                      ),
                      children: [
                        TextSpan(
                          text: '${phoneNumber}',
                          style: TextStyle(
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
                _buildNextButton()

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPinCodeFields(BuildContext context) {
    return Container(
      child: PinCodeTextField(
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
        animationDuration: Duration(milliseconds: 300),
        backgroundColor: MyColors.myWhite,
        enableActiveFill: true,
        // errorAnimationController: errorController,
        // controller: textEditingController,
        onCompleted: (code) {
          print("Completed");
        },
        onChanged: (value) {
          print(value);
        },
      ),
    );
  }

  Widget _buildNextButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom
          (
          minimumSize: const Size(110, 50),
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {},
        child: const Text(
          'Verify',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
