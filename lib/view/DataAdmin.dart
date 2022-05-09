import 'package:flutter/material.dart';
import 'package:helpdesk_apps/model/AdminModel.dart';
import 'package:helpdesk_apps/model/api.dart';
import 'package:helpdesk_apps/view/EditAdmin.dart';
import 'package:helpdesk_apps/view/TambahAdmin.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

class DataAdmin extends StatefulWidget {
  @override
  State<DataAdmin> createState() => _DataAdminState();
}

class _DataAdminState extends State<DataAdmin> {
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

    final response = await http.get(Uri.parse(BaseUrl.urlDataAdmin));
    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = new AdminModel(api['id_admin'], api['nama'], api['username'],
            api['password'], api['level']);
        list.add(ab);
      });
      setState(() {
        loading = false;
      });
    }
  }

  _proseshapus(String id) async {
    final response = await http
        .post(Uri.parse(BaseUrl.urlHapusAdmin), body: {"id_admin": id});
    final data = jsonDecode(response.body);
    int value = data['success'];
    String pesan = data['message'];
    if (value == 1) {
      setState(() {
        Navigator.pop(context);
        _lihatData();
        ;
      });
    } else {
      print(pesan);
    }
  }

  dialogHapus(String id) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: ListView(
            padding: EdgeInsets.all(16.0),
            shrinkWrap: true,
            children: <Widget>[
              Text(
                "Apakah anda yakin ingin menghapus data ini?",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 18.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Tidak",
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 25.0),
                  InkWell(
                    onTap: () {
                      _proseshapus(id);
                    },
                    child: Text(
                      "Ya",
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text(
                "Data Admin",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // print("tambah admin");
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => new TambahAdmin(_lihatData)));
        },
        child: Icon(Icons.add),
        backgroundColor: Color.fromRGBO(255, 82, 48, 1),
      ),
      body: RefreshIndicator(
          onRefresh: _lihatData,
          key: _refresh,
          child: loading
              ? Center(child: CircularProgressIndicator())
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
                                Text("ID : " + x.id_admin.toString(),
                                    style: TextStyle(fontSize: 15.0)),
                                Text(x.nama.toString(),
                                    style: TextStyle(
                                      fontSize: 15.0,
                                    )),
                                Text(x.level.toString(),
                                    style: TextStyle(
                                      fontSize: 15.0,
                                    ))
                              ],
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                // edit
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        EditAdmin(x, _lihatData)));
                              },
                              icon: Icon(Icons.edit)),
                          IconButton(
                              onPressed: () {
                                // delete
                                dialogHapus(x.id_admin);
                              },
                              icon: Icon(Icons.delete))
                        ],
                      ),
                    );
                  },
                )),
    );
  }
}
