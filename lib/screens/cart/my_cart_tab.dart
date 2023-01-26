import 'package:dry_cleaners/constants/app_box_decoration.dart';
import 'package:dry_cleaners/constants/app_colors.dart';
import 'package:dry_cleaners/constants/app_text_decor.dart';
import 'package:dry_cleaners/constants/hive_contants.dart';
import 'package:dry_cleaners/constants/input_field_decorations.dart';
import 'package:dry_cleaners/misc/global_functions.dart';
import 'package:dry_cleaners/misc/misc_global_variables.dart';
import 'package:dry_cleaners/models/hive_cart_item_model.dart';
import 'package:dry_cleaners/providers/address_provider.dart';
import 'package:dry_cleaners/providers/order_providers.dart';
import 'package:dry_cleaners/screens/cart/my_cart_with_image_card.dart';
import 'package:dry_cleaners/utils/context_less_nav.dart';
import 'package:dry_cleaners/utils/routes.dart';
import 'package:dry_cleaners/widgets/buttons/full_width_button.dart';
import 'package:dry_cleaners/widgets/misc_widgets.dart';
import 'package:dry_cleaners/widgets/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MyCartTab extends ConsumerWidget {
  MyCartTab({super.key});
  final Box appSettingsBox = Hive.box(AppHSC.appSettingsBox);
  final TextEditingController coupon = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(couponProvider);
    ref.watch(discountAmountProvider);
    return SingleChildScrollView(
      child: SizedBox(
        height: 812.h,
        width: 375.w,
        child: Column(
          children: [
            Container(
              decoration: AppBoxDecorations.topBar,
              height: 88.h,
              width: 375.w,
              child: Column(
                children: [
                  AppSpacerH(42.h),
                  const AppNavbar(
                    showBack: false,
                    title: 'My Cart',
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                height: 724.h,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: ValueListenableBuilder(
                  valueListenable: Hive.box(AppHSC.authBox).listenable(),
                  builder: (BuildContext context, Box authbox, Widget? child) {
                    return authbox.get(AppHSC.authToken) != null
                        ? SizedBox(
                            height: 606.h,
                            width: 335.w,
                            child: ValueListenableBuilder(
                              valueListenable:
                                  Hive.box(AppHSC.cartBox).listenable(),
                              builder: (
                                BuildContext context,
                                Box cartBox,
                                Widget? child,
                              ) {
                                final List<CarItemHiveModel> cartItems = [];
                                for (var i = 0; i < cartBox.length; i++) {
                                  final Map<String, dynamic> processedData = {};
                                  final Map<dynamic, dynamic> unprocessedData =
                                      cartBox.getAt(i) as Map<dynamic, dynamic>;

                                  unprocessedData.forEach((key, value) {
                                    processedData[key.toString()] = value;
                                  });

                                  cartItems.add(
                                    CarItemHiveModel.fromMap(
                                      processedData,
                                    ),
                                  );
                                }
                                ref.watch(couponProvider).maybeWhen(
                                      orElse: () {},
                                      error: (_) {
                                        EasyLoading.showError(_);
                                        ref.refresh(couponProvider);
                                      },
                                      loaded: (_) {
                                        if (_.data?.coupon?.discount != null) {
                                          if (_.data!.coupon!.type!
                                                  .toLowerCase() ==
                                              "percent".toLowerCase()) {
                                            final double subToatalAmount =
                                                calculateTotal(
                                              cartItems,
                                            );
                                            Future.delayed(buildDuration)
                                                .then((value) {
                                              ref
                                                      .watch(
                                                        discountAmountProvider
                                                            .notifier,
                                                      )
                                                      .state =
                                                  subToatalAmount *
                                                      (_.data!.coupon!
                                                              .discount! /
                                                          100);
                                            });
                                          } else {
                                            Future.delayed(buildDuration)
                                                .then((value) {
                                              ref
                                                      .watch(
                                                        discountAmountProvider
                                                            .notifier,
                                                      )
                                                      .state =
                                                  _.data!.coupon!.discount!
                                                      .toDouble();
                                            });
                                          }
                                        }
                                      },
                                    );
                                return cartItems.isNotEmpty
                                    ? ListView(
                                        padding: EdgeInsets.zero,
                                        children: [
                                          ...cartItems
                                              .map(
                                                (e) => MyCartItemImageCard(
                                                  carItemHiveModel: e,
                                                ),
                                              )
                                              .toList(),
                                          AppSpacerH(25.h),
                                          Text(
                                            'Coupon Code',
                                            style:
                                                AppTextDecor.osSemiBold18black,
                                          ),
                                          SizedBox(
                                            height: 50.h,
                                            width: 335.w,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: TextField(
                                                    controller: coupon,
                                                    decoration: AppInputDecor
                                                        .loginPageInputDecor,
                                                  ),
                                                ),
                                                AppTextButton(
                                                  title: 'Apply',
                                                  height: 50.h,
                                                  width: 86.w,
                                                  onTap: () {
                                                    ref
                                                        .watch(
                                                          couponProvider
                                                              .notifier,
                                                        )
                                                        .applyCoupon(
                                                          coupon: coupon.text,
                                                          amount:
                                                              calculateTotal(
                                                            cartItems,
                                                          ).toStringAsFixed(
                                                            2,
                                                          ),
                                                        );
                                                  },
                                                )
                                              ],
                                            ),
                                          ),
                                          ref.watch(couponProvider).maybeWhen(
                                                orElse: () => const SizedBox(),
                                                loaded: (_) => GestureDetector(
                                                  onTap: () {
                                                    ref.refresh(couponProvider);
                                                    ref.refresh(
                                                      discountAmountProvider,
                                                    );
                                                  },
                                                  child: SizedBox(
                                                    height: 20.h,
                                                    width: 335.w,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          'Remove Coupon ${_.data?.coupon?.code ?? ''}',
                                                          style: AppTextDecor
                                                              .osRegular12red,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          AppSpacerH(3.h),
                                          Text(
                                            'Order Summary',
                                            style:
                                                AppTextDecor.osSemiBold18black,
                                          ),
                                          Container(
                                            width: 335.w,
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 20.w,
                                              vertical: 15.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.white,
                                              borderRadius:
                                                  BorderRadius.circular(5.w),
                                            ),
                                            child: Column(
                                              children: [
                                                Table(
                                                  children: [
                                                    AppGFunctions.tableTextRow(
                                                      title: 'Sub Total',
                                                      data:
                                                          '${appSettingsBox.get('currency') ?? '\$'}${calculateTotal(cartItems).toStringAsFixed(2)}',
                                                    ),
                                                    AppGFunctions.tableTextRow(
                                                      title: 'Delivery Charge',
                                                      data:
                                                          '${appSettingsBox.get('currency') ?? '\$'}0.00',
                                                    ),
                                                    AppGFunctions
                                                        .tableDiscountTextRow(
                                                      title: 'Discount',
                                                      data:
                                                          '${appSettingsBox.get('currency') ?? '\$'}${ref.watch(discountAmountProvider).toStringAsFixed(2)}',
                                                    ),
                                                  ],
                                                ),
                                                AppSpacerH(8.5.h),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Total',
                                                      style: AppTextDecor
                                                          .osBold14black,
                                                    ),
                                                    Text(
                                                      '${appSettingsBox.get('currency') ?? '\$'}${(calculateTotal(cartItems) - ref.watch(discountAmountProvider)).toStringAsFixed(2)}',
                                                      style: AppTextDecor
                                                          .osBold14black,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          AppSpacerH(25.h),
                                          Container(
                                            height: 104.h,
                                            width: 375.w,
                                            color: AppColors.white,
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 20.w,
                                            ),
                                            child: SizedBox(
                                              height: 50,
                                              width: 335.w,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        'Total',
                                                        style: AppTextDecor
                                                            .osSemiBold18black,
                                                      ),
                                                      Text(
                                                        '${appSettingsBox.get('currency') ?? '\$'}${(calculateTotal(cartItems) - ref.watch(discountAmountProvider)).toStringAsFixed(2)}',
                                                        style: AppTextDecor
                                                            .osSemiBold18black,
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      if (calculateTotal(
                                                            cartItems,
                                                          ) <
                                                          20)
                                                        Text(
                                                          'Minimum order Amount ${appSettingsBox.get('currency') ?? '\$'}20',
                                                          style: AppTextDecor
                                                              .osRegular12red,
                                                        ),
                                                      AppSpacerH(5.h),
                                                      AppTextButton(
                                                        title: 'Check Out',
                                                        height: 45.h,
                                                        width: 164.w,
                                                        onTap: () {
                                                          final Box authBox =
                                                              Hive.box(
                                                            AppHSC.authBox,
                                                          ); //Stores Auth Data

                                                          if (authBox.get(
                                                                    AppHSC
                                                                        .authToken,
                                                                  ) !=
                                                                  null &&
                                                              authBox.get(
                                                                    AppHSC
                                                                        .authToken,
                                                                  ) !=
                                                                  '') {
                                                            if (calculateTotal(
                                                                  cartItems,
                                                                ) >=
                                                                20) {
                                                              ref.refresh(
                                                                addresListProvider,
                                                              );
                                                              context.nav
                                                                  .pushNamed(
                                                                Routes
                                                                    .checkOutScreen,
                                                              );
                                                            } else {
                                                              EasyLoading
                                                                  .showError(
                                                                'Minimum Order Amount £20',
                                                              );
                                                            }
                                                          } else {
                                                            context.nav
                                                                .pushNamed(
                                                              Routes
                                                                  .loginScreen,
                                                            );
                                                          }
                                                        },
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          AppSpacerH(90.h)
                                        ],
                                      )
                                    : const MessageTextWidget(
                                        msg: 'No Item In Cart',
                                      );
                              },
                            ),
                          )
                        : const NotSignedInwidget();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double calculateTotal(List<CarItemHiveModel> cartItems) {
    double amount = 0;
    for (final element in cartItems) {
      amount += element.productsQTY * element.unitPrice;
    }
    return amount;
  }
}

class NotSignedInwidget extends ConsumerWidget {
  const NotSignedInwidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/images/not_found.png'),
        Text(
          'You are not signed in!\nPlease sign in first.',
          style: AppTextDecor.osSemiBold18black,
          textAlign: TextAlign.center,
        ),
        AppSpacerH(35.h),
        AppTextButton(
          title: 'Sign in',
          onTap: () {
            context.nav.pushNamed(Routes.loginScreen);
          },
        )
      ],
    );
  }
}
