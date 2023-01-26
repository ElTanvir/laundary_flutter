import 'package:dry_cleaners/constants/app_colors.dart';
import 'package:dry_cleaners/constants/app_text_decor.dart';
import 'package:dry_cleaners/utils/context_less_nav.dart';
import 'package:dry_cleaners/utils/routes.dart';
import 'package:dry_cleaners/widgets/buttons/full_width_button.dart';
import 'package:dry_cleaners/widgets/misc_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderSuccessScreen extends StatefulWidget {
  const OrderSuccessScreen({super.key, required this.details});
  final Map<String, dynamic> details;

  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grayBG,
      body: Container(
        padding: EdgeInsets.only(right: 20.w, left: 20.w, top: 88.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/order_success.png',
              width: 335.w,
              height: 281.h,
            ),
            AppSpacerH(30.h),
            Text(
              'Your order has been ${widget.details['isPaid'] as bool ? 'Confirmed' : 'Placed, Please Make payment to Confirm it'}',
              style: AppTextDecor.osSemiBold18black,
            ),
            AppSpacerH(10.h),
            Text(
              'Your Order ID #${widget.details['id']} ',
              style: AppTextDecor.osRegular18black,
              textAlign: TextAlign.center,
            ),
            AppSpacerH(111.h),
            AppTextButton(
              title: 'Go to Home',
              onTap: () {
                context.nav.pushNamedAndRemoveUntil(
                  Routes.homeScreen,
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
