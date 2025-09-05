import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DocumentKYCScreen extends StatefulWidget {
  const DocumentKYCScreen({super.key});

  @override
  State<DocumentKYCScreen> createState() => _DocumentKYCScreenState();
}

class _DocumentKYCScreenState extends State<DocumentKYCScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final bool _consentGiven = false;
  String? _selectedDocType;
  bool _isLoading = false;
  bool _isVerified = false;
  
  final List<String> _availableDocuments = [
    'Aadhaar Card',
    'PAN Card',
    'Driving License',
    'Voter ID',
    'Passport',
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
          'Document-based KYC',
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
          _buildDocumentSelectionPage(),
          _buildDocumentUploadPage(),
          _buildVerificationPage(),
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
        onPressed: _selectedDocType != null ? _nextPage : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[800],
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey[400],
        ),
        child: const Text('Continue'),
      );
    } else if (_currentPage == 1) {
      return ElevatedButton(
        onPressed: _nextPage,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[800],
          foregroundColor: Colors.white,
        ),
        child: const Text('Upload'),
      );
    } else if (_currentPage == 2) {
      return ElevatedButton(
        onPressed: _simulateVerification,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[800],
          foregroundColor: Colors.white,
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

  Widget _buildDocumentSelectionPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Document Type',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Please select the type of document you want to upload for KYC verification:',
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
      case 'Passport':
        return Icons.flight;
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
      case 'Passport':
        return 'Ministry of External Affairs';
      default:
        return '';
    }
  }

  Widget _buildDocumentUploadPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upload $_selectedDocType',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Please upload a clear photo of your $_selectedDocType for verification.',
            style: GoogleFonts.poppins(
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
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
                  'Important Guidelines',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[800],
                  ),
                ),
                const SizedBox(height: 8),
                _buildGuideline('Ensure the document is clearly visible'),
                _buildGuideline('All four corners should be visible'),
                _buildGuideline('Document should not be blurry or have glare'),
                _buildGuideline('File size should be less than 5MB'),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Center(
            child: Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300, width: 2),
                // Use a custom dash pattern with a BoxDecoration
                boxShadow: const [BoxShadow(color: Colors.transparent)],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cloud_upload,
                    size: 48,
                    color: Colors.blue[800],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Tap to upload document',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Supported formats: JPG, PNG, PDF',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                // In a real app, this would open the camera
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Camera functionality coming soon!'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              icon: const Icon(Icons.camera_alt),
              label: const Text('Take Photo'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideline(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.orange[800],
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Document Verification',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'We are verifying your document. This may take a few moments.',
            style: GoogleFonts.poppins(
              fontSize: 14,
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
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getDocumentIcon(_selectedDocType ?? ''),
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
                            _selectedDocType ?? 'Document',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Uploaded successfully',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.check_circle,
                      color: Colors.green[600],
                      size: 24,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Center(
            child: Column(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: _isLoading
                        ? CircularProgressIndicator(
                            color: Colors.blue[800],
                          )
                        : Icon(
                            Icons.document_scanner,
                            color: Colors.blue[800],
                            size: 60,
                          ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  _isLoading
                      ? 'Verifying document...'
                      : 'Ready to verify',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _isLoading
                      ? 'This may take a few moments'
                      : 'Click the Verify button to proceed',
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
            'Your KYC verification has been completed successfully.',
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
                  value: 'DOC-KYC-${DateTime.now().millisecondsSinceEpoch.toString().substring(0, 8)}',
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