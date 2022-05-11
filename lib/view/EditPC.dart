import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:helpdesk_apps/model/api.dart';
import 'package:helpdesk_apps/model/PCModel.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:async/async.dart';

class EditPC extends StatefulWidget {
  final VoidCallback reload;
  final PCModel model;
  EditPC(this.model, this.reload);
  @override
  State<EditPC> createState() => _EditPCState();
}

class _EditPCState extends State<EditPC> {
  String? id_pc, nama_pc, tipe_pc;
  final _key = new GlobalKey<FormState>();
  TextEditingController? txtidPC, txtnamaPC, txtTipe;
  setup() async {
    txtnamaPC = TextEditingController(text: widget.model.nama_pc);
    txtTipe = TextEditingController(text: widget.model.tipe_pc);
    id_pc = widget.model.id_pc;
  }

  check() {
    final form = _key.currentState;
    if ((form as dynamic).validate()) {
      (form as dynamic).save();
      prosePC();
    }
  }

  prosePC() async {
    try {
      final respon = await http.post(Uri.parse(BaseUrl.urlEditPC.toString()),
          body: {"id_pc": id_pc, "nama_pc": nama_pc, "tipe_pc": tipe_pc});
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
              controller: txtnamaPC,
              validator: (e) {
                if (e!.isEmpty) {
                  return "Silahkan isi nama PC";
                } else {
                  return null;
                }
              },
              onSaved: (e) => nama_pc = e,
              decoration: InputDecoration(labelText: "Nama PC"),
            ),
            TextFormField(
              controller: txtTipe,
              validator: (e) {
                if (e!.isEmpty) {
                  return "Silahkan isi tipe pc";
                } else {
                  return null;
                }
              },
              onSaved: (e) => tipe_pc = e,
              decoration: InputDecoration(labelText: "Type PC"),
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
