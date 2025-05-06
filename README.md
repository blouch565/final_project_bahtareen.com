Mobile Application Documentation for Bahtareen.com
1. Project Overview
Bahtareen.com is an e-commerce platform selling electronics, wearables, home appliances, and mobile phones. The goal of this project is to design and develop a cross-platform mobile application using Flutter, offering users a smooth and feature-rich shopping experience on both Android and iOS.

2. Technology Stack
Frontend Framework: Flutter (Dart)

Backend Services: Firebase (Firestore, Storage, Auth)

State Management: Provider or Riverpod

Authentication: Firebase Email/Password, Google Sign-In

Database: Firebase Firestore

Cloud Storage: Firebase Storage (for images and files)

Image Handling: Image Picker

Payment Integration: (Optional in MVP) Integration with Razorpay or PayFast

Hosting (Web/Admin Portal): Firebase Hosting or existing Bahtareen.com backend

3. Modules Breakdown
3.1 Splash Screen
Shows logo and loading animation

Navigates to Login or Home depending on session state

3.2 Authentication Module
Login (Email/Password, Google)

Signup with email verification

Forgot password

Form validations

Toggle password visibility

3.3 Home Page
Product listing from Firestore

Carousel banner for promotions

Category navigation (e.g., Mobiles, Wearables)

Search bar with real-time search functionality

Pull-to-refresh functionality

3.4 Product Details Page
Display selected product’s:

Name

Description

Price

Image(s)

Availability

Add to Cart / Wishlist buttons

3.5 Cart Module
Shows items added to cart

Ability to update quantity or delete item

Calculates total price

Proceed to checkout button

3.6 Wishlist Module
Save products for later purchase

Add/remove from wishlist

Moves to cart if user wishes

3.7 Checkout Module
Billing & shipping address form

Review items

Select delivery method

Confirm order button

Payment integration (optional)

3.8 Order History
List of user orders

Shows order status, date, total amount

Track order or re-order option

3.9 Profile Module
View & update user information

Change password

Logout

3.10 Admin Panel (Optional)
For uploading, editing, and deleting product listings

Use Firebase Console or a custom admin Flutter web app

4. Firebase Structure (Firestore)
Collections:

products

users

cart

orders

wishlist

banners (for home carousel)

Example: Product Document Structure:

json
Copy
Edit
{
  "title": "Samsung Galaxy A14",
  "description": "4GB RAM, 128GB Storage, Black",
  "price": 33000,
  "imageUrl": "https://firebasestorage...",
  "category": "Mobiles",
  "inStock": true
}
5. State Management (Provider)
Each module will use a ChangeNotifier class for reactive updates. Examples:

AuthProvider

ProductProvider

CartProvider

WishlistProvider

Example:

dart
Copy
Edit
class CartProvider with ChangeNotifier {
  List<CartItem> _items = [];
  void addToCart(Product product) {
    _items.add(product);
    notifyListeners();
  }
}
6. Navigation and Routing
Using named routes in MaterialApp:

dart
Copy
Edit
routes: {
  '/': (context) => SplashScreen(),
  '/login': (context) => LoginPage(),
  '/home': (context) => HomePage(),
  '/product': (context) => ProductDetailPage(),
}
7. UI/UX Design Guidelines
Follow Material Design 3

Use GoogleFonts for typography

Responsive layout using LayoutBuilder and MediaQuery

Use shimmer effect or loading indicators for data loading

Professional product card layout with rounded images and shadows

8. Image Upload & Storage
Use image_picker to allow admin to upload product images

Use Firebase Storage to store images and save the URL in Firestore

dart
Copy
Edit
final pickedFile = await picker.pickImage(source: ImageSource.gallery);
final ref = FirebaseStorage.instance.ref().child('products/${file.name}');
await ref.putFile(File(pickedFile.path));
String downloadUrl = await ref.getDownloadURL();
9. Security Measures
Firebase Firestore rules to restrict unauthorized read/write

Validate all user input

Use HTTPS endpoints

Use Firebase Authentication for secure access

10. Testing Plan
Unit testing for provider classes and logic

Widget testing for UI

Manual testing on Android & iOS emulators

Real-device testing for image upload, login, checkout

11. Future Enhancements
Push notifications for order updates (via Firebase Messaging)

Discount and coupon code support

Multilingual support (Urdu & English)

Offline mode for product browsing

Live chat support integration

12. Deployment Steps
Configure Firebase Project and google-services.json / firebase_options.dart

Build Android APK via flutter build apk

Publish to Google Play Store or distribute manually

Optional: Build iOS app using Xcode

13. Conclusion
This Flutter-based application will mirror and enhance the functionality of Bahtareen.com, providing a modern, responsive, and user-friendly shopping experience. The use of Firebase ensures scalability, speed, and security, while Flutter enables quick cross-platform development.
