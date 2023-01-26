import 'package:dry_cleaners/constants/app_colors.dart';
import 'package:dry_cleaners/constants/app_text_decor.dart';
import 'package:dry_cleaners/constants/hive_contants.dart';
import 'package:dry_cleaners/constants/input_field_decorations.dart';
import 'package:dry_cleaners/misc/misc_global_variables.dart';
import 'package:dry_cleaners/providers/address_provider.dart';
import 'package:dry_cleaners/providers/auth_provider.dart';
import 'package:dry_cleaners/providers/profile_update_provider.dart';
import 'package:dry_cleaners/screens/auth/login_screen_wrapper.dart';
import 'package:dry_cleaners/utils/context_less_nav.dart';
import 'package:dry_cleaners/utils/routes.dart';
import 'package:dry_cleaners/widgets/buttons/full_width_button.dart';
import 'package:dry_cleaners/widgets/misc_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final List<FocusNode> fNodes = [FocusNode(), FocusNode()];
  final GlobalKey<FormBuilderState> _formkey = GlobalKey<FormBuilderState>();
  bool obsecureText = true;

  @override
  void initState() {
    super.initState();
    for (final element in fNodes) {
      if (element.hasFocus) {
        element.unfocus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoginScreenWrapper(
      child: SingleChildScrollView(
        child: FormBuilder(
          key: _formkey,
          child: SizedBox(
            height: 812.h,
            width: 375.w,
            child: Column(
              children: [
                SizedBox(
                  height: 230.h,
                  width: 375.w,
                  child: Center(
                    child: Hero(
                      tag: 'logo',
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: 100.h,
                        width: 195.w,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    // height: 582.h,
                    // width: 375.w,
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      children: [
                        AppSpacerH(33.h),
                        FormBuilderTextField(
                          focusNode: fNodes[0],
                          name: 'email',
                          decoration:
                              AppInputDecor.loginPageInputDecor.copyWith(
                            hintText: 'Email',
                          ),
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: FormBuilderValidators.compose(
                            [FormBuilderValidators.required()],
                          ),
                        ),
                        AppSpacerH(20.h),
                        FormBuilderTextField(
                          focusNode: fNodes[1],
                          name: 'password',
                          obscureText: obsecureText,
                          decoration:
                              AppInputDecor.loginPageInputDecor.copyWith(
                            hintText: 'Password',
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  obsecureText = !obsecureText;
                                });
                              },
                              child: Icon(
                                obsecureText
                                    ? Icons.visibility
                                    : Icons.visibility_off_outlined,
                                color: AppColors.black,
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          validator: FormBuilderValidators.compose(
                            [FormBuilderValidators.required()],
                          ),
                        ),
                        AppSpacerH(20.h),
                        SizedBox(
                          height: 18.h,
                          width: 335.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(),
                              GestureDetector(
                                onTap: () {
                                  context.nav.pushNamed(
                                    Routes.recoverPassWordStageOne,
                                  );
                                },
                                child: Text(
                                  'Forgot password?',
                                  style: AppTextDecor.osRegular12black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        AppSpacerH(40.h),
                        SizedBox(
                          height: 50.h,
                          child: Consumer(
                            builder: (context, WidgetRef ref, child) {
                              return ref.watch(loginProvider).map(
                                    error: (_) {
                                      Future.delayed(transissionDuration)
                                          .then((value) {
                                        ref.refresh(loginProvider);
                                      });
                                      return ErrorTextWidget(error: _.error);
                                    },
                                    loaded: (_) {
                                      final Box box = Hive.box(
                                        AppHSC.authBox,
                                      ); //Stores Auth Data
                                      final Box userBox = Hive.box(
                                        AppHSC.userBox,
                                      ); //Stores User Data
                                      box.putAll(_.data.data!.access!.toMap());
                                      userBox
                                          .putAll(_.data.data!.user!.toMap());
                                      Future.delayed(transissionDuration)
                                          .then((value) {
                                        ref.refresh(
                                          loginProvider,
                                        ); //Refresh This so That App Doesn't Auto Login
                                        ref.refresh(profileInfoProvider);
                                        ref.refresh(addresListProvider);

                                        Future.delayed(buildDuration)
                                            .then((value) {
                                          context.nav.pushNamedAndRemoveUntil(
                                            Routes.homeScreen,
                                            (route) => false,
                                          );
                                        });
                                      });
                                      return const MessageTextWidget(
                                        msg: 'Success',
                                      );
                                    },
                                    initial: (_) => AppTextButton(
                                      buttonColor: AppColors.goldenButton,
                                      title: 'Login',
                                      titleColor: AppColors.white,
                                      onTap: () {
                                        for (final element in fNodes) {
                                          if (element.hasFocus) {
                                            element.unfocus();
                                          }
                                        }
                                        if (_formkey.currentState != null &&
                                            _formkey.currentState!
                                                .saveAndValidate()) {
                                          final formData =
                                              _formkey.currentState!.fields;

                                          ref
                                              .watch(loginProvider.notifier)
                                              .login(
                                                formData['email']!.value
                                                    as String,
                                                formData['password']!.value
                                                    as String,
                                              );
                                        }
                                      },
                                    ),
                                    loading: (_) => const LoadingWidget(),
                                  );
                            },
                          ),
                        ),
                        AppSpacerH(220.h),
                        SizedBox(
                          height: 18.h,
                          width: 335.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an Account? ",
                                style: AppTextDecor.osRegular12black,
                              ),
                              GestureDetector(
                                onTap: () {
                                  context.nav.pushNamed(Routes.signUpScreen);
                                },
                                child: Text(
                                  "Sign up",
                                  style: AppTextDecor.osBold12gold,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
