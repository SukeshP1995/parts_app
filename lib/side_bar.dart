import 'package:flutter/material.dart';
import 'package:parts_app/main_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'sale_report_page.dart';
import 'set_checkpoint.dart';
import 'change_partno.dart';

class SideDrawer extends StatelessWidget {

  String checkpoint = "";

  @override
  Widget build(BuildContext context) {
    SharedPreferences.getInstance().then((prefs) {
      var chkpt = prefs.getString("checkpoint");
      if (chkpt != null) {
        checkpoint = chkpt;
      }
    });
    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            child: Center(
              child: Text(
                checkpoint,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.black,
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home Page'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MainPage()),
            ),
          ),
          ListTile(
            leading: Icon(Icons.assignment),
            title: Text('Sale Page'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SaleReportPage()),
            ),
          ),
          ListTile(
            leading: Icon(Icons.assessment),
            title: Text('Change Part No.'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChangePartNoPage()),
            ),
          ),
          ListTile(
            leading: Icon(Icons.border_color),
            title: Text('Set Checkpoint'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SetCheckpointPage()),
            ),
          ),
        ],
      ),
    );
  }
}
