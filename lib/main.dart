import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps/business_logic/maps_logic/maps_cubit.dart';
import 'package:flutter_maps/business_logic/phone_auth/phone_auth_cubit.dart';
import 'package:flutter_maps/data/web_services/places_web_servises.dart';
import 'package:flutter_maps/presentation/screens/login_screen.dart';
import 'package:flutter_maps/presentation/screens/map_screen.dart';
import 'bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  PlacesWebServices.init();
  choseFirstPage();
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}

void choseFirstPage() {
  FirebaseAuth.instance.authStateChanges().listen((event) {
    if (event == null) {
      initalScreen = LoginScreen();
    } else {
      initalScreen = const MapScreen();
    }
  });
}

late Widget initalScreen;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PhoneAuthCubit(),
        ),
        BlocProvider(create: (context) => MapsCubit(),)
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: initalScreen,
      ),
    );
  }
}
