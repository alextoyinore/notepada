import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:notepada/common/widgets/app_toast.dart';
import 'package:notepada/config/strings/strings.dart';
import 'package:flutter/material.dart';
import 'package:notepada/config/theme/styles.dart';
import 'package:notepada/config/theme/colors.dart';
import 'package:notepada/core/routes/names.dart';
import 'package:notepada/core/util/storage/storage_keys.dart';
import 'package:notepada/core/util/storage/storage_service.dart';
import 'package:notepada/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:notepada/features/auth/presentation/bloc/auth_state.dart';
import 'package:notepada/service_locator.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _oldPassword = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();

  final StorageService _storageService = sl<StorageService>();

  bool _sendingData = false;

  @override
  void dispose() {
    // Clear texts from the textfields
    _oldPassword.clear();
    _newPassword.clear();
    // Dispose the controllers
    _oldPassword.dispose();
    _newPassword.dispose();
    super.dispose();
  }

  FToast fToast = FToast();

  @override
  void initState() {
    super.initState();
    fToast.init(context);
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
        automaticallyImplyLeading: false,
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is ChangePasswordLoading) {
            setState(() {
              _sendingData = true;
            });
          } else if (state is ChangePasswordError) {
            setState(() {
              _sendingData = false;
            });
            fToast.showToast(
              child: Text(state.error),
            );
          } else if (state is ChangePasswordSuccess) {
            // Remove circular progress indicator
            setState(() {
              _sendingData = false;
            });

            // Clear session and user ID from storage
            _storageService.clear(StorageKeys.sessionID);
            _storageService.clear(StorageKeys.userID);

            // Show toast message
            appToast(context: context, message: AppStrings.passwordChanged);

            // Logout the user
            context.read<AuthCubit>().logout();

            // Navigate to the auth screen
            context.goNamed(RouteNames.auth);
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
                  AppStrings.changePassword,
                  style: AppStyles.headerStyle,
                ),
                AppGaps.v10,
                const Text(
                  AppStrings.changePasswordDescription,
                  // textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.midGrey,
                  ),
                ),
                AppGaps.v40,
                oldPassword(),
                AppGaps.v20,
                newPassword(),
                AppGaps.v40,
                ElevatedButton(
                  onPressed: _changePassword,
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

  void _changePassword() {
    final oldPassword = _oldPassword.text.toString().trim();
    final newPassword = _newPassword.text.toString().trim();
    context.read<AuthCubit>().changePassword(
          oldPassword: oldPassword,
          newPassword: newPassword,
        );
  }

  Widget oldPassword() {
    return TextField(
      controller: _oldPassword,
      decoration: const InputDecoration(
        hintText: AppStrings.oldPassword,
        hintStyle: TextStyle(color: AppColors.grey),
      ),
    );
  }

  Widget newPassword() {
    return TextField(
      controller: _newPassword,
      decoration: const InputDecoration(
        hintText: AppStrings.newPassword,
        hintStyle: TextStyle(color: AppColors.grey),
      ),
    );
  }
}
