import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:helpdesk_apps/model/api.dart';
import 'package:helpdesk_apps/model/TeknisModel.dart';
import 'package:helpdesk_apps/model/GenderModel.dart';
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
  GenderModel? _currentGender;
  final String? linkGender = BaseUrl.urlGender;
  Future<List<GenderModel>> _fetchGender() async {
    var response = await http.get(Uri.parse(linkGender.toString()));
    print('hasil: ' + response.statusCode.toString());
    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<GenderModel> listOfGender = items.map<GenderModel>((json) {
        return GenderModel.formJson(json);
      }).toList();
      return listOfGender;
    } else {
      throw Exception('gagal');
    }
  }

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
              SizedBox(
                height: 20.0,
              ),
              Text("Gender"),
              FutureBuilder<List<GenderModel>>(
                future: _fetchGender(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<GenderModel>> snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  return DropdownButton<GenderModel>(
                    items: snapshot.data!
                        .map((listGender) => DropdownMenuItem(
                              child: Text(listGender.jenis_gender.toString()),
                              value: listGender,
                            ))
                        .toList(),
                    onChanged: (GenderModel? value) {
                      setState(() {
                        _currentGender = value;
                        gender_teknisi = _currentGender!.inisial;
                      });
                    },
                    isExpanded: false,
                    hint: Text(gender_teknisi == null
                        ? "Pilih jenis Kelamin"
                        : _currentGender!.jenis_gender.toString()),
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
