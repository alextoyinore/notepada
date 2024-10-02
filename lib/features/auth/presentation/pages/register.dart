import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:notepada/config/strings/strings.dart';
import 'package:flutter/material.dart';
import 'package:notepada/config/theme/styles.dart';
import 'package:notepada/config/theme/colors.dart';
import 'package:notepada/core/routes/names.dart';
import 'package:notepada/core/util/storage/storage_keys.dart';
import 'package:notepada/core/util/storage/storage_service.dart';
import 'package:notepada/features/auth/presentation/bloc/auth_state.dart';
import 'package:notepada/features/auth/presentation/bloc/register_cubit.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  bool _sendingData = false;

  final _storageService = StorageService();

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
      body: BlocConsumer<RegisterCubit, AuthState>(
        listener: (context, state) {
          if (state is RegisterLoading) {
            _sendingData = true;
          } else if (state is RegisterError) {
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
          } else if (state is RegisterSuccess) {
            _sendingData = false;

            /// Save user data to storage
            _storageService.setValue(StorageKeys.firstName, _firstName.text);
            _storageService.setValue(StorageKeys.lastName, _lastName.text);
            _storageService.setValue(StorageKeys.email, _email.text);

            /// Snackbar
            var snackBar = SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: AppColors.darkGrey,
              showCloseIcon: true,
              closeIconColor: AppColors.bright,
              content: Text(
                'Hi, ${state.user.name} your account has been successfully created',
                style: const TextStyle(color: Colors.white),
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            context.goNamed(RouteNames.login);
          }
        },
        builder: (context, state) => SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // AppGaps.v20,
                Text(
                  AppStrings.register,
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
                AppGaps.v20,
                firstName(),
                AppGaps.v15,
                lastName(),
                AppGaps.v15,
                email(),
                AppGaps.v15,
                password(),
                AppGaps.v15,
                const Text(
                  AppStrings.registerPolicyCheck,
                  style: TextStyle(
                    color: AppColors.midGrey,
                  ),
                ),
                AppGaps.v20,
                ElevatedButton(
                  onPressed: () {
                    _register();
                  },
                  child: _sendingData
                      ? const CircularProgressIndicator(
                          strokeWidth: 3,
                          color: AppColors.bright,
                        )
                      : const Text(AppStrings.continue_),
                ),
                AppGaps.v20,
                loginLinkQuestion(),
                AppGaps.v20,
              ],
            ),
          ),
        ),
      ),
    );
  }

  _register() {
    final firstName = _firstName.text.toString().trim();
    final lastName = _lastName.text.toString().trim();
    final email = _email.text.toString().trim();
    final password = _password.text.toString().trim();

    context.read<RegisterCubit>().register(
          firstName: firstName,
          lastName: lastName,
          email: email,
          password: password,
        );
  }

  Widget loginLinkQuestion() {
    return RichText(
      text: TextSpan(
        text: AppStrings.loginLinkQuestion,
        style: const TextStyle(color: AppColors.midGrey),
        children: [
          TextSpan(
            text: ' ${AppStrings.login}',
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                context.pushNamed(RouteNames.login);
              },
            style: const TextStyle(color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget firstName() {
    return TextField(
      controller: _firstName,
      decoration: const InputDecoration(
        hintText: AppStrings.firstName,
      ),
    );
  }

  Widget lastName() {
    return TextField(
      controller: _lastName,
      decoration: const InputDecoration(
        hintText: AppStrings.lastName,
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
      decoration: const InputDecoration(
        hintText: AppStrings.password,
      ),
    );
  }
}
