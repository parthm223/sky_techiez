// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:sky_techiez/models/payment_model.dart';
// import 'package:sky_techiez/screens/payment/payment_personalInfo_screen.dart';
// import 'package:sky_techiez/services/paymant_service.dart';

// import 'package:sky_techiez/theme/app_theme.dart';
// import 'package:sky_techiez/widgets/custom_button.dart';

// class PaymentCardScreen extends StatefulWidget {
//   final PaymentData paymentData;
//   final Map<String, dynamic> selectedPlan;

//   const PaymentCardScreen({
//     super.key,
//     required this.paymentData,
//     required this.selectedPlan,
//   });

//   @override
//   State<PaymentCardScreen> createState() => _PaymentCardScreenState();
// }

// class _PaymentCardScreenState extends State<PaymentCardScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _cardNumberController = TextEditingController();
//   final _expMonthController = TextEditingController();
//   final _expYearController = TextEditingController();
//   final _cvvController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _cardNumberController.text = widget.paymentData.cardNumber;
//     _expMonthController.text = widget.paymentData.expMonth;
//     _expYearController.text = widget.paymentData.expYear;
//     _cvvController.text = widget.paymentData.cvv;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Form(
//         key: _formKey,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Payment Information',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.white,
//               ),
//             ),
//             const SizedBox(height: 24),

//             // Card Number
//             TextFormField(
//               controller: _cardNumberController,
//               decoration: const InputDecoration(
//                 labelText: 'Card Number',
//                 hintText: '1234 5678 9012 3456',
//                 prefixIcon: Icon(Icons.credit_card),
//               ),
//               keyboardType: TextInputType.number,
//               inputFormatters: [
//                 FilteringTextInputFormatter.digitsOnly,
//                 LengthLimitingTextInputFormatter(16),
//                 _CardNumberFormatter(),
//               ],
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Card number is required';
//                 }
//                 if (!PaymentService.isValidCardNumber(value)) {
//                   return 'Invalid card number';
//                 }
//                 return null;
//               },
//               onChanged: (value) {
//                 widget.paymentData.cardNumber = value;
//                 setState(() {});
//               },
//             ),

//             if (_cardNumberController.text.isNotEmpty)
//               Padding(
//                 padding: const EdgeInsets.only(top: 8),
//                 child: Text(
//                   'Card Type: ${PaymentService.getCardType(_cardNumberController.text)}',
//                   style: const TextStyle(
//                     fontSize: 12,
//                     color: AppColors.primaryBlue,
//                   ),
//                 ),
//               ),

//             const SizedBox(height: 16),

//             // Expiry and CVV Row
//             Row(
//               children: [
//                 Expanded(
//                   child: TextFormField(
//                     controller: _expMonthController,
//                     decoration: const InputDecoration(
//                       labelText: 'Month',
//                       hintText: 'MM',
//                     ),
//                     keyboardType: TextInputType.number,
//                     inputFormatters: [
//                       FilteringTextInputFormatter.digitsOnly,
//                       LengthLimitingTextInputFormatter(2),
//                     ],
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Required';
//                       }
//                       int month = int.tryParse(value) ?? 0;
//                       if (month < 1 || month > 12) {
//                         return 'Invalid';
//                       }
//                       return null;
//                     },
//                     onChanged: (value) {
//                       widget.paymentData.expMonth = value;
//                     },
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: TextFormField(
//                     controller: _expYearController,
//                     decoration: const InputDecoration(
//                       labelText: 'Year',
//                       hintText: 'YY',
//                     ),
//                     keyboardType: TextInputType.number,
//                     inputFormatters: [
//                       FilteringTextInputFormatter.digitsOnly,
//                       LengthLimitingTextInputFormatter(2),
//                     ],
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Required';
//                       }
//                       if (!PaymentService.isValidExpiryDate(
//                           _expMonthController.text, value)) {
//                         return 'Expired';
//                       }
//                       return null;
//                     },
//                     onChanged: (value) {
//                       widget.paymentData.expYear = value;
//                     },
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: TextFormField(
//                     controller: _cvvController,
//                     decoration: const InputDecoration(
//                       labelText: 'CVV',
//                       hintText: '123',
//                     ),
//                     keyboardType: TextInputType.number,
//                     inputFormatters: [
//                       FilteringTextInputFormatter.digitsOnly,
//                       LengthLimitingTextInputFormatter(4),
//                     ],
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Required';
//                       }
//                       if (value.length < 3) {
//                         return 'Invalid';
//                       }
//                       return null;
//                     },
//                     onChanged: (value) {
//                       widget.paymentData.cvv = value;
//                     },
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 24),

//             // Security Info
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: AppColors.cardBackground.withOpacity(0.5),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: const Row(
//                 children: [
//                   Icon(Icons.security, color: AppColors.primaryBlue, size: 20),
//                   SizedBox(width: 8),
//                   Expanded(
//                     child: Text(
//                       'Your payment information is encrypted and secure',
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: AppColors.grey,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             const Spacer(),

//             CustomButton(
//               text: 'Continue to Personal Info',
//               onPressed: widget.paymentData.isCardInfoValid &&
//                       _formKey.currentState?.validate() == true
//                   ? () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => PaymentPersonalInfoScreen(
//                             paymentData: widget.paymentData,
//                             selectedPlan: widget.selectedPlan,
//                           ),
//                         ),
//                       );
//                     }
//                   : null,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _cardNumberController.dispose();
//     _expMonthController.dispose();
//     _expYearController.dispose();
//     _cvvController.dispose();
//     super.dispose();
//   }
// }

// class _CardNumberFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(
//     TextEditingValue oldValue,
//     TextEditingValue newValue,
//   ) {
//     final text = newValue.text.replaceAll(' ', '');
//     final formatted = PaymentService.formatCardNumber(text);

//     return TextEditingValue(
//       text: formatted,
//       selection: TextSelection.collapsed(offset: formatted.length),
//     );
//   }
// }
