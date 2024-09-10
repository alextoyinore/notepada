import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:notepada/config/strings/strings.dart';
import 'package:flutter/material.dart';
import 'package:notepada/config/theme/styles.dart';
import 'package:notepada/config/theme/colors.dart';
import 'package:notepada/core/routes/routes.dart';
import 'package:notepada/core/routes/names.dart';
import 'package:notepada/core/util/storage/storage_keys.dart';
import 'package:notepada/core/util/storage/storage_service.dart';
import 'package:notepada/features/auth/presentation/bloc/login_cubit.dart';
import 'package:notepada/features/auth/presentation/bloc/login_state.dart';
import 'package:notepada/main.dart';
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
            context.goNamed(RouteNames.auth);
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 32.0),
            child: Icon(
              Icons.arrow_back_ios,
              color: AppColors.grey.withOpacity(.3),
            ),
          ),
        ),
      ),
      body: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginLoading) {
            _sendingData = true;
          } else if (state is LoginError) {
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

          } else if (state is LoginSuccess) {

            _sendingData = false; // Remove circular progress indicator
            _storageService.setValue(StorageKeys.userID, state.session.userId);
            _storageService.setValue(StorageKeys.sessionID, state.session.$id);

            // Show snackbar message
            var snackBar = const SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: AppColors.darkGrey,
              showCloseIcon: true,
              closeIconColor: AppColors.bright,
              content: Text(
                AppStrings.loginSuccessful,
                style: const TextStyle(color: Colors.white),
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);

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
                AppGaps.v50,
                Text(
                  AppStrings.login,
                  style: AppStyles.headerStyle,
                ),
                AppGaps.v10,
                const Text(
                  AppStrings.registerDescription,
                  // textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.midGrey,
                  ),
                ),
                AppGaps.v50,
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
                          strokeWidth: 2,
                          color: AppColors.bright,
                        )
                      : const Text(AppStrings.continue_),
                ),
                AppGaps.v20,
                registerLinkQuestion(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _login() {
    final email = _email.text.toString();
    final password = _password.text.toString();

    // print(email);

    context.read<LoginCubit>().login(
          email: email,
          password: password,
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

  Widget password() {
    return TextField(
      controller: _password,
      // obscureText: false,
      decoration: InputDecoration(
        hintText: AppStrings.password,
        // contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        suffix: GestureDetector(
          onTap: (){

          },
          child: const Icon(Icons.remove_red_eye_outlined),
        ),
      ),
    );
  }
}
