import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpdesk_apps/model/TiketModel.dart';
import 'package:helpdesk_apps/model/api.dart';
import 'package:helpdesk_apps/view/DetailTiket.dart';
import 'package:helpdesk_apps/view/LoadingPageOne.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
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
              ? LoadingPageOne()
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
                              leading: Icon(
                                CupertinoIcons.ticket_fill,
                                size: 50,
                                color: Color(0xff29455b),
                              ),
                              title: Padding(
                                padding: EdgeInsets.only(
                                  left: 10.0,
                                ),
                                child: Text("ID : " + x.id_tiket.toString(),
                                    style: TextStyle(fontSize: 15.0)),
                              ),
                              subtitle: Padding(
                                padding: EdgeInsets.all(1.0),
                                child: new LinearPercentIndicator(
                                  animation: true,
                                  width: 115.0,
                                  lineHeight: 14.0,
                                  percent: x.sts.toString() == "Menunggu"
                                      ? 0.25
                                      : x.sts.toString() == "Dikerjakan"
                                          ? 0.5
                                          : 1,
                                  center: x.sts.toString() == "Menunggu"
                                      ? Text(
                                          "25%",
                                          style: TextStyle(
                                              color: Color(0xfff1f0ec)),
                                        )
                                      : x.sts.toString() == "Dikerjakan"
                                          ? Text("50%",
                                              style: TextStyle(
                                                  color: Color(0xfff1f0ec)))
                                          : Text("100%",
                                              style: TextStyle(
                                                  color: Color(0xfff1f0ec))),
                                  backgroundColor: Colors.grey,
                                  progressColor: Color(0xff29455b),
                                ),
                              ),
                              trailing: IconButton(
                                  onPressed: () {
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
