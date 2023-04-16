import 'package:easy_contacts/presentation/styles/colors.dart';
import 'package:easy_contacts/presentation/widgets/default_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../business_logic/app_cubit.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  late AppCubit cubit;

  @override
  void didChangeDependencies() {
    cubit = AppCubit.get(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: darkSkyBlue,
            centerTitle: true,
            elevation: 8,
            title: DefaultText(
              text: cubit.appBarTitles[cubit.currentIndex],
              textColor: lightBlue,
              weight: FontWeight.bold,
              textSize: 20.sp,
            ),
          ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: darkSkyBlue,
            selectedItemColor: lightSkyBlue,
            unselectedItemColor: lightBlue,
            elevation: 0,
            currentIndex: cubit.currentIndex,
            onTap: (index) => cubit.changeScreensIndex(index),
            items: [
              BottomNavigationBarItem(
                  icon: const Icon(Icons.contacts_outlined),
                  label: cubit.appBarTitles[0],
              ),
              BottomNavigationBarItem(
                  icon: const Icon(Icons.favorite),
                  label: cubit.appBarTitles[1],
              ),
            ],
          ),
        );
      },
    );
  }
}
