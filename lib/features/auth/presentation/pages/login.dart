import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:notepada/common/widgets/app_toast.dart';
import 'package:notepada/config/strings/strings.dart';
import 'package:flutter/material.dart';
import 'package:notepada/config/theme/styles.dart';
import 'package:notepada/config/theme/colors.dart';
import 'package:notepada/core/routes/names.dart';
import 'package:notepada/core/util/storage/storage_keys.dart';
import 'package:notepada/core/util/storage/storage_service.dart';
import 'package:notepada/features/auth/presentation/bloc/auth_state.dart';
import 'package:notepada/features/auth/presentation/bloc/login_cubit.dart';
import 'package:notepada/service_locator.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  final StorageService _storageService = sl<StorageService>();

  bool _sendingData = false;

  @override
  void dispose() {
    // Clear texts from the textfields
    _email.clear();
    _password.clear();
    // Dispose the controllers
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () {
            context.pop();
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
      body: BlocConsumer<LoginCubit, AuthState>(
        listener: (context, state) {
          if (state is LoginLoading) {
            _sendingData = true;
          } else if (state is LoginError) {
            _sendingData = false;
            appToast(context: context, message: state.error);
          } else if (state is LoginSuccess) {
            _sendingData = false; // Remove circular progress indicator
            _storageService.setValue(StorageKeys.userID, state.session.userId);
            _storageService.setValue(StorageKeys.sessionID, state.session.$id);

            // Show snackbar message
            appToast(context: context, message: AppStrings.loginSuccessful);
            // Redirect to home
            context.goNamed(RouteNames.home);
          }
        },
        builder: (context, state) => SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppGaps.v20,
                Text(
                  AppStrings.login,
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
                AppGaps.v20,
                password(),
                AppGaps.v40,
                ElevatedButton(
                  onPressed: () {
                    _login();
                  },
                  child: _sendingData
                      ? const CircularProgressIndicator(
                          strokeWidth: 3,
                          color: AppColors.bright,
                        )
                      : const Text(AppStrings.continue_),
                ),
                AppGaps.v20,
                forgotPassword(),
                AppGaps.v20,
                registerLinkQuestion(),
                AppGaps.v20,
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _login() {
    final email = _email.text.toString().trim();
    final password = _password.text.toString().trim();

    // print(email);

    context.read<LoginCubit>().login(
          email: email,
          password: password,
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
                context.pushNamed(RouteNames.recoverPassword);
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
                context.pushNamed(RouteNames.register);
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

  Widget password() {
    return TextField(
      controller: _password,
      // obscureText: false,
      decoration: InputDecoration(
        hintText: AppStrings.password,
        suffix: GestureDetector(
          onTap: () {},
          child: const Icon(Icons.remove_red_eye_outlined),
        ),
      ),
    );
  }
}
