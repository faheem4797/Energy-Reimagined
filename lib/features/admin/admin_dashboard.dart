// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, prefer_interpolation_to_compose_strings, duplicate_ignore

import 'package:energy_reimagined/constants/colors.dart';
import 'package:energy_reimagined/features/authentication/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:energy_reimagined/widgets/pop_scoop_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;

  @override
  void initState() {
    super.initState();
    _checkCurrentUser();
  }

  Future<void> _checkCurrentUser() async {
    User? user = _auth.currentUser;
    if (user == null) {
      // Handle no authenticated user
      //print("No authenticated user.");
    } else {
      setState(() {
        _user = user;
      });
    }
  }

  void _updateUser(String userId, String firstName, String lastName,
      String empNumber, String email, String role) {
    try {
      // Get the current timestamp
      DateTime now = DateTime.now();
      Timestamp updatedAt = Timestamp.fromDate(now);

      // Update user details in Firestore
      _firestore.collection('users').doc(userId).update({
        'firstName': firstName,
        'lastName': lastName,
        'employeeNumber': empNumber,
        'role': role,
        'UpdatedAt': updatedAt
      });

      // Show success SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'User updated successfully!',
            style:
                TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w400),
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      // Show error SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error updating user: $e',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
          backgroundColor: Colors.redAccent,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      );
    }
  }

  Future<void> _createUser(String firstName, String lastName, String empNumber,
      String email, String password, String role) async {
    // ignore: duplicate_ignore
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the current timestamp
      DateTime now = DateTime.now();
      Timestamp createdAt = Timestamp.fromDate(now);

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'employeeNumber': empNumber,
        'email': email,
        'role': role,
        'password': password,
        'isRestricted': false,
        'createdAt': createdAt,
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'User created successfully!',
            style:
                TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w400),
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      );
      // After creating the user, refresh the user list
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      _checkCurrentUser();
    } catch (e) {
      //print("Error creating user: $e");
      // Show error Snackbar
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error creating user: $e',
            style: const TextStyle(
                fontFamily: 'Poppins', fontWeight: FontWeight.w400),
          ),
          backgroundColor: Colors.redAccent,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      );
    }
  }

  Stream<QuerySnapshot> getUsersStream() {
    return _firestore
        .collection('users')
        // .where('role', isNotEqualTo: 'admin')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
          ),
        ),
        backgroundColor: ConstColors.backgroundDarkColor,
        actions: <Widget>[
          if (_user != null)
            IconButton(
              icon: const Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              onPressed: () async {
                var logout = await WillPopScoopService()
                    .showLogoutConfirmationDialog(context);
                if (logout) {
                  context
                      .read<AuthenticationBloc>()
                      .add(const AuthenticationLogoutRequested());
                  // await _auth.signOut();
                  // setState(() {
                  //   _user = null;
                  // });
                  // FirebaseAuth.instance.authStateChanges().listen((User? user) {
                  //   if (user == null) {
                  //     // User is signed out, perform necessary actions (e.g., navigation)
                  //     Navigator.pushAndRemoveUntil(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) =>
                  //               const SignIn()), // Redirect to sign-in page
                  //       (route) => false,
                  //     );
                  //   }
                  // });
                }

                // Navigator.pushAndRemoveUntil(
                //     context,
                //     MaterialPageRoute(builder: (context) => const SignIn()),
                //     (route) => false);
              },
            ),
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          return await WillPopScoopService()
              .showCloseConfirmationDialog(context);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (_user == null)
                  const Text("You are not logged in as an admin.")
                else
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: StreamBuilder(
                      stream: getUsersStream(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: SizedBox(
                                  height: 200,
                                  width: 200,
                                  child: CircularProgressIndicator()));
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          final users = snapshot.data!.docs;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Users List",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                ConstColors.foregroundColor),
                                        padding: MaterialStateProperty.all<
                                            EdgeInsetsGeometry>(
                                          const EdgeInsets.symmetric(
                                              horizontal: 14, vertical: 10),
                                        ),
                                        // To change the shape of the button:
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CreateUserScreen(
                                              createUser: _createUser,
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        "Create User",
                                        style: TextStyle(
                                            fontFamily: 'Poppins',
                                            color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: users.length,
                                  itemBuilder: (context, index) {
                                    final bool isRestricted =
                                        users[index]['isRestricted'] == true;

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
                                                        text: users[index]
                                                                ['firstName'] +
                                                            " " +
                                                            users[index]
                                                                ['lastName'],
                                                        style: const TextStyle(
                                                          fontFamily: 'Poppins',
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            '${'  [' + users[index]['role']}]',
                                                        style: const TextStyle(
                                                          fontFamily: 'Poppins',
                                                          color: ConstColors
                                                              .whiteColor,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                subtitle: Text(
                                                  users[index]['email'],
                                                  style: const TextStyle(
                                                    fontFamily: 'Poppins',
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                trailing: IconButton(
                                                  icon: const Icon(Icons.edit),
                                                  color: Colors.white,
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            EditUserScreen(
                                                          userId:
                                                              users[index].id,
                                                          firstName:
                                                              users[index]
                                                                  ['firstName'],
                                                          lastName: users[index]
                                                              ['lastName'],
                                                          empNumber: users[
                                                                  index][
                                                              'employeeNumber'],
                                                          email: users[index]
                                                              ['email'],
                                                          role: users[index]
                                                              ['role'],
                                                          isRestricted: users[
                                                                  index]
                                                              ['isRestricted'],
                                                          updateUser:
                                                              _updateUser,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ))),
                                        if (isRestricted)
                                          Positioned(
                                            top: 0,
                                            left: 0,
                                            right: 0,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: const Banner(
                                                message: 'Restricted',
                                                location: BannerLocation.topEnd,
                                                color: Color(0xFF8B0000),
                                                textStyle: TextStyle(
                                                  color: Colors
                                                      .white, // Change text color
                                                  fontSize:
                                                      12, // Change text size
                                                  fontWeight: FontWeight
                                                      .bold, // Change text weight
                                                  fontFamily:
                                                      'Poppins', // Change text font family
                                                  // Add more text style properties as needed
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
                          );
                        }
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CreateUserScreen extends StatefulWidget {
  final Function(String, String, String, String, String, String) createUser;

  const CreateUserScreen({super.key, required this.createUser});

  @override
  _CreateUserScreenState createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _employeeNumberController =
      TextEditingController();
  final GlobalKey<FormState> _createuserformKey = GlobalKey<FormState>();
  String _selectedRole = "technician";
  bool _obscureText = true;
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, // Change the color to your desired color
        ),
        centerTitle: true,
        title: const Text(
          'Create User',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
          ),
        ),
        backgroundColor: ConstColors.backgroundDarkColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _createuserformKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    controller: _firstNameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter the first name";
                      }
                      return null;
                    },
                    //autofocus: true,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black54, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black38, width: 2.0),
                        ),
                        labelText: "First Name",
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins',
                        )),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    controller: _lastNameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter the last name";
                      }
                      return null;
                    },
                    //autofocus: true,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black54, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black38, width: 2.0),
                        ),
                        labelText: "Last Name",
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins',
                        )),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    controller: _employeeNumberController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter the employee number";
                      }
                      return null;
                    },
                    //autofocus: true,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black54, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black38, width: 2.0),
                        ),
                        labelText: "Employee Number",
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins',
                        )),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    controller: _emailController,
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return "Enter a valid email";
                      }
                      return null;
                    },
                    //autofocus: true,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black54, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black38, width: 2.0),
                        ),
                        labelText: "Email",
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins',
                        )),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    controller: _passwordController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Password must not be empty';
                      } else if (value.length < 8) {
                        return 'Password must be at least 8 characters';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.done,
                    obscureText: _obscureText,
                    //autofocus: true,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(8),
                    ],
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(_obscureText
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            _toggle();
                          },
                        ),
                        border: const OutlineInputBorder(),
                        focusedBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black54, width: 2.0),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black38, width: 2.0),
                        ),
                        labelText: "Password",
                        labelStyle: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins',
                        )),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ListTile(
                  title: const Text('Role',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Poppins',
                      )),
                  subtitle: Column(
                    children: <Widget>[
                      RadioListTile<String>(
                        title: const Text(
                          'Admin',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                          ),
                        ),
                        value: 'admin',
                        groupValue: _selectedRole,
                        onChanged: (value) {
                          setState(() {
                            _selectedRole = value!;
                          });
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text(
                          'Technician',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                          ),
                        ),
                        value: 'technician',
                        groupValue: _selectedRole,
                        onChanged: (value) {
                          setState(() {
                            _selectedRole = value!;
                          });
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text(
                          'Manager',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                          ),
                        ),
                        value: 'manager',
                        groupValue: _selectedRole,
                        onChanged: (value) {
                          setState(() {
                            _selectedRole = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
                Center(
                  child: ElevatedButton(
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
                      if (_createuserformKey.currentState!.validate()) {
                        // If the form is valid, proceed with user creation
                        widget.createUser(
                          _firstNameController.text.trim(),
                          _lastNameController.text.trim(),
                          _employeeNumberController.text.trim(),
                          _emailController.text.trim(),
                          _passwordController.text.trim(),
                          _selectedRole,
                        );
                      }
                    },
                    child: const Text(
                      "Create User",
                      style:
                          TextStyle(fontFamily: 'Poppins', color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EditUserScreen extends StatefulWidget {
  final String userId;
  final String firstName;
  final String lastName;
  final String empNumber;
  final String email;
  final String role;
  final bool isRestricted;
  final Function(String, String, String, String, String, String) updateUser;

  const EditUserScreen({
    Key? key,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.empNumber,
    required this.email,
    required this.role,
    required this.isRestricted,
    required this.updateUser,
  }) : super(key: key);

  @override
  _EditUserScreenState createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _employeeNumberController;
  late TextEditingController _emailController;
  final GlobalKey<FormState> _updateuserformKey = GlobalKey<FormState>();
  late String _selectedRole;
  late bool _isUserRestricted;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.firstName);
    _lastNameController = TextEditingController(text: widget.lastName);
    _employeeNumberController = TextEditingController(text: widget.empNumber);
    _emailController = TextEditingController(text: widget.email);
    _selectedRole = widget.role;
    _isUserRestricted = widget.isRestricted;
  }

  // Assume you have a function to update the isRestricted field in Firestore
  Future<void> updateUserRestriction(
      String userId, bool isRestricted, BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'isRestricted': isRestricted});

      final message = isRestricted ? 'User restricted' : 'User unrestricted';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print("Error updating user restriction: $e");
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error updating user restriction: $e',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
          backgroundColor: Colors.redAccent,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, // Change the color to your desired color
        ),
        centerTitle: true,
        title: const Text(
          'Edit User',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
          ),
        ),
        backgroundColor: ConstColors.backgroundDarkColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _updateuserformKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      _isUserRestricted ? 'Unrestrict User' : 'Restrict User',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Switch(
                      value: _isUserRestricted,
                      onChanged: (value) async {
                        _isUserRestricted = value;
                        await updateUserRestriction(
                            widget.userId, value, context);
                        setState(() {
                          _isUserRestricted = value;
                        });
                      },
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    // Expanded(
                    //   child: ElevatedButton(
                    //       onPressed: () {
                    //         showDialog(
                    //           context: context,
                    //           builder: (BuildContext context) {
                    //             return AlertDialog(
                    //               title: const Text('Confirm Deletion'),
                    //               content: const Text(
                    //                   'Are you sure you want to delete this user?'),
                    //               actions: <Widget>[
                    //                 TextButton(
                    //                   onPressed: () {
                    //                     Navigator.of(context)
                    //                         .pop(); // Close dialog
                    //                   },
                    //                   child: const Text('Cancel'),
                    //                 ),
                    //                 TextButton(
                    //                   onPressed: () async {
                    //                     // await deleteUserData(widget
                    //                     //     .userId); // Call delete function
                    //                     Navigator.of(context)
                    //                         .pop(); // Close dialog
                    //                   },
                    //                   child: const Text('Delete'),
                    //                 ),
                    //               ],
                    //             );
                    //           },
                    //         );
                    //         ;
                    //       },
                    //       style: ButtonStyle(
                    //         backgroundColor: MaterialStateProperty.all<Color>(
                    //             ConstColors.forgroundColor),
                    //         padding:
                    //             MaterialStateProperty.all<EdgeInsetsGeometry>(
                    //           const EdgeInsets.symmetric(
                    //               horizontal: 14, vertical: 10),
                    //         ),
                    //         // To change the shape of the button:
                    //         shape: MaterialStateProperty.all<
                    //             RoundedRectangleBorder>(
                    //           RoundedRectangleBorder(
                    //             borderRadius: BorderRadius.circular(8.0),
                    //           ),
                    //         ),
                    //       ),
                    //       child: const Text('Delete User Account',
                    //           textAlign: TextAlign.center,
                    //           style: TextStyle(
                    //               fontFamily: 'Poppins', color: Colors.white))),
                    // ),
                  ],
                ),
                const SizedBox(
                  height: 18,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    controller: _firstNameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter the first name";
                      }
                      return null;
                    },
                    //autofocus: true,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black54, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black38, width: 2.0),
                        ),
                        labelText: "First Name",
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins',
                        )),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    controller: _lastNameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter the last name";
                      }
                      return null;
                    },
                    //autofocus: true,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black54, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black38, width: 2.0),
                        ),
                        labelText: "Last Name",
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins',
                        )),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    controller: _employeeNumberController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter the employee number";
                      }
                      return null;
                    },
                    //autofocus: true,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black54, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black38, width: 2.0),
                        ),
                        labelText: "Employee Number",
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins',
                        )),
                  ),
                ),
                // SizedBox(
                //   width: MediaQuery.of(context).size.width,
                //   child: TextFormField(
                //     controller: _emailController,
                //     validator: (value) {
                //       if (value!.isEmpty || !value.contains('@')) {
                //         return "Enter a valid email";
                //       }
                //       return null;
                //     },
                //     //autofocus: true,
                //     textInputAction: TextInputAction.next,
                //     keyboardType: TextInputType.emailAddress,
                //     decoration: const InputDecoration(
                //         border: OutlineInputBorder(),
                //         focusedBorder: OutlineInputBorder(
                //           borderSide:
                //               BorderSide(color: Colors.black54, width: 2.0),
                //         ),
                //         enabledBorder: OutlineInputBorder(
                //           borderSide:
                //               BorderSide(color: Colors.black38, width: 2.0),
                //         ),
                //         labelText: "Email",
                //         labelStyle: TextStyle(
                //           color: Colors.black,
                //           fontFamily: 'Poppins',
                //         )),
                //   ),
                // ),
                // const SizedBox(
                //   height: 10,
                // ),
                ListTile(
                  title: const Text('Role',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Poppins',
                      )),
                  subtitle: Column(
                    children: <Widget>[
                      RadioListTile<String>(
                        title: const Text(
                          'Admin',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                          ),
                        ),
                        value: 'admin',
                        groupValue: _selectedRole,
                        onChanged: (value) {
                          setState(() {
                            _selectedRole = value!;
                          });
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text(
                          'Technician',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                          ),
                        ),
                        value: 'technician',
                        groupValue: _selectedRole,
                        onChanged: (value) {
                          setState(() {
                            _selectedRole = value!;
                          });
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text(
                          'Manager',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                          ),
                        ),
                        value: 'manager',
                        groupValue: _selectedRole,
                        onChanged: (value) {
                          setState(() {
                            _selectedRole = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: ElevatedButton(
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
                      if (_updateuserformKey.currentState!.validate()) {
                        // If the form is valid, proceed with user creation
                        widget.updateUser(
                            widget.userId,
                            _firstNameController.text.trim(),
                            _lastNameController.text.trim(),
                            _employeeNumberController.text.trim(),
                            _emailController.text.trim(),
                            _selectedRole);
                      }
                    },
                    child: const Text(
                      "Update User",
                      style:
                          TextStyle(fontFamily: 'Poppins', color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
