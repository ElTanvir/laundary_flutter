import 'package:dry_cleaners/constants/app_box_decoration.dart';
import 'package:dry_cleaners/constants/app_text_decor.dart';
import 'package:dry_cleaners/constants/hive_contants.dart';
import 'package:dry_cleaners/misc/misc_global_variables.dart';
import 'package:dry_cleaners/models/hive_cart_item_model.dart';
import 'package:dry_cleaners/models/order_place_model/order_place_model.dart';
import 'package:dry_cleaners/providers/misc_providers.dart';
import 'package:dry_cleaners/providers/order_providers.dart';
import 'package:dry_cleaners/screens/payment/payment_controller.dart';
import 'package:dry_cleaners/utils/context_less_nav.dart';
import 'package:dry_cleaners/utils/routes.dart';
import 'package:dry_cleaners/widgets/buttons/full_width_button.dart';
import 'package:dry_cleaners/widgets/misc_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class PaymentSection extends ConsumerWidget {
  PaymentSection({super.key, required this.instruction});
  final Box appSettingsBox = Hive.box(AppHSC.appSettingsBox);
  int? couponID;
  final TextEditingController instruction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(couponProvider).maybeWhen(
          orElse: () {},
          loaded: (_) {
            couponID = _.data?.coupon?.id;
          },
        );
    return ValueListenableBuilder(
      valueListenable: Hive.box(AppHSC.cartBox).listenable(),
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
        return Container(
          width: 375.w,
          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 25.h,
          ),
          decoration: AppBoxDecorations.pageCommonCard,
          child: SizedBox(
            // height: 70.h,
            child: Consumer(
              builder: (context, ref, child) {
                return ref.watch(placeOrdersProvider).map(
                      initial: (_) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Payable',
                                style: AppTextDecor.osSemiBold18black,
                              ),
                              Text(
                                '${appSettingsBox.get('currency') ?? '\$'}${(calculateTotal(cartItems) - ref.watch(discountAmountProvider)).toStringAsFixed(2)}',
                                style: AppTextDecor.osSemiBold18black,
                              ),
                            ],
                          ),
                          AppTextButton(
                            title: 'Pay Now',
                            onTap: () async {
                              /*
                                      Order Placement Data Validation and Logic Processed Here
                                      */
                              final DateFormat formatter = DateFormat(
                                'yyyy-MM-dd',
                              );
                              final isOrderProcessing =
                                  ref.watch(orderProcessingProvider);

                              if (!isOrderProcessing) {
                                ref
                                    .watch(orderProcessingProvider.notifier)
                                    .state = true;
                                final pickUp = ref.watch(
                                  scheduleProvider('Pick Up'),
                                );
                                final delivery = ref.watch(
                                  scheduleProvider(
                                    'Delivery',
                                  ),
                                );
                                final address = ref.watch(
                                  addressIDProvider,
                                );

                                //Cheks All Reguired Data Is AvailAble
                                if (pickUp != null &&
                                    delivery != null &&
                                    address != '' &&
                                    cartItems.isNotEmpty) {
                                  //Has All Data

                                  await ref
                                      .watch(
                                        placeOrdersProvider.notifier,
                                      )
                                      .addOrder(
                                        OrderPlaceModel(
                                          address_id: address,
                                          pick_date: formatter.format(
                                            pickUp.dateTime,
                                          ),
                                          pick_hour:
                                              pickUp.schedule.hour.toString(),
                                          delivery_date: formatter.format(
                                            delivery.dateTime,
                                          ),
                                          delivery_hour:
                                              delivery.schedule.hour.toString(),
                                          coupon_id: couponID?.toString() ?? '',
                                          instruction: instruction.text,
                                          products: cartItems
                                              .map(
                                                (e) => OrderProductModel(
                                                  id: e.productsId.toString(),
                                                  quantity:
                                                      e.productsQTY.toString(),
                                                ),
                                              )
                                              .toList(),
                                          additional_service_id: [],
                                        ),
                                      );
                                } else {
                                  //Missing Data
                                  EasyLoading.showError(
                                    'Please Select All Fields',
                                  );
                                }
                                ref
                                    .watch(orderProcessingProvider.notifier)
                                    .state = false;
                              } else {
                                EasyLoading.showError(
                                  'We are processing your Previous Request.\nPlease Wait',
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      loading: (_) => const LoadingWidget(),
                      loaded: (_) {
                        final PaymentController pay = PaymentController();
                        Future.delayed(buildDuration).then((value) async {
                          EasyLoading.showSuccess(
                            'Order Placed',
                          );
                          final String amount = (calculateTotal(cartItems) -
                                  ref.watch(
                                    discountAmountProvider,
                                  ))
                              .toStringAsFixed(2);
                          final ispaid = await pay.makePayment(
                            amount: amount,
                            currency: 'GBP',
                            couponID: couponID?.toString(),
                            orderID: _.data.data!.order!.id.toString(),
                          );

                          await cartBox.clear();
                          ref.refresh(placeOrdersProvider);
                          ref.refresh(couponProvider);
                          ref.refresh(
                            discountAmountProvider,
                          );
                          ref
                              .watch(
                                dateProvider('Pick Up').notifier,
                              )
                              .state = null;
                          ref
                              .watch(
                                dateProvider('Delivery').notifier,
                              )
                              .state = null;
                          context.nav.pushNamedAndRemoveUntil(
                            Routes.orderSuccessScreen,
                            arguments: {
                              'id': _.data.data!.order!.orderCode,
                              'amount': amount,
                              'isPaid': ispaid
                            },
                            (route) => false,
                          );
                        });
                        return const MessageTextWidget(
                          msg: 'Order Placed',
                        );
                      },
                      error: (_) {
                        Future.delayed(
                          const Duration(seconds: 2),
                        ).then((value) {
                          ref.refresh(placeOrdersProvider);
                        });
                        return ErrorTextWidget(
                          error: _.error,
                        );
                      },
                    );
              },
            ),
          ),
        );
      },
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
