import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:helpdesk_apps/model/api.dart';
import 'package:helpdesk_apps/model/AdminModel.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:async/async.dart';

class TambahAdmin extends StatefulWidget {
  final VoidCallback reload;
  TambahAdmin(this.reload);
  @override
  State<TambahAdmin> createState() => _TambahAdminState();
}

class _TambahAdminState extends State<TambahAdmin> {
  String? nama, username, password;
  final _key = new GlobalKey<FormState>();
  check() {
    final form = _key.currentState;
    if ((form as dynamic).validate()) {
      (form as dynamic).save();
      simpanAdmin();
    }
  }

  simpanAdmin() async {
    try {
      final response = await http.post(
          Uri.parse(BaseUrl.urlTambahAdmin.toString()),
          body: {"nama": nama, "username": username, "password": password});
      final data = jsonDecode(response.body);
      print(data);
      int code = data['success'];
      String pesan = data['message'];
      print(data);
      if (code == 1) {
        setState(() {
          Navigator.pop(context);
          widget.reload();
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
                validator: (e) {
                  if ((e as dynamic).isEmpty) {
                    return "Silahkan isi nama";
                  }
                },
                onSaved: (e) => nama = e,
                decoration: InputDecoration(labelText: "Nama"),
              ),
              TextFormField(
                validator: (e) {
                  if ((e as dynamic).isEmpty) {
                    return "Silahkan isi username";
                  }
                },
                onSaved: (e) => username = e,
                decoration: InputDecoration(labelText: "Username"),
              ),
              TextFormField(
                validator: (e) {
                  if ((e as dynamic).isEmpty) {
                    return "Silahkan isi Password";
                  }
                },
                onSaved: (e) => password = e,
                decoration: InputDecoration(labelText: "Password"),
              ),
              MaterialButton(
                onPressed: () {
                  check();
                },
                child: Text("Simpan"),
              )
            ],
          ),
        ));
  }
}
