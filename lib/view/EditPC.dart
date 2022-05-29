import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:helpdesk_apps/model/api.dart';
import 'package:helpdesk_apps/model/PCModel.dart';
import 'package:helpdesk_apps/model/JenisModel.dart';
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
  TextEditingController? txtidPC, txtnamaPC;
  JenisModel? _currentJenis;
  final String? linJenis = BaseUrl.urlDataJenis;
  Future<List<JenisModel>> _fetchJenis() async {
    var response = await http.get(Uri.parse(linJenis.toString()));
    print('hasil: ' + response.statusCode.toString());
    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<JenisModel> listOfGender = items.map<JenisModel>((json) {
        return JenisModel.fromJson(json);
      }).toList();
      return listOfGender;
    } else {
      throw Exception('gagal');
    }
  }

  setup() async {
    txtnamaPC = TextEditingController(text: widget.model.nama_pc);
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
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 41, 69, 91),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text(
                "Edit PC " + id_pc.toString(),
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            )
          ],
        ),
      ),
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
            SizedBox(
              height: 20.0,
            ),
            Text("Jenis PC"),
            FutureBuilder<List<JenisModel>>(
              future: _fetchJenis(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<JenisModel>> snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                return DropdownButton<JenisModel>(
                  items: snapshot.data!
                      .map((listGender) => DropdownMenuItem(
                            child: Text(listGender.jenis.toString()),
                            value: listGender,
                          ))
                      .toList(),
                  onChanged: (JenisModel? value) {
                    setState(() {
                      _currentJenis = value;
                      tipe_pc = _currentJenis!.id_jenis;
                    });
                  },
                  isExpanded: false,
                  hint: Text(tipe_pc == null || tipe_pc == widget.model.tipe_pc
                      ? widget.model.tipe_pc.toString()
                      : _currentJenis!.jenis.toString()),
                );
              },
            ),
            SizedBox(
              height: 25,
            ),
            MaterialButton(
              color: Color.fromARGB(255, 41, 69, 91),
              onPressed: () {
                check();
              },
              child: Text(
                "Ubah",
                style: TextStyle(color: Colors.white),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)),
            )
          ],
        ),
      ),
    );
  }
}
