import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:notepada/core/routes/names.dart';
import 'package:notepada/core/util/storage/storage_keys.dart';
import 'package:notepada/core/util/storage/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:notepada/features/splash/presentation/bloc/splash_cubit.dart';
import 'package:notepada/features/splash/presentation/bloc/splash_state.dart';
import 'package:notepada/config/assets/vectors.dart';
import 'package:notepada/config/theme/colors.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SplashCubit>().checkSession();
    });
    // StorageService storageService = StorageService();
    // storageService.clearAll();
    super.initState();
    // redirect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: BlocConsumer<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state is SplashSuccess) {
            context.goNamed(RouteNames.home);
          } else if (state is SplashError) {
            final storedUserID = StorageService().getValue(StorageKeys.userID);
            if (storedUserID == null) {
              context.goNamed(RouteNames.intro);
            } else {
              context.goNamed(RouteNames.auth);
              // context.goNamed(RouteNames.intro);
            }
          }
        },
        builder: (context, state) => Center(
          child: SvgPicture.asset(
            AppVectors.icon,
            height: 60,
            color: AppColors.bright,
          ),
        ),
      ),
    );
  }

  Future<void> redirect() async {
    await Future.delayed(const Duration(seconds: 2));
    context.goNamed(RouteNames.intro);
  }
}
