part of 'app_cubit.dart';

abstract class AppState {}

class AppInitial extends AppState {}

class AppChangeBottomNavBarState extends AppState {}

class AppChangeBottomSheetState extends AppState {}

class AppOpenDatabaseState extends AppState {}

class AppGetContactsLoadingState extends AppState {}

class AppGetContactsDoneState extends AppState {}

class AppInsertContactsDoneState extends AppState {}

class AppAddOrRemoveFavoriteState extends AppState {}

class AppEditContactState extends AppState {}

class AppDeleteContactState extends AppState {}