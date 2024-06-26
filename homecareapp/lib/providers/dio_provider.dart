import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioProvider {
  static String api = 'http://127.0.0.1:8000/api';
  //get token
  Future<dynamic> getToken(String email, String password) async {
    try {
      var response = await Dio().post('$api/login',
          data: {'email': email, 'password': password});

      if (response.statusCode == 200 && response.data != '') {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response.data);
        return true;
      } else {
        print('getToken False');
        return false;
      }
    } catch (error) {
       print('getToken Error');
      return error;
    }
  }

  //get user data
  Future<dynamic> getUser(String token) async {
    try {
      var user = await Dio().get('$api/user',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (user.statusCode == 200 && user.data != '') {
        return json.encode(user.data);
      }
      else {
        print('getUser False');
        return false;
      }
    } catch (error) {
      print('getUser Error');
      return error;
    }
  }

  //register new user
  Future<dynamic> registerUser(
    String username, String email, String password) async {
  try {
    var user = await Dio().post('$api/register',
        data: {'name': username, 'email': email, 'password': password});
    
    if (user.statusCode == 201 && user.data != '') {
      return true; // Registrasi berhasil
    } else if (user.statusCode == 409) {
      // Email sudah terdaftar
      return 'Email sudah terdaftar, gunakan email lain.';
    } else {
      return false; // Gagal mendaftar
    }
  } catch (error) {
    return error;
  }
}


  //store booking details
  Future<dynamic> bookAppointment(
      String date, String day, String time, int doctor, String keluhan, String alamat, String token) async {
    try {
      var response = await Dio().post('$api/book',
          data: {'date': date, 'day': day, 'time': time, 'doctor_id': doctor, 'alamat': alamat, 'keluhan': keluhan},
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200 && response.data != '') {
        return response.statusCode;
      } else {
        return 'Error BookAppointment';
      }
    } catch (error) {
      return error;
    }
  }

  //retrieve booking details
  Future<dynamic> getAppointments(String token) async {
    try {
      var response = await Dio().get('$api/appointments',
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200 && response.data != '') {
        return json.encode(response.data);
      } else {
        return 'Error getAppoinment';
      }
    } catch (error) {
      return error;
    }
  }

  //store rating details
  Future<dynamic> storeReviews(
      String reviews, double ratings, int id, int doctor, String token) async {
    try {
      var response = await Dio().post('$api/reviews',
          data: {
            'ratings': ratings,
            'reviews': reviews,
            'appointment_id': id,
            'doctor_id': doctor
          },
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200 && response.data != '') {
        return response.statusCode;
      } else {
        return 'Error StoreReview';
      }
    } catch (error) {
      return error;
    }
  }

  //store fav doctor
  Future<dynamic> storeFavDoc(String token, List<dynamic> favList) async {
    try {
      var response = await Dio().post('$api/fav',
          data: {
            'favList': favList,
          },
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200 && response.data != '') {
        return response.statusCode;
      } else {
        return 'Error StoreFavDoc';
      }
    } catch (error) {
      return error;
    }
  }

//logout
  Future<dynamic> logout(String token) async {
    try {
      var response = await Dio().post('$api/logout',
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200 && response.data != '') {
        return response.statusCode;
      } else {
        return 'Error Logout';
      }
    } catch (error) {
      return error;
    }
  }

  Future<dynamic> getKtp(String token) async {
    try {
      var user = await Dio().post('$api/ktp',
      data:{},
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (user.statusCode == 200 && user.data != '') {
        return json.encode(user.data);
      }
      else {
        print('getUser False');
        return false;
      }
    } catch (error) {
      print('getUser Error');
      return error;
    }
  }
}