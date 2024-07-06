import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:html' as html;

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


  //store booking detail
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

  Future<dynamic> storeKtp(String token, String filePath, {Uint8List? webFile}) async {
    try {
      FormData formData = FormData();

      if (kIsWeb && webFile != null) {
        formData.files.add(MapEntry(
          'ktp',
          MultipartFile.fromBytes(webFile, filename: 'ktp.png'),
        ));
      } else {
        formData.files.add(MapEntry(
          'ktp',
          await MultipartFile.fromFile(filePath, filename: filePath.split('/').last),
        ));
      }

      var response = await Dio().post('$api/ktp',
          data: formData,
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      return response;
    } catch (error) {
      if (error is DioError) {
        return error.response ?? error.message;
      } else {
        return error.toString();
      }
    }
  }

  // Get KTP image
  Future<dynamic> getKtp(String token) async {
    try {
      var response = await Dio().get('$api/ktp',
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      return response;
    } catch (error) {
      if (error is DioError) {
        return error.response ?? error.message;
      } else {
        return error.toString();
      }
    }
  }


  Future<dynamic> getSoap(int appointmentId, String token) async {
    try {
      var response = await Dio().get('$api/soap/$appointmentId',
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200 && response.data != '') {
        return json.encode(response.data);
      } else {
        return 'Error GetSoap';
      }
    } catch (error) {
      return error;
    }
  }

  Future<dynamic> saveSoap(
    int appointmentId,
    String subjective,
    String objective,
    String assessment,
    String planning,
    String resep,
    String token,
  ) async {
    try {
      var response = await Dio().post('$api/soap',
          data: {
            'appoint_id': appointmentId,
            'subjective': subjective,
            'objective': objective,
            'assessment': assessment,
            'planning': planning,
            'resep': resep
          },
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200 && response.data != '') {
        // await updateAppointmentStatus(appointmentId, token);
        return response.statusCode;
      } else {
        return 'Error SaveSoap';
      }
    } catch (error) {
      return error;
    }
  }

  Future<dynamic> updateAppointmentStatus(int appointmentId, String status, String token) async {
    try {
      var response = await Dio().put('$api/appointments/$appointmentId/status',
          data: {'status': status},
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200 && response.data != '') {
        return response.statusCode;
      } else {
        return 'Error UpdateAppointmentStatus';
      }
    } catch (error) {
      return error;
    }
  }
  Future<dynamic> updateAppointmentDetails(int appointmentId, String date, String day, String time, String token) async {
  try {
    var response = await Dio().put('$api/appointments/$appointmentId/details',
        data: {'date': date, 'day': day, 'time': time},
        options: Options(headers: {'Authorization': 'Bearer $token'}));

    if (response.statusCode == 200 && response.data != '') {
      return response.statusCode;
    } else {
      return 'Error UpdateAppointmentDetails';
    }
  } catch (error) {
    return error;
  }
}
  Future<dynamic> verifyUser(String token, int userId, String nik, String namaAsli, String tglLahir, String alamat, String agama, String pekerjaan) async {
    try {
      var response = await Dio().post('$api/admisi/verify',
          data: {
            'user_id': userId,
            'nik': nik,
            'nama_asli': namaAsli,
            'tgl_lahir': tglLahir,
            'alamat': alamat,
            'agama': agama,
            'perkerjaan': pekerjaan,
          },
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      return response.statusCode;
    } catch (error) {
      return 'Error';
    }
  }
Future<dynamic> getUnverifiedUsers(String token) async {
    try {
      var response = await Dio().get('$api/admisi/unverified',
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      return json.encode(response.data);
    } catch (error) {
      return 'Error';
    }
  }
  Future<dynamic> getPasienDetails(String token, int userId) async {
    try {
      var response = await Dio().get('$api/pasien/details/$userId',
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      return response;
    } catch (error) {
      if (error is DioError) {
        return error.response ?? error.message;
      } else {
        return error.toString();
      }
    }
  }
  
}