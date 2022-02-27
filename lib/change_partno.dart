import 'package:flutter/material.dart';

import 'data_services.dart';

class ChangePartNoPage extends StatefulWidget {
  @override
  _ChangePartNoPageState createState() => _ChangePartNoPageState();
}

class _ChangePartNoPageState extends State<ChangePartNoPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  String oldPartNo = "";
  String newPartNo = "";

  void _submit() async {
    var snackBar = SnackBar(
      content: Text('Part no. changed successfully')
    );

    try {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        print(oldPartNo);
        print(newPartNo);
        await changePartNo(oldPartNo, newPartNo);
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

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                    decoration: InputDecoration(labelText: 'old part no.'),
                    onSaved: (value) {
                      setState(() {
                        oldPartNo = value.toString();
                      });
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Invalid old part no.!';
                      }
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'new part no.'),
                    onSaved: (value) {
                      setState(() {
                        newPartNo = value.toString();
                      });
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Invalid new part no.!';
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
