import 'package:energy_reimagined/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TechnicianQRCodePage extends StatelessWidget {
  final String qrCodeText;
  const TechnicianQRCodePage({required this.qrCodeText, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'QR CODE',
          style: TextStyle(
            color: ConstColors.whiteColor,
          ),
        ),
        backgroundColor: ConstColors.backgroundDarkColor,
        iconTheme: const IconThemeData(
          color: ConstColors.whiteColor,
        ),
      ),
      body: Container(
        color: ConstColors.whiteColor,
        child: Center(
          child: QrImageView(
            data: qrCodeText,
            version: QrVersions.auto,
            size: 200.r,
          ),
        ),
      ),
    );
  }
}
