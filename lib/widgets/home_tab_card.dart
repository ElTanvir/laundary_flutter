import 'package:dry_cleaners/constants/app_colors.dart';
import 'package:dry_cleaners/constants/app_text_decor.dart';
import 'package:dry_cleaners/models/all_service_model/service.dart';
import 'package:dry_cleaners/providers/guest_providers.dart';
import 'package:dry_cleaners/widgets/misc_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeTabCard extends ConsumerWidget {
  const HomeTabCard({
    super.key,
    required this.service,
    this.ontap,
  });
  final Service service;
  final Function()? ontap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(servicesVariationsProvider(service.id!.toString()));
    return GestureDetector(
      onTap: ontap,
      child: SizedBox(
        width: 74.h,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5.h),
              child: Container(
                height: 74.h,
                width: 74.h,
                color: AppColors.white,
                child: Image.network(
                  service.imagePath!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            AppSpacerW(4.h),
            Text(
              service.name!,
              style: AppTextDecor.osSemiBold10black,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
