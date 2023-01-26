import 'package:dry_cleaners/constants/app_box_decoration.dart';
import 'package:dry_cleaners/constants/app_colors.dart';
import 'package:dry_cleaners/constants/app_text_decor.dart';
import 'package:dry_cleaners/constants/hive_contants.dart';
import 'package:dry_cleaners/misc/global_functions.dart';
import 'package:dry_cleaners/models/order_details_model/product.dart';
import 'package:dry_cleaners/providers/order_providers.dart';
import 'package:dry_cleaners/screens/order/order_dialouges.dart';
import 'package:dry_cleaners/utils/context_less_nav.dart';
import 'package:dry_cleaners/widgets/buttons/order_cancel_button.dart';
import 'package:dry_cleaners/widgets/dashed_line.dart';
import 'package:dry_cleaners/widgets/misc_widgets.dart';
import 'package:dry_cleaners/widgets/nav_bar.dart';
import 'package:dry_cleaners/widgets/screen_wrapper.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';

class OrderDetails extends ConsumerWidget {
  const OrderDetails({
    super.key,
    required this.orderID,
  });
  final String orderID;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Box settingsBox = Hive.box(AppHSC.appSettingsBox);
    ref.watch(orderDetailsProvider(orderID));
    return ScreenWrapper(
      padding: EdgeInsets.zero,
      child: Container(
        height: 812.h,
        width: 375.w,
        color: AppColors.grayBG,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: AppColors.white,
                height: 88.h,
                width: 375.w,
                child: Column(
                  children: [
                    AppSpacerH(44.h),
                    AppNavbar(
                      title: 'Order details',
                      onBack: () {
                        context.nav.pop();
                      },
                    ),
                  ],
                ),
              ),
              Container(
                height: 724.h,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: ref.watch(orderDetailsProvider(orderID)).map(
                      initial: (_) => const LoadingWidget(),
                      loading: (_) => const LoadingWidget(),
                      loaded: (_) {
                        final List<OrderDetailsTile> orderWidgets = [];
                        for (var i = 0;
                            i < _.data.data!.order!.products!.length;
                            i++) {
                          orderWidgets.add(
                            OrderDetailsTile(
                              product: _.data.data!.order!.products![i],
                              qty: _.data.data!.order!.quantity!.quantity[i]
                                  .quantity,
                            ),
                          );
                        }
                        return ListView(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                                vertical: 15.h,
                              ),
                              decoration: AppBoxDecorations.pageCommonCard,
                              child: ExpandablePanel(
                                header: Text(
                                  'Items (${_.data.data!.order!.products!.length})',
                                  style: AppTextDecor.osBold14black,
                                ),
                                collapsed: const SizedBox(),
                                expanded: Column(
                                  children: orderWidgets,
                                ),
                              ),
                            ),
                            AppSpacerH(15.h),
                            Container(
                              width: 335.w,
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                                vertical: 15.h,
                              ),
                              decoration: AppBoxDecorations.pageCommonCard,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Shipping Address',
                                    style: AppTextDecor.osBold14black,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_pin,
                                        size: 40.w,
                                      ),
                                      AppSpacerW(10.w),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _.data.data!.order!.customer!.user!
                                                .name!,
                                            style:
                                                AppTextDecor.osRegular14black,
                                          ),
                                          Text(
                                            _.data.data!.order!.customer!.user!
                                                .mobile!,
                                            style:
                                                AppTextDecor.osRegular14black,
                                          ),
                                          Text(
                                            _.data.data!.order!.address!
                                                .addressLine!,
                                            style:
                                                AppTextDecor.osRegular14black,
                                          ),
                                          Text(
                                            _.data.data!.order!.address!
                                                    .addressLine2 ??
                                                '',
                                            style:
                                                AppTextDecor.osRegular14black,
                                          ),
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            AppSpacerH(15.h),
                            Container(
                              width: 335.w,
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                                vertical: 15.h,
                              ),
                              decoration: AppBoxDecorations.pageCommonCard,
                              child: Column(
                                children: [
                                  Table(
                                    children: [
                                      AppGFunctions.tableTitleTextRow(
                                        title: 'Order ID',
                                        data:
                                            '#${_.data.data!.order!.orderCode}',
                                      ),
                                      AppGFunctions.tableTextRow(
                                        title: 'Pick Up At',
                                        data:
                                            '${_.data.data!.order!.pickDate} - ${_.data.data!.order!.pickHour}',
                                      ),
                                      AppGFunctions.tableTextRow(
                                        title: 'Delivery At',
                                        data:
                                            '${_.data.data!.order!.deliveryDate} - ${_.data.data!.order!.deliveryHour}',
                                      ),
                                      AppGFunctions.tableTextRow(
                                        title: 'Order Status',
                                        data:
                                            '${_.data.data!.order!.orderStatus}',
                                      ),
                                      AppGFunctions.tableTextRow(
                                        title: 'Payment Status',
                                        data:
                                            '${_.data.data!.order!.paymentStatus}',
                                      ),
                                      AppGFunctions.tableTextRow(
                                        title: 'Sub total',
                                        data:
                                            '${settingsBox.get('currency') ?? '\$'}${_.data.data!.order!.amount}',
                                      ),
                                      AppGFunctions.tableTextRow(
                                        title: 'Delivery Charge',
                                        data:
                                            '${settingsBox.get('currency') ?? '\$'}${_.data.data!.order!.deliveryCharge}',
                                      ),
                                      AppGFunctions.tableDiscountTextRow(
                                        title: 'Discount',
                                        data:
                                            '${settingsBox.get('currency') ?? '\$'}${_.data.data!.order!.discount}',
                                      ),
                                    ],
                                  ),
                                  const MySeparator(),
                                  AppSpacerH(8.5.h),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Total',
                                        style: AppTextDecor.osBold14black,
                                      ),
                                      Text(
                                        '${settingsBox.get('currency') ?? '\$'}${_.data.data!.order!.totalAmount}',
                                        style: AppTextDecor.osBold14black,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            AppSpacerH(15.h),
                            if (_.data.data?.order?.orderStatus ==
                                    'Delivered' &&
                                _.data.data?.order?.rating == null)
                              CancelOrderButton(
                                title: 'Rate Your Experience',
                                onTap: () {
                                  AppOrderDialouges.orderFeedBackDialouge(
                                    context: context,
                                    orderID: _.data.data!.order!.id.toString(),
                                    ref: ref,
                                  );
                                },
                              ),
                          ],
                        );
                      },
                      error: (_) => ErrorTextWidget(
                        error: _.error,
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

class OrderDetailsTile extends StatelessWidget {
  const OrderDetailsTile({
    super.key,
    required this.product,
    required this.qty,
  });
  final Product product;
  final int qty;

  @override
  Widget build(BuildContext context) {
    final Box settingsBox = Hive.box(AppHSC.appSettingsBox);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: SizedBox(
        // height: 40.h,
        width: 297.w,
        child: Row(
          children: [
            Image.network(
              product.imagePath!,
              height: 40.h,
              width: 42.w,
            ),
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product.name!,
                          style: AppTextDecor.osBold12black,
                        ),
                      ),
                      Text(
                        '${settingsBox.get('currency') ?? '\$'}${product.currentPrice! * qty}',
                        style: AppTextDecor.osBold12gold,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product.service?.name ?? '',
                          style: AppTextDecor.osRegular12navy,
                          maxLines: 3,
                        ),
                      ),
                      Text(
                        '${qty}x${settingsBox.get('currency') ?? '\$'}${product.currentPrice!}',
                        style: AppTextDecor.osRegular12navy,
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
