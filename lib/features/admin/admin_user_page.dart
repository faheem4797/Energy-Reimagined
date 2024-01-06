import 'package:energy_reimagined/constants/colors.dart';
import 'package:energy_reimagined/features/admin/blocs/users_stream_bloc/users_stream_bloc.dart';
import 'package:energy_reimagined/widgets/pop_scoop_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminUserPage extends StatelessWidget {
  AdminUserPage({super.key});
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getUsersStream() {
    return _firestore
        .collection('users')
        // .where('role', isNotEqualTo: 'admin')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final usersStream = context.watch<UsersStreamBloc>().state;

    return WillPopScope(
      onWillPop: () async {
        return await WillPopScoopService().showCloseConfirmationDialog(context);
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Users List",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          ConstColors.foregroundColor),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                      ),
                      // To change the shape of the button:
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => CreateUserScreen(
                      //       createUser: _createUser,
                      //     ),
                      //   ),
                      // );
                    },
                    child: const Text(
                      "Create User",
                      style: TextStyle(color: ConstColors.blackColor),
                    ),
                  ),
                ],
              ),
            ),
            usersStream.status == UsersStreamStatus.loading
                ? const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : usersStream.status == UsersStreamStatus.failure
                    ? const Expanded(
                        child: Center(
                          child: Text("Error Loading Stream"),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: usersStream.userStream?.length,
                          itemBuilder: (context, index) {
                            final users = usersStream.userStream!;
                            final bool isRestricted =
                                users[index].isRestricted == true;

                            return Stack(
                              children: [
                                Card(
                                    color: ConstColors.backgroundColor,
                                    elevation: 4,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 8),
                                    child: ListTile(
                                        title: RichText(
                                          text: TextSpan(
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                            children: [
                                              TextSpan(
                                                text:
                                                    "${users[index].firstName} ${users[index].lastName}",
                                                style: const TextStyle(
                                                  color: ConstColors.whiteColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    '${'  [${users[index].role}'}]',
                                                style: const TextStyle(
                                                  color: ConstColors.whiteColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        subtitle: Text(
                                          users[index].email,
                                          style: const TextStyle(
                                            color: ConstColors.whiteColor,
                                          ),
                                        ),
                                        trailing: IconButton(
                                          icon: const Icon(Icons.edit),
                                          color: ConstColors.whiteColor,
                                          onPressed: () {
                                            // Navigator.push(
                                            //   context,
                                            //   MaterialPageRoute(
                                            //     builder: (context) => EditUserScreen(
                                            //       userId: users[index].id,
                                            //       firstName: users[index]['firstName'],
                                            //       lastName: users[index]['lastName'],
                                            //       empNumber: users[index]
                                            //           ['employeeNumber'],
                                            //       email: users[index]['email'],
                                            //       role: users[index]['role'],
                                            //       isRestricted: users[index]
                                            //           ['isRestricted'],
                                            //       updateUser: _updateUser,
                                            //     ),
                                            //   ),
                                            // );
                                          },
                                        ))),
                                if (isRestricted)
                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      child: const Banner(
                                        message: 'Restricted',
                                        location: BannerLocation.topEnd,
                                        color: ConstColors.redColor,
                                        textStyle: TextStyle(
                                          color: ConstColors.whiteColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
