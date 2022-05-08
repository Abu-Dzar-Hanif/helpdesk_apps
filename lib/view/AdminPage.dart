import 'package:flutter/material.dart';
import 'package:helpdesk_apps/view/DataTeknisi.dart';

// import 'package:cupertino_icons/cupertino_icons.dart';
class AdminPage extends StatefulWidget {
  final VoidCallback signOut;

  @override
  AdminPage(this.signOut);
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  signOut() {
    setState(() {
      widget.signOut();
    });
  }

  @override
  Widget build(BuildContext context) {
    var color = 0xffF6F8FC;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Colors.orange,
        title: Text('Administrator Page'),
        actions: <Widget>[
          new IconButton(
              onPressed: () {
                signOut();
              },
              icon: Icon(Icons.double_arrow),
              color: Colors.white)
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
                    child: GestureDetector(
                      onTap: () {
                        print("Container 2 clicked");
                      },
                      child: new Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.orangeAccent,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.groups,
                              size: 40.0,
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Users",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    )),
                Flexible(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        // print("menu teknisi");
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => new DataTeknis()));
                      },
                      child: new Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.settings,
                              size: 40.0,
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Teknisi",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    )),
              ],
            ),
          ),
          Flexible(
            flex: 0,
            child: Row(
              children: <Widget>[
                Flexible(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        print("Container 1 clicked");
                      },
                      child: new Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.desktop_windows,
                              size: 40.0,
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "PC",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    )),
                Flexible(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        print("Container 1 clicked");
                      },
                      child: new Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.lightBlueAccent,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.admin_panel_settings_outlined,
                              size: 40.0,
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Admin",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
