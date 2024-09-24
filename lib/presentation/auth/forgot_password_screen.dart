import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:task_groove/cubits/forgotpassword/forgotpassword_cubit.dart';
import 'package:task_groove/models/forgot_password_status.dart';
import 'package:task_groove/theme/app_textstyle.dart';
import 'package:task_groove/theme/appcolors.dart';
import 'package:task_groove/utils/button.dart';
import 'package:task_groove/utils/custom_textfield.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_groove/utils/error_dialog.dart';
import 'package:validators/validators.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  late TextEditingController _emailController;

  String? _email;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;

      final form = _formKey.currentState;

      if (form == null || !form.validate()) return;

      form.save();

      print(' email: $_email');
      context
          .read<ForgotpasswordCubit>()
          .resetPassword(context: context, email: _email!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgotpasswordCubit, ForgotpasswordState>(
      listener: (context, state) {
        if (state.forgotPasswordStatus == ForgotPasswordStatus.success) {
          context.go('/login');
        } else if (state.forgotPasswordStatus == ForgotPasswordStatus.error) {
          errorDialog(context, state.error);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Forgot password",
              style: AppTextStyles.headingBold,
            ),
          ),
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.h),
                  Center(
                    child: Image.asset(
                      "assets/images/forgot_password.png",
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
                          labelText: "Enter your Email Address",
                          textInputType: TextInputType.name,
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
                        SizedBox(height: 5.h),
                        ButtonPress(
                          backgroundColor: state.forgotPasswordStatus ==
                                  ForgotPasswordStatus.loading
                              ? AppColors.backgroundLoading
                              : AppColors.backgroundDark,
                          onPressed: state.forgotPasswordStatus ==
                                  ForgotPasswordStatus.loading
                              ? null
                              : _submit, // Handle form submission
                          text: state.forgotPasswordStatus ==
                                  ForgotPasswordStatus.loading
                              ? "Loading..."
                              : "Reset Password",
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
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
