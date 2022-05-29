import 'package:flutter/material.dart';
import 'package:helpdesk_apps/view/DataAdmin.dart';
import 'package:helpdesk_apps/view/DataJenis.dart';
import 'package:helpdesk_apps/view/DataPC.dart';
import 'package:helpdesk_apps/view/DataTeknisi.dart';
import 'package:helpdesk_apps/view/SearchTeknisi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';

class AdminPage extends StatefulWidget {
  final VoidCallback signOut;

  @override
  AdminPage(this.signOut);
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  String? idKaryawan, userName, nama;
  getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      idKaryawan = pref.getString("id_karyawan");
      userName = pref.getString("username");
      nama = pref.getString("nama_karyawan");
    });
  }

  signOut() {
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
          title: Text('Helpdesk | ' + nama.toString()),
          actions: <Widget>[
            new IconButton(
                onPressed: () {
                  signOut();
                },
                icon: Icon(Icons.logout),
                color: Colors.white)
          ],
        ),
        body: GridView.count(
          // primary: false,
          padding: EdgeInsets.all(15),
          // crossAxisSpacing: 5,
          // mainAxisSpacing: 5,
          crossAxisCount: 3,
          children: <Widget>[
            Container(
              child: GestureDetector(
                onTap: () {
                  // print("type / jenis pc");
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => new DataJenis()));
                },
                child: Card(
                  color: Color.fromARGB(255, 41, 69, 91),
                  child: new Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(80)),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            CupertinoIcons.tags_solid,
                            size: 30.0,
                            color: Colors.white,
                          ),
                          Text(
                            "Jenis PC",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ]),
                  ),
                ),
              ),
            ),
            Container(
              child: GestureDetector(
                onTap: () {
                  // print("menu teknisi");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => new DataTeknis()));
                },
                child: Card(
                  color: Color.fromARGB(255, 41, 69, 91),
                  child: new Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            CupertinoIcons.settings,
                            size: 30.0,
                            color: Colors.white,
                          ),
                          Text(
                            "Teknisi",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ]),
                  ),
                ),
              ),
            ),
            Container(
              child: GestureDetector(
                onTap: () {
                  // print("data pc");
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => new DataPC()));
                },
                child: Card(
                  color: Color.fromARGB(255, 41, 69, 91),
                  child: new Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            CupertinoIcons.desktopcomputer,
                            size: 30.0,
                            color: Colors.white,
                          ),
                          Text(
                            "PC",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ]),
                  ),
                ),
              ),
            ),
            Container(
              child: GestureDetector(
                onTap: () {
                  // print("menu admin");
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => new DataAdmin()));
                },
                child: Card(
                  color: Color.fromARGB(255, 41, 69, 91),
                  child: new Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            CupertinoIcons.person_alt,
                            size: 30.0,
                            color: Colors.white,
                          ),
                          Text(
                            "Admin",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ]),
                  ),
                ),
              ),
            ),
            Container(
              child: GestureDetector(
                onTap: () {
                  // print("menu admin");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => new SearchTeknisi()));
                },
                child: Card(
                  color: Color.fromARGB(255, 41, 69, 91),
                  child: new Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            CupertinoIcons.doc_text_search,
                            size: 30.0,
                            color: Colors.white,
                          ),
                          Text(
                            "Cari teknisi",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ]),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
