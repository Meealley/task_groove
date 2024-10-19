import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:task_groove/cubits/login/login_cubit.dart';

import 'package:task_groove/models/login_status.dart';
import 'package:task_groove/routes/pages.dart';
import 'package:task_groove/theme/app_textstyle.dart';
import 'package:task_groove/theme/appcolors.dart';
import 'package:task_groove/utils/button.dart';
import 'package:task_groove/utils/custom_textfield.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_groove/utils/error_dialog.dart';
import 'package:validators/validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  late TextEditingController _emailController, _passwordController;

  String? _email, _password;
  bool _obscureText = true;
  bool _loadWithProgress = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();

    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();

    _passwordController.dispose();

    super.dispose();
  }

  void _submit() {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;

      final form = _formKey.currentState;

      if (form == null || !form.validate()) return;

      form.save();

      _loadWithProgress = !_loadWithProgress;

      print(' email: $_email, password: $_password');
      context.read<LoginCubit>().login(
            context: context,
            email: _email!,
            password: _password!,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.loginStatus == LoginStatus.success) {
          context.go('/');
        } else if (state.loginStatus == LoginStatus.error) {
          errorDialog(context, state.error);
          _loadWithProgress = false;
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Login",
              style: AppTextStyles.headingBold,
            ),
          ),
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 2.h),
                      Text(
                        "Login to continue \nwith your tasks 🗄️",
                        style: AppTextStyles.bodyTextLg,
                      ),
                      Center(
                        child: Image.asset(
                          "assets/images/login.png",
                          height: 30.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Form(
                        key: _formKey,
                        autovalidateMode: _autovalidateMode,
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            SizedBox(height: 2.h),
                            CustomTextField(
                              prefixIcon: const Icon(Icons.mail),
                              labelText: "Enter your Email Address",
                              textInputType: TextInputType.emailAddress,
                              textEditingController: _emailController,
                              validator: (String? value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Email is required";
                                }
                                if (!isEmail(value.trim())) {
                                  return "Enter a valid email address";
                                }
                                return null;
                              },
                              onSaved: (String? value) {
                                _email = value;
                              },
                            ),
                            SizedBox(height: 2.h),
                            CustomTextField(
                              prefixIcon: const Icon(Icons.lock),
                              labelText: "Enter your Password",
                              textInputType: TextInputType.text,
                              textEditingController: _passwordController,
                              obscureText: _obscureText,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureText =
                                        !_obscureText; // Toggle visibility
                                  });
                                },
                              ),
                              validator: (String? value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Password is required";
                                }
                                if (value.trim().length < 6) {
                                  return "Password must be at least 6 characters long";
                                }
                                return null;
                              },
                              onSaved: (String? value) {
                                _password = value;
                              },
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Not a member?",
                                        style: AppTextStyles.bodySmall),
                                    const SizedBox(width: 5),
                                    GestureDetector(
                                      onTap: () {
                                        state.loginStatus == LoginStatus.loading
                                            ? null
                                            : context.push(Pages.signup);
                                      },
                                      child: Text(
                                        "Sign up",
                                        style: AppTextStyles.bodySmallUnderline,
                                      ),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    context.push(Pages.forgotPassword);
                                  },
                                  child: Text(
                                    "Forgot Password",
                                    style: AppTextStyles.bodySmall,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5.h),
                            ButtonPress(
                              loadWithProgress: _loadWithProgress,
                              backgroundColor:
                                  state.loginStatus == LoginStatus.loading
                                      ? AppColors.backgroundLoading
                                      : AppColors.backgroundDark,
                              onPressed:
                                  state.loginStatus == LoginStatus.loading
                                      ? null
                                      : _submit, // Handle form submission
                              text: state.loginStatus == LoginStatus.loading
                                  ? "Loading..."
                                  : "Login",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
