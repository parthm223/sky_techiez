import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:sky_techiez/servies/appointment_service.dart';
import 'package:sky_techiez/theme/app_theme.dart';
import 'package:sky_techiez/widgets/custom_button.dart';
import 'package:sky_techiez/widgets/custom_text_field.dart';

import '../widgets/session_string.dart';

class BookAppointmentScreen extends StatefulWidget {
  const BookAppointmentScreen({super.key});

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _issueController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  String? _selectedIssueTypeId;
  String? _selectedIssueTypeName;
  String? _selectedTechnicalSupportType;
  bool _isLoading = false;
  bool _isFetchingIssueTypes = false;

  // Map to store issue types from API (id -> name)
  Map<String, String> _issueTypes = {};

  // Technical support sub-types
  final List<String> _technicalSupportTypes = [
    'Desktop Support',
    'Wireless Printer Setup',
    'Quicken Support',
    'QuickBooks Support',
    'Antivirus Support',
    'Printer Support',
    'Office 365 Support',
    'Outlook Support',
  ];

  @override
  void initState() {
    super.initState();
    print('Initializing BookAppointmentScreen...');
    _fetchIssueTypes();
  }

  Future<void> _fetchIssueTypes() async {
    print('Fetching issue types from API...');
    setState(() {
      _isFetchingIssueTypes = true;
    });

    try {
      final url = 'https://tech.skytechiez.co/api/issue-type-dropdown';
      print('Making GET request to: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'X-Requested-With': 'XMLHttpRequest',
          'Authorization': (GetStorage().read(tokenKey) ?? '').toString(),
        },
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Parsed response data: $data');

        if (data['issue_types'] != null && data['issue_types'] is Map) {
          setState(() {
            _issueTypes = Map<String, String>.from(data['issue_types']);
            print('Loaded issue types: $_issueTypes');

            if (_issueTypes.isNotEmpty) {
              _selectedIssueTypeId = _issueTypes.keys.first;
              _selectedIssueTypeName = _issueTypes[_selectedIssueTypeId];
              print(
                  'Default selected issue type: $_selectedIssueTypeId - $_selectedIssueTypeName');
            }
          });
        }
      } else {
        print(
            'Failed to load issue types. Status code: ${response.statusCode}');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('Failed to load issue types: ${response.statusCode}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print('Error fetching issue types: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error fetching issue types: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        print('Finished fetching issue types');
        setState(() {
          _isFetchingIssueTypes = false;
        });
      }
    }
  }

