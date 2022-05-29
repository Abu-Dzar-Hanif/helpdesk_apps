import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        children: <Widget>[
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
          )
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
            ),
            ListTile(
              leading: Icon(Icons.list_alt),
              title: Text("Riwayat Tiket"),
              onTap: () => print("buka data tiket"),
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
