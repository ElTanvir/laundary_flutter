import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dry_cleaners/constants/app_colors.dart';
import 'package:dry_cleaners/constants/app_text_decor.dart';
import 'package:dry_cleaners/constants/hive_contants.dart';
import 'package:dry_cleaners/misc/misc_global_variables.dart';
import 'package:dry_cleaners/providers/guest_providers.dart';
import 'package:dry_cleaners/providers/misc_providers.dart';
import 'package:dry_cleaners/providers/order_providers.dart';
import 'package:dry_cleaners/providers/profile_update_provider.dart';
import 'package:dry_cleaners/providers/settings_provider.dart';
import 'package:dry_cleaners/screens/order/my_order_home_tile.dart';
import 'package:dry_cleaners/utils/context_less_nav.dart';
import 'package:dry_cleaners/utils/routes.dart';
import 'package:dry_cleaners/widgets/home_tab_card.dart';
import 'package:dry_cleaners/widgets/misc_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';

// ignore: must_be_immutable
class HomeTab extends ConsumerWidget {
  HomeTab({super.key});
  List postCodelist = [];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(profileInfoProvider);
    ref.watch(settingsProvider).maybeWhen(
          orElse: () {},
          loaded: (_) {
            postCodelist = _.data?.postCode ?? [];
          },
        );
    ref.watch(allServicesProvider);

    return SizedBox(
      height: 812.h,
      width: 375.w,
      child: ValueListenableBuilder(
        valueListenable: Hive.box(AppHSC.authBox).listenable(),
        builder: (context, Box authBox, Widget? child) {
          return ValueListenableBuilder(
            valueListenable: Hive.box(AppHSC.userBox).listenable(),
            builder: (context, Box box, Widget? child) {
              return Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20.h),
                      bottomRight: Radius.circular(20.h),
                    ),
                    child: Container(
                      color: AppColors.white,
                      width: 375.w,
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppSpacerH(44.h),
                          SizedBox(
                            height: 48.h,
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/icon_wave.png',
                                  height: 48.h,
                                  width: 48.w,
                                ),
                                AppSpacerW(15.w),
                                // if (authBox.get('token') != null)
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Hello',
                                      style: AppTextDecor.osRegular12black,
                                      textAlign: TextAlign.start,
                                    ),
                                    Text(
                                      authBox.get('token') != null
                                          ? '${box.get('name')}'
                                          : 'Please Login',
                                      style: AppTextDecor.osBold20Black,
                                      textAlign: TextAlign.start,
                                    ),
                                    // Text(
                                    //   address,
                                    //   style: AppTextDecor.osRegular14white,
                                    // )
                                  ],
                                ),
                                const Expanded(child: SizedBox()),
                                if (authBox.get('token') != null)
                                  CachedNetworkImage(
                                    imageUrl: box
                                        .get('profile_photo_path')
                                        .toString(),
                                    width: 39.h,
                                    height: 39.h,
                                    fit: BoxFit.cover,
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  )
                                else
                                  GestureDetector(
                                    onTap: () {
                                      context.nav.pushNamed(
                                        Routes.loginScreen,
                                      );
                                    },
                                    child: SvgPicture.asset(
                                      "assets/svgs/icon_home_login.svg",
                                      width: 39.h,
                                      height: 39.h,
                                    ),
                                  )
                              ],
                            ),
                          ),
                          AppSpacerH(20.h),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          AppSpacerH(20.h),
                          SizedBox(
                            width: 375.w,
                            height: 170.h,
                            child: Consumer(
                              builder: (context, ref, child) {
                                return ref.watch(allPromotionsProvider).map(
                                      initial: (_) => const SizedBox(),
                                      loading: (_) => const LoadingWidget(
                                        showBG: true,
                                      ),
                                      loaded: (_) => CarouselSlider(
                                        options: CarouselOptions(
                                          height: 170.0.h,
                                          viewportFraction: 0.95,
                                        ),
                                        items: _.data.data!.promotions!
                                            .map(
                                              (e) => Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 9.w,
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    10.w,
                                                  ),
                                                  child: Container(
                                                    color: AppColors.white,
                                                    width: 335.w,
                                                    child: Image.network(
                                                      e.imagePath!,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                      error: (_) =>
                                          ErrorTextWidget(error: _.error),
                                    );
                              },
                            ),
                          ),
                          AppSpacerH(32.h),
                          Text(
                            'Service Categories',
                            style: AppTextDecor.osBold24black,
                          ),
                          AppSpacerH(16.h),
                          SizedBox(
                            height: 92.h,
                            child: ref.watch(allServicesProvider).map(
                                  initial: (_) => const SizedBox(),
                                  loading: (_) => const LoadingWidget(
                                    showBG: true,
                                  ),
                                  loaded: (_) {
                                    if (_.data.data!.services!.isNotEmpty) {
                                      return ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount:
                                            _.data.data!.services!.length,
                                        itemBuilder: (context, index) {
                                          final e =
                                              _.data.data!.services![index];
                                          return Padding(
                                            padding: EdgeInsets.only(
                                              right: (index ==
                                                      _.data.data!.services!
                                                              .length -
                                                          1)
                                                  ? 0
                                                  : 20.h,
                                            ),
                                            child: HomeTabCard(
                                              service: e,
                                              ontap: () {
                                                ref.refresh(
                                                  servicesVariationsProvider(
                                                    e.id.toString(),
                                                  ),
                                                );
                                                ref.refresh(
                                                  productsFilterProvider,
                                                );
                                                ref
                                                    .watch(
                                                      itemSelectMenuIndexProvider
                                                          .notifier,
                                                    )
                                                    .state = 0;

                                                context.nav.pushNamed(
                                                  Routes.chooseItemScreen,
                                                  arguments: e,
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      );
                                    } else {
                                      return const MessageTextWidget(
                                        msg: "No Service Available",
                                      );
                                    }
                                  },
                                  error: (_) => ErrorTextWidget(error: _.error),
                                ),
                          ),
                          if (authBox.get('token') != null)
                            ...ref.watch(allOrdersProvider).map(
                                  initial: (_) => [const SizedBox()],
                                  loading: (_) => [const LoadingWidget()],
                                  loaded: (_) {
                                    if (_.data.data!.orders!.isEmpty) {
                                      return [
                                        const MessageTextWidget(
                                          msg: 'No Order Found',
                                        )
                                      ];
                                    } else {
                                      return [
                                        AppSpacerH(32.h),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Active Order",
                                              style:
                                                  AppTextDecor.osRegular12black,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                ref
                                                    .watch(
                                                      homeScreenIndexProvider
                                                          .notifier,
                                                    )
                                                    .state = 1;
                                                ref
                                                    .watch(
                                                      homeScreenPageControllerProvider,
                                                    )
                                                    .animateToPage(
                                                      1,
                                                      duration:
                                                          transissionDuration,
                                                      curve: Curves.easeInOut,
                                                    );
                                              },
                                              child: Text(
                                                "View All",
                                                style: AppTextDecor
                                                    .osRegular12black,
                                              ),
                                            ),
                                          ],
                                        ),
                                        AppSpacerH(16.h),
                                        ..._.data.data!.orders!
                                            .map((e) => HomeOrderTile(data: e))
                                            .toList()
                                      ];
                                    }
                                  },
                                  error: (_) =>
                                      [ErrorTextWidget(error: _.error)],
                                ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  List<String> images = [
    'assets/images/dim_00.png',
    'assets/images/dim_01.png',
    'assets/images/dim_02.png'
  ];
}
