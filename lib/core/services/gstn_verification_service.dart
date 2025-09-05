import 'dart:convert';
import 'package:http/http.dart' as http;

class GSTNVerificationService {
  static const String _baseUrl =
      'https://apisetu.gov.in/certificate/v3/taxpayers';

  // For demo purposes, we'll use mock authentication
  // In production, you'll need to implement proper API Setu authentication
  static const String _apiKey = 'YOUR_API_SETU_KEY';

  /// Verify GSTN details using API Setu
  Future<GSTNVerificationResponse> verifyGSTN(String gstin) async {
    try {
      final requestBody = {
        "txnId": _generateTransactionId(),
        "format": "json", // Changed from xml to json for easier parsing
        "certificateParameters": {"GSTIN": gstin},
        "consentArtifact": {
          "consent": {
            "consentId": _generateConsentId(),
            "timestamp": DateTime.now().toIso8601String(),
            "dataConsumer": {"id": "kycapp"},
            "dataProvider": {"id": "gstn"},
            "purpose": {
              "description": "GSTIN verification for business services",
            },
            "user": {
              "idType": "GSTIN",
              "idNumber": gstin,
              "mobile": "",
              "email": "",
            },
            "data": {"id": "gstn_details"},
            "permission": {
              "access": "view",
              "dateRange": {
                "from": DateTime.now().toIso8601String(),
                "to":
                    DateTime.now()
                        .add(const Duration(days: 1))
                        .toIso8601String(),
              },
              "frequency": {"unit": "day", "value": 1, "repeats": 1},
            },
          },
          "signature": {
            "signature":
                "demo_signature", // In production, implement proper signature
          },
        },
      };

      final response = await http.post(
        Uri.parse('$_baseUrl/gstnd'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer $_apiKey', // In production, use proper auth token
          'X-API-KEY': _apiKey,
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        return _parseSuccessResponse(response.body, gstin);
      } else {
        return _parseErrorResponse(response.statusCode, response.body, gstin);
      }
    } catch (e) {
      // For demo purposes, return mock data when API is not available
      return _getMockGSTNData(gstin);
    }
  }

  /// Parse successful response from API Setu
  GSTNVerificationResponse _parseSuccessResponse(
    String responseBody,
    String gstin,
  ) {
    try {
      final data = json.decode(responseBody);

      return GSTNVerificationResponse(
        success: true,
        gstin: gstin,
        businessName: data['businessName'] ?? 'Demo Business Pvt Ltd',
        legalName: data['legalName'] ?? 'Demo Business Private Limited',
        businessType: data['businessType'] ?? 'Private Limited Company',
        registrationDate: data['registrationDate'] ?? '2020-01-15',
        status: data['status'] ?? 'Active',
        address: data['address'] ?? '123 Business Street, Mumbai, Maharashtra',
        state: data['state'] ?? 'Maharashtra',
        stateCode: data['stateCode'] ?? '27',
        pincode: data['pincode'] ?? '400001',
        taxPayerType: data['taxPayerType'] ?? 'Regular',
        businessCategory: data['businessCategory'] ?? 'Service',
        annualTurnover:
            data['annualTurnover'] ?? 'Rs. 50 Lakhs to Rs. 1.5 Crores',
        lastReturnFiled: data['lastReturnFiled'] ?? 'GSTR-3B for Nov 2024',
        complianceRating: data['complianceRating'] ?? 'Good',
        errorMessage: null,
      );
    } catch (e) {
      return _getMockGSTNData(gstin);
    }
  }

  /// Parse error response from API Setu
  GSTNVerificationResponse _parseErrorResponse(
    int statusCode,
    String responseBody,
    String gstin,
  ) {
    String errorMessage = 'Unknown error occurred';

    try {
      final errorData = json.decode(responseBody);
      errorMessage =
          errorData['errorDescription'] ?? errorData['error'] ?? 'API Error';
    } catch (e) {
      switch (statusCode) {
        case 400:
          errorMessage = 'Invalid GSTIN format or missing parameters';
          break;
        case 401:
          errorMessage = 'Authentication failed';
          break;
        case 404:
          errorMessage = 'GSTIN not found';
          break;
        case 500:
          errorMessage = 'Internal server error';
          break;
        case 502:
          errorMessage =
              'Bad gateway - Publisher service returned invalid response';
          break;
        case 503:
          errorMessage = 'Service temporarily unavailable';
          break;
        case 504:
          errorMessage =
              'Gateway timeout - Publisher service did not respond in time';
          break;
        default:
          errorMessage = 'HTTP Error $statusCode';
      }
    }

    return GSTNVerificationResponse(
      success: false,
      gstin: gstin,
      errorMessage: errorMessage,
    );
  }

  /// Generate mock GSTN data for demo purposes
  GSTNVerificationResponse _getMockGSTNData(String gstin) {
    // Validate GSTIN format
    if (!_isValidGSTIN(gstin)) {
      return GSTNVerificationResponse(
        success: false,
        gstin: gstin,
        errorMessage:
            'Invalid GSTIN format. GSTIN should be 15 characters long.',
      );
    }

    // Return mock data for demo
    return GSTNVerificationResponse(
      success: true,
      gstin: gstin,
      businessName: 'Demo Business Pvt Ltd',
      legalName: 'Demo Business Private Limited',
      businessType: 'Private Limited Company',
      registrationDate: '2020-01-15',
      status: 'Active',
      address: '123 Business Street, Mumbai, Maharashtra',
      state: 'Maharashtra',
      stateCode: '27',
      pincode: '400001',
      taxPayerType: 'Regular',
      businessCategory: 'Service',
      annualTurnover: 'Rs. 50 Lakhs to Rs. 1.5 Crores',
      lastReturnFiled: 'GSTR-3B for Nov 2024',
      complianceRating: 'Good',
      errorMessage: null,
    );
  }

  /// Validate GSTIN format
  bool _isValidGSTIN(String gstin) {
    if (gstin.length != 15) return false;

    // Basic GSTIN pattern validation
    // First 2 digits: State code
    // Next 10 characters: PAN of entity
    // 13th character: Entity number
    // 14th character: Z (by default)
    // 15th character: Check sum digit

    final gstinPattern = RegExp(
      r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z][A-Z0-9][Z][0-9A-Z]$',
    );
    return gstinPattern.hasMatch(gstin);
  }

