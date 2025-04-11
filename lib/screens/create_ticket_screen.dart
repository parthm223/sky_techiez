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

class CreateTicketScreen extends StatefulWidget {
  const CreateTicketScreen({super.key});

  @override
  State<CreateTicketScreen> createState() => _CreateTicketScreenState();
}

class _CreateTicketScreenState extends State<CreateTicketScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedCategory = 'Technical Support';
  String? _selectedTechnicalSupportType;
  String _selectedPriority = 'Medium';
  Map<String, String> _categoriesMap = {};
  List<String> _categories = [];
  bool _isLoadingCategories = true;
  Map<String, String> _subcategoriesMap = {};
  bool _isLoadingSubcategories = false;
  File? _attachment;
  final ImagePicker _picker = ImagePicker();
  bool _isSubmitting = false;

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
        Uri.parse('https://tech.skytechiez.co/api/issue-type-dropdown'),
      );

      request.headers.addAll(headers);
      print('Sending categories request with headers: $headers');

      http.StreamedResponse response = await request.send();
      print('Categories response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final String responseBody = await response.stream.bytesToString();
        print('Categories response body: $responseBody');
        final data = json.decode(responseBody);

        setState(() {
          _categoriesMap = Map<String, String>.from(data['issue_types']);
          _categories = _categoriesMap.values.toList();
          _selectedCategory = _categories.isNotEmpty ? _categories.first : '';
          _isLoadingCategories = false;

          // Find the ID for the selected category
          String? selectedCategoryId = _getCategoryIdByName(_selectedCategory);
          print('Selected category ID: $selectedCategoryId');

          // If the selected category has key "1", fetch subcategories
          if (selectedCategoryId == '1') {
            _fetchSubcategories(selectedCategoryId!);
          }
        });
      } else {
        print('Categories request failed: ${response.reasonPhrase}');
        setState(() {
          _isLoadingCategories = false;
          _categories = ['Technical Support', 'Account Management']; // Fallback
          _selectedCategory = 'Technical Support';
          _categoriesMap = {
            '1': 'Technical Support',
            '2': 'Account Management',
          };
        });
      }
    } catch (e) {
      print('Error fetching categories: $e');
      setState(() {
        _isLoadingCategories = false;
        _categories = ['Technical Support', 'Account Management']; // Fallback
        _selectedCategory = 'Technical Support';
        _categoriesMap = {
          '1': 'Technical Support',
          '2': 'Account Management',
        };
      });
    }
  }

  Future<void> _fetchSubcategories(String categoryId) async {
    print('Fetching subcategories for category ID: $categoryId');
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
        setState(() {
          _isLoadingSubcategories = false;
        });
      }
    } catch (e) {
      print('Error fetching subcategories: $e');
      setState(() {
        _isLoadingSubcategories = false;
      });
    }
  }

  final List<String> _priorities = [
    'Low',
    'Medium',
    'High',
    'Critical',
  ];

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
        setState(() {
          _attachment = File(pickedFile.path);
        });
      } else {
        print('No image selected');
      }
    } catch (e) {
      print('Image picker error: $e');
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
      print('Form validated, creating ticket...');
      setState(() {
        _isSubmitting = true;
      });

      try {
        // Get category ID
        String categoryId = _getCategoryIdByName(_selectedCategory) ?? '1';
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
        };

        // Only add subcategory_id if the category is "Technical Support" (key "1")
        if (categoryId == '1' &&
            _selectedTechnicalSupportType != null &&
            _subcategoriesMap.isNotEmpty) {
          fields['subcategory_id'] =
              _getSubcategoryIdByName(_selectedTechnicalSupportType!) ?? '';
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

        if (response.statusCode == 200 || response.statusCode == 201) {
          json.decode(responseBody);

          // Create local ticket
          final newTicket = Ticket(
            id: _generateTicketId(),
            subject: _subjectController.text,
            category: _selectedCategory,
            technicalSupportType: _selectedTechnicalSupportType,
            priority: _selectedPriority,
            description: _descriptionController.text,
            status: 'New',
            date: DateFormat('MMM dd, yyyy').format(DateTime.now()),
          );

          TicketService.addTicket(newTicket);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ticket created successfully!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );

          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const TicketStatusScreen(),
            ),
          );
        } else {
          if (!mounted) return;

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
      body: SingleChildScrollView(
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
                label: 'Subject',
                hint: 'Enter ticket subject',
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
                                      // Only fetch subcategories if the category key is "1"
                                      if (categoryId == '1') {
                                        _fetchSubcategories(categoryId);
                                      } else {
                                        // Clear subcategory selection for other categories
                                        _selectedTechnicalSupportType = null;
                                      }
                                    }
                                  });
                                }
                              },
                            ),
                    ),
                  ),
                ],
              ),
              // Only show subcategory dropdown if the selected category has key "1"
              if (_getCategoryIdByName(_selectedCategory) == '1') ...[
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Technical Support Type',
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
                                style: const TextStyle(color: AppColors.white),
                                hint: const Text('Select Support Type'),
                                items:
                                    _subcategoriesMap.values.map((String type) {
                                  return DropdownMenuItem<String>(
                                    value: type,
                                    child: Text(type),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    print(
                                        'Technical Support Type changed to: $newValue');
                                    setState(() {
                                      _selectedTechnicalSupportType = newValue;
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
                  const Text(
                    'Priority',
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
                      child: DropdownButton<String>(
                        value: _selectedPriority,
                        isExpanded: true,
                        dropdownColor: AppColors.darkBackground,
                        style: const TextStyle(color: AppColors.white),
                        hint: const Text('Select Priority'),
                        items: _priorities.map((String priority) {
                          return DropdownMenuItem<String>(
                            value: priority,
                            child: Text(priority),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            print('Priority changed to: $newValue');
                            setState(() {
                              _selectedPriority = newValue;
                            });
                          }
                        },
                      ),
                    ),
                  ),
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
              CustomButton(
                text: 'Submit Ticket',
                onPressed: _isSubmitting ? null : _createTicket,
                isLoading: _isSubmitting,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
