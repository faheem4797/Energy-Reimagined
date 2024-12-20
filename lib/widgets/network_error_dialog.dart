import 'package:flutter/material.dart';

class NetworkErrorDialog extends StatelessWidget {
  const NetworkErrorDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
              width: 200,
              child: Image.asset('assets/images/no_connection.jpg')),
          const SizedBox(height: 32),
          const Text(
            "Whoops!",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            "No internet connection found.",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            "Check your connection and try again.",
            style: TextStyle(
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // ElevatedButton(
          //   style: ButtonStyle(
          //     backgroundColor:
          //         MaterialStateProperty.all<Color>(ConstColors.foregroundColor),
          //     padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          //       const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          //     ),
          //     // To change the shape of the button:
          //     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          //       RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(8.0),
          //       ),
          //     ),
          //   ),
          //   //onPressed: onPressed,
          //   child: const Text(
          //     "Try Again",
          //     style: TextStyle(
          //         fontFamily: 'Poppins',
          //         fontWeight: FontWeight.w400,
          //         color: Colors.black),
          //   ),
          // )
        ],
      ),
    );
  }
}
