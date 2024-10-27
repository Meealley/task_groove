// // ProfileDescription.dart
// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';
// import 'package:task_groove/theme/app_textstyle.dart';
// import 'package:task_groove/utils/button.dart';
// import 'package:task_groove/utils/custom_textfield.dart';

// class ProfileDescription extends StatefulWidget {
//   const ProfileDescription({super.key});

//   @override
//   State<ProfileDescription> createState() => _ProfileDescriptionState();
// }

// class _ProfileDescriptionState extends State<ProfileDescription> {
//   late TextEditingController _nameController;
//   late TextEditingController _emailController;
//   late String _profileImageUrl;

//   @override
//   void initState() {
//     super.initState();
//     _nameController = TextEditingController();
//     _emailController = TextEditingController();
//     _profileImageUrl = ''; // Initialize with an empty string
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();

//     // Fetch the passed arguments here instead of initState
//     final args =
//         ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
//     _nameController.text = args['name'] ?? '';
//     _emailController.text = args['email'] ?? '';
//     _profileImageUrl = args['profileImageUrl'] ?? '';
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _nameController.dispose();
//     _emailController.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Edit Profile",
//           style: AppTextStyles.heading,
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Center(
//               child: CircleAvatar(
//                 radius: 50,
//                 backgroundImage: NetworkImage(
//                   _profileImageUrl.isNotEmpty
//                       ? _profileImageUrl
//                       : 'https://example.com/default_profile_image.png',
//                 ),
//               ),
//             ),
//             SizedBox(height: 3.h),
//             Text(
//               "Fullname",
//               style: AppTextStyles.bodyTextBold,
//             ),
//             SizedBox(height: 1.5.h),
//             CustomTextField(
//               textInputType: TextInputType.text,
//               textEditingController: _nameController,
//             ),
//             SizedBox(height: 2.h),
//             Text(
//               "Email",
//               style: AppTextStyles.bodyTextBold,
//             ),
//             SizedBox(height: 1.5.h),
//             CustomTextField(
//               textInputType: TextInputType.emailAddress,
//               textEditingController: _emailController,
//             ),
//             SizedBox(height: 4.h),
//             ButtonPress(
//               text: "Edit Profile",
//               loadWithProgress: false,
//               onPressed: () {
//                 // Implement your logic to update the profile here
//                 print("Updated Name: ${_nameController.text}");
//                 print("Updated Email: ${_emailController.text}");
//                 // You can call a method in your cubit to update the user profile.
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:task_groove/cubits/profile/profile_cubit.dart';
import 'package:task_groove/models/user_model.dart'; // Ensure you import the UserModel
import 'package:task_groove/theme/app_textstyle.dart';
import 'package:task_groove/utils/button.dart';
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

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    _profileImageUrl = widget.user.profilePicsUrl ?? '';
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                  _profileImageUrl.isNotEmpty
                      ? _profileImageUrl
                      : 'https://example.com/default_profile_image.png',
                ),
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
              text: "Edit Profile",
              loadWithProgress: false,
              onPressed: () {
                // Implement your logic to update the profile here
                print("Updated Name: ${_nameController.text}");
                print("Updated Email: ${_emailController.text}");
                // You can call a method in your cubit to update the user profile.
                context.read<ProfileCubit>().updateUserProfile(
                      name: _nameController.text,
                      email: _emailController.text,
                      profileImageUrl: _profileImageUrl,
                    );
              },
            ),
          ],
        ),
      ),
    );
  }
}
