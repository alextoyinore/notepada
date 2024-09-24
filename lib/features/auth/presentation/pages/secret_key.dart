import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:notepada/common/widgets/app_alert.dart';
import 'package:notepada/common/widgets/app_snack.dart';
import 'package:notepada/common/widgets/single_digit_field.dart';
import 'package:notepada/config/strings/strings.dart';
import 'package:notepada/config/theme/colors.dart';
import 'package:notepada/config/theme/styles.dart';
import 'package:notepada/core/util/storage/storage_keys.dart';
import 'package:notepada/core/util/storage/storage_service.dart';
import 'package:notepada/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:notepada/features/auth/presentation/bloc/auth_state.dart';

class SecretKey extends StatefulWidget {
  const SecretKey({super.key});

  @override
  State<SecretKey> createState() => _SecretKeyState();
}

class _SecretKeyState extends State<SecretKey> {
  // Secret Key
  final TextEditingController _secretKeyPINController1 =
      TextEditingController();
  final TextEditingController _secretKeyPINController2 =
      TextEditingController();
  final TextEditingController _secretKeyPINController3 =
      TextEditingController();
  final TextEditingController _secretKeyPINController4 =
      TextEditingController();

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();

  late String _secretKeyPIN;

  final _storageService = StorageService();

  late String userID;

  bool _sendingData = false;

  void _createSecretKey({required BuildContext context}) {
    _secretKeyPIN = _secretKeyPINController1.text +
        _secretKeyPINController2.text +
        _secretKeyPINController3.text +
        _secretKeyPINController4.text;
    context
        .read<AuthCubit>()
        .createSecretKey(userID: userID, secretKeyPIN: _secretKeyPIN);
  }

  @override
  void dispose() {
    // Clear the text fields
    _secretKeyPINController1.clear();
    _secretKeyPINController2.clear();
    _secretKeyPINController3.clear();
    _secretKeyPINController4.clear();

    _secretKeyPINController1.dispose();
    _secretKeyPINController2.dispose();
    _secretKeyPINController3.dispose();
    _secretKeyPINController4.dispose();

    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    _focusNode4.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    userID = _storageService.getValue('userID');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text('Secret Key'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.primary,
          ),
        ),
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is CreateSecretKeyLoading) {
            setState(() {
              _sendingData = true;
            });
          } else if (state is CreateSecretKeyError) {
            setState(() {
              _sendingData = false;
            });
            appSnackBar(context: context, message: state.error);
          } else if (state is CreateSecretKeySuccess) {
            setState(() {
              _sendingData = false;
            });
            appSnackBar(message: AppStrings.secretKeyCreated, context: context);
            _storageService.setValue(StorageKeys.secretKeyPIN, _secretKeyPIN);
            context.pop();
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AppGaps.v20,
                Text(
                  AppStrings.createSecretKey,
                  style: AppStyles.headerStyle,
                  textAlign: TextAlign.left,
                ),
                AppGaps.v20,
                const Text(
                  AppStrings.createSecretKeyDescription,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                AppGaps.v10,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    singleDigitTextField(
                        controller: _secretKeyPINController1,
                        focusNode: _focusNode1,
                        context: context),
                    singleDigitTextField(
                        controller: _secretKeyPINController2,
                        focusNode: _focusNode2,
                        context: context),
                    singleDigitTextField(
                        controller: _secretKeyPINController3,
                        focusNode: _focusNode3,
                        context: context),
                    singleDigitTextField(
                        controller: _secretKeyPINController4,
                        focusNode: _focusNode4,
                        context: context),
                  ],
                ),
                AppGaps.v10,
                ElevatedButton(
                  onPressed: () => _createSecretKey(context: context),
                  child: _sendingData
                      ? const CircularProgressIndicator(
                          color: AppColors.bright,
                          strokeWidth: 3,
                        )
                      : const Text(AppStrings.continue_),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
