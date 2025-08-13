// import 'package:flutter/material.dart';
// import 'package:sky_techiez/models/payment_model.dart';
// import 'package:sky_techiez/screens/payment/payment_card_screen.dart';

// import 'package:sky_techiez/theme/app_theme.dart';

// class PaymentFlowScreen extends StatefulWidget {
//   final Map<String, dynamic> selectedPlan;

//   const PaymentFlowScreen({
//     super.key,
//     required this.selectedPlan,
//   });

//   @override
//   State<PaymentFlowScreen> createState() => _PaymentFlowScreenState();
// }

// class _PaymentFlowScreenState extends State<PaymentFlowScreen> {
//   late PaymentData paymentData;

//   @override
//   void initState() {
//     super.initState();
//     paymentData = PaymentData(planId: widget.selectedPlan['id'].toString());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Payment'),
//         backgroundColor: AppColors.cardBackground,
//       ),
//       body: Column(
//         children: [
//           // Plan Summary Card
//           Container(
//             width: double.infinity,
//             margin: const EdgeInsets.all(16),
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: AppColors.cardBackground,
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: AppColors.primaryBlue, width: 1),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Selected Plan',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: AppColors.white,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   widget.selectedPlan['name'] ?? 'Unknown Plan',
//                   style: const TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: AppColors.primaryBlue,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   widget.selectedPlan['description'] ?? '',
//                   style: const TextStyle(
//                     fontSize: 14,
//                     color: AppColors.grey,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Duration: ${widget.selectedPlan['duration']} month(s)',
//                       style: const TextStyle(
//                         fontSize: 14,
//                         color: AppColors.white,
//                       ),
//                     ),
//                     Text(
//                       '\$${widget.selectedPlan['price']}',
//                       style: const TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         color: AppColors.primaryBlue,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),

//           // Payment Steps
//           Expanded(
//             child: PaymentCardScreen(
//               paymentData: paymentData,
//               selectedPlan: widget.selectedPlan,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
