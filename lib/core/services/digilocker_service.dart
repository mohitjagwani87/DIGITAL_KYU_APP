import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'deep_link_handler.dart';

class DigiLockerService {
  static const String _baseUrl =
      'https://api.digitallocker.gov.in/public/oauth2/1/';
  static const String clientId = 'YOUR_CLIENT_ID';
  static const String clientSecret = 'YOUR_CLIENT_SECRET';
  static const String redirectUri = 'jaaduservices://digilocker';

  static const String _tokenKey = 'digilocker_access_token';
  static const String _userDataKey = 'digilocker_user_data';

  Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_tokenKey);
  }

  Future<void> initiateDigiLockerAuth() async {
    final Uri authUrl = Uri.parse(
      '${_baseUrl}authorize?response_type=code&client_id=$clientId&redirect_uri=$redirectUri&state=state',
    );

    if (await canLaunchUrl(authUrl)) {
      await launchUrl(authUrl, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch DigiLocker authorization';
    }
  }

  Future<String?> _getStoredToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> _storeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<String> getAccessToken() async {
    // Check if we have a stored token
    final storedToken = await _getStoredToken();
    if (storedToken != null) {
      return storedToken;
    }

    // Get auth code from deep link handler
    final authCode = await DeepLinkHandler.getDigiLockerAuthCode();
    if (authCode == null) {
      throw Exception('No authorization code available');
    }

    // Exchange auth code for token
    final response = await http.post(
      Uri.parse('${_baseUrl}token'),
      body: {
        'code': authCode,
        'grant_type': 'authorization_code',
        'client_id': clientId,
        'client_secret': clientSecret,
        'redirect_uri': redirectUri,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final token = data['access_token'];
      await _storeToken(token);
      return token;
    } else {
      throw Exception('Failed to get access token');
    }
  }

  Future<Map<String, dynamic>> fetchKYCDetails() async {
    final token = await getAccessToken();
    final response = await http.get(
      Uri.parse('${_baseUrl}ekyc'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Cache the user data
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userDataKey, json.encode(data));
      return data;
    } else {
      throw Exception('Failed to fetch KYC details');
    }
  }

  Future<List<dynamic>> fetchDocuments() async {
    final token = await getAccessToken();
    final response = await http.get(
      Uri.parse('${_baseUrl}documents'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['documents'] ?? [];
    } else {
      throw Exception('Failed to fetch documents');
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userDataKey);
  }
}
