import 'package:flutter/material.dart';
import 'package:mono/core/constants/colors.dart';
import 'package:mono/core/constants/text_styles.dart';



class ProfileRow extends StatefulWidget {
  final Widget widget;
  final String text;
  final VoidCallback onPressed;
  const ProfileRow({super.key,required this.widget, required this.text, required this.onPressed });

  @override
  State<ProfileRow> createState() => _ProfileRowState();
}

class _ProfileRowState extends State<ProfileRow> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: widget.onPressed,
      child: Row( 
        mainAxisAlignment: MainAxisAlignment.start,
        
        children: [
          widget.widget,
          const SizedBox(width: 15),
          Text(
            widget.text,
            style: AppTextStyles.body1(
              color: AppColors.black,
              fontSize: 16,
            ),
          ),
          
        ],
      ),
    );
  }
}