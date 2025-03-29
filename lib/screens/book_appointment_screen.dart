import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
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
  final _accountIdController = TextEditingController();
  final _issueController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  String _selectedIssueType = 'Technical Support';
  String? _selectedTechnicalSupportType;
  bool _isLoading = false;

  final List<String> _issueTypes = [
    'Technical Support',
    'Account Management',
    'Billing Inquiry',
    'Product Demo',
    'Consultation',
  ];

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
  void dispose() {
    _accountIdController.dispose();
    _issueController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
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
      setState(() {
        // Changed from day/month/year to month/day/year
        _dateController.text = "${picked.month}/${picked.day}/${picked.year}";
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
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
      setState(() {
        _timeController.text = picked.format(context);
      });
    }
  }

  Future<void> _bookAppointment() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Map issue types to their corresponding IDs
        final issueTypeIdMap = {
          'Technical Support': '1',
          'Account Management': '2',
          'Billing Inquiry': '3',
          'Product Demo': '4',
          'Consultation': '5',
        };

        // Get the issue type ID
        final issueTypeId = issueTypeIdMap[_selectedIssueType] ?? '1';

        // Prepare the issue text
        String issueText = _issueController.text;
        if (_selectedIssueType == 'Technical Support' &&
            _selectedTechnicalSupportType != null) {
          issueText = '${_selectedTechnicalSupportType}: $issueText';
        }

        // Prepare headers
        final headers = <String, String>{
          'X-Requested-With': 'XMLHttpRequest',
          'Authorization': (GetStorage().read(tokenKey) ?? '').toString(),
        };

        // Create the request
        var request = http.MultipartRequest('POST',
            Uri.parse('https://tech.skytechiez.co/api/book-appointment'));

        // Add fields
        request.fields.addAll({
          'issue_type_id': issueTypeId,
          'issue': issueText,
          'date': _dateController.text,
          'time': _timeController.text,
          'account_id': _accountIdController.text,
        });

        // Add headers
        request.headers.addAll(headers);

        // Send the request
        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          final responseBody = await response.stream.bytesToString();
          final jsonResponse = jsonDecode(responseBody);

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(jsonResponse['message'] ??
                    'Appointment booked successfully'),
                backgroundColor: Colors.green,
              ),
            );

            // Clear the form after successful submission
            _formKey.currentState?.reset();
            setState(() {
              _selectedIssueType = 'Technical Support';
              _selectedTechnicalSupportType = null;
            });
          }
        } else {
          final errorResponse = await response.stream.bytesToString();
          final jsonError = jsonDecode(errorResponse);

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
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (context.mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
              CustomTextField(
                label: 'Account ID',
                hint: 'Enter your account ID',
                controller: _accountIdController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your account ID';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
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
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedIssueType,
                        isExpanded: true,
                        dropdownColor: AppColors.darkBackground,
                        style: const TextStyle(color: AppColors.white),
                        hint: const Text('Select Issue Type'),
                        items: _issueTypes.map((String type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedIssueType = newValue;
                              if (newValue != 'Technical Support') {
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
              if (_selectedIssueType == 'Technical Support') ...[
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
