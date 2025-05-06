import 'package:bahtareen/models/product_model.dart';
import 'package:bahtareen/providers/cart_provider.dart';
import 'package:bahtareen/screens/cart_screen.dart';
import 'package:bahtareen/screens/home_screen.dart';
import 'package:bahtareen/screens/login_screen.dart';
import 'package:bahtareen/screens/signup_screen.dart';
import 'package:bahtareen/screens/splash_screen.dart';
import 'package:bahtareen/screens/profile_screen.dart';
import 'package:bahtareen/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';  // Import the generated options file

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Run the app with Firebase initialization handled in the FutureBuilder
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize Firebase with options from firebase_options.dart
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        // Show error if Firebase initialization fails
        if (snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text(
                  'Failed to initialize Firebase: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
          );
        }

        // Show loading indicator while Firebase is initializing
        if (snapshot.connectionState != ConnectionState.done) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        // Firebase is initialized, build the actual app
        return MultiProvider(
          providers: [
            Provider<AuthService>(
              create: (_) => AuthService(),
            ),
            StreamProvider<User?>(
              create: (context) => context.read<AuthService>().authStateChanges,
              initialData: null,
            ),
            ChangeNotifierProvider(
              create: (_) => CartProvider(),
            ),
          ],
          child: MaterialApp(
            title: 'Bahtareen',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E2A78)),
              useMaterial3: true,
              scaffoldBackgroundColor: const Color(0xFFF5F6F8),
              fontFamily: 'Poppins',
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            initialRoute: '/',
            routes: {
              '/': (context) => const AuthWrapper(),
              '/login': (context) => const LoginScreen(),
              '/signup': (context) => const SignupScreen(),
              '/home': (context) => const HomeScreen(),
              '/profile': (context) => const ProfileScreen(),
              '/cart': (context) => const CartScreen(),
            },
          ),
        );
      },
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _showingSplash = true;

  @override
  void initState() {
    super.initState();
    // Show splash screen for 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showingSplash = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // If still showing splash, return the splash screen
    if (_showingSplash) {
      return const SplashScreen();
    }

    // Otherwise check auth state and navigate accordingly
    final user = Provider.of<User?>(context);

    // Use one-time post-frame callback to avoid navigation during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (user != null) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });

    // Return loading indicator during transition
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}