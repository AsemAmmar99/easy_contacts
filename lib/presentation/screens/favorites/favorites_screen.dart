import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../business_logic/app_cubit.dart';
import '../../views/contacts_lists_builder.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late List<Map> favoritesList;

  @override
  void didChangeDependencies() {
    favoritesList = AppCubit
        .get(context)
        .favorites;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return ContactsListsBuilder(
          contacts: favoritesList,
          noContactsText: 'No Favorite Contacts..',
          contactType: 'favorite',
        );
      },
    );
  }
}
