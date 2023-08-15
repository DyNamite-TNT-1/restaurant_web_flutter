import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_flutter/app_ceiling.dart';
import 'package:restaurant_flutter/blocs/bloc.dart';
import 'package:restaurant_flutter/configs/configs.dart';
import 'package:restaurant_flutter/configs/user_repository.dart';
import 'package:restaurant_flutter/widgets/widgets.dart';

import 'routes/route_constants.dart';
import 'screens/authentication/login_screen.dart';

class ScaffoldWithNestedNavigation extends StatelessWidget {
  const ScaffoldWithNestedNavigation({
    Key? key,
    required this.navigationShell,
  }) : super(
            key: key ?? const ValueKey<String>('ScaffoldWithNestedNavigation'));
  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 450) {
        return ScaffoldWithNavigationBar(
          body: navigationShell,
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: _goBranch,
        );
      } else {
        return ScaffoldWithNavigationRail(
          body: navigationShell,
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: _goBranch,
        );
      }
    });
  }
}

class ScaffoldWithNavigationBar extends StatelessWidget {
  const ScaffoldWithNavigationBar({
    super.key,
    required this.body,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });
  final Widget body;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        destinations: const [
          NavigationDestination(label: 'Section A', icon: Icon(Icons.home)),
          NavigationDestination(label: 'Section B', icon: Icon(Icons.settings)),
        ],
        onDestinationSelected: onDestinationSelected,
      ),
    );
  }
}

class ScaffoldWithNavigationRail extends StatefulWidget {
  const ScaffoldWithNavigationRail({
    super.key,
    required this.body,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });
  final Widget body;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  State<ScaffoldWithNavigationRail> createState() =>
      _ScaffoldWithNavigationRailState();
}

class _ScaffoldWithNavigationRailState
    extends State<ScaffoldWithNavigationRail> {
  @override
  void initState() {
    Preferences.setPreferences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.chat),
      ),
      body: Column(
        children: [
          AppCeiling(),
          Expanded(
            child: Row(
              children: [
                NavigationRail(
                  selectedIndex: widget.selectedIndex,
                  onDestinationSelected: widget.onDestinationSelected,
                  labelType: NavigationRailLabelType.all,
                  backgroundColor: backgroundColor,
                  destinations: <NavigationRailDestination>[
                    NavigationRailDestination(
                      label: Text('Trang chủ'),
                      icon: Icon(Icons.home),
                    ),
                    NavigationRailDestination(
                      label: Text('Món ăn'),
                      icon: SvgPicture.asset(
                        Images.icForkKnife,
                        height: 20,
                        colorFilter: ColorFilter.mode(
                          widget.selectedIndex == 1 ? blueColor : textColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    NavigationRailDestination(
                      label: Text('Đồ uống'),
                      icon: SvgPicture.asset(
                        Images.icDrink,
                        height: 20,
                        colorFilter: ColorFilter.mode(
                          widget.selectedIndex == 2 ? blueColor : textColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    NavigationRailDestination(
                      label: Text('Chỗ trống'),
                      icon: SvgPicture.asset(
                        Images.icAvailableCalendar,
                        height: 20,
                        colorFilter: ColorFilter.mode(
                          widget.selectedIndex == 3 ? blueColor : textColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ],
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(child: widget.body),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
