import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_groove/theme/app_textstyle.dart';

class NetworkAwareWidget extends StatefulWidget {
  final Widget child;

  const NetworkAwareWidget({super.key, required this.child});

  @override
  State<NetworkAwareWidget> createState() => _NetworkAwareWidgetState();
}

class _NetworkAwareWidgetState extends State<NetworkAwareWidget> {
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool isConnected = true;
  bool isDialogVisible = false; // Track if the dialog is currently visible

  @override
  void initState() {
    super.initState();
    _checkInitialConnectivity();

    // Listen for connectivity changes
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_updateConnectivityStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Check initial connectivity status
  Future<void> _checkInitialConnectivity() async {
    ConnectivityResult result = await Connectivity().checkConnectivity();
    _updateConnectivityStatus(result);
  }

  // Check for actual internet access
  Future<bool> _hasInternetAccess() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // Update connectivity status
  void _updateConnectivityStatus(ConnectivityResult result) async {
    log('Connectivity result: $result'); // Debug log

    if (result == ConnectivityResult.none) {
      setState(() {
        isConnected = false;
      });
    } else {
      isConnected = await _hasInternetAccess();
      log('Has internet access: $isConnected'); // Debug log
    }

    if (!isConnected && !isDialogVisible) {
      _showNoConnectionDialog();
    }
  }

  // Show no connection dialog
  void _showNoConnectionDialog() {
    isDialogVisible = true; // Prevent multiple dialogs
    // if (Platform.isIOS) {
    //   showCupertinoDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return CupertinoAlertDialog(
    //         title: Text(
    //           'No Internet Connection',
    //           style: AppTextStyles.bodyTextBold,
    //         ),
    //         content: Text(
    //           'You are currently offline. Please check your internet connection.',
    //           style: AppTextStyles.bodySmall,
    //         ),
    //         actions: <Widget>[
    //           CupertinoDialogAction(
    //             child: Text('OK', style: AppTextStyles.bodySmall),
    //             onPressed: () {
    //               Navigator.of(context).pop();
    //               isDialogVisible = false;
    //             },
    //           ),
    //         ],
    //       );
    //     },
    //   );
    // } else {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'No Internet Connection',
            style: AppTextStyles.bodyText,
          ),
          content: Text(
            'You are currently offline. Please check your internet connection.',
            style: AppTextStyles.bodySmall,
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK', style: AppTextStyles.bodySmall),
              onPressed: () {
                Navigator.of(context).pop();
                isDialogVisible = false;
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