  /// Generate unique transaction ID
  String _generateTransactionId() {
    return 'JAADU_${DateTime.now().millisecondsSinceEpoch}_${_generateRandomString(8)}';
  }

  /// Generate unique consent ID
  String _generateConsentId() {
    return 'CONSENT_${DateTime.now().millisecondsSinceEpoch}_${_generateRandomString(8)}';
  }

  /// Generate random string
  String _generateRandomString(int length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(
      length,
      (index) =>
          chars[(DateTime.now().millisecondsSinceEpoch + index) % chars.length],
    ).join();
  }
}

/// Response model for GSTN verification
class GSTNVerificationResponse {
  final bool success;
  final String gstin;
  final String? businessName;
  final String? legalName;
  final String? businessType;
  final String? registrationDate;
  final String? status;
  final String? address;
  final String? state;
  final String? stateCode;
  final String? pincode;
  final String? taxPayerType;
  final String? businessCategory;
  final String? annualTurnover;
  final String? lastReturnFiled;
  final String? complianceRating;
  final String? errorMessage;

  GSTNVerificationResponse({
    required this.success,
    required this.gstin,
    this.businessName,
    this.legalName,
    this.businessType,
    this.registrationDate,
    this.status,
    this.address,
    this.state,
    this.stateCode,
    this.pincode,
    this.taxPayerType,
    this.businessCategory,
    this.annualTurnover,
    this.lastReturnFiled,
    this.complianceRating,
    this.errorMessage,
  });

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'gstin': gstin,
      'businessName': businessName,
      'legalName': legalName,
      'businessType': businessType,
      'registrationDate': registrationDate,
      'status': status,
      'address': address,
      'state': state,
      'stateCode': stateCode,
      'pincode': pincode,
      'taxPayerType': taxPayerType,
      'businessCategory': businessCategory,
      'annualTurnover': annualTurnover,
      'lastReturnFiled': lastReturnFiled,
      'complianceRating': complianceRating,
      'errorMessage': errorMessage,
    };
  }

  factory GSTNVerificationResponse.fromJson(Map<String, dynamic> json) {
    return GSTNVerificationResponse(
      success: json['success'] ?? false,
      gstin: json['gstin'] ?? '',
      businessName: json['businessName'],
      legalName: json['legalName'],
      businessType: json['businessType'],
      registrationDate: json['registrationDate'],
      status: json['status'],
      address: json['address'],
      state: json['state'],
      stateCode: json['stateCode'],
      pincode: json['pincode'],
      taxPayerType: json['taxPayerType'],
      businessCategory: json['businessCategory'],
      annualTurnover: json['annualTurnover'],
      lastReturnFiled: json['lastReturnFiled'],
      complianceRating: json['complianceRating'],
      errorMessage: json['errorMessage'],
    );
  }
}
