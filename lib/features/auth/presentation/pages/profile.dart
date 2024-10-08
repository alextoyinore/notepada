import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:notepada/common/bloc/settings/settings_cubit.dart';
import 'package:notepada/common/bloc/theme/theme_cubit.dart';
import 'package:notepada/common/widgets/app_alert.dart';
import 'package:notepada/common/widgets/app_pin_input.dart';
import 'package:notepada/common/widgets/single_digit_field.dart';
import 'package:notepada/config/assets/images.dart';
import 'package:notepada/config/assets/vectors.dart';
import 'package:notepada/config/strings/strings.dart';
import 'package:notepada/config/theme/colors.dart';
import 'package:notepada/config/theme/styles.dart';
import 'package:notepada/core/routes/names.dart';
import 'package:notepada/core/util/storage/storage_keys.dart';
import 'package:notepada/core/util/storage/storage_service.dart';
import 'package:notepada/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:notepada/features/auth/presentation/bloc/auth_state.dart';
import 'package:notepada/features/auth/presentation/widgets/value_changer_setting.dart';
import 'package:shimmer/shimmer.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final userID = StorageService().getValue('userID');
  final _storageService = StorageService();

  // some color values
  Color _pickerColor = AppColors.darkGrey;
  late Color _currentColor;
  late Color _defaultColor;

// ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => _pickerColor = color);
  }

  late String savedSecretKeyPIN;

  // Secret Key
  final TextEditingController _secretKeyPINController = TextEditingController();

  @override
  void initState() {
    savedSecretKeyPIN =
        _storageService.getValue(StorageKeys.secretKeyPIN) ?? '0000';
    _defaultColor = Color(
        int.tryParse(_storageService.getValue(StorageKeys.defaultColor)!)!);
    _currentColor = _defaultColor;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => AuthCubit()..getUser(userID: userID),
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is UserLoading) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppGaps.v50,
                      Container(
                        width: 100,
                        height: 100.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Container(
                        width: MediaQuery.of(context).size.width * .40,
                        height: 20.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: List.generate(
                          8,
                          (index) => Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * .95,
                                height: 40.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white,
                                ),
                              ),
                              AppGaps.v30,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is UserError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        AppVectors.warning,
                        colorFilter: const ColorFilter.mode(
                          AppColors.primary,
                          BlendMode.srcATop,
                        ),
                        height: 100,
                      ),
                      AppGaps.v20,
                      Text(
                        AppStrings.userError,
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.grey
                              : AppColors.darkGrey,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      // AppGaps.v10,
                      TextButton(
                        child: const Text(AppStrings.tryAgain),
                        onPressed: () {
                          context.read<AuthCubit>().getUser(userID: userID);
                        },
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is LoggingOut) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      AppImages.door,
                      height: 150,
                    ),
                    AppGaps.v10,
                    Text(
                      AppStrings.loggingout,
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.grey
                            : AppColors.darkGrey,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            if (state is UserSuccess) {
              // _storageService.setValue(
              //     StorageKeys.firstName, state.user!.firstName);
              // _storageService.setValue(
              //     StorageKeys.firstName, state.user!.lastName);
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppGaps.v50,
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(.1),
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        AppVectors.profile,
                        colorFilter: const ColorFilter.mode(
                          AppColors.primary,
                          BlendMode.srcATop,
                        ),
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    AppGaps.v10,
                    Text(
                      state.user!.fullName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    // AppGaps.v10,
                    Text(
                      state.user!.email,
                      style: const TextStyle(color: AppColors.midGrey),
                    ),
                    AppGaps.v50,

                    //THEME
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.grey.withOpacity(.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            AppStrings.setTheme,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              // LIGHT THEME CHOOSER
                              GestureDetector(
                                onTap: () => setState(() {
                                  context
                                      .read<ThemeCubit>()
                                      .updateTheme(ThemeMode.light);
                                }),
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: context.read<ThemeCubit>().state ==
                                            ThemeMode.light
                                        ? AppColors.primary
                                        : AppColors.grey.withOpacity(.2),
                                  ),
                                  child: Icon(
                                    Icons.sunny,
                                    size: 18,
                                    color: context.read<ThemeCubit>().state ==
                                            ThemeMode.light
                                        ? AppColors.bright
                                        : Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? AppColors.bright
                                            : AppColors.darkGrey,
                                  ),
                                ),
                              ),

                              AppGaps.h10,

                              // DARK THEME CHOOSER
                              GestureDetector(
                                onTap: () => setState(() {
                                  context
                                      .read<ThemeCubit>()
                                      .updateTheme(ThemeMode.dark);
                                }),
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: context.read<ThemeCubit>().state ==
                                            ThemeMode.dark
                                        ? AppColors.primary
                                        : AppColors.grey.withOpacity(.2),
                                  ),
                                  child: Icon(
                                    Icons.nightlight,
                                    size: 18,
                                    color: context.read<ThemeCubit>().state ==
                                            ThemeMode.dark
                                        ? AppColors.bright
                                        : Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? AppColors.bright
                                            : AppColors.darkGrey,
                                  ),
                                ),
                              ),

                              AppGaps.h10,

                              // SYSTEM THEME CHOOSER
                              GestureDetector(
                                onTap: () => setState(() {
                                  context
                                      .read<ThemeCubit>()
                                      .updateTheme(ThemeMode.system);
                                }),
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: context.read<ThemeCubit>().state ==
                                            ThemeMode.system
                                        ? AppColors.primary
                                        : AppColors.grey.withOpacity(.2),
                                  ),
                                  child: Icon(
                                    Icons.brightness_6,
                                    size: 18,
                                    color: context.read<ThemeCubit>().state ==
                                            ThemeMode.system
                                        ? AppColors.bright
                                        : Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? AppColors.bright
                                            : AppColors.darkGrey,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),

                    AppGaps.v10,

                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.grey.withOpacity(.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            AppStrings.defaultColor,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => // raise the [showDialog] widget
                                showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text(AppStrings.chooseNoteColor),
                                content: SingleChildScrollView(
                                  child: BlockPicker(
                                    pickerColor: _currentColor,
                                    onColorChanged: changeColor,
                                  ),
                                ),
                                actions: <Widget>[
                                  ElevatedButton(
                                    child: const Text(AppStrings.confirm),
                                    onPressed: () {
                                      setState(
                                        () {
                                          _currentColor = _pickerColor;
                                          _storageService.setValue(
                                            StorageKeys.defaultColor,
                                            '0x${_currentColor.toHexString()}',
                                          );
                                        },
                                      );
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                            ),
                            child: Container(
                              width: 25,
                              height: 25,
                              decoration: BoxDecoration(
                                color: _currentColor,
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  width: 2,
                                  color: AppColors.darkGrey.withOpacity(.1),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // SECRET KEY
                    AppGaps.v20,
                    Text(
                      AppStrings.secretNotes.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AppGaps.v20,

                    GestureDetector(
                      onTap: () {
                        context.pushNamed(RouteNames.secretKey);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.grey.withOpacity(.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppStrings.secretKeyPIN,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    AppGaps.v10,
                    GestureDetector(
                      onTap: () {
                        appWidgetAlert(
                          context: context,
                          title: AppStrings.enterSecretKey,
                          message: AppStrings.secretViewKeyDescription,
                          continue_: () {
                            final secretKeyPIN = _secretKeyPINController.text;

                            if (secretKeyPIN == savedSecretKeyPIN &&
                                savedSecretKeyPIN != '0000') {
                              context.pushNamed(RouteNames.secretNotes);
                            } else {
                              context.pushNamed(RouteNames.secretKey);
                            }
                          },
                          child: (savedSecretKeyPIN.length == 4 &&
                                  savedSecretKeyPIN != '0000')
                              ? appPinInput(
                                  controller: _secretKeyPINController,
                                  length: 4,
                                  context: context,
                                  stretch: 40,
                                )
                              : const Text(
                                  AppStrings.createSecretKeyDescription,
                                  style: TextStyle(
                                    color: AppColors.midGrey,
                                  ),
                                ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.grey.withOpacity(.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppStrings.secretNotes,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // TEXT SETTINGS
                    AppGaps.v20,
                    Text(
                      AppStrings.fontSettings.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // LIST TEXT SETTING
                    AppGaps.v20,
                    valueChangeSetter(
                      context: context,
                      title: AppStrings.listTextSize,
                      decrement: () => setState(
                          () => context.read<NoteListFontCubit>().decrement()),
                      increment: () => setState(
                          () => context.read<NoteListFontCubit>().increment()),
                      value: context.read<NoteListFontCubit>().state.toString(),
                    ),

                    // VIEW TEXT
                    AppGaps.v10,
                    valueChangeSetter(
                      context: context,
                      title: AppStrings.viewTextSize,
                      decrement: () => setState(
                          () => context.read<NoteViewFontCubit>().decrement()),
                      increment: () => setState(
                          () => context.read<NoteViewFontCubit>().increment()),
                      value: context.read<NoteViewFontCubit>().state.toString(),
                    ),

                    // TEXT TO SPEECH
                    AppGaps.v20,
                    Text(
                      AppStrings.tts.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    AppGaps.v20,

                    // PITCH
                    valueChangeSetter(
                      context: context,
                      title: AppStrings.pitch,
                      decrement: () => setState(
                          () => context.read<VoicePitchCubit>().decrement()),
                      increment: () => setState(
                          () => context.read<VoicePitchCubit>().increment()),
                      value: (context.read<VoicePitchCubit>().state / 100)
                          .toString(),
                    ),
                    AppGaps.v10,

                    // RATE
                    valueChangeSetter(
                      context: context,
                      title: AppStrings.rate,
                      decrement: () => setState(
                          () => context.read<VoiceRateCubit>().decrement()),
                      increment: () => setState(
                          () => context.read<VoiceRateCubit>().increment()),
                      value: (context.read<VoiceRateCubit>().state / 100)
                          .toString(),
                    ),
                    AppGaps.v10,

                    // VOLUME
                    valueChangeSetter(
                      context: context,
                      title: AppStrings.volume,
                      decrement: () => setState(
                          () => context.read<VoiceVolumeCubit>().decrement()),
                      increment: () => setState(
                          () => context.read<VoiceVolumeCubit>().increment()),
                      value: (context.read<VoiceVolumeCubit>().state / 100)
                          .toString(),
                    ),

                    // INFORMATION
                    AppGaps.v20,
                    Text(
                      AppStrings.information.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // CHANGE PASSWORD
                    AppGaps.v20,
                    GestureDetector(
                      onTap: () {
                        context.pushNamed(RouteNames.changePassword);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.grey.withOpacity(.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppStrings.changePassword,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ABOUT
                    AppGaps.v20,
                    GestureDetector(
                      onTap: () {
                        appAlert(
                          context: context,
                          title: AppStrings.aboutNotepada,
                          message: AppStrings.aboutNotepadaDescription,
                          continue_: () {
                            context.pop(true);
                          },
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.grey.withOpacity(.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppStrings.about,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // PRIVACY POLICY
                    AppGaps.v10,
                    GestureDetector(
                      onTap: () {
                        appAlert(
                          context: context,
                          title: AppStrings.privacyPolicy,
                          message: AppStrings.privacyPolicyDescription,
                          continue_: () {
                            context.pop(true);
                          },
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.grey.withOpacity(.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppStrings.privacyPolicy,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // TERMS AND CONDITIONS
                    AppGaps.v10,
                    GestureDetector(
                      onTap: () {
                        appAlert(
                          context: context,
                          title: AppStrings.termsAndConditions,
                          message: AppStrings.termsAndConditionsDescription,
                          continue_: () {
                            context.pop(true);
                          },
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.grey.withOpacity(.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppStrings.termsAndConditions,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // LOGOUT

                    AppGaps.v40,
                    GestureDetector(
                      onTap: () {
                        appAlert(
                            context: context,
                            title: AppStrings.confirmLogout,
                            message: AppStrings.logoutDescription,
                            continue_: () {
                              context.read<AuthCubit>().logout();
                              _storageService.clear(StorageKeys.sessionID);
                              _storageService.clear(StorageKeys.userID);
                              context.goNamed(RouteNames.auth);
                            },
                            yesText: AppStrings.logout,
                            extraButtonText: AppStrings.allDevices,
                            extraButtonCallback: () {});
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppStrings.logout,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    AppGaps.v40,
                  ],
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
