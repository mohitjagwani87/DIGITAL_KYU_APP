import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DigilockerKYCScreen extends StatefulWidget {
  const DigilockerKYCScreen({super.key});

  @override
  State<DigilockerKYCScreen> createState() => _DigilockerKYCScreenState();
}

class _DigilockerKYCScreenState extends State<DigilockerKYCScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _consentGiven = false;
  String? _selectedDocType;
  bool _isLoading = false;
  bool _isVerified = false;
  
  final List<String> _availableDocuments = [
    'Aadhaar Card',
    'PAN Card',
    'Driving License',
    'Voter ID',
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _simulateVerification() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      _isVerified = true;
    });

    // Navigate to success page after verification
    if (_isVerified) {
      _nextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Digilocker KYC',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (int page) {
          setState(() {
            _currentPage = page;
          });
        },
        children: [
          _buildAuthenticationPage(),
          _buildConsentPage(),
          _buildDocumentSelectionPage(),
          _buildVerificationResultPage(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _currentPage > 0
                  ? ElevatedButton(
                      onPressed: _previousPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black87,
                      ),
                      child: const Text('Back'),
                    )
                  : const SizedBox(width: 80),
              Text(
                'Step ${_currentPage + 1} of 4',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              _buildNextButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    if (_currentPage == 0) {
      return ElevatedButton(
        onPressed: _nextPage,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[800],
          foregroundColor: Colors.white,
        ),
        child: const Text('Proceed'),
      );
    } else if (_currentPage == 1) {
      return ElevatedButton(
        onPressed: _consentGiven ? _nextPage : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[800],
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey[400],
        ),
        child: const Text('Continue'),
      );
    } else if (_currentPage == 2) {
      return ElevatedButton(
        onPressed: _selectedDocType != null ? _simulateVerification : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[800],
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey[400],
        ),
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text('Verify'),
      );
    } else {
      return ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green[600],
          foregroundColor: Colors.white,
        ),
        child: const Text('Finish'),
      );
    }
  }

  Widget _buildAuthenticationPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.asset(
              'assets/images/jaadu_logo.png',
              height: 80,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Authenticate with Digilocker',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'To proceed with Digilocker KYC, you need to authenticate with your Digilocker account.',
            style: GoogleFonts.poppins(
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'What is Digilocker?',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'DigiLocker is a secure cloud-based platform for storage, sharing and verification of documents & certificates provided by the Government of India.',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                // In a real app, this would initiate the Digilocker OAuth flow
                _nextPage();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              icon: const Icon(Icons.login),
              label: const Text('Login with Digilocker'),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: () {
                // In a real app, this would open a help page
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Help functionality coming soon!'),
                  ),
                );
              },
              child: Text(
                'Need help?',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.blue[800],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConsentPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Consent for Document Access',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Important Information',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[800],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'We need your consent to access your documents from Digilocker for KYC verification purposes.',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'By providing consent, you authorize us to:',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          _buildConsentItem(
            icon: Icons.file_copy_outlined,
            title: 'Access your documents',
            description: 'We will only access the documents you select in the next step.',
          ),
          _buildConsentItem(
            icon: Icons.verified_user_outlined,
            title: 'Verify your identity',
            description: 'We will use your documents to verify your identity for KYC purposes.',
          ),
          _buildConsentItem(
            icon: Icons.security_outlined,
            title: 'Secure your data',
            description: 'Your data will be encrypted and stored securely as per regulations.',
          ),
          const SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Consent Declaration',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'I hereby consent to the access and processing of my documents from Digilocker for the purpose of KYC verification. I understand that my data will be handled in accordance with the privacy policy.',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: _consentGiven,
                      onChanged: (value) {
                        setState(() {
                          _consentGiven = value ?? false;
                        });
                      },
                      activeColor: Colors.blue[800],
                    ),
                    Expanded(
                      child: Text(
                        'I agree to the terms and provide my consent',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConsentItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Colors.blue[800],
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentSelectionPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Document for Verification',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Please select one document from your Digilocker for KYC verification:',
            style: GoogleFonts.poppins(
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          ..._availableDocuments.map((doc) => _buildDocumentOption(doc)),
          const SizedBox(height: 24),
          if (_selectedDocType != null) ...[            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green[600],
                    size: 24,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Document Selected',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'You have selected $_selectedDocType for verification',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDocumentOption(String documentType) {
    final bool isSelected = _selectedDocType == documentType;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDocType = documentType;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[50] : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue.shade400 : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue[100] : Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getDocumentIcon(documentType),
                color: isSelected ? Colors.blue[800] : Colors.grey[700],
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    documentType,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    _getDocumentDescription(documentType),
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: documentType,
              groupValue: _selectedDocType,
              onChanged: (value) {
                setState(() {
                  _selectedDocType = value;
                });
              },
              activeColor: Colors.blue[800],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getDocumentIcon(String documentType) {
    switch (documentType) {
      case 'Aadhaar Card':
        return Icons.fingerprint;
      case 'PAN Card':
        return Icons.credit_card;
      case 'Driving License':
        return Icons.drive_eta;
      case 'Voter ID':
        return Icons.how_to_vote;
      default:
        return Icons.description;
    }
  }

  String _getDocumentDescription(String documentType) {
    switch (documentType) {
      case 'Aadhaar Card':
        return 'Unique Identification Authority of India';
      case 'PAN Card':
        return 'Permanent Account Number';
      case 'Driving License':
        return 'Transport Authority';
      case 'Voter ID':
        return 'Election Commission of India';
      default:
        return '';
    }
  }

  Widget _buildVerificationResultPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.green[50],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle,
              color: Colors.green[600],
              size: 80,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Verification Successful!',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green[700],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Your KYC verification has been completed successfully using Digilocker.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildVerificationDetail(
                  title: 'Document Type',
                  value: _selectedDocType ?? 'Not selected',
                  icon: Icons.description,
                ),
                const Divider(),
                _buildVerificationDetail(
                  title: 'Verification ID',
                  value: 'DL-KYC-${DateTime.now().millisecondsSinceEpoch.toString().substring(0, 8)}',
                  icon: Icons.numbers,
                ),
                const Divider(),
                _buildVerificationDetail(
                  title: 'Timestamp',
                  value: DateTime.now().toString().substring(0, 16),
                  icon: Icons.access_time,
                ),
                const Divider(),
                _buildVerificationDetail(
                  title: 'Status',
                  value: 'Verified',
                  icon: Icons.verified,
                  valueColor: Colors.green[700],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info,
                      color: Colors.blue[800],
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'What happens next?',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Your KYC verification is now complete. You can proceed with using our services. A confirmation email has been sent to your registered email address.',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationDetail({
    required String title,
    required String value,
    required IconData icon,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.grey[600],
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: valueColor ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}