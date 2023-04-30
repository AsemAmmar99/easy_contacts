import 'package:easy_contacts/presentation/screens/contacts/contacts_screen.dart';
import 'package:easy_contacts/presentation/screens/favorites/favorites_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());

  static AppCubit get(context) => BlocProvider.of<AppCubit>(context);

  int currentIndex = 0;
  bool isBottomSheetShown = false;
  IconData floatingActionButtonIcon = Icons.person_add;

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

  void changeBottomSheetState({
    required bool isShown,
    required IconData icon,
  }) {
    isBottomSheetShown = isShown;
    floatingActionButtonIcon = icon;
    emit(AppChangeBottomSheetState());
  }

  List<Map> contacts = [];
  List<Map> favorites = [];

  late Database database;

  void createDatabase() {
    openDatabase('contacts.db', version: 1, onCreate: (db, version) {
      if (kDebugMode) {
        print('database created!');
      }
      db
          .execute(
              'CREATE TABLE contacts (id INTEGER PRIMARY KEY, name TEXT, phoneNumber TEXT, type TEXT)')
          .then((value) {
        if (kDebugMode) {
          print('table created!');
        }
      }).catchError((error) {
        if (kDebugMode) {
          print('Error while creating table $error');
        }
      });
    }, onOpen: (db) {
      getContacts(db);
      if (kDebugMode) {
        print('database opened!');
      }
    }).then((value) {
      database = value;
      emit(AppOpenDatabaseState());
    });
  }

  void getContacts(Database database) async {
    contacts.clear();
    favorites.clear();

    emit(AppGetContactsLoadingState());

    await database.rawQuery('SELECT * FROM contacts').then((value) {
      for (Map<String, Object?> element in value) {
        contacts.add(element);

        if (element['type'] == 'favorite') {
          favorites.add(element);
        }
      }
    });
    emit(AppGetContactsDoneState());
  }

  Future<void> insertContact({
    required String name,
    required String phoneNumber,
  }) async {
    await database.transaction((txn) {
      return txn.rawInsert(
          'INSERT INTO contacts(name, phoneNumber, type) VALUES("$name", "$phoneNumber", "all")');
    }).then((value) {
      if (kDebugMode) {
        print('Contact $value successfully inserted!');
      }
      emit(AppInsertContactsDoneState());
      getContacts(database);
    }).catchError((error) {
      if (kDebugMode) {
        print('Error while inserting Contact $error');
      }
    });
  }

  void addOrRemoveFavorite({
  required String type,
  required int id,
}) async{
    await database.rawUpdate('UPDATE contacts SET type = ? WHERE id = ?',
    [type, id]
    ).then((value) {
      getContacts(database);
      emit(AppAddOrRemoveFavoriteState());
    });
  }

  void editContact({
    required String name,
    required String phoneNumber,
    required int id,
  }) async{
    await database.rawUpdate('UPDATE contacts SET name = ?, phoneNumber = ? WHERE id = ?',
        [name, phoneNumber, id]
    ).then((value) {
      getContacts(database);
      emit(AppEditContactState());
    });
  }

  void deleteContact({
    required int id,
  }) async{
    await database.rawDelete('DELETE FROM contacts WHERE id = ?',
        [id]
    ).then((value) {
      getContacts(database);
      emit(AppDeleteContactState());
    });
  }

}
