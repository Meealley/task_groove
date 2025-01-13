import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:task_groove/constants/constants.dart';
import 'package:task_groove/theme/app_textstyle.dart';
import 'package:task_groove/theme/appcolors.dart';
import 'package:task_groove/utils/button.dart';
import 'package:task_groove/utils/custom_error.dart';
import 'package:task_groove/utils/custom_textfield.dart';
import 'package:task_groove/utils/toast_message_services.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final currentUser = auth.currentUser;
      if (currentUser == null) {
        throw const CustomError(
            code: "No User", message: "No authenticated user found");
      }

      final email = currentUser.email;
      final password = _currentPasswordController.text;

      final credential =
          EmailAuthProvider.credential(email: email!, password: password);

      await currentUser.reauthenticateWithCredential(credential);

      await currentUser
          .updatePassword(_newPasswordController.text)
          .whenComplete(() => ToastService.sendScaffoldAlert(
                msg: "Password Updated",
                toastStatus: "SUCCESS",
                context: context,
              ));

      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
    } catch (e) {
      ToastService.sendScaffoldAlert(
        msg: "Password Update Failed",
        toastStatus: "ERROR",
        context: context,
      );
      log(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Change Password",
          style: AppTextStyles.headingBold.copyWith(color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () => context.pop(),
          color: Colors.white,
          icon: const FaIcon(
            FontAwesomeIcons.arrowLeft,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                textInputType: TextInputType.text,
                textEditingController: _currentPasswordController,
                labelText: 'Current Password',
                obscureText: _obscureCurrentPassword,
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureCurrentPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureCurrentPassword = !_obscureCurrentPassword;
                    });
                  },
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your current password';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 5.h,
              ),
              CustomTextField(
                textInputType: TextInputType.text,
                textEditingController: _newPasswordController,
                labelText: 'New Password',
                obscureText: _obscureNewPassword,
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureNewPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureNewPassword = !_obscureNewPassword;
                    });
                  },
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a new password';
                  } else if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 5.h,
              ),
              CustomTextField(
                textInputType: TextInputType.text,
                textEditingController: _confirmPasswordController,
                labelText: 'Confirm Password',
                obscureText: _obscureConfirmPassword,
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your new password';
                  } else if (value != _newPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              // _isLoading
              //     ? const Center(child: CircularProgressIndicator())
              //     : ElevatedButton(
              //         onPressed: _changePassword,
              //         child: const Text('Change Password'),
              //       ),

              ButtonPress(
                loadWithProgress: _isLoading,
                backgroundColor: _isLoading
                    ? AppColors.backgroundDark
                    : AppColors.backgroundDark,
                onPressed: _changePassword,
                text: _isLoading ? "Loading..." : "Update Password",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
