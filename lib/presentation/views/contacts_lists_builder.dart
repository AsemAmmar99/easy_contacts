import 'package:easy_contacts/presentation/styles/colors.dart';
import 'package:easy_contacts/presentation/views/contacts_list_item.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../widgets/default_lists_separator.dart';
import '../widgets/default_text.dart';

class ContactsListsBuilder extends StatelessWidget {
  final List<Map> contacts;
  final String noContactsText;
  final String contactType;

  const ContactsListsBuilder(
      {Key? key,
      required this.contacts,
      required this.noContactsText,
      required this.contactType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: contacts.isNotEmpty,
      replacement: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.no_accounts,
              size: 75.sp,
              color: white,
            ),
            DefaultText(
              text: noContactsText,
              textSize: 14.sp,
              weight: FontWeight.bold,
              textColor: white,
            ),
          ],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        child: ListView.separated(
          itemBuilder: (context, index) =>
              ContactsListItem(contactModel: contacts[index]),
          separatorBuilder: (context, index) => const DefaultListsSeparator(),
          itemCount: contacts.length,
        ),
      ),
    );
  }
}