  @override
  void dispose() {
    print('Disposing BookAppointmentScreen...');
    _issueController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    print('Opening date picker...');
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primaryBlue,
              onPrimary: AppColors.white,
              onSurface: AppColors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      print('Selected date: $picked');
      setState(() {
        _dateController.text = "${picked.month}/${picked.day}/${picked.year}";
        print('Formatted date: ${_dateController.text}');
      });
    } else {
      print('Date selection cancelled');
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    print('Opening time picker...');
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primaryBlue,
              onPrimary: AppColors.white,
              onSurface: AppColors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      print('Selected time: $picked');
      setState(() {
        _timeController.text = picked.format(context);
        print('Formatted time: ${_timeController.text}');
      });
    } else {
      print('Time selection cancelled');
    }
  }

  Future<void> _bookAppointment() async {
    print('Attempting to book appointment...');
    if (_formKey.currentState!.validate()) {
      print('Form validation passed');
      setState(() {
        _isLoading = true;
      });

      try {
        String issueText = _issueController.text;
        print('Original issue text: $issueText');

        if (_selectedIssueTypeName == 'Technical Support' &&
            _selectedTechnicalSupportType != null) {
          issueText = '${_selectedTechnicalSupportType}: $issueText';
          print('Modified issue text with technical support type: $issueText');
        }

        final headers = <String, String>{
          'X-Requested-With': 'XMLHttpRequest',
          'Authorization': (GetStorage().read(tokenKey) ?? '').toString(),
        };
        print('Request headers: $headers');

        var request = http.MultipartRequest(
          'POST',
          Uri.parse('https://tech.skytechiez.co/api/book-appointment'),
        );

        final requestFields = {
          'issue_type_id': _selectedIssueTypeId ?? '1',
          'issue': issueText,
          'date': _dateController.text,
          'time': _timeController.text,
        };
        request.fields.addAll(requestFields);

        print('Request fields: $requestFields');
        request.headers.addAll(headers);

        print('Sending appointment booking request...');
        http.StreamedResponse response = await request.send();

        print('Received response with status: ${response.statusCode}');
        if (response.statusCode == 200) {
          final responseBody = await response.stream.bytesToString();
          print('Raw response body: $responseBody');

          final jsonResponse = jsonDecode(responseBody);
          print('Parsed response: $jsonResponse');

          // Generate a unique appointment ID
          final appointmentId = AppointmentService.generateAppointmentId();

          // Save appointment details to shared service
          final appointmentDetails = {
            'id': appointmentId,
            'issue_type': _selectedIssueTypeName,
            'issue': issueText,
            'date': _dateController.text,
            'time': _timeController.text,
            'status': 'Scheduled',
            'created_at': DateTime.now().toString(),
          };

          // Save to shared service
          AppointmentService.saveAppointment(appointmentDetails);
          print('Saved appointment details: $appointmentDetails');

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(jsonResponse['message'] ??
                    'Appointment booked successfully'),
                backgroundColor: Colors.green,
              ),
            );

            // Navigate back to home screen
            Navigator.pop(context);

            _formKey.currentState?.reset();
            setState(() {
              if (_issueTypes.isNotEmpty) {
                _selectedIssueTypeId = _issueTypes.keys.first;
                _selectedIssueTypeName = _issueTypes[_selectedIssueTypeId];
              }
              _selectedTechnicalSupportType = null;
            });
            print('Appointment booked successfully. Form reset.');
          }
        } else {
          final errorResponse = await response.stream.bytesToString();
          print('Error response body: $errorResponse');

          final jsonError = jsonDecode(errorResponse);
          print('Parsed error: $jsonError');

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text(jsonError['message'] ?? 'Failed to book appointment'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        print('Error booking appointment: $e');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        print('Finished booking attempt');
        if (context.mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } else {
      print('Form validation failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Building BookAppointmentScreen...');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Appointment'),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Issue Type',
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
                    child: _isFetchingIssueTypes
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedIssueTypeId,
                              isExpanded: true,
                              dropdownColor: AppColors.darkBackground,
                              style: const TextStyle(color: AppColors.white),
                              hint: const Text('Select Issue Type'),
                              items: _issueTypes.entries.map((entry) {
                                print(
                                    'Adding dropdown item: ${entry.key} - ${entry.value}');
                                return DropdownMenuItem<String>(
                                  value: entry.key,
                                  child: Text(entry.value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  print(
                                      'Selected issue type changed to: $newValue');
                                  setState(() {
                                    _selectedIssueTypeId = newValue;
                                    _selectedIssueTypeName =
                                        _issueTypes[newValue];
                                    print(
                                        'New selected issue type: $_selectedIssueTypeName');
                                    if (_selectedIssueTypeName !=
                                        'Technical Support') {
                                      print(
                                          'Clearing technical support type selection');
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
              if (_selectedIssueTypeName == 'Technical Support') ...[
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
                        child: DropdownButton<String>(
                          value: _selectedTechnicalSupportType,
                          isExpanded: true,
                          dropdownColor: AppColors.darkBackground,
                          style: const TextStyle(color: AppColors.white),
                          hint: const Text('Select Technical Support Type'),
                          items: _technicalSupportTypes.map((String type) {
                            return DropdownMenuItem<String>(
                              value: type,
                              child: Text(type),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              print(
                                  'Selected technical support type changed to: $newValue');
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
              CustomTextField(
                label: 'Issue',
                hint: 'Describe your issue briefly',
                controller: _issueController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please describe your issue';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Date',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _dateController,
                          readOnly: true,
                          style: const TextStyle(color: AppColors.white),
                          decoration: InputDecoration(
                            hintText: 'Select date',
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.calendar_today,
                                  color: AppColors.grey),
                              onPressed: () => _selectDate(context),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a date';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Time',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _timeController,
                          readOnly: true,
                          style: const TextStyle(color: AppColors.white),
                          decoration: InputDecoration(
                            hintText: 'Select time',
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.access_time,
                                  color: AppColors.grey),
                              onPressed: () => _selectTime(context),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a time';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Submit',
                onPressed: _isLoading ? null : _bookAppointment,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
