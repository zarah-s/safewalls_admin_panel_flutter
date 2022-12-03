import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/common/button/linear_btn.dart';
import 'package:flutter_demo/common/flushbar/show_flushbar.dart';
import 'package:flutter_demo/common/inputs/custom_input.dart';
import 'package:flutter_demo/common/typography/text_widget.dart';
import 'package:flutter_demo/main.dart';
import 'package:flutter_demo/services/api.dart';
import 'package:flutter_demo/services/provider.dart';
import 'package:flutter_demo/utils/colors.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  late AutovalidateMode _autoValidateMode;
  bool loading = false;
  Provider provider = Get.find();
  late String _email, _password;
  Dio dio = Dio();
  @override
  void initState() {
    super.initState();
    _autoValidateMode = AutovalidateMode.disabled;
    // _formKey.currentState!.save();
    // if (!_formKey.currentState!.validate()) return;
  }

  Future<void> login() async {
    _formKey.currentState!.save();

    setState(() {
      _autoValidateMode = AutovalidateMode.always;
    });

    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() {
        loading = true;
      });

      var response = await dio.post('$api/adminAuth',
          data: {'email': _email, 'password': _password});

      if (response.data['success']) {
        provider.saveId(true);
        Get.offAll(() => const HomePage());
      } else {
        // ignore: use_build_context_synchronously
        showFlushbar(provider, response.data['msg'], context, success: false);
      }
      setState(() {
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
      showFlushbar(provider, "Network interrupted", context, success: false);
    }
//proceed login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/logo.png',
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    "Safewalls",
                    style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 65,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic),
                  )
                ],
              ),
              Material(
                elevation: 20,
                color: Colors.transparent,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 70, vertical: 35),
                  width: 500,
                  // height: 500,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: _autoValidateMode,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/logo.png',
                          color: primaryColor,
                          width: 40,
                          height: 40,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Safewalls Admin Login",
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w600,
                            fontSize: 25,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextWidget(
                          text:
                              "If you're not an admin, kindly know that this ain't a place for you.",
                          centralized: true,
                          fontWeight: FontWeight.w500,
                          color: getblackOpacity(.5),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        TextFormField(
                          onChanged: (value) => setState(() {
                            _email = value;
                          }),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Email required";
                            } else {
                              if (GetUtils.isEmail(value)) {
                                return null;
                              } else {
                                return "Invalid Email Address";
                              }
                            }
                          },
                          decoration: InputDecoration(
                            labelText: "Email",
                            floatingLabelStyle: TextStyle(color: primaryColor),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: getblackOpacity(.5),
                              ),
                            ),
                            // floatingLabelStyle: ,
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: primaryColor, width: 2),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        TextFormField(
                          onChanged: (value) => setState(() {
                            _password = value;
                          }),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Password required";
                            } else {
                              return null;
                            }
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Password",
                            floatingLabelStyle: TextStyle(color: primaryColor),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: getblackOpacity(.5),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: primaryColor, width: 2),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () {
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: SizedBox(
                                    width: 270,
                                    // height: 0,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        TextWidget(
                                          text: "Recover Password",
                                          fontWeight: FontWeight.w600,
                                          size: 18,
                                          color: getblackOpacity(.5),
                                        ),
                                        IconButton(
                                          padding: const EdgeInsets.all(0),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          icon: Icon(
                                            Icons.cancel_outlined,
                                            color: getblackOpacity(.5),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      InputField(
                                        onChange: (value) {},
                                        validator: (value) {
                                          return null;
                                        },
                                        label: "Enter Email",
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      LinearButton(
                                        text: "Recover password",
                                        onTap: () {},
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                            child: TextWidget(
                              text: "Forgot Password?",
                              fontWeight: FontWeight.w500,
                              color: getblackOpacity(.5),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        LinearButton(
                          text: loading ? "Authenticating" : "Submit",
                          onTap: () {
                            if (!loading) {
                              login();
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
