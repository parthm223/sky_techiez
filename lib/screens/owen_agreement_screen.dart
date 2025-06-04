import 'package:flutter/material.dart';

class SkyTechiezAgreementScreen extends StatefulWidget {
  const SkyTechiezAgreementScreen({super.key});

  @override
  State<SkyTechiezAgreementScreen> createState() =>
      _SkyTechiezAgreementScreenState();
}

class _SkyTechiezAgreementScreenState extends State<SkyTechiezAgreementScreen> {
  final TextEditingController _signatureController = TextEditingController();
  bool _agreedToTerms = false;
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _signatureController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        title: const Text(
          'SkyTechiez Agreement',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade900, Colors.black],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _agreedToTerms && _signatureController.text.isNotEmpty
                ? _saveAgreement
                : null,
            tooltip: 'Save Agreement',
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Color(0xFF0A0E21)],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/images/SkyLogo.png',
                        height: 100,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Center(
                      child: Text(
                        'User Agreement',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Center(
                      child: Text(
                        'Last Updated: May 2024',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white54,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Divider(color: Colors.blueGrey, thickness: 1),
                    const SizedBox(height: 24),
                    _buildHeaderSection(),
                    const SizedBox(height: 24),
                    _buildTermsAndConditions(),
                    const SizedBox(height: 24),
                    _buildSubscriptionSection(),
                    const SizedBox(height: 24),
                    _buildPaymentPolicy(),
                    const SizedBox(height: 24),
                    _buildDataProtectionSection(),
                    const SizedBox(height: 32),
                    _buildSignatureField(),
                    const SizedBox(height: 24),
                    _buildTermsCheckbox(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SkyTechiez LLC (Application)',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
        const SizedBox(height: 16),
        _buildAgreementText(
          'Welcome to SkyTechiez LLC (Application)! This is a User Agreement between you (also referred to herein as "User" or "customer") and SkyTechiez LLC (Application), Inc. ("SkyTechiez LLC," "we," "us," and "our").',
        ),
        _buildAgreementText(
          'This User Agreement ("Agreement" or "User Agreement") governs your use of the services provided by SkyTechiez LLC (Application) described below and any other services that may be offered by SkyTechiez LLC (Application) from time to time ("SkyTechiez LLC (Application) Services" or "SkyTechiez LLC Services").',
        ),
        _buildAgreementText(
          'By signing up to use a SkyTechiez LLC (Application) account or service through skyechiez.co, our APIs, the SkyTechiez LLC (Application) mobile application, or any other SkyTechiez LLC website (collectively referred to as the "SkyTechiez LLC Site"), or by obtaining, holding, or using a wrapped token issued by SkyTechiez LLC (Application), you agree that you have read, understood, and accepted all the terms and conditions contained in this Agreement, including our Privacy Policy, term and condition and other policies.',
        ),
        _buildAgreementText(
          'You may need to agree to additional terms and conditions to use certain Additional Services (as defined below).',
        ),
        const SizedBox(height: 16),
        _buildCompanyInfo(),
      ],
    );
  }

  Widget _buildTermsAndConditions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Terms & Conditions',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
        const SizedBox(height: 16),
        _buildAgreementText(
          'SkyTechiez LLC (Application) Terms of Service ("Service Terms") is provided to you ("Customer") in connection with the SkyTechiez LLC (Application) Onsite(in the future)/Online Support for Home Devices & Peripherals Plan (the "Service") that you have purchased. These terms and conditions constitute the entire agreement between you and SkyTechiez LLC (Application) regarding the Service.',
        ),
        const SizedBox(height: 16),
        const Text(
          'Description of Service:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        _buildAgreementText(
          'Upon purchasing the Service, you are eligible to receive the following support via onsite (in the future), online, or phone assistance (for example, through online support, or remote access to your computer by a SkyTechiez LLC Agent:',
        ),
        _buildBulletPoint(
            'Software assessment and removal of viruses, malware, spyware, and adware.'),
        _buildBulletPoint(
            'Operating system updates, speed optimization, and junk file removal.'),
        _buildBulletPoint('Coverage for all PC/Laptop issues and cleanup.'),
        _buildBulletPoint(
            'Support for all software on Mac, iPhone, iPad, and MacBook.'),
        _buildBulletPoint(
            'Assistance with all browser issues and real-time ad blocking.'),
        _buildBulletPoint('Network firewall security with real-time scanning.'),
        _buildBulletPoint(
            'Printer warranty and unlimited driver installation as per the subscription plan.'),
        const SizedBox(height: 16),
        _buildAgreementText(
          'The Service is provided on a per-customer basis for the devices owned by you. The fee for the Service is a set amount, without regard to usage; therefore, once you have purchased the Service, there will be no refund of the fee even if you do not use the Service afterward. Customers can purchase the Service in increments of one, two, three, or five months or on a per-incident basis. Training services are not included in the Service but can be obtained at SkyTechiez LLC\'s (Application) standard service rate. If SkyTechiez LLC (Application) is unable to complete a requested service either in-store or by logging into your computer remotely, you may obtain additional services from SkyTechiez LLC (Application) at a 15% discount off the regular service price.',
        ),
        const SizedBox(height: 16),
        const Text(
          'Customer Pre-requisites:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        _buildAgreementText(
          'The Service requires a functioning high-speed internet connection and up-to-date antivirus software installed on your PCs. SkyTechiez LLC (Application) will not be held responsible for any delays or non-resolution of issues if your internet stops working after registration.',
        ),
        const SizedBox(height: 16),
        const Text(
          'Remote Access:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        _buildAgreementText(
          'SkyTechiez LLC (Application) offers remote access services to diagnose and resolve system issues. This process allows the SkyTechiez LLC (Application) Agent to remotely access your computer to identify problems and either repair them or advise you on available options for resolution. Using this service, you permit the SkyTechiez LLC (Application) Agent to log onto your computer (using a secure tool), which may contain personal information. The SkyTechiez LLC (Application) Agent will only diagnose your computer to determine the cause of the problem and will make an effort to limit their interaction with your files to a minimum. It is your responsibility to ensure that all your files, especially those containing personal information, are secure to prevent any risk of data loss or corruption. This includes securing your name, address, credit card number, and other personal or financial information.',
        ),
      ],
    );
  }

  Widget _buildSubscriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SkyTechiez LLC (Application) Subscription',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Subscription-Based Membership:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        _buildAgreementText(
          'SkyTechiez LLC (Application) operates as a subscription-based membership service. Please note that your subscription will renew automatically, and recurring payments are required.',
        ),
        const SizedBox(height: 16),
        const Text(
          'Membership Benefits:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        _buildAgreementText(
          'Membership benefits are subject to change or removal without prior notice. Not all benefits are available for all users. As a member, you can visit the member\'s home to view the list of currently available services. For important disclosures related to your services, please refer to the SkyTechiez LLC (Application) On Benefit Disclosures page. Some benefits may be provided through partnerships with third parties; in these cases, the third party is the actual provider of the benefit, not SkyTechiez LLC (Application).',
        ),
        const SizedBox(height: 16),
        const Text(
          'Subscription Fee and Billing:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        _buildAgreementText(
          'By signing up, you authorize a recurring charge of your subscription fee (plus any applicable taxes) to any stored payment method, cash balance, or Digital Asset balance from your sign-up date. If you are on a free trial, the charge will begin once the trial ends, unless you cancel beforehand. To prevent the next charge, please manage your subscription in the member home before your renewal date. The subscription fee presented during sign-up is subject to change. You can view your current subscription fee in the member home. If your primary payment method fails, we are authorized to charge any backup payment method, cash balance, or Digital Asset balance on file.',
        ),
        const SizedBox(height: 16),
        const Text(
          'Paying Subscription Fee with Digital Assets:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        _buildAgreementText(
          'If you opt to use Digital Assets as your primary or backup payment method, you authorize SkyTechiez LLC (Application) to deduct the amount necessary to cover your subscription fee, based on the prevailing prices of those Digital Assets as determined by SkyTechiez LLC (Application) at the time the transaction is executed. Please be aware that payments made with Digital Assets are subject to Section 6.8 ("Taxes") of the User Agreement.',
        ),
        const SizedBox(height: 16),
        const Text(
          'Cancellation:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        _buildAgreementText(
          'You can cancel your subscription via the "Manage" section of your member home. Your cancellation will take effect at the end of your current billing period. To avoid the next charge, make sure to cancel before your renewal date.',
        ),
        const SizedBox(height: 16),
        const Text(
          'Free Trial:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        _buildAgreementText(
          'At its sole discretion, SkyTechiez LLC (the Application) may offer you a free trial or other promotional offer. Unless you cancel before the end of your free trial or promotion, your subscription will automatically renew at the end of the trial period, and you will be charged the subscription fee repeatedly until you cancel.',
        ),
        const SizedBox(height: 16),
        _buildAgreementText(
          'Please note: We only provide IT related solution, we do not provide solution on your personal profile.',
        ),
      ],
    );
  }

  Widget _buildPaymentPolicy() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SkyTechiez LLC (Application) Device Repair Service Payment Policy',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Payment Methods',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        _buildBulletPoint(
          'Payment will be based on a pre-paid monthly subscription plan: Customers will be invoiced and charged for a subscription to SkyTechiez LLC (Application), and upon they will be able to get unlimited support for device issues. Accepted payment methods include online payment through the SkyTechiez application, credit/debit cards, and other electronic payment options.',
        ),
        const SizedBox(height: 16),
        const Text(
          'Service Fees',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        _buildBulletPoint(
          'Customers will receive a detailed invoice copy related to the service fees. Past payment and subscription history will be reflected on the SkyTechiez LLC application upon subscription.',
        ),
        const SizedBox(height: 16),
        const Text(
          'Services scheduling',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        _buildBulletPoint(
          'Appointment Confirmation: Service appointments will be scheduled, and customers must confirm their willingness to proceed with the service.',
        ),
        const SizedBox(height: 16),
        const Text(
          'Monthly Plans',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        _buildBulletPoint(
          'Subscription Plans: Customers who opt for the services will get the monthly plans. Payment for Monthly plans is due at the initiation of the plan.',
        ),
        const SizedBox(height: 16),
        const Text(
          'Refund and Cancellation',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        _buildBulletPoint(
          'Refund Policy: Once a service has been successfully provided, fees are non-refundable. Monthly plan fees are non-refundable after the initiation of the plan.',
        ),
        _buildBulletPoint(
          'Cancellation Policy: Customers must notify SkyTechiez LLC through mail or Application of any cancellations at least seven (7) days before the next scheduled service to avoid charges. Cancellations of the Monthly plan are subject to the terms outlined in our Monthly plan agreement.',
        ),
        _buildAgreementText(
          'Note: In case of cancellation of the monthly subscription plan all the third party software support will be ended at the time of cancellation (if provided).',
        ),
        const SizedBox(height: 16),
        const Text(
          'Services and Agreement',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        _buildBulletPoint(
          'SkyTechiez customer will get a signed soft-copy of the SkyTechiez LLC service agreement as well as SkyTechiez agent will also inform the customer regarding the services and the agreement.',
        ),
        const SizedBox(height: 16),
        const Text(
          'Dispute Resolution',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        _buildBulletPoint(
          'Dispute Resolution Process: In the event of a dispute regarding payments or services, customers are encouraged to contact SkyTechiez LLC (Application) to resolve the issue through an agreed-upon dispute resolution process.',
        ),
        const SizedBox(height: 16),
        const Text(
          'Governing Law',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        _buildBulletPoint(
          'Legal Jurisdiction: This payment policy is governed by the laws of California, and any disputes will be resolved under these laws.',
        ),
        const SizedBox(height: 16),
        const Text(
          'Changes to Payment Policy',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        _buildBulletPoint(
          'Policy Updates: SkyTechiez LLC (Application) reserves the right to update or modify this payment policy. Customers will be notified of any changes in advance.',
        ),
        const SizedBox(height: 16),
        _buildAgreementText(
          'By engaging with SkyTechiez LLC (Application)\'s device repair services, customers acknowledge and agree to comply with the terms outlined in this payment policy.',
        ),
        const SizedBox(height: 16),
        const Text(
          'Privacy Policy:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        _buildAgreementText(
          'SkyTechiez LLC (Application) is committed to respecting the privacy of its customers.',
        ),
        _buildAgreementText(
          'For information on our privacy practices, please visit www.SkyTechiez.co or call +1 (307) 217-8790.',
        ),
      ],
    );
  }

  Widget _buildDataProtectionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Data Protection and Security',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Personal Data:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        _buildAgreementText(
          'You acknowledge that we may process personal data related to you (if you are an individual), as well as personal data that you have provided or may provide in the future concerning your employees and other associated individuals, in connection with this Agreement or the SkyTechiez LLC (Application) Services. Accordingly, you represent and warrant that: (i) any personal data relating to individuals other than yourself has been or will be disclosed to us following all applicable data protection and privacy laws, and that such data is accurate, up-to-date, and relevant at the time of disclosure; (ii) before providing any personal data to us, you have read and understood our Privacy Policy, and in the case of personal data relating to individuals other than yourself, you have (or will at the time of disclosure have) provided a copy of that Privacy Policy (as amended from time to time) to those individuals; and (iii) if we provide you with a replacement version of the Privacy Policy from time to time, you will promptly read it and provide a copy to any individual whose personal data you have provided to us.',
        ),
        const SizedBox(height: 16),
        const Text(
          'Security Breach:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        _buildAgreementText(
          'If you suspect that your SkyTechiez LLC (Application) Account or any of your security details have been compromised, or if you become aware of any fraud, attempted fraud, or any other security incident (including a cybersecurity attack) affecting you and/or SkyTechiez LLC (Application) (collectively referred to as a "Security Breach"), you must immediately notify SkyTechiez LLC (Application) Support at https://help.SkyTechiez.co or (307) 217-8790, providing accurate and up-to-date information for the duration of the Security Breach. Please take any reasonable steps we need to reduce or manage the Security Breach. Just to let you know, reporting a Security Breach does not guarantee reimbursement for any losses incurred or that SkyTechiez LLC (Application) will be liable for any losses resulting from the Security Breach.',
        ),
        const SizedBox(height: 16),
        _buildCompanyInfo(),
      ],
    );
  }

  Widget _buildAgreementText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          height: 1.5,
          color: Colors.white70,
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4, right: 8),
            child: Icon(
              Icons.circle,
              size: 8,
              color: Colors.blue.shade300,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Colors.white70,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade900.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade700),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SkyTechiez LLC',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '7903 Elm Ave #360\nRancho Cucamonga, CA 91730, USA\n+1 (307) 217-8790\nwww.SkyTechiez.co',
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignatureField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Customer Signature',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _signatureController,
          decoration: InputDecoration(
            hintText: 'Enter your full name as signature',
            hintStyle: const TextStyle(color: Colors.white54),
            filled: true,
            fillColor: Colors.grey[900],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: (value) {
            setState(() {});
          },
        ),
        const SizedBox(height: 8),
        const Text(
          'By signing above, you acknowledge that you have read and agree to all terms and conditions outlined in this agreement.',
          style: TextStyle(
            fontSize: 14,
            fontStyle: FontStyle.italic,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: _agreedToTerms,
          onChanged: (value) {
            setState(() {
              _agreedToTerms = value ?? false;
            });
          },
          fillColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.selected)) {
              return Colors.blue;
            }
            return Colors.grey.shade800;
          }),
        ),
        const Expanded(
          child: Text(
            'I have read and agree to all terms and conditions outlined in this agreement',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade900, Colors.black],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _agreedToTerms && _signatureController.text.isNotEmpty
              ? _saveAgreement
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                _agreedToTerms && _signatureController.text.isNotEmpty
                    ? Colors.blue
                    : Colors.blue.shade800.withOpacity(0.5),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Submit Agreement',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void _saveAgreement() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          'Agreement Submitted',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Thank you, ${_signatureController.text}, for agreeing to our terms. Your agreement has been successfully submitted.',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}
