// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:web_test/common/extension/num_extension.dart';
import 'package:web_test/common/widget/text_field_widget.dart';
import 'package:web_test/generated/assets.gen.dart';
import 'package:web_test/main.dart';
import 'package:web_test/service/auth.dart';
import 'package:web_test/service/local.dart';
import 'package:web_test/utility/loading.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final form = GlobalKey<FormState>();
  String email = '';
  String password = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              Assets.images.background.path,
            ),
          ),
        ),
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.only(top: 80.hMax),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 600.w,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.8),
                          spreadRadius: 1,
                          blurRadius: 8,
                        ),
                      ],
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                    child: Form(
                      key: form,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 40.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 40.hMax),
                          TextFieldWidget(
                            label: 'Username',
                            fillColor: Colors.white,
                            filled: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your username.';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              email = value;
                            },
                          ),
                          SizedBox(
                            height: 24.hMax,
                          ),
                          TextFieldWidget(
                            label: 'Password',
                            fillColor: Colors.white,
                            filled: true,
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password.';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              password = value;
                            },
                          ),
                          SizedBox(height: 40.hMax),
                          InkWell(
                            onTap: () async {
                              if (form.currentState!.validate()) {
                                try {
                                  LoadingUtility.show();
                                  final auth = AuthService();

                                  final response = await auth.login(email, password);
                                  if (response) {
                                    LocalStorageUtility.storeData('username', email);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const StartPage(),
                                      ),
                                    );
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text(
                                          'Error',
                                          style: TextStyle(fontSize: 26.sp, color: Colors.red),
                                        ),
                                        content: Text(
                                          'Your login info is not correct. Please check again.',
                                          style: TextStyle(
                                            fontSize: 18.sp,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text(
                                        'Error',
                                        style: TextStyle(fontSize: 26.sp, color: Colors.red),
                                      ),
                                      content: Text(
                                        e.toString(),
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  );
                                } finally {
                                  LoadingUtility.dismiss();
                                }
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                                color: const Color(0xFFeb7b3b),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 12.h),
                              alignment: Alignment.center,
                              child: Text(
                                'Sign In',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22.sp,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
