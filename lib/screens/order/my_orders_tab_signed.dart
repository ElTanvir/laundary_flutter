import 'package:dry_cleaners/constants/app_colors.dart';
import 'package:dry_cleaners/constants/app_text_decor.dart';
import 'package:dry_cleaners/constants/hive_contants.dart';
import 'package:dry_cleaners/misc/global_functions.dart';
import 'package:dry_cleaners/models/addres_list_model/address.dart';
import 'package:dry_cleaners/models/all_orders_model/order.dart';
import 'package:dry_cleaners/providers/order_providers.dart';
import 'package:dry_cleaners/utils/context_less_nav.dart';
import 'package:dry_cleaners/utils/routes.dart';
import 'package:dry_cleaners/widgets/buttons/full_width_button.dart';
import 'package:dry_cleaners/widgets/dashed_line.dart';
import 'package:dry_cleaners/widgets/misc_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class MyOrdersSignedIn extends ConsumerWidget {
  const MyOrdersSignedIn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(allOrdersProvider);

    return SizedBox(
      height: 606.h,
      width: 335.w,
      child: ref.watch(allOrdersProvider).map(
            initial: (_) => const SizedBox(),
            loading: (_) => const LoadingWidget(),
            loaded: (_) {
              if (_.data.data!.orders!.isEmpty) {
                return const MessageTextWidget(
                  msg: 'No Order Found',
                );
              } else {
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: _.data.data!.orders!.length,
                  itemBuilder: (context, index) {
                    final Order data = _.data.data!.orders![index];
                    return OrderTile(data: data);
                  },
                );
              }
            },
            error: (_) => ErrorTextWidget(error: _.error),
          ),
    );
  }
}

class OrderTile extends StatelessWidget {
  OrderTile({
    super.key,
    required this.data,
  });

  final Order data;
  final Box settingsBox = Hive.box(AppHSC.appSettingsBox);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.nav
            .pushNamed(Routes.orderDetails, arguments: data.id!.toString());
      },
      child: Padding(
        padding: EdgeInsets.only(top: 10.h),
        child: Container(
          // height: 219.h,
          width: 335.w,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10.w),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 15.h,
          ),
          child: Column(
            children: [
              Table(
                children: [
                  TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 3.5.h,
                        ),
                        child: Text(
                          'Order ID',
                          style: AppTextDecor.osBold14black,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 3.5.h,
                        ),
                        child: Text(
                          '#${data.orderCode}',
                          style: AppTextDecor.osBold14black,
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 3.5.h,
                        ),
                        child: Text(
                          'Date',
                          style: AppTextDecor.osRegular14black,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 3.5.h,
                        ),
                        child: Text(
                          DateFormat("dd MMM, yyyy").format(
                            DateTime.parse(data.orderedAt!.split(" ").first),
                          ),
                          style: AppTextDecor.osRegular14black,
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                  // AppGFunctions.tableTextRow(
                  //   title: 'Pick Up At',
                  //   data: '${data.pickDate} - ${data.pickHour}',
                  // ),
                  // AppGFunctions.tableTextRow(
                  //   title: 'Delivery At',
                  //   data: '${data.deliveryDate} - ${data.deliveryHour}',
                  // ),
                  TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 3.5.h,
                        ),
                        child: Text(
                          'Delivery Option',
                          style: AppTextDecor.osRegular14black,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 3.5.h,
                        ),
                        child: Text(
                          '${data.paymentType}',
                          style: AppTextDecor.osRegular14black,
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 3.5.h,
                        ),
                        child: Text(
                          'Payable Amount',
                          style: AppTextDecor.osRegular14black,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 3.5.h,
                        ),
                        child: Text(
                          '${settingsBox.get('currency') ?? '\$'}${data.totalAmount}',
                          style: AppTextDecor.osRegular14black,
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 3.5.h,
                        ),
                        child: Text(
                          'Status',
                          style: AppTextDecor.osRegular14black,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      AppTextButton(
                        title: '${data.orderStatus}',
                        height: 25.h,
                        width: 122.w,
                        buttonColor: getOrderStatusColor(),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 3.5.h,
                        ),
                        child: Text(
                          'Payment Status',
                          style: AppTextDecor.osRegular14black,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Text(
                        '${data.paymentStatus}',
                        style: data.paymentStatus?.toLowerCase() == 'paid'
                            ? AppTextDecor.osBold14gold
                            : AppTextDecor.osBold14red,
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                ],
              ),
              AppSpacerH(10.h),
              const MySeparator(),
              AppSpacerH(10.h),
              SizedBox(
                height: 32.h,
                width: 335.w,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_pin,
                      size: 18.h,
                    ),
                    Expanded(
                      child: Text(
                        AppGFunctions.processAdAddess(
                          Address.fromMap(data.address!.toMap()),
                        ),
                        style: AppTextDecor.osRegular12black,
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_right,
                      size: 18.h,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Color getOrderStatusColor() {
    if (data.orderStatus!.toLowerCase() == 'pending') {
      return AppColors.gray;
    } else if (data.orderStatus!.replaceAll(' ', '').toLowerCase() ==
        'pickedYourOrder'.toLowerCase()) {
      return const Color(0xFF3AD0FF);
    } else {
      return AppColors.gold;
    }
  }
}
