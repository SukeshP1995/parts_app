import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import "package:collection/collection.dart";
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

import 'data_services.dart';

class _PartDescription extends StatelessWidget {
  _PartDescription({
    Key? key,
    required this.partNo,
    required this.quantity,
    required this.date,
    required this.saleType,
  }) : super(key: key);
  final String partNo;
  final int quantity;
  final String date;
  final String saleType;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Part No: $partNo',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20.0,
                ),
              ),
              Text(
                'Quantity: $quantity',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20.0,
                ),
              ),
             Text(
                'Sale Date: $date',
                style: const TextStyle(fontSize: 16.0),
              ),
              Text(
                'Sale Type: $saleType',
                style: const TextStyle(fontSize: 16.0),
              )
            ],
          ),
        )
    );
  }
}

class SalePage extends StatefulWidget {
  SalePage({Key? key}) : super(key: key);

  @override
  _SalePageState createState() => _SalePageState();
}

class _SalePageState extends State<SalePage> {

  final _addPartFormKey = GlobalKey<FormState>();

  DateTime currentDate = DateTime.now();

  List<Map<dynamic, dynamic>> parts = [];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Sale Page'),
            IconButton(icon: Icon(Icons.check), onPressed: _summaryDialog)
          ],
        ),
      ),
      body: Center(
          child: ListView.builder(
            itemCount: parts.length,
            itemBuilder: (context, index) {
              final part = parts[index];
              return Dismissible(
                key: Key(part["partNo"]),
                onDismissed: (direction) {
                  setState(() {
                    var deletedItem = parts.removeAt(index);

                    ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(
                        content: Text("data related to " + part["partNo"] + " dismissed"),
                        action: SnackBarAction(
                          label: "UNDO",
                          onPressed: () => setState(() => parts.insert(index, deletedItem),) // this is what you needed
                        ),
                    ));
                  });
                },
                child: _PartDescription(
                  partNo: part["partNo"],
                  quantity: part["quantity"],
                  date: part["date"].toString().substring(0, 10),
                  saleType: part["saleType"]
                ),
              );
            },
          )
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _addPartDialog(),
      ),
    );
  }

  void _addPartDialog() {
    // flutter defined function
    String partNo = "";
    String saleType = "Counter";
    int quantity = 0;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add part no. and date"),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Form(
                key: _addPartFormKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
                      SizedBox(height: 25.0,),
                      TextFormField(
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
                      SizedBox(height: 25.0,),
                      DateTimeField(
                        format: DateFormat("yyyy-MM-dd"),
                        onShowPicker: (context, currentValue) {
                          return showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            initialDate: currentValue ?? DateTime.now(),
                            lastDate: DateTime(2100)
                          );
                        },
                        initialValue: DateTime.now(),
                        onSaved: (value) {
                          currentDate = DateTime.parse(value.toString());
                        },
                        validator: (value) {
                          if (value == null)
                            return 'Please enter sale date';
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: "sale date",
                          hintText: "sale date",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 25.0,),
                      DropdownButtonFormField<String>(
                        value: saleType,
                        items: ["Counter", "Workshop"]
                            .map((label) => DropdownMenuItem<String>(
                          child: Text(label),
                          value: label,
                        )).toList(),
                        onChanged: (value) {
                          setState(() => saleType = value.toString());
                        },
                        decoration: InputDecoration(
                          labelText: "sale type",
                          hintText: "sale type",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text("cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("accept"),
              onPressed: () async {
                var snackBar;
                print(_addPartFormKey.currentState!.validate());
                try {
                  if (_addPartFormKey.currentState!.validate()) {
                    _addPartFormKey.currentState!.save();
                    // if(parts.map((e) => e["partNo"]).contains(partNo)) {
                    //   var snackBar = SnackBar(
                    //     content: Text('Frame Number already exists')
                    //   );
                    //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    // } else {
                      // var unit = (await getParts([partNo]));

                    var dailySale = (await getSaleInfo(
                        date: DateFormat('yyyy-MM-dd').format(currentDate),
                        partNo: partNo
                    ))["saleInfo"]["daily"];

                    if (dailySale[partNo] == null) {
                      snackBar = SnackBar(
                        content: Text('Part no. is not correct')
                      );
                    } else if (dailySale[partNo][2] == 0) {
                      snackBar = SnackBar(
                        content: Text('stock is empty for the given Part no.')
                      );
                    }
                    else {
                      setState(() {
                        parts.add(<dynamic, dynamic>{
                          "partNo": partNo,
                          "quantity": quantity,
                          "date": DateFormat('yyyy-MM-dd').format(currentDate),
                          "saleType": saleType,
                        });
                      });
                      // }
                      // print(_getSummary());
                      _addPartFormKey.currentState!.reset();
                      snackBar = SnackBar(
                        content: Text('Part added successfully')
                      );
                      Navigator.of(context).pop();
                    }
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
              },
            ),
          ],
        );
      },
    );
  }

  void _summaryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Submit"),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: DataTable(columns: [
                      DataColumn(label: Text("Part No.")),
                      DataColumn(label: Text("Count"), numeric: true)
                    ], rows: _getSummary().map((e)=> DataRow(
                        cells: [
                          DataCell(Text(e[0].toString())),
                          DataCell(Text(e[1].toString()))
                        ])).toList() + [
                      DataRow(
                          cells: [
                            DataCell(Text("Total", style: new TextStyle(fontWeight: FontWeight.bold))),
                            DataCell(Text(_getSummary().map((e) => int.tryParse(e[1])).reduce((a, b) => a! + b!).toString(), style: new TextStyle(fontWeight: FontWeight.bold)))
                          ])
                    ]),
                  ),
                ],
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
                var snackBar;
                try {
                  await sellUnits(parts);
                  print(parts);
                  setState(() {
                    parts = [];
                  });
                  Navigator.of(context).pop();
                  snackBar = SnackBar(
                    content: Text('Submit completed successfully')
                  );
                } on Exception catch(_) {
                  snackBar = SnackBar(
                    content: Text('Submit failed')
                  );
                }
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            ),
          ],
        );
      },
    );
  }

  List<List<String>> _getSummary() {
    List<List<String>> summary = [];

    groupBy(parts, (Map<dynamic, dynamic> obj) => obj['partNo']).forEach((k, v) {
      summary.add([k, v.map((e) => e["quantity"]).reduce((a, b) => a! + b!).toString()]);
    });

    return summary;
  }
}



