import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sky_techiez/models/ticket.dart';
import 'package:http/http.dart' as http;
import 'package:sky_techiez/screens/ticket_status_screen.dart';
import 'package:sky_techiez/services/ticket_service.dart';
import 'package:sky_techiez/theme/app_theme.dart';
import 'package:sky_techiez/widgets/custom_button.dart';
import 'package:sky_techiez/widgets/custom_text_field.dart';
import 'package:sky_techiez/widgets/session_string.dart';
import 'package:url_launcher/url_launcher.dart';

class CreateTicketScreen extends StatefulWidget {
  const CreateTicketScreen({super.key});

  @override
  State<CreateTicketScreen> createState() => _CreateTicketScreenState();
}

class _CreateTicketScreenState extends State<CreateTicketScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedCategory = 'Other';
  String? _selectedTechnicalSupportType;
  final String _selectedPriority = 'Medium';
  Map<String, String> _categoriesMap = {};
  List<String> _categories = [];
  bool _isLoadingCategories = true;
  Map<String, String> _subcategoriesMap = {};
  bool _isLoadingSubcategories = false;
  File? _attachment;
  final ImagePicker _picker = ImagePicker();
  bool _isSubmitting = false;
  bool _isCallingTNF = false;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    print('Fetching categories...');
    var headers = {
      'X-Requested-With': 'XMLHttpRequest',
      'Authorization': (GetStorage().read(tokenKey) ?? '').toString(),
    };

    try {
      var request = http.MultipartRequest(
        'GET',
        Uri.parse('https://tech.skytechiez.co/api/ticket-category-dropdown'),
      );
      request.headers.addAll(headers);
      print('Sending categories request with headers: $headers');

      http.StreamedResponse response = await request.send();
      print('Categories response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final String responseBody = await response.stream.bytesToString();
        print('Categories response body: $responseBody');
        final data = json.decode(responseBody);

        if (!mounted) return; // Check if widget is still mounted

        setState(() {
          _categoriesMap = Map<String, String>.from(data['ticket_categories']);
          _categories = _categoriesMap.values.toList();
          _selectedCategory = _categories.isNotEmpty ? _categories.first : '';
          _isLoadingCategories = false;
        });

        String? selectedCategoryId = _getCategoryIdByName(_selectedCategory);
        print('Selected category ID: $selectedCategoryId');
        if (selectedCategoryId != null && mounted) {
          _fetchSubcategories(selectedCategoryId);
        }
      } else {
        print('Categories request failed: ${response.reasonPhrase}');
        if (!mounted) return; // Check if widget is still mounted
        setState(() {
          _isLoadingCategories = false;
          _categories = [
            'Other',
            'Account Related Issue',
            'Billing Related Issue'
          ];
          _selectedCategory = 'Other';
          _categoriesMap = {
            '4': 'Other',
            '6': 'Account Related Issue',
            '7': 'Billing Related Issue',
          };
        });
      }
    } catch (e) {
      print('Error fetching categories: $e');
      if (!mounted) return; // Check if widget is still mounted
      setState(() {
        _isLoadingCategories = false;
        _categories = [
          'Other',
          'Account Related Issue',
          'Billing Related Issue'
        ];
        _selectedCategory = 'Other';
        _categoriesMap = {
          '4': 'Other',
          '6': 'Account Related Issue',
          '7': 'Billing Related Issue',
        };
      });
    }
  }

  Future<void> _fetchSubcategories(String categoryId) async {
    print('Fetching subcategories for category ID: $categoryId');
    if (!mounted) return; // Check if widget is still mounted

    setState(() {
      _isLoadingSubcategories = true;
      _selectedTechnicalSupportType = null;
    });

    var headers = {
      'X-Requested-With': 'XMLHttpRequest',
      'Authorization': (GetStorage().read(tokenKey) ?? '').toString(),
    };

    try {
      var request = http.Request(
        'GET',
        Uri.parse(
            'https://tech.skytechiez.co/api/get-subcategory-dropdown/$categoryId'),
      );
      request.headers.addAll(headers);
      print('Sending subcategories request with headers: $headers');

      http.StreamedResponse response = await request.send();
      print('Subcategories response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final String responseBody = await response.stream.bytesToString();
        print('Subcategories response body: $responseBody');
        final data = json.decode(responseBody);

        if (!mounted) return; // Check if widget is still mounted

        setState(() {
          _subcategoriesMap = Map<String, String>.from(data['subcategories']);
          _isLoadingSubcategories = false;
          if (_subcategoriesMap.isNotEmpty) {
            _selectedTechnicalSupportType = _subcategoriesMap.values.first;
          }
          print('Loaded ${_subcategoriesMap.length} subcategories');
        });
      } else {
        print('Subcategories request failed: ${response.reasonPhrase}');
        if (!mounted) return; // Check if widget is still mounted
        setState(() {
          _isLoadingSubcategories = false;
        });
      }
    } catch (e) {
      print('Error fetching subcategories: $e');
      if (!mounted) return; // Check if widget is still mounted
      setState(() {
        _isLoadingSubcategories = false;
      });
    }
  }

  // New method to fetch settings and get toll-free number
  Future<void> _callTollFreeNumber() async {
    if (!mounted) return;

    setState(() {
      _isCallingTNF = true;
    });

    try {
      var headers = {
        'X-Requested-With': 'XMLHttpRequest',
        'Authorization': (GetStorage().read(tokenKey) ?? '').toString(),
      };

      var request = http.MultipartRequest(
          'GET', Uri.parse('https://tech.skytechiez.co/api/settings'));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final String responseBody = await response.stream.bytesToString();
        print('Settings response: $responseBody');

        final data = json.decode(responseBody);
        final settings = data['settings'] as List;

        // Find toll-free number from settings
        String? tollFreeNumber;
        for (var setting in settings) {
          if (setting['key'] == 'toll_free_number') {
            tollFreeNumber = setting['value'];
            break;
          }
        }

        if (tollFreeNumber != null && tollFreeNumber.isNotEmpty) {
          await _makePhoneCall(tollFreeNumber);
        } else {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Toll-free number not found'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        print('Settings request failed: ${response.reasonPhrase}');
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Failed to get contact information: ${response.reasonPhrase}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error calling TNF: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isCallingTNF = false;
        });
      }
    }
  }

  // Method to make the actual phone call
  Future<void> _makePhoneCall(String phoneNumber) async {
    try {
      // Remove any formatting and keep only numbers and +
      final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
      final Uri phoneUri = Uri(scheme: 'tel', path: cleanNumber);

      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not launch phone dialer'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error making phone call: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error making call: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // final List<String> _priorities = [
  //   'Low',
  //   'Medium',
  //   'High',
  //   'Critical',
  // ];

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String _generateTicketId() {
    final now = DateTime.now();
    final timestamp = now.millisecondsSinceEpoch.toString().substring(6);
    return 'TKT-${now.year}-$timestamp';
  }

  Future<void> _pickImage() async {
    try {
      print('Picking image...');
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        print('Selected image: ${pickedFile.path}');
        if (!mounted) return; // Check if widget is still mounted
        setState(() {
          _attachment = File(pickedFile.path);
        });
      } else {
        print('No image selected');
      }
    } catch (e) {
      print('Image picker error: $e');
      if (!mounted) return; // Check if widget is still mounted
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _createTicket() async {
    if (_formKey.currentState!.validate()) {
      // Validate technical support type is selected when subcategories exist
      if (_subcategoriesMap.isNotEmpty &&
          _selectedTechnicalSupportType == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a support type'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      print('Form validated, creating ticket...');
      if (!mounted) return; // Check if widget is still mounted

      setState(() {
        _isSubmitting = true;
      });

      try {
        // Get category ID
        String? categoryId = _getCategoryIdByName(_selectedCategory);
        categoryId ??= '4'; // Default to 'Other' if not found
        print('Category ID for $_selectedCategory: $categoryId');

        var headers = {
          'X-Requested-With': 'XMLHttpRequest',
          'Authorization': (GetStorage().read(tokenKey) ?? '').toString(),
          'Accept': 'application/json',
        };

        var request = http.MultipartRequest(
          'POST',
          Uri.parse('https://tech.skytechiez.co/api/create-ticket'),
        );

        // Add fields
        Map<String, String> fields = {
          'subject': _subjectController.text,
          'description': _descriptionController.text,
          'category_id': categoryId,
          'priority': _selectedPriority,
          'category_name': _selectedCategory,
        };

        // Add subcategory if available
        if (_selectedTechnicalSupportType != null) {
          String? subcategoryId =
              _getSubcategoryIdByName(_selectedTechnicalSupportType!);
          fields['category_sub_id'] = subcategoryId ?? '';
          // fields['sub_category_name'] = _selectedTechnicalSupportType!;
        }

        request.fields.addAll(fields);
        print('Ticket request fields: ${request.fields}');

        // Add attachment if exists
        if (_attachment != null) {
          print('Adding attachment: ${_attachment!.path}');
          request.files.add(
            await http.MultipartFile.fromPath(
              'attachment',
              _attachment!.path,
            ),
          );
        }

        request.headers.addAll(headers);
        print('Sending ticket request with headers: $headers');

        http.StreamedResponse response = await request.send();
        print('Ticket creation response status: ${response.statusCode}');

        final responseBody = await response.stream.bytesToString();
        print('Ticket creation response: $responseBody');

        if (!mounted) return; // Check if widget is still mounted

        if (response.statusCode == 200 || response.statusCode == 201) {
          json.decode(responseBody);

          // Create local ticket with proper null handling
          final newTicket = Ticket(
            id: null,
            ticketId: _generateTicketId(),
            subject: _subjectController.text,
            categoryName: _selectedCategory,
            subcategoryName: _selectedTechnicalSupportType,
            priority: _selectedPriority,
            description: _descriptionController.text,
            status: 'New',
            date: DateFormat('MMM dd, yyyy').format(DateTime.now()),
            categoryId: categoryId,
            subcategoryId: _selectedTechnicalSupportType != null
                ? _getSubcategoryIdByName(_selectedTechnicalSupportType!)
                : null,
          );

          TicketService.addTicket(newTicket);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ticket created successfully!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const TicketStatusScreen(),
            ),
          );
        } else {
          String errorMessage = 'Failed to create ticket';
          try {
            final errorData = json.decode(responseBody);
            if (errorData['message'] != null) {
              errorMessage = errorData['message'];
            } else if (errorData['error'] != null) {
              errorMessage = errorData['error'];
            }
          } catch (e) {
            errorMessage = 'Failed to create ticket: ${response.reasonPhrase}';
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        print('Ticket creation exception: $e');
        if (!mounted) return; // Check if widget is still mounted
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isSubmitting = false;
          });
        }
      }
    }
  }

  String? _getCategoryIdByName(String categoryName) {
    String? categoryId;
    _categoriesMap.forEach((key, value) {
      if (value == categoryName) {
        categoryId = key;
      }
    });
    return categoryId;
  }

  String? _getSubcategoryIdByName(String subcategoryName) {
    String? subcategoryId;
    _subcategoriesMap.forEach((key, value) {
      if (value == subcategoryName) {
        subcategoryId = key;
      }
    });
    return subcategoryId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Ticket'),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          _fetchCategories();
          _selectedCategory = 'Other';
          _selectedTechnicalSupportType = null;
          _isLoadingCategories = true;
          _isLoadingSubcategories = false;
          _categories = [];
          _subcategoriesMap = {};
          _subjectController.clear();
          _descriptionController.clear();
          _attachment = null;
          return Future.value();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/SkyLogo.png',
                    height: 120,
                  ),
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  label: 'Enter Name',
                  hint: 'Enter Your Name',
                  controller: _subjectController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a subject';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Category',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.lightGrey,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: _isLoadingCategories
                            ? const Center(child: CircularProgressIndicator())
                            : DropdownButton<String>(
                                value: _selectedCategory,
                                isExpanded: true,
                                dropdownColor: AppColors.darkBackground,
                                style: const TextStyle(color: AppColors.white),
                                hint: const Text('Select Category'),
                                items: _categories.map((String category) {
                                  return DropdownMenuItem<String>(
                                    value: category,
                                    child: Text(category),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    print('Category changed to: $newValue');
                                    setState(() {
                                      _selectedCategory = newValue;
                                      String? categoryId =
                                          _getCategoryIdByName(newValue);
                                      if (categoryId != null) {
                                        _fetchSubcategories(categoryId);
                                      } else {
                                        _selectedTechnicalSupportType = null;
                                      }
                                    });
                                  }
                                },
                              ),
                      ),
                    ),
                  ],
                ),
                if (_subcategoriesMap.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Support Type',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: AppColors.lightGrey,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: _isLoadingSubcategories
                              ? const Center(child: CircularProgressIndicator())
                              : DropdownButton<String>(
                                  value: _selectedTechnicalSupportType,
                                  isExpanded: true,
                                  dropdownColor: AppColors.darkBackground,
                                  style:
                                      const TextStyle(color: AppColors.white),
                                  hint: const Text('Select Support Type'),
                                  items: _subcategoriesMap.values
                                      .map((String type) {
                                    return DropdownMenuItem<String>(
                                      value: type,
                                      child: Text(type),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    if (newValue != null) {
                                      print(
                                          'Support Type changed to: $newValue');
                                      setState(() {
                                        _selectedTechnicalSupportType =
                                            newValue;
                                      });
                                    }
                                  },
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const Text(
                    //   'Priority',
                    //   style: TextStyle(
                    //     fontSize: 14,
                    //     fontWeight: FontWeight.w500,
                    //     color: AppColors.white,
                    //   ),
                    // ),
                    const SizedBox(height: 8),
                    // Container(
                    //   padding: const EdgeInsets.symmetric(horizontal: 16),
                    //   decoration: BoxDecoration(
                    //     color: AppColors.lightGrey,
                    //     borderRadius: BorderRadius.circular(8),
                    //   ),
                    //   child: DropdownButtonHideUnderline(
                    //     child: DropdownButton<String>(
                    //       value: _selectedPriority,
                    //       isExpanded: true,
                    //       dropdownColor: AppColors.darkBackground,
                    //       style: const TextStyle(color: AppColors.white),
                    //       hint: const Text('Select Priority'),
                    //       items: _priorities.map((String priority) {
                    //         return DropdownMenuItem<String>(
                    //           value: priority,
                    //           child: Text(priority),
                    //         );
                    //       }).toList(),
                    //       onChanged: (String? newValue) {
                    //         if (newValue != null) {
                    //           print('Priority changed to: $newValue');
                    //           setState(() {
                    //             _selectedPriority = newValue;
                    //           });
                    //         }
                    //       },
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 5,
                      style: const TextStyle(color: AppColors.white),
                      decoration: const InputDecoration(
                        hintText: 'Describe your issue in detail',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Attachments',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.lightGrey,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.grey,
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Column(
                          children: [
                            _attachment != null
                                ? Image.file(
                                    _attachment!,
                                    height: 100,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(
                                    Icons.cloud_upload,
                                    size: 48,
                                    color: AppColors.grey,
                                  ),
                            const SizedBox(height: 8),
                            Text(
                              _attachment != null
                                  ? _attachment!.path.split('/').last
                                  : 'Drag and drop files here or click to browse',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: AppColors.grey,
                              ),
                            ),
                            const SizedBox(height: 16),
                            OutlinedButton(
                              onPressed: _pickImage,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.primaryBlue,
                                side: const BorderSide(
                                    color: AppColors.primaryBlue),
                              ),
                              child: const Text('Browse Files'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Updated button section with both Submit and Call buttons
                Row(
                  children: [
                    // Submit Button
                    Expanded(
                      flex: 2,
                      child: CustomButton(
                        text: 'Submit Ticket',
                        onPressed: _isSubmitting ? null : _createTicket,
                        isLoading: _isSubmitting,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Call Button
                    // Expanded(
                    //   flex: 1,
                    //   child: Container(
                    //     height: 48, // Match the height of CustomButton
                    //     child: ElevatedButton.icon(
                    //       onPressed: _isCallingTNF ? null : _callTollFreeNumber,
                    //       icon: _isCallingTNF
                    //           ? const SizedBox(
                    //               width: 16,
                    //               height: 16,
                    //               child: CircularProgressIndicator(
                    //                 strokeWidth: 2,
                    //                 valueColor: AlwaysStoppedAnimation<Color>(
                    //                     Colors.white),
                    //               ),
                    //             )
                    //           : const Icon(
                    //               Icons.phone,
                    //               size: 18,
                    //               color: Colors.white,
                    //             ),
                    //       label: Text(
                    //         _isCallingTNF ? 'Calling...' : 'Call',
                    //         style: const TextStyle(
                    //           color: Colors.white,
                    //           fontSize: 14,
                    //           fontWeight: FontWeight.w500,
                    //         ),
                    //       ),
                    //       style: ElevatedButton.styleFrom(
                    //         backgroundColor: Colors.green,
                    //         disabledBackgroundColor:
                    //             Colors.green.withOpacity(0.6),
                    //         shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(8),
                    //         ),
                    //         elevation: 0,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
