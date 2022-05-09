import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:helpdesk_apps/model/api.dart';
import 'package:helpdesk_apps/model/AdminModel.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:async/async.dart';

class EditAdmin extends StatefulWidget {
  final VoidCallback reload;
  final AdminModel model;
  EditAdmin(this.model, this.reload);
  @override
  State<EditAdmin> createState() => _EditAdminState();
}

class _EditAdminState extends State<EditAdmin> {
  String? id_admin, nama, username;
  final _key = new GlobalKey<FormState>();
  TextEditingController? txtidAdmin, txtNama, txtuserName;
  setup() async {
    txtNama = TextEditingController(text: widget.model.nama);
    txtuserName = TextEditingController(text: widget.model.username);
    id_admin = widget.model.id_admin;
  }

  check() {
    final form = _key.currentState;
    if ((form as dynamic).validate()) {
      (form as dynamic).save();
      proseAdmin();
    }
  }

  proseAdmin() async {
    try {
      final respon = await http.post(Uri.parse(BaseUrl.urlEditAdmin.toString()),
          body: {"id_admin": id_admin, "nama": nama, "username": username});
      final data = jsonDecode(respon.body);
      print(data);
      int code = data['success'];
      String pesan = data['message'];
      print(data);
      if (code == 1) {
        setState(() {
          widget.reload();
          Navigator.pop(context);
        });
      } else {
        print(pesan);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    setup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(244, 244, 244, 1),
      appBar: AppBar(),
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              controller: txtNama,
              validator: (e) {
                if (e!.isEmpty) {
                  return "Silahkan isi nama";
                } else {
                  return null;
                }
              },
              onSaved: (e) => nama = e,
              decoration: InputDecoration(labelText: "Nama"),
            ),
            TextFormField(
              controller: txtuserName,
              validator: (e) {
                if (e!.isEmpty) {
                  return "Silahkan isi Username";
                } else {
                  return null;
                }
              },
              onSaved: (e) => username = e,
              decoration: InputDecoration(labelText: "Username"),
            ),
            MaterialButton(
              onPressed: () {
                check();
              },
              child: Text("Ubah"),
            )
          ],
        ),
      ),
    );
  }
}
