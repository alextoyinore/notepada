import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:notepada/common/bloc/settings/settings_cubit.dart';
import 'package:notepada/common/bloc/theme/theme_cubit.dart';
import 'package:notepada/common/widgets/app_alert.dart';
import 'package:notepada/config/assets/images.dart';
import 'package:notepada/config/assets/vectors.dart';
import 'package:notepada/config/strings/strings.dart';
import 'package:notepada/config/theme/colors.dart';
import 'package:notepada/config/theme/styles.dart';
import 'package:notepada/core/routes/names.dart';
import 'package:notepada/core/util/storage/storage_keys.dart';
import 'package:notepada/core/util/storage/storage_service.dart';
import 'package:notepada/features/auth/presentation/bloc/auth_state.dart';
import 'package:notepada/features/auth/presentation/bloc/user_cubit.dart';

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

  @override
  void initState() {
    _defaultColor = Color(
        int.tryParse(_storageService.getValue(StorageKeys.defaultColor)!)!);
    _currentColor = _defaultColor;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        leading: IconButton(
          padding: const EdgeInsets.only(left: 20),
          onPressed: () => context.goNamed(RouteNames.home),
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.grey
                : AppColors.darkGrey,
          ),
        ),
      ),
      body: BlocProvider(
        create: (context) => UserCubit()..getUser(userID: userID),
        child: BlocBuilder<UserCubit, AuthState>(
          builder: (context, state) {
            if (state is UserLoading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      AppImages.gettingNotes,
                      height: 150,
                    ),
                    AppGaps.v10,
                    Text(
                      AppStrings.userLoading,
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
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppGaps.v10,

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
                                    Icons.computer,
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
                              // Text(context.read<ThemeCubit>().state.name),
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
                                      // print(_currentColor.toHexString());
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

                    AppGaps.v10,

                    // FONT SETTINGS
                    AppGaps.v10,
                    Text(
                      AppStrings.fontSettings.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // LIST FONT SETTING
                    AppGaps.v10,
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: AppColors.grey.withOpacity(.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            AppStrings.listTextSize,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    context
                                        .read<NoteListFontCubit>()
                                        .decrement();
                                  });
                                },
                                icon: const Icon(Icons.remove),
                              ),
                              Text(
                                context
                                    .read<NoteListFontCubit>()
                                    .state
                                    .toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    context
                                        .read<NoteListFontCubit>()
                                        .increment();
                                  });
                                },
                                icon: const Icon(Icons.add),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // VIEW FONT
                    AppGaps.v10,
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: AppColors.grey.withOpacity(.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            AppStrings.viewTextSize,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    context
                                        .read<NoteViewFontCubit>()
                                        .decrement();
                                  });
                                },
                                icon: const Icon(Icons.remove),
                              ),
                              Text(
                                context
                                    .read<NoteViewFontCubit>()
                                    .state
                                    .toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    context
                                        .read<NoteViewFontCubit>()
                                        .increment();
                                  });
                                },
                                icon: const Icon(Icons.add),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // ABOUT
                    AppGaps.v40,
                    Container(
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

                    // LOGOUT

                    AppGaps.v40,
                    GestureDetector(
                      onTap: () {
                        appAlert(
                            context: context,
                            title: AppStrings.confirmLogout,
                            message: AppStrings.logoutDescription,
                            continue_: () {
                              context.read<UserCubit>().logout();
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
