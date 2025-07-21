import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_widgets.dart';
import '../animations/page_transitions.dart';

class PrivacySecurityScreen extends StatefulWidget {
  const PrivacySecurityScreen({super.key});

  @override
  State<PrivacySecurityScreen> createState() => _PrivacySecurityScreenState();
}

class _PrivacySecurityScreenState extends State<PrivacySecurityScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  // إعدادات الخصوصية والأمان
  bool enableDataEncryption = true;
  bool enableBiometricAuth = false;
  bool enableAutoLock = true;
  bool shareAnalytics = false;
  bool enableLocationTracking = true;
  bool enableRemoteWipe = true;
  bool enableScreenshots = false;
  bool enableAppUsageStats = true;
  int autoLockDuration = 5; // بالدقائق

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

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        ),
        title: const Text('سياسة الخصوصية'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'نحن نحترم خصوصيتك ونلتزم بحماية بياناتك الشخصية.',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 16),
              Text('1. جمع البيانات:'),
              Text('• نجمع فقط البيانات الضرورية لتشغيل التطبيق'),
              Text('• معلومات الجهاز والموقع (عند الحاجة)'),
              Text('• بيانات الاستخدام لتحسين الخدمة'),
              SizedBox(height: 12),
              Text('2. استخدام البيانات:'),
              Text('• إدارة الأجهزة عن بُعد'),
              Text('• تحسين الأمان والحماية'),
              Text('• تطوير الميزات الجديدة'),
              SizedBox(height: 12),
              Text('3. حماية البيانات:'),
              Text('• تشفير جميع البيانات المنقولة'),
              Text('• تخزين آمن في خوادم محمية'),
              Text('• عدم مشاركة البيانات مع أطراف ثالثة'),
              SizedBox(height: 12),
              Text('4. حقوقك:'),
              Text('• الوصول إلى بياناتك'),
              Text('• تعديل أو حذف البيانات'),
              Text('• إيقاف جمع البيانات'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('فهمت'),
          ),
        ],
      ),
    );
  }

  void _showSecurityTips() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        ),
        title: Row(
          children: [
            const Icon(Icons.security, color: AppTheme.primaryColor),
            const SizedBox(width: 8),
            const Text('نصائح الأمان'),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '🔐 نصائح لحماية أجهزتك:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 16),
              Text('• استخدم كلمات مرور قوية ومعقدة'),
              Text('• فعّل المصادقة الثنائية عند الإمكان'),
              Text('• حدّث التطبيقات والنظام بانتظام'),
              Text('• تجنب الاتصال بشبكات Wi-Fi غير آمنة'),
              Text('• راجع أذونات التطبيقات بانتظام'),
              SizedBox(height: 12),
              Text(
                '📱 حماية البيانات:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Text('• فعّل تشفير البيانات'),
              Text('• استخدم النسخ الاحتياطي المشفر'),
              Text('• احذف البيانات الحساسة عند عدم الحاجة'),
              Text('• تجنب حفظ كلمات المرور في التطبيقات'),
              SizedBox(height: 12),
              Text(
                '⚠️ علامات التحذير:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Text('• رسائل مشبوهة أو روابط غريبة'),
              Text('• طلبات أذونات غير مبررة'),
              Text('• تطبيقات من مصادر غير موثوقة'),
              Text('• تغييرات غير مبررة في الإعدادات'),
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

  void _showAutoLockOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        ),
        title: const Text('مدة القفل التلقائي'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<int>(
              title: const Text('دقيقة واحدة'),
              value: 1,
              groupValue: autoLockDuration,
              onChanged: (value) {
                setState(() => autoLockDuration = value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<int>(
              title: const Text('5 دقائق'),
              value: 5,
              groupValue: autoLockDuration,
              onChanged: (value) {
                setState(() => autoLockDuration = value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<int>(
              title: const Text('15 دقيقة'),
              value: 15,
              groupValue: autoLockDuration,
              onChanged: (value) {
                setState(() => autoLockDuration = value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<int>(
              title: const Text('30 دقيقة'),
              value: 30,
              groupValue: autoLockDuration,
              onChanged: (value) {
                setState(() => autoLockDuration = value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<int>(
              title: const Text('60 دقيقة'),
              value: 60,
              groupValue: autoLockDuration,
              onChanged: (value) {
                setState(() => autoLockDuration = value!);
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
        title: const Text('الخصوصية والأمان'),
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
              // قسم الأمان
              _buildSectionHeader('إعدادات الأمان', Icons.security),
              const SizedBox(height: AppConstants.paddingMedium),
              _buildSecurityCard(),

              const SizedBox(height: AppConstants.paddingLarge),

              // قسم الخصوصية
              _buildSectionHeader('إعدادات الخصوصية', Icons.privacy_tip),
              const SizedBox(height: AppConstants.paddingMedium),
              _buildPrivacyCard(),

              const SizedBox(height: AppConstants.paddingLarge),

              // قسم البيانات
              _buildSectionHeader('إدارة البيانات', Icons.storage),
              const SizedBox(height: AppConstants.paddingMedium),
              _buildDataCard(),

              const SizedBox(height: AppConstants.paddingLarge),

              // قسم المساعدة
              _buildSectionHeader('المساعدة والدعم', Icons.help),
              const SizedBox(height: AppConstants.paddingMedium),
              _buildHelpCard(),
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

  Widget _buildSecurityCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          _buildSwitchTile(
            icon: Icons.lock,
            title: 'تشفير البيانات',
            subtitle: 'تشفير جميع البيانات المحفوظة والمنقولة',
            value: enableDataEncryption,
            onChanged: (value) => setState(() => enableDataEncryption = value),
            iconColor: AppTheme.successColor,
          ),
          _buildDivider(),
          _buildSwitchTile(
            icon: Icons.fingerprint,
            title: 'المصادقة البيومترية',
            subtitle: 'استخدام بصمة الإصبع أو الوجه للدخول',
            value: enableBiometricAuth,
            onChanged: (value) => setState(() => enableBiometricAuth = value),
            iconColor: AppTheme.accentColor,
          ),
          _buildDivider(),
          _buildSwitchTile(
            icon: Icons.lock_clock,
            title: 'القفل التلقائي',
            subtitle: 'قفل التطبيق تلقائياً بعد فترة عدم النشاط',
            value: enableAutoLock,
            onChanged: (value) => setState(() => enableAutoLock = value),
            iconColor: AppTheme.warningColor,
            trailing: enableAutoLock
                ? TextButton(
                    onPressed: _showAutoLockOptions,
                    child: Text('$autoLockDuration دقيقة'),
                  )
                : null,
          ),
          _buildDivider(),
          _buildSwitchTile(
            icon: Icons.delete_forever,
            title: 'المسح عن بُعد',
            subtitle: 'السماح بمسح بيانات الجهاز عن بُعد',
            value: enableRemoteWipe,
            onChanged: (value) => setState(() => enableRemoteWipe = value),
            iconColor: AppTheme.dangerColor,
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          _buildSwitchTile(
            icon: Icons.location_on,
            title: 'تتبع الموقع',
            subtitle: 'السماح بتتبع موقع الأجهزة',
            value: enableLocationTracking,
            onChanged: (value) => setState(() => enableLocationTracking = value),
            iconColor: AppTheme.accentColor,
          ),
          _buildDivider(),
          _buildSwitchTile(
            icon: Icons.screenshot,
            title: 'لقطات الشاشة',
            subtitle: 'السماح بأخذ لقطات شاشة للتطبيق',
            value: enableScreenshots,
            onChanged: (value) => setState(() => enableScreenshots = value),
            iconColor: AppTheme.primaryColor,
          ),
          _buildDivider(),
          _buildSwitchTile(
            icon: Icons.analytics,
            title: 'إحصائيات الاستخدام',
            subtitle: 'جمع بيانات مجهولة لتحسين التطبيق',
            value: enableAppUsageStats,
            onChanged: (value) => setState(() => enableAppUsageStats = value),
            iconColor: AppTheme.successColor,
          ),
          _buildDivider(),
          _buildSwitchTile(
            icon: Icons.share,
            title: 'مشاركة التحليلات',
            subtitle: 'مشاركة بيانات التحليل مع المطورين',
            value: shareAnalytics,
            onChanged: (value) => setState(() => shareAnalytics = value),
            iconColor: AppTheme.warningColor,
          ),
        ],
      ),
    );
  }

  Widget _buildDataCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          _buildActionTile(
            icon: Icons.download,
            title: 'تصدير البيانات',
            subtitle: 'تحميل نسخة من بياناتك',
            onTap: () {
              // TODO: Export data functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('سيتم تصدير البيانات قريباً')),
              );
            },
            iconColor: AppTheme.accentColor,
          ),
          _buildDivider(),
          _buildActionTile(
            icon: Icons.delete_sweep,
            title: 'مسح البيانات',
            subtitle: 'حذف جميع البيانات المحفوظة',
            onTap: () {
              _showDeleteDataConfirmation();
            },
            iconColor: AppTheme.dangerColor,
          ),
          _buildDivider(),
          _buildActionTile(
            icon: Icons.backup,
            title: 'النسخ الاحتياطي',
            subtitle: 'إنشاء نسخة احتياطية من الإعدادات',
            onTap: () {
              // TODO: Backup functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم إنشاء النسخة الاحتياطية')),
              );
            },
            iconColor: AppTheme.successColor,
          ),
        ],
      ),
    );
  }

  Widget _buildHelpCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          _buildActionTile(
            icon: Icons.policy,
            title: 'سياسة الخصوصية',
            subtitle: 'اقرأ سياسة الخصوصية الكاملة',
            onTap: _showPrivacyPolicy,
            iconColor: AppTheme.primaryColor,
          ),
          _buildDivider(),
          _buildActionTile(
            icon: Icons.security,
            title: 'نصائح الأمان',
            subtitle: 'تعلم كيفية حماية أجهزتك',
            onTap: _showSecurityTips,
            iconColor: AppTheme.warningColor,
          ),
          _buildDivider(),
          _buildActionTile(
            icon: Icons.support_agent,
            title: 'الدعم الفني',
            subtitle: 'تواصل مع فريق الدعم',
            onTap: () {
              // TODO: Contact support
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('سيتم فتح صفحة الدعم قريباً')),
              );
            },
            iconColor: AppTheme.accentColor,
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
    Widget? trailing,
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
      trailing: trailing ?? Switch(
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

  void _showDeleteDataConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        ),
        title: Row(
          children: [
            const Icon(Icons.warning, color: AppTheme.dangerColor),
            const SizedBox(width: 8),
            const Text('تحذير'),
          ],
        ),
        content: const Text(
          'هل أنت متأكد من رغبتك في حذف جميع البيانات؟\n\nهذا الإجراء لا يمكن التراجع عنه وسيتم فقدان جميع البيانات المحفوظة.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Delete data functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم حذف البيانات'),
                  backgroundColor: AppTheme.dangerColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.dangerColor,
            ),
            child: const Text('حذف', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

