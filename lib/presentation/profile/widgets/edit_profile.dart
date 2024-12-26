import 'dart:developer';
import 'dart:io';
import 'package:image/image.dart' as img;

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:task_groove/constants/constants.dart';
import 'package:task_groove/cubits/app_theme/theme_cubit.dart';
import 'package:task_groove/cubits/profile/profile_cubit.dart';
import 'package:task_groove/cubits/profile/profile_state.dart';
import 'package:task_groove/models/user_model.dart'; // Ensure you import the UserModel
import 'package:task_groove/theme/app_textstyle.dart';
import 'package:task_groove/utils/button.dart';
import 'package:task_groove/utils/custom_error.dart';
import 'package:task_groove/utils/custom_textfield.dart';

class ProfileDescription extends StatefulWidget {
  final UserModel user;

  const ProfileDescription({super.key, required this.user});

  @override
  State<ProfileDescription> createState() => _ProfileDescriptionState();
}

class _ProfileDescriptionState extends State<ProfileDescription> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late String _profileImageUrl;
  final bool _loadWithProgress = false;
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    _profileImageUrl = widget.user.profilePicsUrl ?? '';

    // Load the profile from SharedPreferences
    context.read<ProfileCubit>().loadProfileFromSharedPreferences();

    // Listen to changes in the ProfileCubit and update the UI accordingly
    context.read<ProfileCubit>().fetchUserProfile();
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
  }

  Future<void> _pickSingleImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() {
          _isUploading = true;
        });

        File profileImageFile = File(image.path);
        String uploadImgaeUrl = await _uploadProfileImage(profileImageFile);

        setState(() {
          _profileImageUrl = uploadImgaeUrl;
          _isUploading = false;
        });

        context.read<ProfileCubit>().updateUserProfile(
              name: _nameController.text,
              email: _emailController.text,
              profileImageUrl: _profileImageUrl,
              context: context,
            );
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //       // backgroundColor: state.color,
        //       content: Text(
        //     'Profile updated Successfully',
        //     style: AppTextStyles.bodyText.copyWith(
        //       color: Colors.white,
        //     ),
        //   )),
        // );
      }
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
      print("Error picking image: $e");
    }
  }

  Future<File> _compressImage(File file) async {
    // Decode the image file
    img.Image image = img.decodeImage(file.readAsBytesSync())!;

    // Resize the image (optional, adjust the size to your need)
    img.Image resizedImage = img.copyResize(image,
        width: 800); // Resize to 800px width (you can adjust)

    // Save the resized image
    final compressedFile = File('${file.path}_compressed.jpg')
      ..writeAsBytesSync(img.encodeJpg(resizedImage));

    return compressedFile;
  }

  Future<String> _uploadProfileImage(File profileImage) async {
    try {
      // Compress the image before uploading
      File compressedImage = await _compressImage(profileImage);
      String fileName = "${auth.currentUser!.uid}/profile_image_${uuid.v4()}";
      Reference storageRef = FirebaseStorage.instance.ref().child(fileName);
      await storageRef.putFile(compressedImage);
      String downloadUrl = await storageRef.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      log("Error uploading profile image: $e");
      throw const CustomError(
        code: "StorageError",
        message: "Failed to upload profile image",
        plugin: "Firebase_Storage",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: AppTextStyles.heading,
        ),
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Stack(
                      alignment:
                          Alignment.center, // Center the loading indicator
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: _isUploading
                              ? null // No image if uploading
                              : NetworkImage(
                                  _profileImageUrl.isNotEmpty
                                      ? _profileImageUrl
                                      : 'https://example.com/default_profile_image.png',
                                ),
                          child: _isUploading
                              ? const CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                ) // Show progress indicator
                              : null,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Your avatar photo will be public.",
                          style: AppTextStyles.bodySmall,
                        ),
                        BlocBuilder<ThemeCubit, ThemeState>(
                          builder: (context, state) {
                            return GestureDetector(
                              onTap: _pickSingleImage,
                              child: Text(
                                "Edit",
                                style: AppTextStyles.bodySmall
                                    .copyWith(color: state.color),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    "Fullname",
                    style: AppTextStyles.bodyTextBold,
                  ),
                  SizedBox(height: 1.5.h),
                  CustomTextField(
                    textInputType: TextInputType.text,
                    textEditingController: _nameController,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "Email",
                    style: AppTextStyles.bodyTextBold,
                  ),
                  SizedBox(height: 1.5.h),
                  CustomTextField(
                    textInputType: TextInputType.emailAddress,
                    textEditingController: _emailController,
                  ),
                  SizedBox(height: 4.h),
                  ButtonPress(
                    text: state.isLoading ? "Loading..." : "Edit Profile",
                    loadWithProgress: _loadWithProgress,
                    onPressed: () {
                      // Implement your logic to update the profile here
                      print("Updated Name: ${_nameController.text}");
                      print("Updated Email: ${_emailController.text}");
                      // You can call a method in your cubit to update the user profile.
                      context.read<ProfileCubit>().updateUserProfile(
                            name: _nameController.text,
                            email: _emailController.text,
                            profileImageUrl: _profileImageUrl,
                            context: context,
                          );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
