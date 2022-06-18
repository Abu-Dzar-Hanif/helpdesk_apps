import 'package:flutter/material.dart';
import 'package:helpdesk_apps/model/TiketModel.dart';
import 'package:helpdesk_apps/model/api.dart';
import 'package:helpdesk_apps/view/EditTiket.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

class DataTket extends StatefulWidget {
  @override
  State<DataTket> createState() => _DataTketState();
}

class _DataTketState extends State<DataTket> {
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

    final response = await http.get(Uri.parse(BaseUrl.urlDataTiket));
    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = new TiketModel(
            api['id_tiket'],
            api['id_karyawan'],
            api['nama_karyawan'],
            api['keluhan'],
            api['foto'],
            api['tgl_buat'],
            api['tgl_selesai'],
            api['teknisi'],
            api['sts']);
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
                "Data Tiket",
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
                                Text("ID : " + x.id_tiket.toString(),
                                    style: TextStyle(fontSize: 15.0)),
                                Text(x.nama_karyawan.toString(),
                                    style: TextStyle(
                                      fontSize: 15.0,
                                    )),
                                Text(x.sts.toString(),
                                    style: TextStyle(
                                      fontSize: 15.0,
                                    ))
                              ],
                            ),
                          ),
                          if (x.sts == "Selesai")
                            ...[]
                          else ...[
                            IconButton(
                                onPressed: () {
                                  // edit
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          EditTiket(x, _lihatData)));
                                },
                                icon: Icon(Icons.edit)),
                          ],
                          IconButton(
                              onPressed: () {
                                // delete
                                // dialogHapus(x.id_pc);
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
