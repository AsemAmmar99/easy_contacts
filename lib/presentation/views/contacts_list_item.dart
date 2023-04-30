import 'package:easy_contacts/business_logic/app_cubit.dart';
import 'package:easy_contacts/presentation/styles/colors.dart';
import 'package:easy_contacts/presentation/views/edit_contact_dialog.dart';
import 'package:easy_contacts/presentation/widgets/default_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactsListItem extends StatelessWidget {
  final Map contactModel;

  const ContactsListItem({Key? key, required this.contactModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(contactModel['id'].toString()),
      onDismissed: (direction) async {
        await AppCubit.get(context).deleteContact(id: contactModel['id']);
        Fluttertoast.showToast(
            msg: "Contact Deleted Successfully!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.green,
            textColor: darkBlue,
            fontSize: 14.sp);
      },
      child: InkWell(
        onLongPress: () {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => EditContactDialog(contactModel: contactModel),
          );
        },
        onDoubleTap: () async{
          final Uri launchUri = Uri(
            scheme: 'tel',
            path: contactModel['phoneNumber']
          );
          await launchUrl(launchUri);
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 2.w),
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.sp),
            gradient: const LinearGradient(
              begin: AlignmentDirectional.centerStart,
              end: AlignmentDirectional.centerEnd,
              colors: [
                lightPurple,
                black,
                lightPurple,
              ],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.only(start: 2.w),
                    child: Flexible(
                      child: DefaultText(
                        text: contactModel['name'],
                        textSize: 14.sp,
                        weight: FontWeight.bold,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textColor: white,
                      ),
                    ),
                  ),
                  Flexible(
                    child: DefaultText(
                      text: contactModel['phoneNumber'],
                      textSize: 14.sp,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textColor: white,
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: contactModel['type'] == 'favorite',
                replacement: IconButton(
                  onPressed: () => AppCubit.get(context).addOrRemoveFavorite(
                      type: 'favorite', id: contactModel['id']),
                  icon: const Icon(
                    Icons.favorite_border_outlined,
                    color: Colors.red,
                  ),
                ),
                child: IconButton(
                  onPressed: () => AppCubit.get(context)
                      .addOrRemoveFavorite(type: 'all', id: contactModel['id']),
                  icon: const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
