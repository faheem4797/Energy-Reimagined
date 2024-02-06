import 'package:energy_reimagined/constants/colors.dart';
import 'package:energy_reimagined/constants/helper_functions.dart';
import 'package:energy_reimagined/features/authentication/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:energy_reimagined/features/manager/blocs/manager_nav_bloc/manager_nav_bloc.dart';
import 'package:energy_reimagined/features/manager/escalation_screen.dart';
import 'package:energy_reimagined/widgets/pop_scoop_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<BottomNavigationBarItem> bottomNavItems = const <BottomNavigationBarItem>[
  BottomNavigationBarItem(
    icon: Icon(Icons.assessment),
    label: 'Report',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.timer),
    label: 'Escalations',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.handyman),
    label: 'Tools',
  ),
];

List<Widget> bottomNavScreen = <Widget>[
  const Placeholder(),
  const EscalationsScreen(),
  const Placeholder(),
];

class ManagerDashbaord extends StatefulWidget {
  const ManagerDashbaord({super.key});

  @override
  State<ManagerDashbaord> createState() => _ManagerDashbaordState();
}

class _ManagerDashbaordState extends State<ManagerDashbaord> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ManagerNavBloc, ManagerNavState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              'Manager Dashboard',
              style: TextStyle(
                color: ConstColors.whiteColor,
              ),
            ),
            backgroundColor: ConstColors.backgroundDarkColor,
            actions: <Widget>[
              IconButton(
                icon: const Icon(
                  Icons.exit_to_app,
                  color: ConstColors.whiteColor,
                ),
                onPressed: () async {
                  var logout = await WillPopScoopService()
                      .showLogoutConfirmationDialog(context);
                  if (logout) {
                    if (!context.mounted) return;
                    checkConnectionFunc(context, () {
                      context
                          .read<AuthenticationBloc>()
                          .add(const AuthenticationLogoutRequested());
                    });
                  }
                },
              ),
            ],
          ),
          body: Center(child: bottomNavScreen.elementAt(state.tabIndex)),
          bottomNavigationBar: BottomNavigationBar(
            items: bottomNavItems,
            currentIndex: state.tabIndex,
            selectedItemColor: ConstColors.backgroundDarkColor,
            unselectedItemColor: Colors.grey,
            onTap: (index) {
              context.read<ManagerNavBloc>().add(TabChange(tabIndex: index));
            },
          ),
        );
      },
    );

    // return Scaffold(
    //   appBar: AppBar(
    //     centerTitle: true,
    //     title: const Text(
    //       'Manager Screen',
    //       style: TextStyle(
    //         color: ConstColors.whiteColor,
    //       ),
    //     ),
    //     backgroundColor: ConstColors.backgroundDarkColor,
    //     actions: <Widget>[
    //       //if (_user != null)
    //       IconButton(
    //         icon: const Icon(
    //           Icons.exit_to_app,
    //           color: ConstColors.whiteColor,
    //         ),
    //         onPressed: () async {
    //           var logout = await WillPopScoopService()
    //               .showLogoutConfirmationDialog(context);
    //           if (logout) {
    //             if (!mounted) return;
    //             checkConnectionFunc(context, () {
    //               context
    //                   .read<AuthenticationBloc>()
    //                   .add(const AuthenticationLogoutRequested());
    //             });
    //           }
    //         },
    //       ),
    //     ],
    //   ),
    //   body: WillPopScope(
    //     onWillPop: () async {
    //       return await WillPopScoopService()
    //           .showCloseConfirmationDialog(context);
    //     },
    //     child: const Center(
    //       child: Text(
    //         'Welcome, Manager this is underdevelopment.',
    //         style: TextStyle(
    //           color: ConstColors.blackColor,
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
