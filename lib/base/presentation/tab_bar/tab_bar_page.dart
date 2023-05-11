import 'package:easy_english/base/presentation/base_widget.dart';
import 'package:easy_english/feature/course/presentation/view/course/course_page.dart';
import 'package:easy_english/feature/game/presentation/view/game/game_page.dart';
import 'package:easy_english/feature/home/presentation/view/home/home_page.dart';
import 'package:easy_english/feature/setting/presentation/view/setting/setting_page.dart';
import 'package:easy_english/utils/config/app_text_style.dart';
import 'package:easy_english/utils/gen/colors.gen.dart';
import 'package:flutter/cupertino.dart';
import "package:persistent_bottom_nav_bar/persistent_tab_view.dart";

import './tab_bar_controller.dart';

class TabBarPage extends BaseWidget<TabBarController> {
  List<Widget> _buildScreens() {
    return [
      const HomePage(),
      const CoursePage(),
      const GamePage(),
      const SettingPage(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.globe),
        iconSize: 24,
        textStyle: AppTextStyle.w600s12(ColorName.primaryColor),
        title: ("Trang chủ"),
        activeColorPrimary: ColorName.primaryColor,
        inactiveColorPrimary: ColorName.gray838,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.book_solid),
        iconSize: 24,
        textStyle: AppTextStyle.w600s12(ColorName.primaryColor),
        title: ("Học"),
        activeColorPrimary: ColorName.primaryColor,
        inactiveColorPrimary: ColorName.gray838,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.game_controller_solid),
        iconSize: 24,
        textStyle: AppTextStyle.w600s12(ColorName.primaryColor),
        title: ("Khám phá"),
        activeColorPrimary: ColorName.primaryColor,
        inactiveColorPrimary: ColorName.gray838,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.person_fill),
        iconSize: 24,
        textStyle: AppTextStyle.w600s12(ColorName.primaryColor),
        title: ("Cá nhân"),
        activeColorPrimary: ColorName.primaryColor,
        inactiveColorPrimary: ColorName.gray838,
      ),
    ];
  }

  @override
  Widget onBuild(BuildContext context) {
    return PersistentTabView(
      context,
      controller: PersistentTabController(initialIndex: 0),
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 300),
      ),
      navBarStyle: NavBarStyle.style4,
    );
  }
}
