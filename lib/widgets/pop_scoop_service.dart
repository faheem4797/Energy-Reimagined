import 'package:energy_reimagined/constants/colors.dart';
import 'package:flutter/material.dart';

class WillPopScoopService {
  Future<bool> showCloseConfirmationDialog(BuildContext context) async {
    // Show a dialog to confirm whether to navigate back or not
    bool? shouldNavigateBack = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Are you sure?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: ConstColors.blackColor,
            ),
          ),
          content: const Text(
            'Do you want to exit the app?',
            style: TextStyle(
              fontWeight: FontWeight.w200,
              fontSize: 16,
              color: ConstColors.blackColor,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(
                'No',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: ConstColors.blackColor,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                'Yes',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: ConstColors.greenColor,
                ),
              ),
            ),
          ],
        );
      },
    );

    // If dialog is dismissed, default to false
    return shouldNavigateBack ?? false;
  }

  Future<bool> showToolRequestConfirmationDialog(BuildContext context) async {
    // Show a dialog to confirm whether to navigate back or not
    bool? shouldNavigateBack = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Are you sure?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: ConstColors.blackColor,
            ),
          ),
          content: const Text(
            'Do you confirm that you have received the requested tools?',
            style: TextStyle(
              fontWeight: FontWeight.w200,
              fontSize: 16,
              color: ConstColors.blackColor,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(
                'No',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: ConstColors.blackColor,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                'Yes',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: ConstColors.greenColor,
                ),
              ),
            ),
          ],
        );
      },
    );

    // If dialog is dismissed, default to false
    return shouldNavigateBack ?? false;
  }

  Future<bool> showLogoutConfirmationDialog(BuildContext context) async {
    // Show a dialog to confirm whether to navigate back or not
    bool? shouldNavigateBack = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Are you sure?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: ConstColors.blackColor,
            ),
          ),
          content: const Text(
            'Do you want to logout?',
            style: TextStyle(
              fontWeight: FontWeight.w200,
              fontSize: 16,
              color: ConstColors.blackColor,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(
                'No',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: ConstColors.blackColor,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                'Yes',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: ConstColors.greenColor,
                ),
              ),
            ),
          ],
        );
      },
    );

    // If dialog is dismissed, default to false
    return shouldNavigateBack ?? false;
  }

  Future<bool> showCancelJobConfirmationDialog(BuildContext context) async {
    // Show a dialog to confirm whether to navigate back or not
    bool? shouldNavigateBack = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Are you sure?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: ConstColors.blackColor,
            ),
          ),
          content: const Text(
            'Do you want to cancel this job? This action is irreversible',
            style: TextStyle(
              fontWeight: FontWeight.w200,
              fontSize: 16,
              color: ConstColors.blackColor,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(
                'No',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: ConstColors.blackColor,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                'Yes',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: ConstColors.greenColor,
                ),
              ),
            ),
          ],
        );
      },
    );

    // If dialog is dismissed, default to false
    return shouldNavigateBack ?? false;
  }
}
