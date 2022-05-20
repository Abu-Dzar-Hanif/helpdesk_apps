import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:helpdesk_apps/model/api.dart';
import 'package:helpdesk_apps/model/PCModel.dart';
import 'package:helpdesk_apps/model/JenisModel.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:async/async.dart';

class TambahPC extends StatefulWidget {
  final VoidCallback reload;
  TambahPC(this.reload);
  @override
  State<TambahPC> createState() => _TambahPCState();
}

class _TambahPCState extends State<TambahPC> {
  String? nama_pc, tipe_pc;
  final _key = new GlobalKey<FormState>();
  JenisModel? _currentJenis;
  final String? linkJenis = BaseUrl.urlDataJenis;
  Future<List<JenisModel>> _fetchJenis() async {
    var response = await http.get(Uri.parse(linkJenis.toString()));
    print('hasil: ' + response.statusCode.toString());
    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<JenisModel> listOfJenis = items.map<JenisModel>((json) {
        return JenisModel.fromJson(json);
      }).toList();
      return listOfJenis;
    } else {
      throw Exception('gagal');
    }
  }

  check() {
    final form = _key.currentState;
    if ((form as dynamic).validate()) {
      (form as dynamic).save();
      simpanPC();
    }
  }

  simpanPC() async {
    try {
      final response = await http.post(
          Uri.parse(BaseUrl.urlTambahPC.toString()),
          body: {"nama_pc": nama_pc, "tipe_pc": tipe_pc});
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
                    return "Silahkan isi nama pc";
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
                        .map((listJenis) => DropdownMenuItem(
                              child: Text(listJenis.jenis.toString()),
                              value: listJenis,
                            ))
                        .toList(),
                    onChanged: (JenisModel? value) {
                      setState(() {
                        _currentJenis = value;
                        tipe_pc = _currentJenis!.id_jenis;
                      });
                    },
                    isExpanded: false,
                    hint: Text(tipe_pc == null
                        ? "Pilih Tipe PC"
                        : _currentJenis!.jenis.toString()),
                  );
                },
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
