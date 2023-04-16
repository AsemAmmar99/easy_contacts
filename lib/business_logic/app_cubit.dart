import 'package:easy_contacts/presentation/screens/contacts/contacts_screen.dart';
import 'package:easy_contacts/presentation/screens/favorites/favorites_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());
  
  static AppCubit get(context) => BlocProvider.of<AppCubit>(context);

  int currentIndex = 0;

  List<Widget> screens = [
    const ContactsScreen(),
    const FavoritesScreen(),
  ];

  List<String> appBarTitles = [
    'Contacts',
    'Favorites',
  ];

  void changeScreensIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }
}
