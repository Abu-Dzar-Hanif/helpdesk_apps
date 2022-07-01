import 'package:flutter/material.dart';
import 'package:helpdesk_apps/model/api.dart';
import 'package:helpdesk_apps/model/model_karyawan.dart';
import 'package:helpdesk_apps/view/LoadingPage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

class DataKaryawan extends StatefulWidget {
  @override
  State<DataKaryawan> createState() => _DataKaryawanState();
}

class _DataKaryawanState extends State<DataKaryawan> {
  var loading = false;
  final list = [];
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

  getPref() async {
    _lihatData();
  }

  Future<void> _lihatData() async {
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http.get(Uri.parse(BaseUrl.urlDataKaryawan));
    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = new model_karyawan(
            api['id_karyawan'],
            api['nama_karyawan'],
            api['divisi'],
            api['gender'],
            api['level'],
            api['username'],
            api['password']);
        list.add(ab);
      });
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 41, 69, 91),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text(
                "Data Karyawan",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            )
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _lihatData,
        key: _refresh,
        child: loading
            ? LoadingPage()
            : ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, i) {
                  final x = list[i];
                  return Container(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("ID : " + x.id_karyawan.toString(),
                                  style: TextStyle(fontSize: 15.0)),
                              Text("Nama : " + x.nama_karyawan.toString(),
                                  style: TextStyle(
                                    fontSize: 15.0,
                                  )),
                              Text("Divisi : " + x.divisi.toString(),
                                  style: TextStyle(
                                    fontSize: 15.0,
                                  )),
                              Text("Gender : " + x.gender.toString(),
                                  style: TextStyle(
                                    fontSize: 15.0,
                                  )),
                              Text(
                                  x.level.toString() == "0"
                                      ? "Level : User"
                                      : "Level : admin",
                                  style: TextStyle(
                                    fontSize: 15.0,
                                  )),
                              Text("Username : " + x.username.toString(),
                                  style: TextStyle(
                                    fontSize: 15.0,
                                  )),
                              Text("password : " + x.password.toString(),
                                  style: TextStyle(
                                    fontSize: 15.0,
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
      ),
    );
  }
}
