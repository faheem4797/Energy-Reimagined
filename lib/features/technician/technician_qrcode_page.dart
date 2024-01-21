import 'package:energy_reimagined/constants/colors.dart';
import 'package:energy_reimagined/features/technician/blocs/technician_jobs_stream_bloc/technician_jobs_stream_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobs_repository/jobs_repository.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TechnicianQRCodePage extends StatelessWidget {
  final JobModel jobModel;
  const TechnicianQRCodePage({required this.jobModel, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<TechnicianJobsStreamBloc, TechnicianJobsStreamState>(
      listener: (context, state) {
        if (state.jobStream != null) {
          final updatedModel = state.jobStream!
              .firstWhere((element) => element.id == jobModel.id);
          if (updatedModel.currentToolsRequestQrCode == '') {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  duration: Duration(seconds: 2),
                  content: Text('Tools Delivered Successfully.'),
                ),
              );
            Future.delayed(const Duration(seconds: 2), () {
              Navigator.of(context).pop();
            });
          }
        }
      },
      child: Scaffold(
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
              data: jobModel.currentToolsRequestQrCode,
              version: QrVersions.auto,
              size: 200.r,
            ),
          ),
        ),
      ),
    );
  }
}
