import 'package:energy_reimagined/constants/colors.dart';
import 'package:energy_reimagined/constants/helper_functions.dart';
import 'package:energy_reimagined/features/admin/jobs/blocs/qr_code_scanner_bloc/qr_code_scanner_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class AdminQRCodeScannerPage extends StatefulWidget {
  const AdminQRCodeScannerPage({super.key});

  @override
  State<AdminQRCodeScannerPage> createState() => _AdminQRCodeScannerPageState();
}

class _AdminQRCodeScannerPageState extends State<AdminQRCodeScannerPage> {
  final MobileScannerController cameraController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: ConstColors.whiteColor,
        ),
        centerTitle: true,
        title: const Text(
          'QR CODE Scanner',
          style: TextStyle(
            color: ConstColors.whiteColor,
          ),
        ),
        backgroundColor: ConstColors.backgroundDarkColor,
      ),
      body: BlocConsumer<QrCodeScannerBloc, QrCodeScannerState>(
        listener: (context, state) {
          if (state is QrCodeScannerFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                ),
              );
          } else if (state is QrCodeScannerSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  duration: Duration(seconds: 2),
                  content: Text('Tools Delivered Successfully.'),
                ),
              );
            Future.delayed(const Duration(seconds: 2), () {
              Navigator.of(context)
                ..pop()
                ..pop();
            });
          }
        },
        builder: (context, state) {
          return state is QrCodeScannerLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  color: ConstColors.greyColor,
                  child: MobileScanner(
                    fit: BoxFit.contain,
                    // scanWindow: Rect.fromCenter(
                    //   center: MediaQuery.of(context).size.center(Offset.zero),
                    //   width: 200,
                    //   height: 200,
                    // ),
                    onDetect: (capture) {
                      checkConnectionFunc(context, () {
                        context.read<QrCodeScannerBloc>().add(BarCodeDetected(
                              capture: capture,
                            ));
                      });
                    },
                    controller: cameraController,
                  ),
                );
        },
      ),
    );
  }
}
