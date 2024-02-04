import "package:autoparts/constant/app_colors.dart";
import "package:autoparts/constant/app_text_style.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";

class CustomRoundTextField extends StatelessWidget {
  final Icon? icon;
  final String? iconAsset;
  final String? hintText;
  final String? initialValue;

  String? Function(String? val)? validator;
  //final Function()? ;
  String? Function(String? val)? onSaved;
  //final Function()? onSaved,
  final Function(String text)? onChanged;
  final bool? isPassword;
  final bool? isEmail;
  final bool? enable;
  final bool? readOnly;
  final int? minLines;
  final int? maxLength;
  final EdgeInsetsGeometry? padding;
  final int? maxLines;
  final FocusNode? focusNode;
  final Color? fillColor;
  final Function()? onTap;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixIcon;

  CustomRoundTextField({
    this.icon,
    this.hintText,
    this.maxLength,
    this.fillColor,
    this.padding : const EdgeInsets.fromLTRB(0, 0, 0, 15),
    this.isEmail : false,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.isPassword : false,
    this.keyboardType,
    this.controller,
    this.enable,
    this.minLines : 1,
    this.maxLines : 1,
    this.focusNode,
    this.readOnly : false,
    this.initialValue,
    this.onTap,
    this.inputFormatters,
    this.iconAsset : "",
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding!,
      child: TextFormField(
        style: AppTextStyles.mediumStyle(
            AppFontSize.font_16, AppColors.blackColor),
        maxLength: maxLength,
        autofocus: false,
        readOnly: readOnly!,
        controller: controller,
        enabled: enable,
        minLines: minLines,
        maxLines: maxLines,
        focusNode: focusNode,
        initialValue: initialValue,
        onTap: onTap,
        textCapitalization: keyboardType == TextInputType.emailAddress ? TextCapitalization.none : TextCapitalization.sentences,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          counterText: "",
          // labelText: "",
          prefixIcon: iconAsset!.isNotEmpty
              ? Transform.scale(
                  scale: 0.6,
                  child: IconButton(
                    onPressed: () {},
                    icon: Image.asset(
                      iconAsset!,
                      color: Colors.black,
                    ),
                  ),
                )
              : icon,
          suffixIcon: suffixIcon,
          hintText: hintText,
          hintStyle: AppTextStyles.mediumStyle(
              AppFontSize.font_16, AppColors.hintTextColor),
          errorMaxLines: 4,
          contentPadding: const EdgeInsets.all(16.0),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            borderSide: BorderSide(
              color: AppColors.borderColor,
              width: 2,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
               Radius.circular(10),
            ),
            borderSide: BorderSide(color: AppColors.btnBlackColor, width: 2),
          ),
          filled: true,
          fillColor: fillColor,
         focusedErrorBorder: const OutlineInputBorder(
           borderRadius: BorderRadius.all(
             Radius.circular(10),
           ),
           borderSide: BorderSide(
             color: AppColors.borderColor,
             width: 2,
           ),
         ),
         errorBorder: const OutlineInputBorder(
           borderRadius: BorderRadius.all(
              Radius.circular(10),
           ),
           borderSide: BorderSide(
             color: AppColors.borderColor,
             width: 2,
           ),
         ),
         errorStyle:
             const TextStyle(color: AppColors.borderColor, decorationColor: AppColors.borderColor),
        ),
        obscureText: isPassword! ? true : false,
        validator: validator,
        onSaved: onSaved,
        onChanged: onChanged,
        keyboardType: keyboardType,
        autocorrect: false,
      ),
    );
  }
}
