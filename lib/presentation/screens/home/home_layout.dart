import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_contacts/presentation/styles/colors.dart';
import 'package:easy_contacts/presentation/widgets/default_form_field.dart';
import 'package:easy_contacts/presentation/widgets/default_phone_form_field.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  CountryCode myCountryCode = CountryCode(name: 'EG', dialCode: '+20');

  @override
  void didChangeDependencies() {
    cubit = AppCubit.get(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {
        if (state is AppInsertContactsDoneState) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          key: _scaffoldKey,
          extendBody: true,
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
          body: Stack(children: [
            Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                begin: AlignmentDirectional.topStart,
                end: AlignmentDirectional.bottomEnd,
                colors: [skyBlue, lightSkyBlue, skyBlue],
              )),
            ),
            BlocBuilder<AppCubit, AppState>(
              builder: (BuildContext context, state) {
                if (state is AppGetContactsLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(color: darkBlue),
                  );
                } else {
                  return cubit.screens[cubit.currentIndex];
                }
              },
            ),
          ]),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              if (cubit.isBottomSheetShown) {
                if (_formKey.currentState!.validate()) {
                  await cubit.insertContact(
                      name: nameController.text,
                      phoneNumber:
                          '${myCountryCode.dialCode}${phoneController.text}');
                  nameController.text = '';
                  phoneController.text = '';
                }
              } else {
                cubit.changeBottomSheetState(
                    isShown: true, icon: Icons.add_box_outlined);
                _scaffoldKey.currentState!
                    .showBottomSheet(
                      (context) => Wrap(children: [
                        Container(
                          color: darkSkyBlue,
                          padding: EdgeInsets.symmetric(
                              vertical: 2.h, horizontal: 3.w),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: 1.h),
                                  child: DefaultFormField(
                                    controller: nameController,
                                    keyboardType: TextInputType.name,
                                    validator: (text) {
                                      if (text!.isEmpty) {
                                        return "Name can't be empty";
                                      }
                                      return null;
                                    },
                                    textColor: white,
                                    prefixIcon:
                                        const Icon(Icons.title_outlined),
                                    hintText: 'Contact Name',
                                  ),
                                ),
                                DefaultPhoneFormField(
                                  controller: phoneController,
                                  validator: (text) {
                                    if (text!.isEmpty) {
                                      return "Phone Number can't be empty";
                                    }
                                    return null;
                                  },
                                  labelText: 'Contact Phone Number',
                                  textColor: white,
                                  labelColor: lightBlue,
                                  onChange: (countryCode) {
                                    myCountryCode = countryCode;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]),
                    )
                    .closed
                    .then(
                      (value) => cubit.changeBottomSheetState(
                          isShown: false, icon: Icons.person_add),
                    );
              }
            },
            backgroundColor: darkSkyBlue,
            elevation: 20,
            child: Icon(
              cubit.floatingActionButtonIcon,
              color: lightBlue,
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomAppBar(
            color: darkSkyBlue,
            elevation: 0,
            shape: const CircularNotchedRectangle(),
            notchMargin: 12,
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
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
          ),
        );
      },
    );
  }
}
