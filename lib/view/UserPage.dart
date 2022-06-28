import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpdesk_apps/model/TiketModel.dart';
import 'package:helpdesk_apps/model/api.dart';
import 'package:helpdesk_apps/view/LoadingPageOne.dart';
import 'package:helpdesk_apps/view/RiwayatTiket.dart';
import 'package:helpdesk_apps/view/TambahTiket.dart';
import 'package:helpdesk_apps/view/DetailTiket.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

class UserPage extends StatefulWidget {
  final VoidCallback signOut;
  @override
  UserPage(this.signOut);
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  String? idKaryawan, userName, nama, Lvl;
  getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      idKaryawan = pref.getString("id_karyawan");
      userName = pref.getString("username");
      nama = pref.getString("nama_karyawan");
      Lvl = pref.getString("level");
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

    final response =
        await http.get(Uri.parse(BaseUrl.urlGetTiket + idKaryawan.toString()));
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

  sigOut() {
    setState(() {
      widget.signOut();
    });
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
        title: Text('Helpdesk'),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(20),
            child: Card(
              color: const Color(0xfff1f0ec),
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                ListTile(
                  leading: Icon(
                    CupertinoIcons.person_crop_circle_fill,
                    size: 50,
                    color: Color.fromARGB(255, 23, 33, 41),
                  ),
                  title: Text("Halo " + nama.toString(),
                      style: TextStyle(
                          color: Color.fromARGB(255, 23, 33, 41),
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  subtitle: Text(
                      'Selamat datang di helpdesk IT Silahkan laporkan atau cek kendala anda',
                      style: TextStyle(color: Color.fromARGB(255, 23, 33, 41))),
                ),
              ]),
            ),
            //   decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(4),
            //       boxShadow: [
            //         new BoxShadow(
            //           color: Colors.grey.withOpacity(0.5),
            //           blurRadius: 2.5, // soften the shadow
            //           spreadRadius: 1.0,
            //           offset: Offset(4.0, 4.0), //extend the shadow
            //           // soften the shadow
            //         ),
            //       ]),
          ),
          Expanded(
              child: RefreshIndicator(
                  onRefresh: _lihatData,
                  key: _refresh,
                  child: loading
                      ? LoadingPageOne()
                      : ListView.builder(
                          itemCount: list.length,
                          itemBuilder: (context, i) {
                            final x = list[i];
                            return Container(
                              margin:
                                  EdgeInsets.only(top: 10, left: 20, right: 20),
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
                                        child: Text(
                                            "ID : " + x.id_tiket.toString(),
                                            style: TextStyle(fontSize: 15.0)),
                                      ),
                                      subtitle: Padding(
                                        padding: EdgeInsets.all(1.0),
                                        child: new LinearPercentIndicator(
                                          animation: true,
                                          width: 115.0,
                                          lineHeight: 14.0,
                                          percent: x.sts.toString() ==
                                                  "Menunggu"
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
                                                          color: Color(
                                                              0xfff1f0ec)))
                                                  : Text("100%",
                                                      style: TextStyle(
                                                          color: Color(
                                                              0xfff1f0ec))),
                                          backgroundColor: Colors.grey,
                                          progressColor: Color(0xff29455b),
                                        ),
                                      ),
                                      trailing: IconButton(
                                          onPressed: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        DetailTiket(
                                                            x, _lihatData)));
                                          },
                                          icon: Icon(
                                              CupertinoIcons
                                                  .arrow_right_square_fill,
                                              size: 25,
                                              color: Color(0xff29455b))),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ))),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(nama.toString()),
              accountEmail:
                  Lvl.toString() == "0" ? Text("User") : Text("Admin"),
              currentAccountPicture: new CircleAvatar(
                backgroundImage: AssetImage("assets/logo_m2v_n2.jpg"),
              ),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 41, 69, 91),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 10, bottom: 10),
              child: Text("Tiket",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  )),
            ),
            ListTile(
              leading: Icon(CupertinoIcons.create),
              title: Text("Buat Tiket"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => new TambahTiket(_lihatData)));
              },
            ),
            ListTile(
              leading: Icon(Icons.list_alt),
              title: Text("Riwayat Tiket"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => new RiwayatTiket()));
              },
            ),
            Divider(height: 25, thickness: 1),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Loogout"),
              onTap: () => sigOut(),
            ),
          ],
        ),
      ),
    );
  }
}
