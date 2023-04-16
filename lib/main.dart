import 'package:easy_contacts/business_logic/app_cubit.dart';
import 'package:easy_contacts/core/my_bloc_observer.dart';
import 'package:easy_contacts/presentation/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final AppRouter appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit(),
      child: Sizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Easy Contacts',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            onGenerateRoute: appRouter.onGenerateRoute,
          );
        },
      ),
    );
  }
}