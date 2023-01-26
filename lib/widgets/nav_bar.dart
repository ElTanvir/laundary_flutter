import 'package:dry_cleaners/widgets/buttons/back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppNavbar extends StatelessWidget {
  const AppNavbar({super.key, this.title, this.onBack, this.showBack = true});
  final String? title;
  final Function()? onBack;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44.h,
      width: 345.w,
      child: Stack(
        children: [
          if (showBack)
            AppBackButton(
              size: 44.h,
              onTap: onBack,
            ),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              height: 44.h,
              width: 301.w,
              child: Center(
                child: Text(
                  title ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
