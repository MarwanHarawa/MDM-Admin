import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_widgets.dart';
import '../animations/page_transitions.dart';

class ThemeScreen extends StatefulWidget {
  const ThemeScreen({super.key});

  @override
  State<ThemeScreen> createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  String selectedTheme = 'light'; // light, dark, auto
  String accentColor = 'blue';
  bool enableAnimations = true;
  bool enableHapticFeedback = true;
  bool enableSoundEffects = false;
  double fontSize = 16.0;
  String fontFamily = 'default';
  bool enableGradients = true;
  bool enableShadows = true;
  double borderRadius = 12.0;

  final List<ThemeOption> themes = [
    ThemeOption(
      id: 'light',
      name: 'المظهر الفاتح',
      description: 'مظهر فاتح ومريح للعين',
      icon: Icons.light_mode,
      primaryColor: AppTheme.primaryColor,
      backgroundColor: Colors.white,
      surfaceColor: Colors.grey[50]!,
    ),
    ThemeOption(
      id: 'dark',
      name: 'المظهر الداكن',
      description: 'مظهر داكن لتوفير الطاقة',
      icon: Icons.dark_mode,
      primaryColor: AppTheme.primaryColor,
      backgroundColor: const Color(0xFF121212),
      surfaceColor: const Color(0xFF1E1E1E),
    ),
    ThemeOption(
      id: 'auto',
      name: 'تلقائي',
      description: 'يتبع إعدادات النظام',
      icon: Icons.auto_awesome,
      primaryColor: AppTheme.primaryColor,
      backgroundColor: Colors.grey[100]!,
      surfaceColor: Colors.white,
    ),
  ];

  final List<AccentColorOption> accentColors = [
    AccentColorOption(id: 'blue', name: 'أزرق', color: Colors.blue),
    AccentColorOption(id: 'purple', name: 'بنفسجي', color: Colors.purple),
    AccentColorOption(id: 'green', name: 'أخضر', color: Colors.green),
    AccentColorOption(id: 'orange', name: 'برتقالي', color: Colors.orange),
    AccentColorOption(id: 'red', name: 'أحمر', color: Colors.red),
    AccentColorOption(id: 'teal', name: 'أزرق مخضر', color: Colors.teal),
    AccentColorOption(id: 'pink', name: 'وردي', color: Colors.pink),
    AccentColorOption(id: 'indigo', name: 'نيلي', color: Colors.indigo),
  ];

