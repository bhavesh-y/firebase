import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddData extends StatefulWidget {
  const AddData({super.key});

  @override
  State<AddData> createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();
  addData(String title, String desc) async {
    if (title == "" && desc == "") {
      log("enter data");
    } else {
      FirebaseFirestore.instance
          .collection("user")
          .doc(title)
          .set({"title": title, "description": desc})
          .then((value) {
            log("data inserted");
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Data'), centerTitle: true),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: TextField(
              controller: titlecontroller,
              decoration: InputDecoration(
                hintText: 'Enter Title',
                suffixIcon: Icon(Icons.title),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: TextField(
              controller: descriptioncontroller,
              decoration: InputDecoration(
                hintText: 'Enter description',
                suffixIcon: Icon(Icons.description),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              addData(
                titlecontroller.text.toString(),
                descriptioncontroller.text.toString(),
              );
            },
            child: Text('Add Data'),
          ),
        ],
      ),
    );
  }
}
