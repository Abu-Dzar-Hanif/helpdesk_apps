import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:helpdesk_apps/model/api.dart';
import 'package:helpdesk_apps/model/TeknisModel.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:async/async.dart';

class EditTeknisi extends StatefulWidget {
  final VoidCallback reload;
  final TeknisiModel model;
  EditTeknisi(this.model, this.reload);

  @override
  State<EditTeknisi> createState() => _EditTeknisiState();
}

class _EditTeknisiState extends State<EditTeknisi> {
  String? id_teknisi, nama_teknisi, gender_teknisi;
  final _key = new GlobalKey<FormState>();
  TextEditingController? txtidTeknisi, txtnamaTeknisi, txtgenderTeknisi;
  setup() async {
    txtnamaTeknisi = TextEditingController(text: widget.model.nama_teknisi);
    txtgenderTeknisi = TextEditingController(text: widget.model.gender_teknisi);
    id_teknisi = widget.model.id_teknisi;
  }

  check() {
    final form = _key.currentState;
    if ((form as dynamic).validate()) {
      (form as dynamic).save();
      proseTeknisi();
    }
  }

  proseTeknisi() async {
    try {
      final respon =
          await http.post(Uri.parse(BaseUrl.urlEditTeknisi.toString()), body: {
        "id_teknisi": id_teknisi,
        "nama_teknisi": nama_teknisi,
        "gender_teknisi": gender_teknisi
      });
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
              controller: txtnamaTeknisi,
              validator: (e) {
                if (e!.isEmpty) {
                  return "Silahkan isi nama Teknisi";
                } else {
                  return null;
                }
              },
              onSaved: (e) => nama_teknisi = e,
              decoration: InputDecoration(labelText: "Nama Kategori"),
            ),
            TextFormField(
              controller: txtgenderTeknisi,
              validator: (e) {
                if (e!.isEmpty) {
                  return "Silahkan isi gender Kategori";
                } else {
                  return null;
                }
              },
              onSaved: (e) => gender_teknisi = e,
              decoration: InputDecoration(labelText: "gender Kategori"),
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
