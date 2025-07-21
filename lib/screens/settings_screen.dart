import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_widgets.dart';
import '../animations/page_transitions.dart';
import 'privacy_security_screen.dart';
import 'language_screen.dart';
import 'theme_screen.dart';
import 'help_support_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  PackageInfo? packageInfo;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadPackageInfo();
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

  Future<void> _loadPackageInfo() async {
    try {
      final info = await PackageInfo.fromPlatform();
      setState(() {
        packageInfo = info;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        ),
        title: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
              ),
              child: const Icon(
                Icons.info,
                color: AppTheme.textOnPrimary,
                size: 24,
              ),
            ),
            const SizedBox(width: AppConstants.paddingMedium),
            const Text('حول التطبيق'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'تطبيق إدارة الأجهزة المحسن',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            Text(
              'تطبيق متطور لإدارة الأجهزة المحمولة عن بُعد مع واجهة مستخدم جميلة وتجربة متطورة.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            if (packageInfo != null) ...[
              _buildInfoRow('الإصدار', packageInfo!.version),
              _buildInfoRow('رقم البناء', packageInfo!.buildNumber),
              _buildInfoRow('اسم الحزمة', packageInfo!.packageName),
            ],
            const SizedBox(height: AppConstants.paddingMedium),
            const Text(
              '© 2024 جميع الحقوق محفوظة',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
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

  void _showDeveloperInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        ),
        title: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: AppTheme.accentGradient,
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
              ),
              child: const Icon(
                Icons.person,
                color: AppTheme.textOnPrimary,
                size: 24,
              ),
            ),
            const SizedBox(width: AppConstants.paddingMedium),
            const Text('معلومات المطور'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    shape: BoxShape.circle,
                    boxShadow: AppTheme.elevatedShadow,
                  ),
                  child: const Icon(
                    Icons.code,
                    color: AppTheme.textOnPrimary,
                    size: 40,
                  ),
                ),
                const SizedBox(width: AppConstants.paddingLarge),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'مروان',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'مطور تطبيقات محترف',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingLarge),
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              decoration: BoxDecoration(
                color: AppTheme.accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                border: Border.all(
                  color: AppTheme.accentColor.withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: AppTheme.accentColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'التخصصات',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.accentColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.paddingSmall),
                  const Text('• تطوير تطبيقات Flutter'),
                  const Text('• تطوير تطبيقات Android الأصلية'),
                  const Text('• تصميم واجهات المستخدم'),
                  const Text('• إدارة قواعد البيانات'),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              decoration: BoxDecoration(
                color: AppTheme.successColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                border: Border.all(
                  color: AppTheme.successColor.withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.emoji_events,
                        color: AppTheme.successColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'الإنجازات',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.successColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.paddingSmall),
                  const Text('• أكثر من 50 تطبيق منشور'),
                  const Text('• خبرة 5+ سنوات في التطوير'),
                  const Text('• تقييم 4.8/5 من العملاء'),
                  const Text('• متخصص في الحلول المؤسسية'),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: AppTheme.textPrimary),
            ),
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
        title: const Text('الإعدادات'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // قسم التطبيق
                    _buildSectionHeader('معلومات التطبيق', Icons.apps),
                    const SizedBox(height: AppConstants.paddingMedium),
                    _buildSettingsCard([
                      _buildSettingsTile(
                        icon: Icons.info_outline,
                        title: 'حول التطبيق',
                        subtitle: 'معلومات عن التطبيق والإصدار',
                        onTap: _showAboutDialog,
                      ),
                      _buildDivider(),
                      _buildSettingsTile(
                        icon: Icons.update,
                        title: 'إصدار التطبيق',
                        subtitle: packageInfo?.version ?? 'غير متوفر',
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.successColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'الأحدث',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppTheme.successColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      _buildDivider(),
                      _buildSettingsTile(
                        icon: Icons.security,
                        title: 'الخصوصية والأمان',
                        subtitle: 'إعدادات الحماية والخصوصية',
                        onTap: () {
                          TransitionHelpers.navigateWithTransition(
                            context,
                            const PrivacySecurityScreen(),
                            type: TransitionType.slideFromRight,
                          );
                        },
                      ),
                    ]),

                    const SizedBox(height: AppConstants.paddingLarge),

                    // // قسم المطور
                    // _buildSectionHeader('معلومات المطور', Icons.person),
                    // const SizedBox(height: AppConstants.paddingMedium),
                    // _buildDeveloperCard(),

                    // const SizedBox(height: AppConstants.paddingLarge),

                    // قسم الإعدادات العامة
                    _buildSectionHeader('الإعدادات العامة', Icons.settings),
                    const SizedBox(height: AppConstants.paddingMedium),
                    _buildSettingsCard([
                      _buildSettingsTile(
                        icon: Icons.language,
                        title: 'اللغة',
                        subtitle: 'العربية',
                        onTap: () {
                          TransitionHelpers.navigateWithTransition(
                            context,
                            const LanguageScreen(),
                            type: TransitionType.slideFromRight,
                          );
                        },
                      ),
                      _buildDivider(),
                      _buildSettingsTile(
                        icon: Icons.dark_mode,
                        title: 'المظهر',
                        subtitle: 'فاتح',
                        onTap: () {
                          TransitionHelpers.navigateWithTransition(
                            context,
                            const ThemeScreen(),
                            type: TransitionType.slideFromRight,
                          );
                        },
                      ),
                      _buildDivider(),
                      _buildSettingsTile(
                        icon: Icons.notifications,
                        title: 'الإشعارات',
                        subtitle: 'إدارة إعدادات الإشعارات',
                        onTap: () {
                          // TODO: Notification settings
                        },
                      ),
                    ]),

                    const SizedBox(height: AppConstants.paddingLarge),

                    // قسم الدعم
                    _buildSectionHeader('الدعم والمساعدة', Icons.help),
                    const SizedBox(height: AppConstants.paddingMedium),
                    _buildSettingsCard([
                      _buildSettingsTile(
                        icon: Icons.help_outline,
                        title: 'المساعدة',
                        subtitle: 'الأسئلة الشائعة والدعم',
                        onTap: () {
                          TransitionHelpers.navigateWithTransition(
                            context,
                            const HelpSupportScreen(),
                            type: TransitionType.slideFromRight,
                          );
                        },
                      ),
                      _buildDivider(),
                      _buildSettingsTile(
                        icon: Icons.feedback,
                        title: 'إرسال ملاحظات',
                        subtitle: 'شاركنا رأيك لتحسين التطبيق',
                        onTap: () {
                          // TODO: Feedback form
                        },
                      ),
                      _buildDivider(),
                      _buildSettingsTile(
                        icon: Icons.star_rate,
                        title: 'تقييم التطبيق',
                        subtitle: 'قيم التطبيق في المتجر',
                        onTap: () {
                          // TODO: Rate app
                        },
                      ),
                    ]),

                    const SizedBox(height: AppConstants.paddingXLarge),

                    // معلومات إضافية
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'تطبيق إدارة الأجهزة',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'DeepSafer : تم التطوير بواسطة ',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '© 2025 جميع الحقوق محفوظة',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
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

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        ),
        child: Icon(icon, color: AppTheme.primaryColor, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: AppTheme.textSecondary),
      ),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  // Widget _buildDeveloperCard() {
  //   return InteractiveContainer(
  //     onTap: _showDeveloperInfo,
  //     child: Container(
  //       padding: const EdgeInsets.all(AppConstants.paddingLarge),
  //       decoration: BoxDecoration(
  //         gradient: AppTheme.accentGradient,
  //         borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
  //         boxShadow: AppTheme.elevatedShadow,
  //       ),
  //       child: Row(
  //         children: [
  //           Container(
  //             width: 60,
  //             height: 60,
  //             decoration: BoxDecoration(
  //               color: Colors.white.withOpacity(0.2),
  //               shape: BoxShape.circle,
  //             ),
  //             child: const Icon(
  //               Icons.code,
  //               color: AppTheme.textOnPrimary,
  //               size: 30,
  //             ),
  //           ),
  //           const SizedBox(width: AppConstants.paddingLarge),
  //           Expanded(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   'مروان',
  //                   style: Theme.of(context).textTheme.headlineSmall?.copyWith(
  //                     color: AppTheme.textOnPrimary,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //                 const SizedBox(height: 4),
  //                 Text(
  //                   'مطور تطبيقات',
  //                   style: Theme.of(context).textTheme.bodyLarge?.copyWith(
  //                     color: AppTheme.textOnPrimary.withOpacity(0.9),
  //                   ),
  //                 ),
  //                 const SizedBox(height: 8),
  //                 Row(
  //                   children: [
  //                     ...List.generate(5, (index) => const Icon(
  //                       Icons.star,
  //                       color: Colors.amber,
  //                       size: 16,
  //                     )),
  //                     const SizedBox(width: 8),
  //                     Text(
  //                       '5.0',
  //                       style: TextStyle(
  //                         color: AppTheme.textOnPrimary.withOpacity(0.9),
  //                         fontWeight: FontWeight.w600,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //           const Icon(
  //             Icons.arrow_forward_ios,
  //             color: AppTheme.textOnPrimary,
  //             size: 16,
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

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

