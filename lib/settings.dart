//App version
// V4.4.4
class AppSettings {
  ///
  /// Basic setup details
  ///

  // The name of the application
  static const String appName = 'eShop';

  // The package name for the Android app
  static const String packageName = 'com.eshopsingle.customer';

  // The package name for the iOS app
  static const String iosPackage = 'com.wrteam.eshop';

  // The URL link to the iOS app on the App Store (to be replaced with the actual link)
  static const String iosLink = 'your ios link here';

  // App Store ID for the iOS app
  static const String appStoreId = '123456789';

  // API configuration: Update with your server URL and client-specific details
  static const String baseUrl = 'PLACE_YOUR_HOST_URL_HERE'; // Base API endpoint

  static const String chatBaseUrl =
      "PLACE_YOUR_CHAT_BASE_URL_HERE"; // Chat-specific API endpoint

  // Deep linking configuration
  static const String deepLinkUrlPrefix =
      'https://eshopwrteamin.page.link'; // Prefix for dynamic links
  static const String deepLinkName = 'eshop.com'; // Hostname for deep links
  static const String shareNavigationWebUrl =
      "eshopweb.store"; // Web URL for sharing navigation

  // Toggle to disable dark mode across the app (set `true` to disable)
  static const bool disableDarkTheme = false;

  // Default localization settings
  static const String defaultLanguageCode = "en"; // Default language (English)
  static const String defaultCountryCode = 'IN'; // Default country (India)

  // Formatting settings
  static const int decimalPoints =
      2; // Number of decimal points for numeric values

  // Network request configuration
  static const int timeOut = 50; // Timeout duration in seconds for API calls
  static const int perPage = 10; // Default pagination size for API results

  // Chat feature settings
  static const String messagesLoadLimit =
      '30'; // Limit for the number of chat messages to load
  static const double allowableTotalFileSizesInChatMediaInMB =
      15.0; // Maximum allowable size for chat media uploads in MB
}
