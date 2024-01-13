// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_app/widgets/widgets.dart';

import '../main.dart';
// import '../models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  User? currentUser = FirebaseAuth.instance.currentUser;
  String? name, email;
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        getData(user.uid);
      }
    });
  }

  void getData(String userId) {
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('users').doc(userId);
    docRef.get().then((docSnapshot) {
      if (docSnapshot.exists) {
        Map<String, dynamic>? data =
            docSnapshot.data() as Map<String, dynamic>?;
        setState(() {
          name = data?['name'];
          email = data?['email'];
        });
      } else {
        return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    changePassword(
        {required email, required oldPassword, required newPassword}) async {
      var cred =
          EmailAuthProvider.credential(email: email, password: oldPassword);
      await currentUser!.reauthenticateWithCredential(cred).then((value) {
        currentUser!.updatePassword(newPassword);
        CherryToast.success(
                title: const Text("Change password successfully",
                    style: TextStyle(color: Colors.black)),
                animationDuration: const Duration(milliseconds: 1000),
                autoDismiss: true)
            .show(context);
      }).catchError((error) {
        CherryToast.error(
                title: Text(error.message.toString(),
                    style: const TextStyle(color: Colors.black)),
                animationDuration: const Duration(milliseconds: 1000),
                autoDismiss: true)
            .show(context);
      });
    }

    return Scaffold(
      bottomNavigationBar: const CustomNavBar(),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 3,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(35),
                          bottomRight: Radius.circular(35)),
                      color: Colors.blue,
                      gradient: LinearGradient(
                          colors: [
                            Colors.deepPurple.shade800.withOpacity(0.8),
                            Colors.deepPurple.shade200.withOpacity(0.8)
                          ],
                          begin: const FractionalOffset(0.0, 0.0),
                          end: const FractionalOffset(1.0, 0.0),
                          stops: const [0.0, 1.0],
                          tileMode: TileMode.clamp)),
                ),
                const Positioned(
                    bottom: -50.0,
                    child: InkWell(
                      child: CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 75,
                          backgroundColor: Colors.white,
                          backgroundImage:
                              AssetImage("assets/images/bgmk.jpg"),
                        ),
                      ),
                    ))
              ]),
          const SizedBox(
            height: 55,
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Column(
                children: [
                  Card(
                    elevation: 4,
                    child: ListTile(
                      leading: const Icon(Icons.person, color: Colors.brown),
                      title: Text(
                        "$name",
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  Card(
                    elevation: 4,
                    child: ListTile(
                      leading: const Icon(Icons.email, color: Colors.purple),
                      title: Text(
                        "$email",
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showGeneralDialog(
                          context: context,
                          barrierLabel: "Barrier",
                          barrierDismissible: true,
                          barrierColor: Colors.black.withOpacity(0.5),
                          transitionDuration: const Duration(milliseconds: 700),
                          pageBuilder: (_, __, ___) {
                            return Center(
                                child: SizedBox(
                              height: 350,
                              child: Card(
                                margin: const EdgeInsets.all(20),
                                elevation: 3,
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextFormField(
                                        style: const TextStyle(
                                          color: Colors
                                              .black, // set the color of the text
                                        ),
                                        controller: oldPasswordController,
                                        decoration: const InputDecoration(
                                            prefixIcon: Icon(
                                                Icons.person_outline_outlined),
                                            labelText: "Old Password",
                                            hintText: "Old Password",
                                            border: OutlineInputBorder()),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      TextFormField(
                                        style: const TextStyle(
                                          color: Colors
                                              .black, // set the color of the text
                                        ),
                                        controller: newPasswordController,
                                        decoration: const InputDecoration(
                                            prefixIcon: Icon(
                                                Icons.person_outline_outlined),
                                            labelText: "New Password",
                                            hintText: "New Password",
                                            border: OutlineInputBorder()),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          FloatingActionButton.extended(
                                            label: Row(
                                              children: const [
                                                Text("Close"),
                                                Icon(Icons.close),
                                              ],
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            extendedTextStyle: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500),
                                            backgroundColor: Colors.green,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          FloatingActionButton.extended(
                                            label: Row(
                                              children: const [
                                                Text("Confirm"),
                                                Icon(Icons.check),
                                              ],
                                            ),
                                            onPressed: () async {
                                              await changePassword(
                                                email: email,
                                                oldPassword:
                                                    oldPasswordController.text,
                                                newPassword:
                                                    newPasswordController.text,
                                              );
                                            },
                                            extendedTextStyle: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ));
                          });
                    },
                    child: const Card(
                      elevation: 4,
                      child: ListTile(
                        leading: Icon(Icons.lock, color: Colors.blue),
                        title: Text(
                          "Change Passowrd",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  Card(
                    elevation: 4,
                    child: ListTile(
                      leading: const Icon(Icons.logout, color: Colors.red),
                      title: const Text(
                        "Log-out",
                        style: TextStyle(color: Colors.black),
                      ),
                      onTap: signOut,
                    ),
                  ),
                  // ElevatedButton(onPressed: getData, child: Text("abcd"))
                ],
              ),
            ),
          )
        ],
      )),
    );
  }

  Future signOut() async {
    await auth.signOut();
    navigatorKey.currentState?.pushNamed('/login');
  }
}
