import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'main_page.dart';

class SetCheckpointPage extends StatefulWidget {
  @override
  _SetCheckpointPageState createState() => _SetCheckpointPageState();
}

class _SetCheckpointPageState extends State<SetCheckpointPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String checkpoint = "";

  void _submit() async {
    var snackBar = SnackBar(
      content: Text('Checkpoint set successfully')
    );;

    try {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        final prefs = await SharedPreferences.getInstance();
        print(checkpoint);
        prefs.setString("checkpoint", checkpoint);
        print(prefs.getString("checkpoint"));

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainPage()),
        );

        _formKey.currentState!.reset();
      } else {
        snackBar = SnackBar(
          content: Text('Please enter all details correctly')
        );
      }
    } on Exception catch(_) {
      snackBar = SnackBar(
        content: Text('Part not added')
      );
    }

    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      var chkpt = prefs.getString("checkpoint");
      if (chkpt != null) {
        setState(() {
          checkpoint = chkpt;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Set checkpoint"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(labelText: 'checkpoint'),
                    onSaved: (value) {
                      setState(() {
                        checkpoint = value.toString();
                      });
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Invalid checkpoint!';
                      }
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: _submit,
                    child: Text("submit"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
