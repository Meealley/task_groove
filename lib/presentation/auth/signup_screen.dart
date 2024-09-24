import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:task_groove/cubits/signup/signup_cubit.dart';
import 'package:task_groove/models/signup_status.dart';
import 'package:task_groove/repository/image_services.dart';
// import 'package:task_groove/routes/pages.dart';
import 'package:task_groove/theme/app_textstyle.dart';
import 'package:task_groove/theme/appcolors.dart';
import 'package:task_groove/utils/button.dart';
import 'package:task_groove/utils/custom_textfield.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_groove/utils/error_dialog.dart';
import 'package:task_groove/utils/toast_message_services.dart';
import 'package:validators/validators.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  late TextEditingController _nameController,
      _emailController,
      _passwordController,
      _confirmPasswordController;

  String? _name, _email, _password;
  File? _selectedImage; // For storing the selected image

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _nameController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(BuildContext context) async {
    File? pickedImage =
        await ImagePickerService.pickSingleImage(context: context);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = pickedImage; // Set the image if picked
      });
    } else {
      ToastService.sendScaffoldAlert(
        msg: "Please select an Image",
        toastStatus: "ERROR",
        context: context,
      );
    }
  }

  void _submit() {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;

      final form = _formKey.currentState;

      if (form == null || !form.validate()) return;

      form.save();

      print('name: $_name, email: $_email, password: $_password');

      if (_selectedImage == null) {
        ToastService.sendScaffoldAlert(
          msg: "Please select an Image",
          toastStatus: "ERROR",
          context: context,
        );
      }
      context.read<SignupCubit>().signup(
            name: _name!,
            email: _email!,
            password: _password!,
            profileImage: _selectedImage, // Pass the selected image here
            context: context,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupCubit, SignupState>(
      listener: (context, state) {
        if (state.signUpStatus == SignUpStatus.success) {
          context.go('/home');
        } else if (state.signUpStatus == SignUpStatus.error) {
          errorDialog(context, state.error);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Register",
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
                  Text(
                    "Create your account",
                    style: AppTextStyles.bodyText,
                  ),
                  SizedBox(height: 3.h),
                  Form(
                    key: _formKey,
                    autovalidateMode: _autovalidateMode,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _pickImage(
                                context); // Trigger image picker on avatar tap
                          },
                          child: CircleAvatar(
                            radius: 7.h,
                            backgroundColor: Colors.black,
                            child: CircleAvatar(
                              radius: 7.h - 2,
                              backgroundImage: _selectedImage != null
                                  ? FileImage(_selectedImage!)
                                  : null, // Show the selected image
                              child: _selectedImage == null
                                  ? Icon(
                                      Icons.person,
                                      size: 9.h,
                                      color: Colors.white,
                                    )
                                  : null, // Default icon if no image
                            ),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        CustomTextField(
                          labelText: "Enter your name",
                          textInputType: TextInputType.name,
                          textEditingController: _nameController,
                          validator: (String? value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Name is required";
                            }
                            if (value.trim().length < 2) {
                              return "Name must be at least 2 characters";
                            }
                            return null;
                          },
                          onSaved: (String? value) {
                            _name = value;
                          },
                        ),
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
                        CustomTextField(
                          labelText: "Enter your Password",
                          textInputType: TextInputType.name,
                          textEditingController: _passwordController,
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
                        SizedBox(height: 2.h),
                        CustomTextField(
                          labelText: "Confirm Password",
                          textInputType: TextInputType.name,
                          textEditingController: _confirmPasswordController,
                          validator: (String? value) {
                            if (_passwordController.text != value) {
                              return "Password does not match 👀";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 5.h),
                        ButtonPress(
                          backgroundColor:
                              state.signUpStatus == SignUpStatus.loading
                                  ? AppColors.backgroundLoading
                                  : AppColors.backgroundDark,
                          onPressed: state.signUpStatus == SignUpStatus.loading
                              ? null
                              : _submit, // Handle form submission
                          text: state.signUpStatus == SignUpStatus.loading
                              ? "Loading..."
                              : "Register",
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
