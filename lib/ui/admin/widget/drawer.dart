import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:web_test/common/extension/num_extension.dart';
import 'package:web_test/generated/assets.gen.dart';

class DrawerItem {
  final Widget icon;
  final Widget activeIcon;
  final String label;
  final VoidCallback onTap;

  DrawerItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.onTap,
  });
}

enum AdminDrawerType {
  dashboard;

  DrawerItem drawerItem(BuildContext context) {
    switch (this) {
      case AdminDrawerType.dashboard:
        return DrawerItem(
          icon: const Icon(
            Icons.dashboard_outlined,
            color: Colors.black,
          ),
          activeIcon: const Icon(
            Icons.dashboard,
            color: Colors.white,
          ),
          label: 'Dashboard',
          onTap: () {},
        );
    }
  }
}

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.primary,
      shadowColor: Colors.white,
      width: 300,
      child: SafeArea(
        child: Column(
          children: [
            16.hSpace,
            Assets.images.logoWhite.image(
              width: 150,
            ),
            const Divider(color: Colors.white),
            DrawerButton(
              item: AdminDrawerType.dashboard.drawerItem(context),
              isActive: true,
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerButton extends StatefulWidget {
  final DrawerItem item;
  final bool isActive;
  const DrawerButton({
    super.key,
    required this.item,
    required this.isActive,
  });

  @override
  State<DrawerButton> createState() => _DrawerButtonState();
}

class _DrawerButtonState extends State<DrawerButton> {
  @override
  void didUpdateWidget(covariant DrawerButton oldWidget) {
    if (widget.isActive) {
      isHover = false;
      setState(() {});
    }
    super.didUpdateWidget(oldWidget);
  }

  bool isHover = false;
  @override
  Widget build(BuildContext context) {
    Color? hoverColor = Colors.white;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          widget.item.onTap.call();
        },
        onHover: (value) {
          if (!widget.isActive) {
            setState(() {
              isHover = value;
            });
          }
        },
        child: AnimatedContainer(
          padding: EdgeInsets.symmetric(vertical: 12.hMax),
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isHover ? hoverColor : null,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Row(
            children: [
              24.w.wSpace,
              widget.isActive ? widget.item.activeIcon : widget.item.icon,
              16.wSpace,
              Expanded(
                child: Text(
                  widget.item.label,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: widget.isActive ? Colors.white : Colors.black,
                        fontWeight: widget.isActive ? FontWeight.bold : FontWeight.normal,
                      ),
                ),
              ),
              49.w.wSpace,
              if (widget.isActive)
                Container(
                  height: 32,
                  width: 10,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4),
                      bottomLeft: Radius.circular(4),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
