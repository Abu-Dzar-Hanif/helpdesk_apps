import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:helpdesk_apps/model/api.dart';
import 'package:helpdesk_apps/model/TeknisModel.dart';
import 'package:helpdesk_apps/model/GenderModel.dart';
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
  TextEditingController? txtidTeknisi, txtnamaTeknisi;
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

  setup() async {
    txtnamaTeknisi = TextEditingController(text: widget.model.nama_teknisi);
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
                  hint: Text(gender_teknisi == null ||
                          gender_teknisi == widget.model.gender_teknisi
                      ? widget.model.gender_teknisi.toString()
                      : _currentGender!.jenis_gender.toString()),
                );
              },
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
