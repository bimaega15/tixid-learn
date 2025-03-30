import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tixid_lear_raisya/blocs/auth/auth_bloc.dart';
import 'package:tixid_lear_raisya/screens/sign_in_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Fix system-wide scroll settings
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc()),
      ],
      child: MaterialApp(
        title: 'Cinema Tickets',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6A1B9A)),
          useMaterial3: true,
          fontFamily: 'Montserrat',
          scaffoldBackgroundColor: const Color(0xFF1A1A2A),
          // Improve scrolling behavior app-wide
          scrollbarTheme: ScrollbarThemeData(
            thumbVisibility: MaterialStateProperty.all(true),
            thickness: MaterialStateProperty.all(6),
            radius: const Radius.circular(10),
          ),
        ),
        home: const SignInScreen(),
      ),
    );
  }
}
