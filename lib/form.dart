// ignore_for_file: unnecessary_new, unused_field, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, unused_import, use_key_in_widget_constructors, avoid_print, unused_element

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'main.dart';

class FormPage extends StatefulWidget {
  //constructor have one parameter, optional paramter
  //if have id we will show data and run update method
  //else run add data
  const FormPage({this.id});

  final String? id;

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  //set form key
  final _formKey = GlobalKey<FormState>();

  //set texteditingcontroller variable
  var namaController = TextEditingController();
  var nohpController = TextEditingController();
  var emailController = TextEditingController();
  var alamatController = TextEditingController();

  //inisialize firebase instance
  FirebaseFirestore firebase = FirebaseFirestore.instance;
  CollectionReference? users;

  void getData() async {
    //get users collection from firebase
    //collection is table in mysql
    users = firebase.collection('users');

    //if have id
    if (widget.id != null) {
      //get users data based on id document
      var data = await users!.doc(widget.id).get();

      //we get data.data()
      //so that it can be accessed, we make as a map
      var item = data.data() as Map<String, dynamic>;

      //set state to fill data controller from data firebase
      setState(() {
        namaController = TextEditingController(text: item['nama']);
        nohpController = TextEditingController(text: item['nohp']);
        emailController = TextEditingController(text: item['email']);
        alamatController = TextEditingController(text: item['alamat']);
      });
    }
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Form Kontak"),
          actions: [
            //if have data show delete button
            widget.id != null
                ? IconButton(
                    onPressed: () {
                      //method to delete data based on id
                      users!.doc(widget.id).delete();

                      //back to main page
                      // '/' is home
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/', (Route<dynamic> route) => false);
                    },
                    icon: Icon(Icons.delete))
                : SizedBox()
          ],
        ),
        //this form for add and edit data
        //if have id passed from main, field will show data
        body: Form(
          key: _formKey,
          child: ListView(padding: EdgeInsets.all(16.0), children: [
            SizedBox(
              height: 10,
            ),
            CircleAvatar(
              radius: 30,
              child: Icon(
                Icons.person,
                size: 30,
              ),
            ),
            Text(
              'Nama',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: namaController,
              decoration: InputDecoration(
                  hintText: "Nama",
                  prefixIcon: Icon(Icons.person_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  fillColor: Colors.white,
                  filled: true),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Nama harus diisi!!!';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            Text(
              'No. HP',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: nohpController,
              decoration: InputDecoration(
                  hintText: "No. HP",
                  prefixIcon: Icon(Icons.phone_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  fillColor: Colors.white,
                  filled: true),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'No. HP harus diisi!!!';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            Text(
              'Email',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                  hintText: "Email",
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  fillColor: Colors.white,
                  filled: true),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Email harus diisi!!!';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            Text(
              'Alamat',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: alamatController,
              decoration: InputDecoration(
                  hintText: "Alamat",
                  prefixIcon: Icon(Icons.home_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  fillColor: Colors.white,
                  filled: true),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Alamat harus diisi!!!';
                }
                return null;
              },
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  "Tambah",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  //if id not null run add data to store data into firebase
                  //else update data based on id
                  if (widget.id == null) {
                    users!.add({
                      'nama': namaController.text,
                      'nohp': nohpController.text,
                      'email': emailController.text,
                      'alamat': alamatController.text
                    });
                  } else {
                    users!.doc(widget.id).update({
                      'nama': namaController.text,
                      'nohp': nohpController.text,
                      'email': emailController.text,
                      'alamat': alamatController.text
                    });
                  }
                  //snackbar notification
                  final snackBar = SnackBar(
                      content: Text(
                          'Data telah berhasil disimpan ke dalam database!'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);

                  //back to main page
                  //home page => '/'
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/', (Route<dynamic> route) => false);
                }
              },
            )
          ]),
        ));
  }
}
