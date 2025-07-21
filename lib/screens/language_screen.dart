import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_widgets.dart';
import '../animations/page_transitions.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  String selectedLanguage = 'ar'; // اللغة المحددة حالياً
  bool autoDetectLanguage = false;
  bool enableRTL = true;
  String dateFormat = 'dd/MM/yyyy';
  String timeFormat = '24h';
  String numberFormat = 'arabic';

  final List<LanguageOption> languages = [
    LanguageOption(
      code: 'ar',
      name: 'العربية',
      nativeName: 'العربية',
      flag: '🇸🇦',
      isRTL: true,
    ),
    LanguageOption(
      code: 'en',
      name: 'الإنجليزية',
      nativeName: 'English',
      flag: '🇺🇸',
      isRTL: false,
    ),
    LanguageOption(
      code: 'fr',
      name: 'الفرنسية',
      nativeName: 'Français',
      flag: '🇫🇷',
      isRTL: false,
    ),
    LanguageOption(
      code: 'es',
      name: 'الإسبانية',
      nativeName: 'Español',
      flag: '🇪🇸',
      isRTL: false,
    ),
    LanguageOption(
      code: 'de',
      name: 'الألمانية',
      nativeName: 'Deutsch',
      flag: '🇩🇪',
      isRTL: false,
    ),
    LanguageOption(
      code: 'it',
      name: 'الإيطالية',
      nativeName: 'Italiano',
      flag: '🇮🇹',
      isRTL: false,
    ),
    LanguageOption(
      code: 'ru',
      name: 'الروسية',
      nativeName: 'Русский',
      flag: '🇷🇺',
      isRTL: false,
    ),
    LanguageOption(
      code: 'zh',
      name: 'الصينية',
      nativeName: '中文',
      flag: '🇨🇳',
      isRTL: false,
    ),
    LanguageOption(
      code: 'ja',
      name: 'اليابانية',
      nativeName: '日本語',
      flag: '🇯🇵',
      isRTL: false,
    ),
    LanguageOption(
      code: 'ko',
      name: 'الكورية',
      nativeName: '한국어',
      flag: '🇰🇷',
      isRTL: false,
    ),
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

  void _changeLanguage(String languageCode) {
    setState(() {
      selectedLanguage = languageCode;
      final selectedLang = languages.firstWhere((lang) => lang.code == languageCode);
      enableRTL = selectedLang.isRTL;
    });

    // إظهار رسالة تأكيد
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text('تم تغيير اللغة إلى ${languages.firstWhere((lang) => lang.code == languageCode).name}'),
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

  void _showDateFormatOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        ),
        title: const Text('تنسيق التاريخ'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('dd/MM/yyyy (31/12/2024)'),
              value: 'dd/MM/yyyy',
              groupValue: dateFormat,
              onChanged: (value) {
                setState(() => dateFormat = value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('MM/dd/yyyy (12/31/2024)'),
              value: 'MM/dd/yyyy',
              groupValue: dateFormat,
              onChanged: (value) {
                setState(() => dateFormat = value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('yyyy/MM/dd (2024/12/31)'),
              value: 'yyyy/MM/dd',
              groupValue: dateFormat,
              onChanged: (value) {
                setState(() => dateFormat = value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('dd-MM-yyyy (31-12-2024)'),
              value: 'dd-MM-yyyy',
              groupValue: dateFormat,
              onChanged: (value) {
                setState(() => dateFormat = value!);
                Navigator.pop(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
        ],
      ),
    );
  }

  void _showTimeFormatOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        ),
        title: const Text('تنسيق الوقت'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('24 ساعة (14:30)'),
              value: '24h',
              groupValue: timeFormat,
              onChanged: (value) {
                setState(() => timeFormat = value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('12 ساعة (2:30 PM)'),
              value: '12h',
              groupValue: timeFormat,
              onChanged: (value) {
                setState(() => timeFormat = value!);
                Navigator.pop(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
        ],
      ),
    );
  }

  void _showNumberFormatOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        ),
        title: const Text('تنسيق الأرقام'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('الأرقام العربية (١٢٣٤٥)'),
              value: 'arabic',
              groupValue: numberFormat,
              onChanged: (value) {
                setState(() => numberFormat = value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('الأرقام الإنجليزية (12345)'),
              value: 'english',
              groupValue: numberFormat,
              onChanged: (value) {
                setState(() => numberFormat = value!);
                Navigator.pop(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
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
        title: const Text('اللغة والتنسيق'),
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
              // قسم اللغة
              _buildSectionHeader('اختيار اللغة', Icons.language),
              const SizedBox(height: AppConstants.paddingMedium),
              _buildLanguageCard(),

              const SizedBox(height: AppConstants.paddingLarge),

              // قسم الإعدادات العامة
              _buildSectionHeader('إعدادات اللغة', Icons.settings),
              const SizedBox(height: AppConstants.paddingMedium),
              _buildLanguageSettingsCard(),

              const SizedBox(height: AppConstants.paddingLarge),

              // قسم التنسيق
              _buildSectionHeader('تنسيق البيانات', Icons.format_list_numbered),
              const SizedBox(height: AppConstants.paddingMedium),
              _buildFormatCard(),

              const SizedBox(height: AppConstants.paddingLarge),

              // معلومات إضافية
              _buildInfoCard(),
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

  Widget _buildLanguageCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: languages.map((language) {
          final isSelected = selectedLanguage == language.code;
          return Column(
            children: [
              InteractiveContainer(
                onTap: () => _changeLanguage(language.code),
                child: Container(
                  padding: const EdgeInsets.all(AppConstants.paddingMedium),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primaryColor.withOpacity(0.1) : null,
                    borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                  ),
                  child: Row(
                    children: [
                      Text(
                        language.flag,
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(width: AppConstants.paddingMedium),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              language.name,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: isSelected ? AppTheme.primaryColor : AppTheme.textPrimary,
                              ),
                            ),
                            Text(
                              language.nativeName,
                              style: TextStyle(
                                color: isSelected 
                                    ? AppTheme.primaryColor.withOpacity(0.8)
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
                            color: AppTheme.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: AppTheme.textOnPrimary,
                            size: 16,
                          ),
                        ),
                      if (language.isRTL)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.accentColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'RTL',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppTheme.accentColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              if (language != languages.last) _buildDivider(),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLanguageSettingsCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          _buildSwitchTile(
            icon: Icons.auto_awesome,
            title: 'الكشف التلقائي للغة',
            subtitle: 'تحديد اللغة تلقائياً حسب إعدادات النظام',
            value: autoDetectLanguage,
            onChanged: (value) => setState(() => autoDetectLanguage = value),
            iconColor: AppTheme.accentColor,
          ),
          _buildDivider(),
          _buildSwitchTile(
            icon: Icons.format_textdirection_r_to_l,
            title: 'الكتابة من اليمين لليسار',
            subtitle: 'تفعيل اتجاه النص من اليمين إلى اليسار',
            value: enableRTL,
            onChanged: (value) => setState(() => enableRTL = value),
            iconColor: AppTheme.primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildFormatCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          _buildActionTile(
            icon: Icons.calendar_today,
            title: 'تنسيق التاريخ',
            subtitle: dateFormat,
            onTap: _showDateFormatOptions,
            iconColor: AppTheme.accentColor,
          ),
          _buildDivider(),
          _buildActionTile(
            icon: Icons.access_time,
            title: 'تنسيق الوقت',
            subtitle: timeFormat == '24h' ? '24 ساعة' : '12 ساعة',
            onTap: _showTimeFormatOptions,
            iconColor: AppTheme.primaryColor,
          ),
          _buildDivider(),
          _buildActionTile(
            icon: Icons.numbers,
            title: 'تنسيق الأرقام',
            subtitle: numberFormat == 'arabic' ? 'الأرقام العربية' : 'الأرقام الإنجليزية',
            onTap: _showNumberFormatOptions,
            iconColor: AppTheme.successColor,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      decoration: BoxDecoration(
        gradient: AppTheme.accentGradient,
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        boxShadow: AppTheme.elevatedShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info,
                color: AppTheme.textOnPrimary,
                size: 24,
              ),
              const SizedBox(width: AppConstants.paddingSmall),
              Text(
                'معلومات مهمة',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.textOnPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          Text(
            '• قد تحتاج إلى إعادة تشغيل التطبيق لتطبيق بعض التغييرات\n'
            '• بعض اللغات قد تتطلب تحميل ملفات إضافية\n'
            '• يمكنك تغيير اللغة في أي وقت من الإعدادات\n'
            '• التنسيقات المحددة ستطبق على جميع أجزاء التطبيق',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textOnPrimary.withOpacity(0.9),
            ),
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

class LanguageOption {
  final String code;
  final String name;
  final String nativeName;
  final String flag;
  final bool isRTL;

  LanguageOption({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.flag,
    required this.isRTL,
  });
}

