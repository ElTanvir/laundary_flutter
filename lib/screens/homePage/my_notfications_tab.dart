import 'package:dry_cleaners/constants/app_colors.dart';
import 'package:dry_cleaners/constants/app_text_decor.dart';
import 'package:dry_cleaners/constants/hive_contants.dart';
import 'package:dry_cleaners/widgets/misc_widgets.dart';
import 'package:dry_cleaners/widgets/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MyNotificationsTab extends ConsumerWidget {
  const MyNotificationsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 812.h,
      width: 375.w,
      child: Column(
        children: [
          Container(
            color: AppColors.white,
            height: 88.h,
            width: 375.w,
            child: Column(
              children: [
                AppSpacerH(44.h),
                const AppNavbar(
                  showBack: false,
                  title: 'Notifications',
                ),
              ],
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: Hive.box(AppHSC.authBox).listenable(),
              builder: (BuildContext context, Box authbox, Widget? child) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/icon_notification.png',
                          height: 118.h,
                          width: 118.w,
                        ),
                        AppSpacerH(60.h),
                        Text(
                          'Your notification is Empty.',
                          style: AppTextDecor.osSemiBold18black,
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
