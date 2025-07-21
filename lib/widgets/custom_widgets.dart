import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// بطاقة جهاز محسنة مع تصميم جذاب
class EnhancedDeviceCard extends StatefulWidget {
  final String deviceName;
  final String deviceModel;
  final String manufacturer;
  final int batteryLevel;
  final bool isOnline;
  final String lastSeen;
  final int appsCount;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const EnhancedDeviceCard({
    super.key,
    required this.deviceName,
    required this.deviceModel,
    required this.manufacturer,
    required this.batteryLevel,
    required this.isOnline,
    required this.lastSeen,
    required this.appsCount,
    required this.onTap,
    this.onLongPress,
  });

  @override
  State<EnhancedDeviceCard> createState() => _EnhancedDeviceCardState();
}

class _EnhancedDeviceCardState extends State<EnhancedDeviceCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppConstants.animationDurationFast,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _animationController.reverse();
    widget.onTap();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            onLongPress: widget.onLongPress,
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingMedium,
                vertical: AppConstants.paddingSmall,
              ),
              decoration: BoxDecoration(
                color: AppTheme.cardColor,
                borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
                boxShadow: _isPressed ? [] : AppTheme.cardShadow,
                border: Border.all(
                  color: widget.isOnline
                      ? AppTheme.successColor.withOpacity(0.3)
                      : AppTheme.dividerColor,
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.paddingLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // رأس البطاقة
                    Row(
                      children: [
                        // أيقونة الجهاز
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            gradient: widget.isOnline
                                ? AppTheme.primaryGradient
                                : LinearGradient(
                                    colors: [
                                      AppTheme.textSecondary.withOpacity(0.3),
                                      AppTheme.textSecondary.withOpacity(0.1),
                                    ],
                                  ),
                            borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                          ),
                          child: Icon(
                            Icons.smartphone,
                            size: 32,
                            color: widget.isOnline
                                ? AppTheme.textOnPrimary
                                : AppTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(width: AppConstants.paddingMedium),
                        
                        // معلومات الجهاز
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.deviceName,
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${widget.manufacturer} • ${widget.deviceModel}',
                                style: Theme.of(context).textTheme.bodyMedium,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        
                        // حالة الاتصال
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: widget.isOnline
                                ? AppTheme.successColor.withOpacity(0.1)
                                : AppTheme.textSecondary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: widget.isOnline
                                      ? AppTheme.successColor
                                      : AppTheme.textSecondary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                widget.isOnline ? 'متصل' : 'غير متصل',
                                style: TextStyle(
                                  color: widget.isOnline
                                      ? AppTheme.successColor
                                      : AppTheme.textSecondary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: AppConstants.paddingLarge),
                    
                    // معلومات إضافية
                    Row(
                      children: [
                        // البطارية
                        Expanded(
                          child: _buildInfoItem(
                            icon: Icons.battery_std,
                            label: 'البطارية',
                            value: '${widget.batteryLevel}%',
                            color: _getBatteryColor(widget.batteryLevel),
                          ),
                        ),
                        
                        // التطبيقات
                        Expanded(
                          child: _buildInfoItem(
                            icon: Icons.apps,
                            label: 'التطبيقات',
                            value: '${widget.appsCount}',
                            color: AppTheme.accentColor,
                          ),
                        ),
                        
                        // آخر ظهور
                        Expanded(
                          child: _buildInfoItem(
                            icon: Icons.access_time,
                            label: 'آخر ظهور',
                            value: widget.lastSeen,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, size: 24, color: color),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Color _getBatteryColor(int level) {
    if (level >= 50) return AppTheme.successColor;
    if (level >= 20) return AppTheme.warningColor;
    return AppTheme.dangerColor;
  }
}

/// زر إجراء محسن مع تأثيرات بصرية
class EnhancedActionButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool isLoading;
  final bool isDestructive;

  const EnhancedActionButton({
    super.key,
    required this.label,
    required this.icon,
    this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.isLoading = false,
    this.isDestructive = false,
  });

  @override
  State<EnhancedActionButton> createState() => _EnhancedActionButtonState();
}

class _EnhancedActionButtonState extends State<EnhancedActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppConstants.animationDurationFast,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.backgroundColor ??
        (widget.isDestructive ? AppTheme.dangerColor : AppTheme.primaryColor);
    final foregroundColor = widget.foregroundColor ?? AppTheme.textOnPrimary;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ElevatedButton.icon(
              onPressed: widget.isLoading ? null : () {
                _animationController.forward().then((_) {
                  _animationController.reverse();
                });
                widget.onPressed?.call();
              },
              icon: widget.isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
                      ),
                    )
                  : Icon(widget.icon, size: 20),
              label: Text(
                widget.label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: foregroundColor,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor,
                foregroundColor: foregroundColor,
                disabledBackgroundColor: AppTheme.textSecondary.withOpacity(0.3),
                disabledForegroundColor: AppTheme.textSecondary,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingLarge,
                  vertical: AppConstants.paddingMedium,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                ),
                elevation: widget.isLoading ? 0 : AppConstants.elevationMedium,
                shadowColor: backgroundColor.withOpacity(0.3),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// عنوان قسم محسن مع خط فاصل
class SectionHeader extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Color? color;
  final Widget? trailing;

  const SectionHeader({
    super.key,
    required this.title,
    this.icon,
    this.color,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMedium,
        vertical: AppConstants.paddingSmall,
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: color ?? AppTheme.primaryColor,
              size: 24,
            ),
            const SizedBox(width: AppConstants.paddingSmall),
          ],
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: color ?? AppTheme.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

/// حالة فارغة محسنة مع رسوم متحركة
class EmptyStateWidget extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.buttonText,
    this.onButtonPressed,
  });

  @override
  State<EmptyStateWidget> createState() => _EmptyStateWidgetState();
}

class _EmptyStateWidgetState extends State<EmptyStateWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppConstants.animationDurationSlow,
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.paddingXLarge),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        widget.icon,
                        size: 60,
                        color: AppTheme.primaryColor.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingLarge),
                    Text(
                      widget.title,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppConstants.paddingSmall),
                    Text(
                      widget.subtitle,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (widget.buttonText != null && widget.onButtonPressed != null) ...[
                      const SizedBox(height: AppConstants.paddingLarge),
                      EnhancedActionButton(
                        label: widget.buttonText!,
                        icon: Icons.refresh,
                        onPressed: widget.onButtonPressed,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// شريط بحث محسن
class EnhancedSearchBar extends StatefulWidget {
  final String hintText;
  final ValueChanged<String> onChanged;
  final VoidCallback? onClear;
  final TextEditingController? controller;

  const EnhancedSearchBar({
    super.key,
    required this.hintText,
    required this.onChanged,
    this.onClear,
    this.controller,
  });

  @override
  State<EnhancedSearchBar> createState() => _EnhancedSearchBarState();
}

class _EnhancedSearchBarState extends State<EnhancedSearchBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppConstants.animationDuration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingMedium,
              vertical: AppConstants.paddingSmall,
            ),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
              boxShadow: _isFocused ? AppTheme.elevatedShadow : AppTheme.cardShadow,
              border: Border.all(
                color: _isFocused ? AppTheme.primaryColor : AppTheme.dividerColor,
                width: _isFocused ? 2 : 1,
              ),
            ),
            child: TextField(
              controller: widget.controller,
              onChanged: widget.onChanged,
              onTap: () {
                setState(() => _isFocused = true);
                _animationController.forward();
              },
              onTapOutside: (_) {
                setState(() => _isFocused = false);
                _animationController.reverse();
              },
              decoration: InputDecoration(
                hintText: widget.hintText,
                prefixIcon: Icon(
                  Icons.search,
                  color: _isFocused ? AppTheme.primaryColor : AppTheme.textSecondary,
                ),
                suffixIcon: widget.controller?.text.isNotEmpty == true
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          widget.controller?.clear();
                          widget.onClear?.call();
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingMedium,
                  vertical: AppConstants.paddingMedium,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// مؤشر تحميل محسن مع تراكب
class LoadingOverlay extends StatelessWidget {
  final String message;
  final bool isVisible;

  const LoadingOverlay({
    super.key,
    required this.message,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
            boxShadow: AppTheme.elevatedShadow,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: AppConstants.paddingMedium),
              Text(
                message,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

