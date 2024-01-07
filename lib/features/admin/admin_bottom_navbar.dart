import 'package:energy_reimagined/constants/colors.dart';
import 'package:energy_reimagined/constants/helper_functions.dart';
import 'package:energy_reimagined/features/admin/blocs/admin_nav_bloc/admin_nav_bloc.dart';
import 'package:energy_reimagined/features/admin/tools/screens/admin_tool_page.dart';
import 'package:energy_reimagined/features/admin/users/screens/admin_user_page.dart';
import 'package:energy_reimagined/features/authentication/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:energy_reimagined/widgets/pop_scoop_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<BottomNavigationBarItem> bottomNavItems = const <BottomNavigationBarItem>[
  BottomNavigationBarItem(
    icon: Icon(Icons.person),
    label: 'Users',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.handyman),
    label: 'Tools',
  ),
];

List<Widget> bottomNavScreen = <Widget>[
  const AdminUserPage(),
  const AdminToolPage(),
];

class AdminBottomNavBar extends StatelessWidget {
  const AdminBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminNavBloc, AdminNavState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              'Admin Dashboard',
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
              context.read<AdminNavBloc>().add(TabChange(tabIndex: index));
            },
          ),
        );
      },
    );
  }
}
