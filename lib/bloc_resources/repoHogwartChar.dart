

import 'package:assignment/model/HogwartCharacters.dart';
import 'package:dio/dio.dart';

class HogwartsCharRepository {
  String userUrl = 'https://reqres.in/api/users?page=2';

  Future<List<HogwartChars>> getChars() async {
    final Dio dio = new Dio();
    Response response = await dio.get(
        "https://hp-api.onrender.com/api/characters/students");

    if (response.statusCode == 200) {
      var list =
      (response.data as List).map((x) => HogwartChars.fromJson(x)).toList();
      print(list);
      return (response.data as List)
          .map((x) => HogwartChars.fromJson(x))
          .toList();
    } else {
      throw Exception(response.data);
    }
  }
}