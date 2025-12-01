import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/common_widgets/height.dart';

class CustomBottomNavBar extends StatefulWidget {
  final Function(int) onTap;
  final RxInt selectedIndex;

  CustomBottomNavBar({required this.onTap, required this.selectedIndex});

  @override
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    double navBarHeight = MediaQuery.of(context).size.height * 0.1;
    navBarHeight = navBarHeight < 70 ? 70 : navBarHeight;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: navBarHeight,
            decoration: const BoxDecoration(
              color: Color(0xFF813BEA),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: 'assets/image_rent/home.png',
                  label: 'Home',
                  index: 0,
                ),
                boxH50(),
                _buildNavItem(
                  icon: 'assets/image_rent/saveSearch.png',
                  label: 'Save Search',
                  index: 2,
                ),
              ],
            ),
          ),
        ),

        // Floating Middle Button
        Positioned(
          bottom:  navBarHeight - 65, // Adjust position
          left: 5,
          right: 10,
          child: GestureDetector(
            onTap: () => widget.onTap(1),
            child: Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
              child: Center(
                child: Image.asset(
                  'assets/image_rent/postProperty.png',
                  width: 50, // Bigger size
                  height: 50,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem(
      {required String icon, required String label, required int index}) {
    return GestureDetector(
      onTap: () => widget.onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            icon,
            width: 24,
            height: 24,
            color: widget.selectedIndex.value == index
                ? Colors.white
                : Colors.white.withOpacity(0.5),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: widget.selectedIndex.value == index
                  ? Colors.white
                  : Colors.white.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}
