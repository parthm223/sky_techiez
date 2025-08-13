class PaymentData {
  String cardNumber;
  String expMonth;
  String expYear;
  String cvv;
  String planId;
  String firstName;
  String lastName;
  String email;
  String address;
  String city;
  String state;
  String zip;
  String? country;
  String? phone;

  PaymentData({
    this.cardNumber = '',
    this.expMonth = '',
    this.expYear = '',
    this.cvv = '',
    this.planId = '',
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.address = '',
    this.city = '',
    this.state = '',
    this.zip = '',
    this.country,
    this.phone,
  });

  bool get isComplete {
    return cardNumber.isNotEmpty &&
        expMonth.isNotEmpty &&
        expYear.isNotEmpty &&
        cvv.isNotEmpty &&
        firstName.isNotEmpty &&
        lastName.isNotEmpty &&
        email.isNotEmpty &&
        address.isNotEmpty &&
        city.isNotEmpty &&
        state.isNotEmpty &&
        zip.isNotEmpty;
  }
}
