import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './data_services.dart';

class DashboardPage extends StatefulWidget {
  DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isLoading = true;
  DateTime currentDate = DateTime.now();

  var saleInfo = {
    "daily": {},
    "monthly": {}
  };

  var partNos = {
    "daily": [],
    "monthly": []
  };

  var total = {
    "daily": [0, 0, 0, 0],
    "monthly": [0]
  };

  var saleTypes = {
    "daily" : {},
    "monthly" : {}
  };

  var financeNames = {
    "daily" : {},
    "monthly" : {}
  };

  var transactionTypes = {
    "daily" : {},
    "monthly" : {}
  };

  var counterSold = {
    "daily" : {},
    "monthly" : {}
  };

  var workshopSold = {
    "daily" : {},
    "monthly" : {}
  };

  String _selected = "daily";

  var columns = ["Opening", "Sold", "Closed", "Received"];

  Future<void> _getData() async {
    setState(() {
      _isLoading = true;
    });

    var data = await getSaleInfo(date: "${currentDate.toLocal()}".split(' ')[0]);

    setState(() {
      total = {
        "daily": data["total"]["daily"].cast<int>(),
        "monthly": data["total"]["monthly"].cast<int>()
      };

      saleInfo = new Map<String, Map<String, dynamic>>.from(data["saleInfo"]);

      print(saleInfo);

      partNos = {
        "daily": saleInfo["daily"]!.keys.toList()..sort(),
        "monthly": saleInfo["monthly"]!.keys.toList()..sort()
      };

      saleTypes = new Map<String, Map<dynamic, dynamic>>.from(data["saleTypes"]);

      counterSold = new Map<String, Map<dynamic, dynamic>>.from(data["counterSold"]);
      workshopSold = new Map<String, Map<dynamic, dynamic>>.from(data["workshopSold"]);

      _isLoading = false;
    });
  }

  void initState() {
    super.initState();
    _getData();
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));

    if (picked != null && picked != currentDate) {
      setState(() {
        currentDate = picked;
      });
      _getData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: _isLoading ?
        Center(child: CircularProgressIndicator(),) :
        RefreshIndicator(
          child: Flex(
            direction: Axis.vertical,
            children: <Widget>[
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Card(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: DropdownButton(
                                items: [
                                  DropdownMenuItem<String>(
                                    value: "daily",
                                    child: Text("daily"),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: "monthly",
                                    child: Text("monthly",),
                                  ),
                                ],
                                // elevation: 2,
                                value: _selected,
                                onChanged: (value) {
                                  setState(() {
                                    _selected = value.toString();
                                    if (_selected == "daily")
                                      columns = ["Opening", "Sold", "Closed", "Received"];
                                    else {
                                      columns = ["Sold", "Received"];
                                    }
                                  });
                                  // print(networkSold[_selected].keys.toList());
                                },
                                isDense: true,
                                iconSize: 40.0,
                              ),
                            ),
                            TextButton(
                              child: Text("${currentDate.toLocal()}".split(' ')[0]),
                              onPressed: () => _selectDate(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: FittedBox(
                          child: DataTable(
                            columnSpacing: 0,
                            showBottomBorder: true,
                            dividerThickness: 2.0,
                            columns: [
                              DataColumn(label: Text("Part No.")),
                              ...(columns.map((e) => [
                                DataColumn(label: Text('')),
                                DataColumn(label: Text(e))
                              ]).reduce((a, b) => [...a, ...b])),
                            ],
                            rows: [
                              ...saleInfo[_selected]!.entries.map((e) => DataRow(cells: [
                                DataCell(Text(e.key)),
                                ...(e.value.map((f) => [
                                  DataCell(VerticalDivider()),
                                  DataCell(Text(f.toString())),
                                ]).reduce((a, b) => [...a, ...b]))
                              ])).toList(),
                              DataRow(cells: [
                                DataCell(Text("Total")),
                                ...total[_selected]!.map((e) => [
                                  DataCell(VerticalDivider()),
                                  DataCell(Text(e.toString())),
                                ]).reduce((a, b) => [...a, ...b])
                              ]
                              )
                            ]
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 80),
                  ],
                ),
                // child: Text("Forever Single"),
              ),
            ],
          ),
          onRefresh: _getData,
        )
    );
  }
}
