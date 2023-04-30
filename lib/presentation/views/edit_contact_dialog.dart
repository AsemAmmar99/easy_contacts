import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_contacts/presentation/styles/colors.dart';
import 'package:easy_contacts/presentation/widgets/default_text_button.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../business_logic/app_cubit.dart';
import '../widgets/default_form_field.dart';
import '../widgets/default_phone_form_field.dart';
import '../widgets/default_text.dart';

class EditContactDialog extends StatefulWidget {
  final Map contactModel;

  const EditContactDialog({Key? key, required this.contactModel})
      : super(key: key);

  @override
  State<EditContactDialog> createState() => _EditContactDialogState();
}

class _EditContactDialogState extends State<EditContactDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController nameController =
      TextEditingController(text: widget.contactModel['name']);

  late TextEditingController phoneController = TextEditingController(
      text: widget.contactModel['phoneNumber'].toString().substring(3));

  CountryCode myCountryCode = CountryCode(name: 'EG', dialCode: '+20');

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: darkSkyBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.sp),
      ),
      child: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(15.sp),
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
                  prefixIcon: const Icon(Icons.title_outlined),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: DefaultTextButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await AppCubit.get(context).editContact(
                              id: widget.contactModel['id'],
                              name: nameController.text,
                              phoneNumber:
                                  '${myCountryCode.dialCode}${phoneController.text}');
                          Fluttertoast.showToast(
                              msg: "Contact Edited Successfully!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 3,
                              backgroundColor: Colors.green,
                              textColor: darkBlue,
                              fontSize: 14.sp);
                          if (mounted) {
                            Navigator.pop(context);
                          }
                        }
                      },
                      child: DefaultText(
                        text: 'Save',
                        textSize: 14.sp,
                        weight: FontWeight.bold,
                        textColor: lightBlue,
                      ),
                    ),
                  ),
                  Flexible(
                    child: DefaultTextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: DefaultText(
                        text: 'Cancel',
                        textSize: 14.sp,
                        weight: FontWeight.bold,
                        textColor: lightBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
