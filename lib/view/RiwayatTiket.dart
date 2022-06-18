import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpdesk_apps/model/TiketModel.dart';
import 'package:helpdesk_apps/model/api.dart';
import 'package:helpdesk_apps/view/DetailTiket.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

class RiwayatTiket extends StatefulWidget {
  @override
  State<RiwayatTiket> createState() => _RiwayatTiketState();
}

class _RiwayatTiketState extends State<RiwayatTiket> {
  String? idKaryawan;
  getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      idKaryawan = pref.getString("id_karyawan");
    });
    _lihatData();
  }

  var loading = false;
  final list = [];
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

  Future<void> _lihatData() async {
    list.clear();
    setState(() {
      loading = true;
    });

    final response = await http
        .get(Uri.parse(BaseUrl.urlGetUsrTiket + idKaryawan.toString()));
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
        elevation: 0.1,
        // const Color(0xff29455b) = const Color(#29455b)
        backgroundColor: const Color(0xff29455b),
        title: Text('Riwayat Tiket'),
      ),
      body: RefreshIndicator(
          onRefresh: _lihatData,
          key: _refresh,
          child: loading
              ? Center(
                  child: Text("Tidak Tiket Yang di proses"),
                )
              : ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, i) {
                    final x = list[i];
                    return Container(
                      margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                      child: Card(
                        color: const Color(0xfff1f0ec),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: x.sts.toString() == "Menunggu"
                                  ? Icon(
                                      CupertinoIcons.ticket_fill,
                                      size: 50,
                                      color: Color(0xff203646),
                                    )
                                  : x.sts.toString() == "Dikerjakan"
                                      ? Icon(
                                          CupertinoIcons.ticket_fill,
                                          size: 50,
                                          color: Color(0xffff8566),
                                        )
                                      : Icon(
                                          CupertinoIcons.ticket_fill,
                                          size: 50,
                                          color: Color(0xff008000),
                                        ),
                              title: Text("ID : " + x.id_tiket.toString(),
                                  style: TextStyle(fontSize: 15.0)),
                              subtitle: Text(x.sts.toString(),
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                  )),
                              trailing: IconButton(
                                  onPressed: () {
                                    // Detail
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DetailTiket(x, _lihatData)));
                                  },
                                  icon: Icon(
                                      CupertinoIcons.arrow_right_square_fill,
                                      size: 25,
                                      color: Color(0xff29455b))),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )),
    );
  }
}
