import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'uihelper.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  File? pickedImage;

  Future<void> signUp(String email, String password) async {
    if (email.isEmpty || password.isEmpty || pickedImage == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Please fill all fields"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await uploadData();

      log("User Created: ${userCredential.user!.uid}");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Account Created Successfully"),
        ),
      );

      emailController.clear();
      passwordController.clear();

      setState(() {
        pickedImage = null;
      });
    } on FirebaseAuthException catch (e) {
      log(e.code);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? e.code),
        ),
      );
    } catch (e) {
      log(e.toString());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  Future<void> uploadData() async {
    try {
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child("profile_pics")
          .child("${emailController.text.trim()}.jpg");

      UploadTask uploadTask = storageRef.putFile(pickedImage!);

      TaskSnapshot snapshot = await uploadTask;

      String imageUrl = await snapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection("users")
          .doc(emailController.text.trim())
          .set({
        "email": emailController.text.trim(),
        "image": imageUrl,
      });

      log("User data saved successfully");
    } catch (e) {
      log("Upload Error: $e");
      rethrow;
    }
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final photo = await ImagePicker().pickImage(source: source);

      if (photo == null) return;

      setState(() {
        pickedImage = File(photo.path);
      });
    } catch (e) {
      log(e.toString());
    }
  }

  void showAlertBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Pick Image From"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Camera"),
              onTap: () {
                Navigator.pop(context);
                pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text("Gallery"),
              onTap: () {
                Navigator.pop(context);
                pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up Page"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            InkWell(
              onTap: showAlertBox,
              child: pickedImage != null
                  ? CircleAvatar(
                radius: 80,
                backgroundImage: FileImage(pickedImage!),
              )
                  : const CircleAvatar(
                radius: 80,
                child: Icon(
                  Icons.person,
                  size: 80,
                ),
              ),
            ),

            const SizedBox(height: 30),

            Uihelper.CustomTextField(
              controller: emailController,
              text: "Email",
              icon: Icons.email,
            ),

            const SizedBox(height: 15),

            Uihelper.CustomTextField(
              controller: passwordController,
              text: "Password",
              icon: Icons.lock,
              obscureText: true,
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  signUp(
                    emailController.text.trim(),
                    passwordController.text.trim(),
                  );
                },
                child: const Text(
                  "Sign Up",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}