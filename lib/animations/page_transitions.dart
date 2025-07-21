import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// مجموعة من الانتقالات المخصصة للصفحات
class PageTransitions {
  
  /// انتقال الانزلاق من اليمين
  static Route<T> slideFromRight<T extends Object?>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: AppConstants.animationDuration,
      reverseTransitionDuration: AppConstants.animationDuration,
    );
  }

  /// انتقال الانزلاق من الأسفل
  static Route<T> slideFromBottom<T extends Object?>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: AppConstants.animationDuration,
      reverseTransitionDuration: AppConstants.animationDuration,
    );
  }

  /// انتقال التلاشي
  static Route<T> fadeTransition<T extends Object?>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration: AppConstants.animationDuration,
      reverseTransitionDuration: AppConstants.animationDuration,
    );
  }

  /// انتقال التكبير
  static Route<T> scaleTransition<T extends Object?>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeInOutBack;
        
        var scaleAnimation = Tween(
          begin: 0.8,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: curve,
        ));

        var fadeAnimation = Tween(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        ));

        return ScaleTransition(
          scale: scaleAnimation,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: child,
          ),
        );
      },
      transitionDuration: AppConstants.animationDurationSlow,
      reverseTransitionDuration: AppConstants.animationDuration,
    );
  }

  /// انتقال الدوران مع التلاشي
  static Route<T> rotationTransition<T extends Object?>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var rotationAnimation = Tween(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.elasticOut,
        ));

        var fadeAnimation = Tween(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        ));

        return RotationTransition(
          turns: rotationAnimation,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: child,
          ),
        );
      },
      transitionDuration: AppConstants.animationDurationSlow,
      reverseTransitionDuration: AppConstants.animationDuration,
    );
  }

  /// انتقال مخصص مع تأثيرات متعددة
  static Route<T> customTransition<T extends Object?>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // انتقال الانزلاق
        var slideAnimation = Tween(
          begin: const Offset(0.3, 0.0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        ));

        // انتقال التكبير
        var scaleAnimation = Tween(
          begin: 0.9,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        ));

        // انتقال التلاشي
        var fadeAnimation = Tween(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        ));

        return SlideTransition(
          position: slideAnimation,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: FadeTransition(
              opacity: fadeAnimation,
              child: child,
            ),
          ),
        );
      },
      transitionDuration: AppConstants.animationDuration,
      reverseTransitionDuration: AppConstants.animationDuration,
    );
  }
}

/// ودجت للتأثيرات البصرية المتحركة
class AnimatedContainer extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final Curve curve;
  final Offset? slideOffset;
  final double? scaleBegin;
  final double? fadeBegin;

  const AnimatedContainer({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = AppConstants.animationDuration,
    this.curve = Curves.easeOut,
    this.slideOffset,
    this.scaleBegin,
    this.fadeBegin,
  });

  @override
  State<AnimatedContainer> createState() => _AnimatedContainerState();
}

class _AnimatedContainerState extends State<AnimatedContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: widget.fadeBegin ?? 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    _scaleAnimation = Tween<double>(
      begin: widget.scaleBegin ?? 1.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    _slideAnimation = Tween<Offset>(
      begin: widget.slideOffset ?? Offset.zero,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: widget.child,
            ),
          ),
        );
      },
    );
  }
}

/// ودجت للتأثيرات التفاعلية
class InteractiveContainer extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double scaleOnPress;
  final Duration animationDuration;
  final bool enableHapticFeedback;

  const InteractiveContainer({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.scaleOnPress = 0.95,
    this.animationDuration = AppConstants.animationDurationFast,
    this.enableHapticFeedback = true,
  });

  @override
  State<InteractiveContainer> createState() => _InteractiveContainerState();
}

class _InteractiveContainerState extends State<InteractiveContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scaleOnPress,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _controller.forward();
    
    if (widget.enableHapticFeedback) {
      // HapticFeedback.lightImpact();
    }
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
    widget.onTap?.call();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onLongPress: widget.onLongPress,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: widget.child,
          );
        },
      ),
    );
  }
}

/// ودجت للتأثيرات المتموجة
class RippleEffect extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color rippleColor;
  final Duration duration;

  const RippleEffect({
    super.key,
    required this.child,
    this.onTap,
    this.rippleColor = AppTheme.primaryColor,
    this.duration = AppConstants.animationDuration,
  });

  @override
  State<RippleEffect> createState() => _RippleEffectState();
}

class _RippleEffectState extends State<RippleEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  Offset? _tapPosition;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _tapPosition = details.localPosition;
    });
    _controller.forward().then((_) {
      _controller.reset();
    });
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      child: Stack(
        children: [
          widget.child,
          if (_tapPosition != null)
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Positioned.fill(
                  child: CustomPaint(
                    painter: RipplePainter(
                      center: _tapPosition!,
                      radius: _animation.value * 200,
                      color: widget.rippleColor.withOpacity(
                        (1 - _animation.value) * 0.3,
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

/// رسام التأثير المتموج
class RipplePainter extends CustomPainter {
  final Offset center;
  final double radius;
  final Color color;

  RipplePainter({
    required this.center,
    required this.radius,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(RipplePainter oldDelegate) {
    return oldDelegate.center != center ||
        oldDelegate.radius != radius ||
        oldDelegate.color != color;
  }
}

/// ودجت للتأثيرات المتدرجة للقوائم
class StaggeredList extends StatefulWidget {
  final List<Widget> children;
  final Duration itemDelay;
  final Duration itemDuration;
  final Curve curve;
  final Axis scrollDirection;

  const StaggeredList({
    super.key,
    required this.children,
    this.itemDelay = const Duration(milliseconds: 100),
    this.itemDuration = AppConstants.animationDuration,
    this.curve = Curves.easeOut,
    this.scrollDirection = Axis.vertical,
  });

  @override
  State<StaggeredList> createState() => _StaggeredListState();
}

class _StaggeredListState extends State<StaggeredList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: widget.scrollDirection,
      itemCount: widget.children.length,
      itemBuilder: (context, index) {
        return AnimatedContainer(
          delay: widget.itemDelay * index,
          duration: widget.itemDuration,
          curve: widget.curve,
          slideOffset: widget.scrollDirection == Axis.vertical
              ? const Offset(0, 0.5)
              : const Offset(0.5, 0),
          fadeBegin: 0.0,
          scaleBegin: 0.8,
          child: widget.children[index],
        );
      },
    );
  }
}

/// مساعدات للانتقالات
class TransitionHelpers {
  
  /// تنفيذ انتقال مخصص للصفحة
  static void navigateWithTransition(
    BuildContext context,
    Widget page, {
    TransitionType type = TransitionType.slideFromRight,
  }) {
    Route route;
    
    switch (type) {
      case TransitionType.slideFromRight:
        route = PageTransitions.slideFromRight(page);
        break;
      case TransitionType.slideFromBottom:
        route = PageTransitions.slideFromBottom(page);
        break;
      case TransitionType.fade:
        route = PageTransitions.fadeTransition(page);
        break;
      case TransitionType.scale:
        route = PageTransitions.scaleTransition(page);
        break;
      case TransitionType.rotation:
        route = PageTransitions.rotationTransition(page);
        break;
      case TransitionType.custom:
        route = PageTransitions.customTransition(page);
        break;
    }
    
    Navigator.push(context, route);
  }
}

/// أنواع الانتقالات المتاحة
enum TransitionType {
  slideFromRight,
  slideFromBottom,
  fade,
  scale,
  rotation,
  custom,
}

