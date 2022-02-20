import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

BaseOptions options = new BaseOptions(
  baseUrl: "https://parts-api.vercel.app/api",
  connectTimeout: 80000,
  receiveTimeout: 30000,
  headers: {"Accept": "application/json"}
);

Dio dio = new Dio(options);


Future<void> addParts(List<Map<dynamic, dynamic>> parts) async {
  final prefs = await SharedPreferences.getInstance();

  Response response = await dio.post('/add', data: jsonEncode({
    "checkpoint": prefs.getString("checkpoint"),
    "parts": parts
  }));
}

Future getParts(List<String> ids) async {
  Response response = await dio.post('/get', data: jsonEncode(ids));

  return jsonDecode(response.data.toString());
}

Future getSold(String date) async {
  final prefs = await SharedPreferences.getInstance();

  Response response = await dio.get('/getsold', queryParameters: {
    "checkpoint": prefs.getString("checkpoint"),
    'date': date
  });

  return jsonDecode(response.data.toString());
}

Future<Map> getSaleInfo(String _date) async {
  final prefs = await SharedPreferences.getInstance();

  Response response = await dio.get('/saleinfo', queryParameters: {
    "checkpoint": prefs.getString("checkpoint"),
    'date': _date
  });
  return response.data;
}

Future<void> sellUnits(List<Map<dynamic, dynamic>> parts) async {
  final prefs = await SharedPreferences.getInstance();

  Response response = await dio.post('/sell', data: jsonEncode({
    "checkpoint": prefs.getString("checkpoint"),
    "parts": parts
  }));
}