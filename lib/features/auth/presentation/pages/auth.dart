import 'package:appwrite/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:notepada/common/widgets/app_snack.dart';
import 'package:notepada/config/assets/images.dart';
import 'package:notepada/config/assets/vectors.dart';
import 'package:notepada/config/strings/strings.dart';
import 'package:notepada/config/theme/styles.dart';
import 'package:notepada/core/routes/names.dart';
import 'package:notepada/config/theme/colors.dart';
import 'package:notepada/core/util/storage/storage_service.dart';
import 'package:notepada/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:notepada/features/auth/presentation/bloc/auth_state.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  final StorageService _storageService = StorageService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is OAuth2Success) {
            // _storageService.setValue(
            //     StorageKeys.userID, state.success.toString());
            appSnackBar(context: context, message: AppStrings.loginSuccess);
            context.pushNamed(RouteNames.login);
          } else if (state is OAuth2Error) {
            appSnackBar(context: context, message: state.error);
          } else if (state is OAuth2Loading) {
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 10,
                    width: 10,
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  ),
                  AppGaps.v10,
                  Text(
                    AppStrings.gettingNotes,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
        },
        builder: (context, state) => SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              AppGaps.v40,
              SvgPicture.asset(
                AppVectors.icon,
                colorFilter: const ColorFilter.mode(
                  AppColors.primary,
                  BlendMode.srcATop,
                ),
                height: 50,
              ),
              AppGaps.v20,
              Text(
                AppStrings.introTitle,
                style: AppStyles.headerStyle.copyWith(fontSize: 30),
                textAlign: TextAlign.center,
              ),
              // AppGaps.v10,
              Text(
                AppStrings.introDescription,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.midGrey
                      : AppColors.darkGrey,
                  height: 1.3,
                ),
                textAlign: TextAlign.center,
              ),
              AppGaps.v30,
              Image.asset(
                AppImages.tree,
                height: 220,
                fit: BoxFit.cover,
              ),
              AppGaps.v20,
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppGaps.v20,
                    ElevatedButton(
                      onPressed: () {
                        context.pushNamed(RouteNames.register);
                      },
                      child: const Text(AppStrings.register),
                    ),
                    AppGaps.v10,
                    TextButton(
                      onPressed: () {
                        context.pushNamed(RouteNames.login);
                      },
                      child: const Text(
                        AppStrings.login,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    AppGaps.v10,
                    const Divider(),
                    AppGaps.v10,
                    const Text(
                      AppStrings.oauthDescription,
                      textAlign: TextAlign.center,
                    ),
                    AppGaps.v10,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            context
                                .read<AuthCubit>()
                                .oauth2(provider: OAuthProvider.google);
                          },
                          icon: SvgPicture.asset(
                            AppVectors.google,
                            height: 40,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: SvgPicture.asset(
                            AppVectors.apple,
                            height: 40,
                            colorFilter: ColorFilter.mode(
                              Theme.of(context).brightness == Brightness.dark
                                  ? AppColors.bright
                                  : AppColors.backgroundDark,
                              BlendMode.srcATop,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: SvgPicture.asset(
                            AppVectors.facebook,
                            height: 40,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: SvgPicture.asset(
                            AppVectors.twitter,
                            height: 40,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
