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
        backgroundColor: Color.fromARGB(255, 41, 69, 91),
        title: Text('Helpdesk'),
        actions: <Widget>[
          new IconButton(
            onPressed: () {
              sigOut();
            },
            icon: Icon(Icons.double_arrow),
            color: Colors.white,
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            flex: 0,
            child: Row(
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: new Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Halo " + nama.toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                            "Selamat datang di helpdesk IT Silahkan klik menu buat tiket jika terjadi kendala, Silahkan klik menu daftar tiket untuk melihat semua tiket yang anda punya",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.normal)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
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
            ListTile(
              leading: Icon(CupertinoIcons.create),
              title: Text("Buat Tiket"),
            ),
            ListTile(
              leading: Icon(Icons.list_alt),
              title: Text("Riwayat Tiket"),
              onTap: () => print("buka data tiket"),
            )
          ],
        ),
      ),
    );
  }
}
