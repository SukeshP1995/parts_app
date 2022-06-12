import 'dart:async';
import 'package:flutter/material.dart';

import 'data_services.dart';
import 'part_description.dart';
import 'sale_page.dart';

class SaleReportPage extends StatefulWidget {

  SaleReportPage({Key? key}) : super(key: key);

  @override
  _SaleReportPageState createState() => _SaleReportPageState();
}

class _SaleReportPageState extends State<SaleReportPage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  DateTime currentDate = DateTime.now();

  String barcode = "";

  var parts = [];

  void initState() {
    super.initState();

    getSold("${currentDate.toLocal()}".split(' ')[0]).then((value) {
      setState(() {
        parts = value;
      });
      print(parts[1]);
    });
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
      getSold("${currentDate.toLocal()}".split(' ')[0]).then((value) {
        setState(() {
          parts = value;
        });
      });
    }
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Sale Page'),
          ],
        ),
      ),
      body: Flex(
        direction: Axis.vertical,
        children: <Widget>[
          Expanded(
            child: ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: <Widget>[
                Card(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          child: Text("${currentDate.toLocal()}".split(' ')[0]),
                          onPressed: () => _selectDate(context),
                        ),
                      ],
                    ),
                  ),
                ),
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: parts.length,
                  itemBuilder: (context, index) {
                    final part = parts[index];
                    return PartDescription(
                      partNo: part["partNo"],
                      quantity: part["quantity"],
                      date: part["date"].toString().substring(0, 10),
                      saleType: part["saleType"],
                    );
                  },
                )
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SalePage()),
        ),
      ),

    );
  }

}



