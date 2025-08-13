// import 'package:flutter/material.dart';
// import 'package:sky_techiez/models/payment_model.dart';
// import 'package:sky_techiez/screens/payment/payment_review_screen.dart';
// import 'package:sky_techiez/theme/app_theme.dart';
// import 'package:sky_techiez/widgets/custom_button.dart';

// class PaymentPersonalInfoScreen extends StatefulWidget {
//   final PaymentData paymentData;
//   final Map<String, dynamic> selectedPlan;

//   const PaymentPersonalInfoScreen({
//     super.key,
//     required this.paymentData,
//     required this.selectedPlan,
//   });

//   @override
//   State<PaymentPersonalInfoScreen> createState() =>
//       _PaymentPersonalInfoScreenState();
// }

// class _PaymentPersonalInfoScreenState extends State<PaymentPersonalInfoScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _firstNameController = TextEditingController();
//   final _lastNameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _phoneController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _firstNameController.text = widget.paymentData.firstName;
//     _lastNameController.text = widget.paymentData.lastName;
//     _emailController.text = widget.paymentData.email;
//     _phoneController.text = widget.paymentData.phone ?? '';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Personal Information'),
//         backgroundColor: AppColors.cardBackground,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'Personal Information',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: AppColors.white,
//                 ),
//               ),
//               const SizedBox(height: 24),

//               // First Name
//               TextFormField(
//                 controller: _firstNameController,
//                 decoration: const InputDecoration(
//                   labelText: 'First Name *',
//                   prefixIcon: Icon(Icons.person),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.trim().isEmpty) {
//                     return 'First name is required';
//                   }
//                   if (value.trim().length > 255) {
//                     return 'First name too long';
//                   }
//                   return null;
//                 },
//                 onChanged: (value) {
//                   widget.paymentData.firstName = value.trim();
//                 },
//               ),

//               const SizedBox(height: 16),

//               // Last Name
//               TextFormField(
//                 controller: _lastNameController,
//                 decoration: const InputDecoration(
//                   labelText: 'Last Name *',
//                   prefixIcon: Icon(Icons.person_outline),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.trim().isEmpty) {
//                     return 'Last name is required';
//                   }
//                   if (value.trim().length > 255) {
//                     return 'Last name too long';
//                   }
//                   return null;
//                 },
//                 onChanged: (value) {
//                   widget.paymentData.lastName = value.trim();
//                 },
//               ),

//               const SizedBox(height: 16),

//               // Email
//               TextFormField(
//                 controller: _emailController,
//                 decoration: const InputDecoration(
//                   labelText: 'Email Address *',
//                   prefixIcon: Icon(Icons.email),
//                 ),
//                 keyboardType: TextInputType.emailAddress,
//                 validator: (value) {
//                   if (value == null || value.trim().isEmpty) {
//                     return 'Email is required';
//                   }
//                   if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
//                       .hasMatch(value)) {
//                     return 'Invalid email format';
//                   }
//                   return null;
//                 },
//                 onChanged: (value) {
//                   widget.paymentData.email = value.trim();
//                 },
//               ),

//               const SizedBox(height: 16),

//               // Phone (Optional)
//               TextFormField(
//                 controller: _phoneController,
//                 decoration: const InputDecoration(
//                   labelText: 'Phone Number (Optional)',
//                   prefixIcon: Icon(Icons.phone),
//                 ),
//                 keyboardType: TextInputType.phone,
//                 validator: (value) {
//                   if (value != null && value.isNotEmpty && value.length > 20) {
//                     return 'Phone number too long';
//                   }
//                   return null;
//                 },
//                 onChanged: (value) {
//                   widget.paymentData.phone =
//                       value.trim().isEmpty ? null : value.trim();
//                 },
//               ),

//               const SizedBox(height: 24),

//               // Progress Indicator
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: AppColors.cardBackground.withOpacity(0.5),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: const Row(
//                   children: [
//                     Icon(Icons.info_outline,
//                         color: AppColors.primaryBlue, size: 20),
//                     SizedBox(width: 8),
//                     Expanded(
//                       child: Text(
//                         'Step 2 of 3: Personal Information',
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: AppColors.grey,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const Spacer(),

//               CustomButton(
//                 text: 'Continue to Billing Address',
//                 onPressed: widget.paymentData.isPersonalInfoValid &&
//                         _formKey.currentState?.validate() == true
//                     ? () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => PaymentBillingScreen(
//                               paymentData: widget.paymentData,
//                               selectedPlan: widget.selectedPlan,
//                             ),
//                           ),
//                         );
//                       }
//                     : null,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _firstNameController.dispose();
//     _lastNameController.dispose();
//     _emailController.dispose();
//     _phoneController.dispose();
//     super.dispose();
//   }
// }
