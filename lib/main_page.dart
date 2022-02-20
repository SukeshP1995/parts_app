import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';


import 'package:file_picker/file_picker.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';

import './side_bar.dart';
import './data_services.dart';
import './dashboard_page.dart';


class MainPage extends StatefulWidget {

  MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // User user;
  _MainPageState();

  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _addUnitFormKey = GlobalKey<FormState>();

  bool _isLoading = false;

  Future<void> _fileHandler() async {
    setState(() {
      _isLoading = true;
    });
    SnackBar snackBar = SnackBar(
      content: Text('File not selected')
    );
    try {
      var fileResult = await FilePicker.platform.pickFiles();
      // print(filePath);
      if (fileResult == null) {

      } if (fileResult!.isSinglePick) {
        var decoder = new SpreadsheetDecoder.decodeBytes(fileResult.files[0].bytes!.toList());
        List<List<dynamic>> rows = decoder.tables['Sheet1']!.rows.sublist(1);
        print(rows);
        await addParts(rows.map((List<dynamic> row) {
          return <dynamic, dynamic>{
            'partNo': row[0],
            'quantity': row[1],
            "date": row[2].toString().substring(0, 10)
          };
        }).toList());
        snackBar = SnackBar(
            content: Text('Stock data upload successful')
        );
      }
    }  on Exception catch(_) {
      snackBar = SnackBar(
          content: Text('Stock data upload failed')
      );
    }
    setState(() {
      _isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // key: _scaffoldKey,
      drawer: SideDrawer(),
      appBar: AppBar(
        title: Text('Home')
      ),
      body: _isLoading ? Center(
        child: CircularProgressIndicator(),
      ) :  DashboardPage(),
        // floatingActionButton: buildSpeedDial()
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _addPartsDialog(),
      ),
    );
  }

  void _addPartsDialog() {
    bool isSwitched = false;
    String partNo = "";
    int quantity = 0;

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Add parts"),
              content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Upload file"),
                            Switch(
                              value: isSwitched,
                              onChanged: (value) {
                                setState(() {
                                  isSwitched = value;
                                });
                              },
                              activeTrackColor: Colors.lightBlueAccent,
                              activeColor: Colors.blue,
                            ),
                          ],
                        ),
                        isSwitched ? Container(
                          color: Colors.white,
                        ) : Form(
                          key: _addUnitFormKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Flexible(
                                    fit: FlexFit.tight,
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter part number';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        partNo = value.toString();
                                      },
                                      decoration: InputDecoration(
                                        labelText: "part number",
                                        hintText: "part number",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const Gap(5),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Flexible(
                                    fit: FlexFit.tight,
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter quanity';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        quantity = int.parse(value.toString());
                                      },
                                      decoration: InputDecoration(
                                        labelText: "quantity",
                                        hintText: "quantity",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10.0),
                                          ),
                                        ),
                                      ),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      keyboardType: TextInputType.number,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
              actions: <Widget>[
                TextButton(
                  child: Text("cancel"),
                  onPressed:  () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text("accept"),
                  onPressed: () async {
                    var snackBar = SnackBar(
                        content: Text('Unit added successfully')
                    );
                    try {
                      if (isSwitched) {
                        _fileHandler();
                      }

                      else if (_addUnitFormKey.currentState!.validate()) {
                        _addUnitFormKey.currentState!.save();
                        print("dadas");
                        await addParts([<dynamic, dynamic>{
                          'partNo': partNo,
                          'quantity': quantity,
                          "date":  DateFormat('yyyy-MM-dd').format(DateTime.now())
                        }]);
                        snackBar = SnackBar(
                          content: Text('Unit added successfully')
                        );
                      }
                      else {
                        snackBar = SnackBar(
                          content: Text('Some fields are not entered')
                        );
                      }

                    } on Exception catch(_) {
                      snackBar = SnackBar(
                        content: Text('Unit not added')
                      );
                    }
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    Navigator.of(context).pop();
                  },
                ),
              ]
          );
        }
    );
  }

}
