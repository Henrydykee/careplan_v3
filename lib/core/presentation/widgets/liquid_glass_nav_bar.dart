import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../resources/color.dart';

/// One destination in a [LiquidGlassNavBar].
///
/// Supply either [svgAsset] (the app's own icon set) or [icon].
class LiquidGlassNavItem {
  const LiquidGlassNavItem({
    required this.label,
    this.svgAsset,
    this.icon,
  }) : assert(svgAsset != null || icon != null,
            'A nav item needs an svgAsset or an icon');

  final String label;
  final String? svgAsset;
  final IconData? icon;
}

/// A floating tab bar in the Liquid Glass idiom: a translucent capsule that
/// blurs and brightens whatever scrolls behind it, edged with a specular
/// highlight, with a brighter glass "lens" that glides between destinations
/// and stretches slightly as it travels.
///
/// The host must set `extendBody: true` on its Scaffold so content passes
/// under the glass — otherwise there is nothing for it to refract and it
/// flattens into an opaque panel.
///
/// Purely presentational: it holds no selection state, so it drops into
/// whatever navigation the host already uses.
class LiquidGlassNavBar extends StatefulWidget {
  const LiquidGlassNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.margin = const EdgeInsets.fromLTRB(16, 0, 16, 12),
    this.height = 62,
    this.iconSize = 21,
    this.blurSigma = 24,
    this.tint,
    this.activeColor,
    this.inactiveColor,
    this.enableHaptics = true,
  }) : assert(items.length > 1, 'A nav bar needs at least two destinations');

  final List<LiquidGlassNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  final EdgeInsets margin;
  final double height;
  final double iconSize;

  /// Backdrop blur strength. Lower it on low-end devices.
  final double blurSigma;

  /// Glass tint laid over the blurred backdrop.
  final Color? tint;
  final Color? activeColor;
  final Color? inactiveColor;
  final bool enableHaptics;

  @override
  State<LiquidGlassNavBar> createState() => _LiquidGlassNavBarState();
}

