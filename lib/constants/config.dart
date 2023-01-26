class AppConfig {
  AppConfig._();

  //Base Url For APP
  static const String baseUrl = 'http://laundry.razinsoft.com/api';

  //Stripe Keys For App - Replace With Yours
  static const String secretKey = 'your_stripe_secret_key';
  static const String publicKey = 'your_stripe_public_key';

  //One Signal
  static const String oneSignalAppID =
      'your_oneSignal_app_ID'; // One Signal App ID

  static const String appName =
      'Laundry'; //Only For Showing Inside App. Doesn't Change Launher App Name

  //Contact US Config
  static const String ctAboutCompany =
      'Tanvir Ahmed'; //Company name And Address
  static const String ctWhatsApp =
      '+8801575210862'; // whats app Number with Country Code
  static const String ctPhone = '+8801575210862'; // Contact Phone Number
  static const String ctMail = 'eltanvirahmed@gmail.com'; // Contact Mail
}
