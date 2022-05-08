import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:helpdesk_apps/model/api.dart';
import 'package:helpdesk_apps/model/TeknisModel.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:async/async.dart';

class TambahTeknisi extends StatefulWidget {
  final VoidCallback reload;
  TambahTeknisi(this.reload);

  @override
  State<TambahTeknisi> createState() => _TambahTeknisiState();
}

class _TambahTeknisiState extends State<TambahTeknisi> {
  String? nama_teknisi, gender_teknisi;
  final _key = new GlobalKey<FormState>();
  check() {
    final form = _key.currentState;
    if ((form as dynamic).validate()) {
      (form as dynamic).save();
      simpanTeknisi();
    }
  }

  simpanTeknisi() async {
    try {
      final response = await http
          .post(Uri.parse(BaseUrl.urlTambahTeknisi.toString()), body: {
        "nama_teknisi": nama_teknisi,
        "gender_teknisi": gender_teknisi
      });
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
                    return "Silahkan isi nama kategori";
                  }
                },
                onSaved: (e) => nama_teknisi = e,
                decoration: InputDecoration(labelText: "Nama Teknisi"),
              ),
              TextFormField(
                validator: (e) {
                  if ((e as dynamic).isEmpty) {
                    return "Silahkan isi nama kategori";
                  }
                },
                onSaved: (e) => gender_teknisi = e,
                decoration: InputDecoration(labelText: "Gender Teknisi"),
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
