import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chattingapp/api/apis.dart';
import 'package:chattingapp/helper/dialogs.dart';
import 'package:chattingapp/screens/auth/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import '../main.dart';
import '../models/chat_user.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _image;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile Screen'),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(10),
          child: FloatingActionButton.extended(
            onPressed: () async {
              Dialogs.showProgressBar(context);
              await APIs.auth.signOut().then(
                (value) async {
                  await GoogleSignIn().signOut().then(
                        (value) => {
                          Navigator.pop(context),
                          Navigator.pop(context),
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                          ),
                        },
                      );
                },
              );
            },
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Log Out'),
            backgroundColor: Colors.redAccent,
          ),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: mq.width,
                    height: mq.height * .03,
                  ),
                  Stack(
                    children: [
                      _image != null
                          ? ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(mq.height * .1),
                              child: Image.file(
                                File(_image!),
                                height: mq.height * .2,
                                width: mq.height * .2,
                                fit: BoxFit.cover,
                              ),
                            )
                          : ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(mq.height * .1),
                              child: CachedNetworkImage(
                                height: mq.height * .2,
                                width: mq.height * .2,
                                fit: BoxFit.cover,
                                imageUrl: widget.user.image,
                                errorWidget: (context, url, error) =>
                                    const CircleAvatar(
                                  child: Icon(CupertinoIcons.person),
                                ),
                              ),
                            ),
                      Positioned(
                        bottom: -1,
                        right: -5,
                        child: MaterialButton(
                          elevation: 1,
                          onPressed: () {
                            _showBottomSheet();
                          },
                          color: Colors.white,
                          shape: const CircleBorder(),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: mq.height * .03,
                  ),
                  Text(
                    widget.user.email,
                    style: const TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                  SizedBox(
                    height: mq.height * .05,
                  ),
                  TextFormField(
                    onSaved: (val) => APIs.me.name = val ?? '',
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : 'Required',
                    initialValue: widget.user.name,
                    decoration: InputDecoration(
                      hintText: "eg: Shaquib nawaz",
                      prefixIcon: const Icon(
                        CupertinoIcons.person,
                        color: Colors.blue,
                      ),
                      labelText: "Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: mq.height * .02,
                  ),
                  TextFormField(
                    onSaved: (val) => APIs.me.about = val ?? '',
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : 'Required',
                    initialValue: widget.user.about,
                    decoration: InputDecoration(
                      hintText: "eg: Feeling Happy",
                      prefixIcon: const Icon(
                        CupertinoIcons.info,
                        color: Colors.blue,
                      ),
                      labelText: "About",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: mq.height * .05,
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      minimumSize: Size(mq.width * .5, mq.height * .06),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        APIs.updateUserInfo().then(
                          (value) => Dialogs.showSnackBar(
                              context, 'Profile Updated Successfully'),
                        );
                        print('inside it');
                      }
                    },
                    icon: const Icon(
                      Icons.edit,
                      size: 28,
                    ),
                    label: const Text(
                      "Update",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
        ),
        context: context,
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding:
                EdgeInsets.only(top: mq.height * .03, bottom: mq.height * .05),
            children: [
              const Text(
                'Pick Profile Picture',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: const CircleBorder(),
                      fixedSize: Size(mq.width * .03, mq.height * .15),
                    ),
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        setState(() {
                          _image = image.path;
                        });
                        APIs.updateProfilePic(File(_image!));
                        Navigator.pop(context);
                      }
                    },
                    child: const Image(
                      image: AssetImage('images/add_image.png'),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: const CircleBorder(),
                      fixedSize: Size(mq.width * .03, mq.height * .15),
                    ),
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image =
                          await picker.pickImage(source: ImageSource.camera);
                      if (image != null) {
                        setState(() {
                          _image = image.path;
                        });
                        APIs.updateProfilePic(File(_image!));
                        Navigator.pop(context);
                      }
                    },
                    child: const Image(
                      image: AssetImage('images/camera.png'),
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }
}