  final List<FontOption> fonts = [
    FontOption(id: 'default', name: 'الخط الافتراضي', family: 'default'),
    FontOption(id: 'cairo', name: 'Cairo', family: 'Cairo'),
    FontOption(id: 'amiri', name: 'Amiri', family: 'Amiri'),
    FontOption(id: 'noto', name: 'Noto Sans Arabic', family: 'NotoSansArabic'),
    FontOption(id: 'tajawal', name: 'Tajawal', family: 'Tajawal'),
  ];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _changeTheme(String themeId) {
    setState(() {
      selectedTheme = themeId;
    });

    final theme = themes.firstWhere((t) => t.id == themeId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(theme.icon, color: Colors.white),
            const SizedBox(width: 8),
            Text('تم تطبيق ${theme.name}'),
          ],
        ),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        ),
      ),
    );
  }

  void _changeAccentColor(String colorId) {
    setState(() {
      accentColor = colorId;
    });

    final color = accentColors.firstWhere((c) => c.id == colorId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: color.color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text('تم تطبيق اللون ${color.name}'),
          ],
        ),
        backgroundColor: color.color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        ),
      ),
    );
  }

  void _showFontSizeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        ),
        title: const Text('حجم الخط'),
        content: StatefulBuilder(
          builder: (context, setDialogState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'حجم الخط: ${fontSize.toInt()}',
                style: TextStyle(fontSize: fontSize),
              ),
              const SizedBox(height: 16),
              Slider(
                value: fontSize,
                min: 12.0,
                max: 24.0,
                divisions: 12,
                label: fontSize.toInt().toString(),
                onChanged: (value) {
                  setDialogState(() => fontSize = value);
                  setState(() => fontSize = value);
                },
              ),
              const SizedBox(height: 16),
              Text(
                'نص تجريبي لمعاينة الحجم',
                style: TextStyle(fontSize: fontSize),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  void _showBorderRadiusDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        ),
        title: const Text('انحناء الحواف'),
        content: StatefulBuilder(
          builder: (context, setDialogState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('انحناء الحواف: ${borderRadius.toInt()}'),
              const SizedBox(height: 16),
              Slider(
                value: borderRadius,
                min: 0.0,
                max: 24.0,
                divisions: 24,
                label: borderRadius.toInt().toString(),
                onChanged: (value) {
                  setDialogState(() => borderRadius = value);
                  setState(() => borderRadius = value);
                },
              ),
              const SizedBox(height: 16),
              Container(
                width: 100,
                height: 60,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                child: const Center(
                  child: Text(
                    'معاينة',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('المظهر والثيم'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // قسم المظهر العام
              _buildSectionHeader('المظهر العام', Icons.palette),
              const SizedBox(height: AppConstants.paddingMedium),
              _buildThemeCard(),

              const SizedBox(height: AppConstants.paddingLarge),

              // قسم الألوان
              _buildSectionHeader('الألوان', Icons.color_lens),
              const SizedBox(height: AppConstants.paddingMedium),
              _buildAccentColorCard(),

              const SizedBox(height: AppConstants.paddingLarge),

              // قسم الخطوط
              _buildSectionHeader('الخطوط والنصوص', Icons.text_fields),
              const SizedBox(height: AppConstants.paddingMedium),
              _buildFontCard(),

              const SizedBox(height: AppConstants.paddingLarge),

              // قسم التأثيرات البصرية
              _buildSectionHeader('التأثيرات البصرية', Icons.auto_awesome),
              const SizedBox(height: AppConstants.paddingMedium),
              _buildEffectsCard(),

              const SizedBox(height: AppConstants.paddingLarge),

              // قسم التخصيص المتقدم
              _buildSectionHeader('التخصيص المتقدم', Icons.tune),
              const SizedBox(height: AppConstants.paddingMedium),
              _buildAdvancedCard(),

              const SizedBox(height: AppConstants.paddingLarge),

              // معلومات إضافية
              _buildPreviewCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primaryColor, size: 24),
        const SizedBox(width: AppConstants.paddingSmall),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildThemeCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: themes.map((theme) {
          final isSelected = selectedTheme == theme.id;
          return Column(
            children: [
              InteractiveContainer(
                onTap: () => _changeTheme(theme.id),
                child: Container(
                  padding: const EdgeInsets.all(AppConstants.paddingMedium),
                  decoration: BoxDecoration(
                    color: isSelected ? theme.primaryColor.withOpacity(0.1) : null,
                    borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: theme.backgroundColor,
                          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                          border: Border.all(color: theme.primaryColor.withOpacity(0.3)),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 8,
                              left: 8,
                              right: 8,
                              child: Container(
                                height: 4,
                                decoration: BoxDecoration(
                                  color: theme.primaryColor,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 8,
                              left: 8,
                              right: 8,
                              child: Container(
                                height: 20,
                                decoration: BoxDecoration(
                                  color: theme.surfaceColor,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppConstants.paddingMedium),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              theme.name,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: isSelected ? theme.primaryColor : AppTheme.textPrimary,
                              ),
                            ),
                            Text(
                              theme.description,
                              style: TextStyle(
                                color: isSelected 
                                    ? theme.primaryColor.withOpacity(0.8)
                                    : AppTheme.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: theme.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              if (theme != themes.last) _buildDivider(),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAccentColorCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'اختر اللون المميز',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: accentColors.map((colorOption) {
                final isSelected = accentColor == colorOption.id;
                return InteractiveContainer(
                  onTap: () => _changeAccentColor(colorOption.id),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: colorOption.color,
                      shape: BoxShape.circle,
                      border: isSelected 
                          ? Border.all(color: AppTheme.textPrimary, width: 3)
                          : null,
                      boxShadow: isSelected ? AppTheme.elevatedShadow : AppTheme.cardShadow,
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 24)
                        : null,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFontCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          _buildActionTile(
            icon: Icons.font_download,
            title: 'نوع الخط',
            subtitle: fonts.firstWhere((f) => f.id == fontFamily).name,
            onTap: () {
              // TODO: Show font selection dialog
            },
            iconColor: AppTheme.primaryColor,
          ),
          _buildDivider(),
          _buildActionTile(
            icon: Icons.format_size,
            title: 'حجم الخط',
            subtitle: '${fontSize.toInt()} نقطة',
            onTap: _showFontSizeDialog,
            iconColor: AppTheme.accentColor,
          ),
        ],
      ),
    );
  }

  Widget _buildEffectsCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          _buildSwitchTile(
            icon: Icons.animation,
            title: 'الرسوم المتحركة',
            subtitle: 'تفعيل التأثيرات المتحركة في التطبيق',
            value: enableAnimations,
            onChanged: (value) => setState(() => enableAnimations = value),
            iconColor: AppTheme.accentColor,
          ),
          _buildDivider(),
          _buildSwitchTile(
            icon: Icons.vibration,
            title: 'الاهتزاز التفاعلي',
            subtitle: 'اهتزاز خفيف عند اللمس',
            value: enableHapticFeedback,
            onChanged: (value) => setState(() => enableHapticFeedback = value),
            iconColor: AppTheme.warningColor,
          ),
          _buildDivider(),
          _buildSwitchTile(
            icon: Icons.volume_up,
            title: 'الأصوات',
            subtitle: 'تشغيل أصوات التفاعل',
            value: enableSoundEffects,
            onChanged: (value) => setState(() => enableSoundEffects = value),
            iconColor: AppTheme.successColor,
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          _buildSwitchTile(
            icon: Icons.gradient,
            title: 'التدرجات اللونية',
            subtitle: 'استخدام التدرجات في الخلفيات',
            value: enableGradients,
            onChanged: (value) => setState(() => enableGradients = value),
            iconColor: AppTheme.primaryColor,
          ),
          _buildDivider(),
          _buildSwitchTile(
            icon: Icons.wb_shade,
            title: 'الظلال',
            subtitle: 'إضافة ظلال للعناصر',
            value: enableShadows,
            onChanged: (value) => setState(() => enableShadows = value),
            iconColor: AppTheme.textSecondary,
          ),
          _buildDivider(),
          _buildActionTile(
            icon: Icons.rounded_corner,
            title: 'انحناء الحواف',
            subtitle: '${borderRadius.toInt()} نقطة',
            onTap: _showBorderRadiusDialog,
            iconColor: AppTheme.accentColor,
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewCard() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      decoration: BoxDecoration(
        gradient: enableGradients ? AppTheme.primaryGradient : null,
        color: enableGradients ? null : AppTheme.primaryColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: enableShadows ? AppTheme.elevatedShadow : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.preview,
                color: AppTheme.textOnPrimary,
                size: 24,
              ),
              const SizedBox(width: AppConstants.paddingSmall),
              Text(
                'معاينة المظهر',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.textOnPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          Text(
            'هذا مثال على كيفية ظهور النصوص والعناصر مع الإعدادات المحددة. '
            'يمكنك تجربة تغيير الإعدادات ومشاهدة التأثير مباشرة.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textOnPrimary.withOpacity(0.9),
              fontSize: fontSize - 2,
            ),
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(borderRadius / 2),
                ),
                child: Text(
                  'زر تجريبي',
                  style: TextStyle(
                    color: AppTheme.textOnPrimary,
                    fontSize: fontSize - 2,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: accentColors.firstWhere((c) => c.id == accentColor).color,
                  borderRadius: BorderRadius.circular(borderRadius / 2),
                ),
                child: const Icon(Icons.favorite, color: Colors.white, size: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color iconColor,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: AppTheme.textSecondary),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppTheme.primaryColor,
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color iconColor,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: AppTheme.textSecondary),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      color: AppTheme.dividerColor,
      indent: 16,
      endIndent: 16,
    );
  }
}

class ThemeOption {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color primaryColor;
  final Color backgroundColor;
  final Color surfaceColor;

  ThemeOption({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.primaryColor,
    required this.backgroundColor,
    required this.surfaceColor,
  });
}

class AccentColorOption {
  final String id;
  final String name;
  final Color color;

  AccentColorOption({
    required this.id,
    required this.name,
    required this.color,
  });
}

class FontOption {
  final String id;
  final String name;
  final String family;

  FontOption({
    required this.id,
    required this.name,
    required this.family,
  });
}

