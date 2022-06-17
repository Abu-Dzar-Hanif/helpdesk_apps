import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:helpdesk_apps/model/api.dart';
import 'package:helpdesk_apps/model/TiketModel.dart';
import 'package:helpdesk_apps/model/TeknisiModel.dart';
import 'package:helpdesk_apps/model/StatusModel.dart';
import 'package:helpdesk_apps/custome/datePicker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:async/async.dart';

class EditTiket extends StatefulWidget {
  final VoidCallback reload;
  final TiketModel model;
  EditTiket(this.model, this.reload);
  @override
  State<EditTiket> createState() => _EditTiketState();
}

class _EditTiketState extends State<EditTiket> {
  String? id_tiket, teknisi, statusA, status;
  final _key = new GlobalKey<FormState>();
  TextEditingController? txtidTiket;
  setup() async {
    statusA = widget.model.status;
    id_tiket = widget.model.id_tiket;
  }

  TeknisiModel? _currentTeknisi;
  final String? linkTeknisi = BaseUrl.urlDataTeknisi;
  Future<List<TeknisiModel>> _fetchTeknisi() async {
    var response = await http.get(Uri.parse(linkTeknisi.toString()));
    print('hasil: ' + response.statusCode.toString());
    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<TeknisiModel> listOfTeknisi = items.map<TeknisiModel>((json) {
        return TeknisiModel.fromJson(json);
      }).toList();
      return listOfTeknisi;
    } else {
      throw Exception('gagal');
    }
  }

  StatusModel? _currentSts;
  final String? linkSts = BaseUrl.urlDataSts;
  Future<List<StatusModel>> _fetchSts() async {
    var response = await http.get(Uri.parse(linkSts.toString()));
    print('hasil: ' + response.statusCode.toString());
    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<StatusModel> listOfSts = items.map<StatusModel>((json) {
        return StatusModel.fromJson(json);
      }).toList();
      return listOfSts;
    } else {
      throw Exception('gagal');
    }
  }

  check() {
    final form = _key.currentState;
    if ((form as dynamic).validate()) {
      (form as dynamic).save();
      if (statusA == "1") {
        proseTiket();
      } else {
        proseTiket3();
      }
    }
  }

  proseTiket() async {
    try {
      final respon =
          await http.post(Uri.parse(BaseUrl.urlEditTiket.toString()), body: {
        "id_tiket": id_tiket,
        "teknisi": teknisi,
        "status": status,
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

  proseTiket3() async {
    try {
      final respon = await http.post(Uri.parse(BaseUrl.urlEditTiket.toString()),
          body: {
            "id_tiket": id_tiket,
            "status": status,
            "tgl_selesai": "$tgl"
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

  String? pilihTanggal, labelText;
  DateTime tgl = new DateTime.now();
  final TextStyle valueStyle = TextStyle(fontSize: 16.0);
  Future<Null> _selctedDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: tgl,
        firstDate: DateTime(1990),
        lastDate: DateTime(2099));
    if (picked != null && picked != tgl) {
      setState(() {
        tgl = picked;
        pilihTanggal = new DateFormat.yMd().format(tgl);
      });
    } else {}
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
                "Edit Tiket " + id_tiket.toString(),
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
            Text("Status"),
            FutureBuilder<List<StatusModel>>(
              future: _fetchSts(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<StatusModel>> snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                return DropdownButton<StatusModel>(
                  items: snapshot.data!
                      .map((listSts) => DropdownMenuItem(
                            child: Text(listSts.status.toString()),
                            value: listSts,
                          ))
                      .toList(),
                  onChanged: (StatusModel? value) {
                    setState(() {
                      _currentSts = value;
                      status = _currentSts!.id_sts;
                    });
                  },
                  isExpanded: false,
                  hint: Text(status == null || status == widget.model.status
                      ? widget.model.status.toString()
                      : _currentSts!.status.toString()),
                );
              },
            ),
            SizedBox(
              height: 20,
            ),
            if (statusA == "1") ...[
              Text("Teknisi"),
              FutureBuilder<List<TeknisiModel>>(
                future: _fetchTeknisi(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<TeknisiModel>> snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  return DropdownButton<TeknisiModel>(
                    items: snapshot.data!
                        .map((listGender) => DropdownMenuItem(
                              child: Text(listGender.nama_teknisi.toString()),
                              value: listGender,
                            ))
                        .toList(),
                    onChanged: (TeknisiModel? value) {
                      setState(() {
                        _currentTeknisi = value;
                        teknisi = _currentTeknisi!.id_teknisi;
                      });
                    },
                    isExpanded: false,
                    hint: Text(teknisi == null
                        ? "Pilih Teknisi"
                        : _currentTeknisi!.nama_teknisi.toString()),
                  );
                },
              ),
            ] else ...[
              Text("Tgl Selesai"),
              DateDropDown(
                labelText: labelText,
                valueText: new DateFormat.yMd().format(tgl),
                valueStyle: valueStyle,
                onPressed: () {
                  _selctedDate(context);
                },
              ),
            ],
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
