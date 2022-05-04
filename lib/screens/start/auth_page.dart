import 'package:beamer/beamer.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:hohee_record/constants/shared_pref_key.dart';
import 'package:hohee_record/states/user_notifier.dart';
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

  String? _verificationId;
  int? _forceResendingToken;

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
                    onPressed: () async {
                      if (_verificationStatus == VerificationStatus.codeSending) return;
                      if (_formKey.currentState != null) {
                        bool passed = _formKey.currentState!.validate();

                        if (passed) {
                          String phoneNum = _phoneNumberController.text;
                          phoneNum = phoneNum
                              .replaceAll(' ', '')
                              .replaceFirst('0', '');

                          // https://firebase.flutter.dev/docs/auth/phone
                          FirebaseAuth auth = FirebaseAuth.instance;

                          setState(() {
                            _verificationStatus =
                                VerificationStatus.codeSending;
                          });

                          await auth.verifyPhoneNumber(
                            phoneNumber: '+82$phoneNum',
                            forceResendingToken: _forceResendingToken,
                            verificationCompleted:
                                (PhoneAuthCredential credential) async {
                              await auth.signInWithCredential(credential);
                            },
                            codeSent: (String verificationId,
                                int? forceResendingToken) async {
                              setState(() {
                                _verificationStatus =
                                    VerificationStatus.codeSent;
                              });
                              _verificationId = verificationId;
                              _forceResendingToken = forceResendingToken;
                            },
                            verificationFailed: (FirebaseAuthException error) {
                              logger.e(error.message);
                              setState(() {
                                _verificationStatus = VerificationStatus.none;
                              });
                            },
                            codeAutoRetrievalTimeout:
                                (String verificationId) {},
                          );
                        }
                      }
                    },
                    style: TextButton.styleFrom(
                      // backgroundColor: Colors.grey,
                      minimumSize: const Size(48, 48),
                    ),
                    child: (_verificationStatus ==
                            VerificationStatus.codeSending)
                        ? const SizedBox(
                            height: 26,
                            width: 26,
                            child:
                                CircularProgressIndicator(color: Colors.white),
                          )
                        : const Text(
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
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
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
      case VerificationStatus.codeSending:
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
      case VerificationStatus.codeSending:
        return 48;
    }
  }

  void attemptVerify() async {
    setState(() {
      _verificationStatus = VerificationStatus.verifying;
    });

    try {
      // Create a PhoneAuthCredential with the code
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationId!, smsCode: _codeController.text);
      // Sign the user in (or link) with the credential
      await FirebaseAuth.instance.signInWithCredential(credential);
      context.beamToNamed('/home');
    } catch (e) {
      logger.e('attemptVerify error: $e');
      SnackBar snackBar = const SnackBar(content: Text('입력하신 코드가 들려요.'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    setState(() {
      _verificationStatus = VerificationStatus.verificationDone;
    });
  }

  _getAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String address = prefs.getString(SHARED_ADDRESS) ?? "";
    double lat = prefs.getDouble(SHARED_LAT) ?? 0;
    double log = prefs.getDouble(SHARED_LON) ?? 0;
  }
}

enum VerificationStatus {
  none,
  codeSending,
  codeSent,
  verifying,
  verificationDone
}
