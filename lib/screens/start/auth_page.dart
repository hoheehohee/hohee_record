import 'package:beamer/beamer.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:hohee_record/states/user_provider.dart';
import 'package:hohee_record/utils/logger.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/common_size.dart';

class AuthPage extends StatefulWidget {
  AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

const duration = Duration(milliseconds: 300);

class _AuthPageState extends State<AuthPage> {
  final inputBorder = const OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey),
  );

  final TextEditingController _phoneNumberController =
      TextEditingController(text: '010');

  final TextEditingController _codeController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  VerificationStatus _verificationStatus = VerificationStatus.none;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      Size size = MediaQuery.of(context).size;

      return IgnorePointer(
        ignoring: _verificationStatus == VerificationStatus.verifying,
        child: Form(
          key: _formKey,
          child: Scaffold(
            appBar: AppBar(
              titleTextStyle: Theme.of(context).appBarTheme.titleTextStyle,
              title: const Text('전화번호 로그인'),
              elevation: 2,
            ),
            body: Padding(
              padding: const EdgeInsets.all(common_padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      ExtendedImage.asset(
                        'assets/imgs/padlock.png',
                        width: size.width * 0.15,
                        height: size.width * 0.15,
                      ),
                      const SizedBox(width: common_sm_padding),
                      const Text(
                        'hohee마켓은 휴대폰 번호로 가입해요.\n번호는 완전하게 보관 되며 \n어디에도 공개되지 않아요.',
                        style: TextStyle(height: 1.3),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: common_padding,
                  ),
                  TextFormField(
                    controller: _phoneNumberController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [MaskedInputFormatter("000 0000 0000")],
                    decoration: InputDecoration(
                      focusedBorder: inputBorder,
                      border: inputBorder,
                    ),
                    validator: (phoneNumber) {
                      if (phoneNumber != null && phoneNumber.length == 13) {
                        return null;
                      } else {
                        // error
                        return '전화번호가 잘못되었습니다.';
                      }
                    },
                  ),
                  const SizedBox(
                    height: common_sm_padding,
                  ),
                  TextButton(
                    onPressed: () {
                      if (_formKey.currentState != null) {
                        bool passed = _formKey.currentState!.validate();

                        if (passed) {
                          setState(() {
                            _verificationStatus = VerificationStatus.codeSent;
                          });
                        }
                      }
                    },
                    style: TextButton.styleFrom(
                      // backgroundColor: Colors.grey,
                      minimumSize: const Size(48, 48),
                    ),
                    child: const Text(
                      "인증문자 받기",
                    ),
                  ),
                  const SizedBox(
                    height: common_padding,
                  ),
                  AnimatedOpacity(
                    duration: duration,
                    opacity: (_verificationStatus == VerificationStatus.none
                        ? 0
                        : 1),
                    child: AnimatedContainer(
                      duration: duration,
                      curve: Curves.easeInOut,
                      height: getVerificationHeight(_verificationStatus),
                      child: TextFormField(
                        controller: _codeController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [MaskedInputFormatter('000000')],
                        decoration: InputDecoration(
                          focusedBorder: inputBorder,
                          border: inputBorder,
                        ),
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: duration,
                    curve: Curves.easeInOut,
                    height: getVerificationButtonHeight(_verificationStatus),
                    child: TextButton(
                      onPressed: () {
                        attemptVerify();
                      },
                      style: TextButton.styleFrom(
                          // backgroundColor: Colors.grey,
                          minimumSize: const Size(48, 48)),
                      child:
                          (_verificationStatus == VerificationStatus.verifying)
                              ? const CircularProgressIndicator(color: Colors.white,)
                              : const Text("인증번호 확인"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  double getVerificationHeight(VerificationStatus status) {
    switch (status) {
      case VerificationStatus.none:
        return 0;
      case VerificationStatus.codeSent:
      case VerificationStatus.verifying:
      case VerificationStatus.verificationDone:
        return 60 + common_sm_padding;
    }
  }

  double getVerificationButtonHeight(VerificationStatus status) {
    switch (status) {
      case VerificationStatus.none:
        return 0;
      case VerificationStatus.codeSent:
      case VerificationStatus.verifying:
      case VerificationStatus.verificationDone:
        return 48;
    }
  }

  void attemptVerify() async {
    setState(() {
      _verificationStatus = VerificationStatus.verifying;
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _verificationStatus = VerificationStatus.verificationDone;
    });

    context.read<UserProvider>().setUserAuth(true);
    context.beamToNamed('/');
  }

  _getAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String address = prefs.getString('address') ?? "";
    logger.d(address);
  }
}

enum VerificationStatus { none, codeSent, verifying, verificationDone }