class _LiquidGlassNavBarState extends State<LiquidGlassNavBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _slide;

  late int _from;
  late int _to;

  @override
  void initState() {
    super.initState();
    _from = widget.currentIndex;
    _to = widget.currentIndex;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 460),
    )..value = 1;

    // Glass settles rather than bounces: it overshoots a hair, then relaxes.
    _slide = CurvedAnimation(parent: _controller, curve: Curves.easeOutQuint);
  }

  @override
  void didUpdateWidget(covariant LiquidGlassNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != oldWidget.currentIndex) {
      setState(() {
        _from = oldWidget.currentIndex;
        _to = widget.currentIndex;
      });
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap(int index) {
    if (index == widget.currentIndex) return;
    if (widget.enableHaptics) HapticFeedback.selectionClick();
    widget.onTap(index);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final radius = widget.height / 2;

    final tint = widget.tint ??
        (isDark
            ? Colors.black.withOpacity(0.28)
            : Colors.white.withOpacity(0.55));
    final active =
        widget.activeColor ?? (isDark ? Colors.white : CarePlanColor.brown);
    final inactive = widget.inactiveColor ??
        (isDark ? Colors.white54 : CarePlanColor.grey_3);

    return SafeArea(
      top: false,
      child: Padding(
        padding: widget.margin,
        child: SizedBox(
          height: widget.height,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.45 : 0.14),
                  blurRadius: 28,
                  spreadRadius: -4,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: BackdropFilter(
                // Blur plus a saturation lift: glass concentrates the colour
                // of whatever passes behind it instead of greying it out.
                filter: ui.ImageFilter.compose(
                  outer: ui.ImageFilter.blur(
                    sigmaX: widget.blurSigma,
                    sigmaY: widget.blurSigma,
                  ),
                  inner: const ColorFilter.matrix(_saturate),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: tint,
                    borderRadius: BorderRadius.circular(radius),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withOpacity(0.14)
                          : Colors.white.withOpacity(0.7),
                      width: 1,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Specular sheen along the top edge.
                      Positioned.fill(
                        child: IgnorePointer(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(radius),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.white
                                      .withOpacity(isDark ? 0.14 : 0.45),
                                  Colors.white.withOpacity(0),
                                  Colors.black.withOpacity(isDark ? 0 : 0.03),
                                ],
                                stops: const [0, 0.55, 1],
                              ),
                            ),
                          ),
                        ),
                      ),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final slot =
                              constraints.maxWidth / widget.items.length;

                          return AnimatedBuilder(
                            animation: _slide,
                            builder: (context, _) {
                              final t = _slide.value;
                              final x = (slot * _from) +
                                  (slot * (_to - _from)) * t;

                              // Liquid: the lens stretches along its travel
                              // and relaxes back as it arrives.
                              final travel = (_to - _from).abs().toDouble();
                              final stretch = travel == 0
                                  ? 0.0
                                  : (4 * t * (1 - t)).clamp(0.0, 1.0) *
                                      (0.10 + 0.05 * travel);

                              return Stack(
                                children: [
                                  Positioned(
                                    left: x,
                                    top: 0,
                                    bottom: 0,
                                    width: slot,
                                    child: Center(
                                      child: Transform.scale(
                                        scaleX: 1 + stretch,
                                        scaleY: 1 - stretch * 0.45,
                                        child: _GlassLens(
                                          width: slot - 10,
                                          height: widget.height - 12,
                                          isDark: isDark,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      for (var i = 0;
                                          i < widget.items.length;
                                          i++)
                                        Expanded(
                                          child: _GlassNavSlot(
                                            item: widget.items[i],
                                            selected: i == widget.currentIndex,
                                            activeColor: active,
                                            inactiveColor: inactive,
                                            iconSize: widget.iconSize,
                                            onTap: () => _handleTap(i),
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Saturation boost (~1.5x) applied to the backdrop before blurring.
const List<double> _saturate = <double>[
  1.35, -0.25, -0.10, 0, 0, //
  -0.15, 1.25, -0.10, 0, 0, //
  -0.15, -0.25, 1.40, 0, 0, //
  0, 0, 0, 1, 0, //
];

/// The brighter pane of glass that sits under the active destination.
class _GlassLens extends StatelessWidget {
  const _GlassLens({
    required this.width,
    required this.height,
    required this.isDark,
  });

  final double width;
  final double height;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(height / 2),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [
                  Colors.white.withOpacity(0.18),
                  Colors.white.withOpacity(0.07),
                ]
              : [
                  Colors.white.withOpacity(0.92),
                  Colors.white.withOpacity(0.62),
                ],
        ),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.22)
              : Colors.white.withOpacity(0.9),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.25 : 0.07),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
    );
  }
}

class _GlassNavSlot extends StatelessWidget {
  const _GlassNavSlot({
    required this.item,
    required this.selected,
    required this.activeColor,
    required this.inactiveColor,
    required this.iconSize,
    required this.onTap,
  });

  final LiquidGlassNavItem item;
  final bool selected;
  final Color activeColor;
  final Color inactiveColor;
  final double iconSize;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? activeColor : inactiveColor;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedScale(
            duration: const Duration(milliseconds: 320),
            curve: Curves.easeOutBack,
            scale: selected ? 1.08 : 1,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 220),
              opacity: selected ? 1 : 0.85,
              child: item.svgAsset != null
                  ? SvgPicture.asset(
                      item.svgAsset!,
                      height: iconSize,
                      width: iconSize,
                      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                    )
                  : Icon(item.icon, size: iconSize + 2, color: color),
            ),
          ),
          const SizedBox(height: 4),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 220),
            style: TextStyle(
              fontFamily: 'avenir',
              fontSize: 10.5,
              height: 1,
              letterSpacing: 0.1,
              fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
              color: color,
            ),
            child: Text(item.label),
          ),
        ],
      ),
    );
  }
}
