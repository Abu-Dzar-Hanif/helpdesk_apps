import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpdesk_apps/model/TiketModel.dart';
import 'package:helpdesk_apps/model/api.dart';
import 'package:helpdesk_apps/view/LoadingPageOne.dart';
import 'package:helpdesk_apps/view/RiwayatTiket.dart';
import 'package:helpdesk_apps/view/TambahTiket.dart';
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
  String? idKaryawan, userName, nama;
  getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      idKaryawan = pref.getString("id_karyawan");
      userName = pref.getString("username");
      nama = pref.getString("nama_karyawan");
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
                    color: Colors.black,
                  ),
                  title: Text("Halo " + nama.toString(),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  subtitle: Text(
                      'Selamat datang di helpdesk IT Silahkan laporkan atau cek kendala anda'),
                ),
              ]),
            ),
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
                                      leading: x.sts.toString() == "Menunggu"
                                          ? Icon(
                                              CupertinoIcons.ticket_fill,
                                              size: 50,
                                              color: Color(0xffb30000),
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
                                      title: Text(
                                          "ID : " + x.id_tiket.toString(),
                                          style: TextStyle(fontSize: 15.0)),
                                      subtitle: Text(x.nama_karyawan.toString(),
                                          style: TextStyle(
                                            fontSize: 15.0,
                                          )),
                                      trailing: IconButton(
                                          onPressed: () {
                                            // edit
                                            // Navigator.of(context).push(MaterialPageRoute(
                                            //     builder: (context) =>
                                            //         EditTiket(x, _lihatData)));
                                          },
                                          icon: Icon(
                                              CupertinoIcons
                                                  .arrow_right_square_fill,
                                              size: 25,
                                              color: Color(0xff29455b))),
                                    ),
                                    Container(
                                      child: new LinearPercentIndicator(
                                        width: 140.0,
                                        lineHeight: 14.0,
                                        percent: 0.5,
                                        backgroundColor: Colors.grey,
                                        progressColor: Colors.blue,
                                      ),
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
              accountEmail: Text(idKaryawan.toString()),
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
