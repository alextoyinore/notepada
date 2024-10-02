import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:notepada/common/widgets/app_pin_input.dart';
import 'package:notepada/common/widgets/app_snack.dart';
import 'package:notepada/config/strings/strings.dart';
import 'package:notepada/config/theme/colors.dart';
import 'package:notepada/config/theme/styles.dart';
import 'package:notepada/core/routes/names.dart';
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
  late String _secretKeyPIN;

  final _storageService = StorageService();

  late String userID;

  bool _sendingData = false;

  final _secretPINController = TextEditingController();

  void _createSecretKey({required BuildContext context}) {
    _secretKeyPIN = _secretPINController.text;
    context
        .read<AuthCubit>()
        .createSecretKey(userID: userID, secretKeyPIN: _secretKeyPIN);
  }

  void _checkSecretKeyPIN({required BuildContext context}) {
    savedSecretKeyPIN = _storageService.getValue(StorageKeys.secretKeyPIN);
    if (_secretPINController.text.isNotEmpty &&
        _secretPINController.text.length == 4) {
      if (savedSecretKeyPIN == _secretPINController.text) {
        context.goNamed(RouteNames.secretNotes, extra: {
          'selectedApp': 'secretKey',
        });
      } else {
        _createSecretKey(context: context);
      }
    }
  }

  @override
  void dispose() {
    _secretPINController.clear();
    _secretPINController.dispose();

    super.dispose();
  }

  late String savedSecretKeyPIN;

  @override
  void initState() {
    super.initState();
    userID = _storageService.getValue('userID');
    savedSecretKeyPIN =
        _storageService.getValue(StorageKeys.secretKeyPIN) ?? '0000';
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
            context.goNamed(RouteNames.secretNotes, extra: {
              'selectedApp': 'secretKey',
            });
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
                appPinInput(
                  controller: _secretPINController,
                  length: 4,
                  context: context,
                ),
                AppGaps.v20,
                ElevatedButton(
                  onPressed: () => _checkSecretKeyPIN(context: context),
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
