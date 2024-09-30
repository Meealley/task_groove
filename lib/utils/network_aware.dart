import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
    // Dispose of the connectivity subscription when the widget is disposed
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Check the initial connectivity status when the widget loads
  Future<void> _checkInitialConnectivity() async {
    ConnectivityResult result = await Connectivity().checkConnectivity();
    _updateConnectivityStatus(result); // Update the connection status
  }

  // Update the connection status and show a dialog if there is no connection
  void _updateConnectivityStatus(ConnectivityResult result) {
    setState(() {
      isConnected = result != ConnectivityResult.none;
    });
    if (!isConnected) {
      _showNoConnectionDialog();
    }
  }

  // Show platform-specific dialog based on the network status
  void _showNoConnectionDialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(
              'No Internet Connection',
              style: AppTextStyles.bodyTextBold,
            ),
            content: Text(
              'You are currently offline. Please check your internet connection.',
              style: AppTextStyles.bodySmall,
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text('OK', style: AppTextStyles.bodySmall),
                onPressed: () {
                  context.pop();
                },
              ),
            ],
          );
        },
      );
    } else {
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
                style: AppTextStyles.bodySmall),
            actions: <Widget>[
              TextButton(
                child: Text('OK', style: AppTextStyles.bodySmall),
                onPressed: () {
                  context.pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
