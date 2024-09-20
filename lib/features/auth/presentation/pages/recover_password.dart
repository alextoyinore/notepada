import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:notepada/config/strings/strings.dart';
import 'package:flutter/material.dart';
import 'package:notepada/config/theme/styles.dart';
import 'package:notepada/config/theme/colors.dart';
import 'package:notepada/core/routes/names.dart';
import 'package:notepada/core/util/storage/storage_service.dart';
import 'package:notepada/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:notepada/features/auth/presentation/bloc/auth_state.dart';
import 'package:notepada/service_locator.dart';

class RecoverPassword extends StatefulWidget {
  const RecoverPassword({super.key});

  @override
  State<RecoverPassword> createState() => _RecoverPasswordState();
}

class _RecoverPasswordState extends State<RecoverPassword> {
  final TextEditingController _email = TextEditingController();

  final StorageService _storageService = sl<StorageService>();

  bool _sendingData = false;

  @override
  void dispose() {
    // Clear texts from the textfields
    _email.clear();
    // Dispose the controllers
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () {
            context.pushNamed(RouteNames.login);
          },
          child: const Padding(
            padding: EdgeInsets.only(left: 32.0),
            child: Icon(
              Icons.arrow_back_ios,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is RecoverPasswordLoading) {
            _sendingData = true;
          } else if (state is RecoverPasswordError) {
            _sendingData = false;
            var snackBar = SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: AppColors.darkGrey,
              showCloseIcon: true,
              closeIconColor: AppColors.bright,
              content: Text(
                state.error,
                style: const TextStyle(color: Colors.white),
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else if (state is RecoverPasswordSuccess) {
            _sendingData = false; // Remove circular progress indicator

            // Show snackbar message
            var snackBar = const SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: AppColors.darkGrey,
              showCloseIcon: true,
              closeIconColor: AppColors.bright,
              content: Text(
                AppStrings.loginSuccessful,
                style: TextStyle(color: Colors.white),
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);

            // Redirect to home
            context.goNamed(RouteNames.login);
          }
        },
        builder: (context, state) => SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppGaps.v50,
                Text(
                  AppStrings.recoverPassword,
                  style: AppStyles.headerStyle,
                ),
                AppGaps.v10,
                const Text(
                  AppStrings.loginDescription,
                  // textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.midGrey,
                  ),
                ),
                AppGaps.v40,
                email(),
                AppGaps.v40,
                ElevatedButton(
                  onPressed: () {
                    _recoverPassword();
                  },
                  child: _sendingData
                      ? const CircularProgressIndicator(
                          strokeWidth: 3,
                          color: AppColors.bright,
                        )
                      : const Text(AppStrings.continue_),
                ),
                AppGaps.v20,
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _recoverPassword() {
    final email = _email.text.toString().trim();
    context.read<AuthCubit>().recoverPassword(
          email: email,
        );
  }

  Widget forgotPassword() {
    return RichText(
      text: TextSpan(
        // text: AppStrings.forgotPasswordLinkQuestion,
        style: const TextStyle(color: AppColors.midGrey),
        children: [
          TextSpan(
            text: ' ${AppStrings.forgotPasswordLinkQuestion}',
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                context.goNamed(RouteNames.register);
              },
            style: const TextStyle(color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget registerLinkQuestion() {
    return RichText(
      text: TextSpan(
        text: AppStrings.registerLinkQuestion,
        style: const TextStyle(color: AppColors.midGrey),
        children: [
          TextSpan(
            text: ' ${AppStrings.register}',
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                context.goNamed(RouteNames.register);
              },
            style: const TextStyle(color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget email() {
    return TextField(
      controller: _email,
      decoration: const InputDecoration(
        hintText: AppStrings.email,
      ),
    );
  }
}
