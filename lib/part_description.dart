import 'package:flutter/material.dart';

class PartDescription extends StatelessWidget {
  PartDescription({
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
                'Frame No: $partNo',
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
              ),
            ],
          ),
        )
    );
  }

}
