import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/device_model.dart';
import '../widgets/custom_widgets.dart';
import '../theme/app_theme.dart';
import '../notifications/notifications_helper.dart';

class DeviceDetailsScreen extends StatefulWidget {
  final DeviceModel device;

  const DeviceDetailsScreen({super.key, required this.device});

  @override
  State<DeviceDetailsScreen> createState() => _DeviceDetailsScreenState();
}

class _DeviceDetailsScreenState extends State<DeviceDetailsScreen>
    with TickerProviderStateMixin {
  late DeviceModel currentDevice;
  bool isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    currentDevice = widget.device;
    _setupAnimations();
    _refreshDeviceData();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
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

  Future<void> _refreshDeviceData() async {
    setState(() => isLoading = true);

    try {
      final doc = await FirebaseFirestore.instance
          .collection('devices')
          .doc(currentDevice.id)
          .get();

      if (doc.exists) {
        setState(() {
          currentDevice = DeviceModel.fromFirestore(doc);
        });
      }
    } catch (e) {
      _showErrorSnackBar('فشل في تحديث بيانات الجهاز');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _sendCommand(String command, {String? packageName}) async {
    setState(() => isLoading = true);

    try {
      await NotificationService.sendNotification(
        deviceToken: currentDevice.token,
        // title: "أمر من المسؤول",
        // body: "تم تنفيذ أمر: $command",
        data: {
          "command": command,
          if (packageName != null) "package_name": packageName,
        },
        // includeNotification: false,
      );

      _showSuccessSnackBar('تم إرسال الأمر بنجاح');
      
      // تحديث البيانات بعد إرسال الأمر
      Future.delayed(const Duration(seconds: 2), _refreshDeviceData);
    } catch (e) {
      _showErrorSnackBar('فشل في إرسال الأمر: ${e.toString()}');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppTheme.dangerColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        ),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
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

  Future<void> _showConfirmationDialog({
    required String title,
    required String content,
    required VoidCallback onConfirm,
    bool isDangerous = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        ),
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isDangerous ? AppTheme.dangerColor : AppTheme.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
              ),
            ),
            child: const Text('تأكيد', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          _buildDeviceHeader(),
          _buildDeviceInfo(),
          _buildQuickActions(),
          _buildDetailedInfo(),
          _buildCommandsSection(),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 100,
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh, color: AppTheme.textPrimary),
          onPressed: _refreshDeviceData,
        ),
        IconButton(
          icon: const Icon(Icons.more_vert, color: AppTheme.textPrimary),
          onPressed: () {
            // TODO: Show device options menu
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          currentDevice.name,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
    );
  }

  Widget _buildDeviceHeader() {
    return SliverToBoxAdapter(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Container(
            margin: const EdgeInsets.all(AppConstants.paddingMedium),
            padding: const EdgeInsets.all(AppConstants.paddingLarge),
            decoration: BoxDecoration(
              gradient: currentDevice.isOnline
                  ? AppTheme.primaryGradient
                  : LinearGradient(
                      colors: [
                        AppTheme.textSecondary.withOpacity(0.3),
                        AppTheme.textSecondary.withOpacity(0.1),
                      ],
                    ),
              borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
              boxShadow: AppTheme.elevatedShadow,
            ),
            child: Column(
              children: [
                // أيقونة الجهاز الكبيرة
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.smartphone,
                    size: 40,
                    color: currentDevice.isOnline
                        ? AppTheme.textOnPrimary
                        : AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: AppConstants.paddingMedium),
                
                // اسم الجهاز
                Text(
                  currentDevice.name,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: currentDevice.isOnline
                        ? AppTheme.textOnPrimary
                        : AppTheme.textSecondary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppConstants.paddingSmall),
                
                // معلومات أساسية
                Text(
                  '${currentDevice.manufacturer} • ${currentDevice.model}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: (currentDevice.isOnline
                            ? AppTheme.textOnPrimary
                            : AppTheme.textSecondary)
                        .withOpacity(0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppConstants.paddingMedium),
                
                // حالة الاتصال
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: currentDevice.isOnline
                              ? AppTheme.successColor
                              : AppTheme.dangerColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        currentDevice.connectionStatus,
                        style: TextStyle(
                          color: currentDevice.isOnline
                              ? AppTheme.textOnPrimary
                              : AppTheme.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeviceInfo() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
        child: Row(
          children: [
            Expanded(
              child: _buildInfoCard(
                icon: Icons.battery_std,
                title: 'البطارية',
                value: '${currentDevice.batteryLevel}%',
                subtitle: currentDevice.batteryStatus,
                color: _getBatteryColor(currentDevice.batteryLevel),
              ),
            ),
            const SizedBox(width: AppConstants.paddingSmall),
            Expanded(
              child: _buildInfoCard(
                icon: Icons.android,
                title: 'النظام',
                value: 'Android',
                subtitle: currentDevice.osVersion,
                color: AppTheme.successColor,
              ),
            ),
            const SizedBox(width: AppConstants.paddingSmall),
            Expanded(
              child: _buildInfoCard(
                icon: Icons.apps,
                title: 'التطبيقات',
                value: '${currentDevice.appsCount}',
                subtitle: 'تطبيق مثبت',
                color: AppTheme.accentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: AppConstants.paddingSmall),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              title: 'الإجراءات السريعة',
              icon: Icons.flash_on,
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionButton(
                    icon: currentDevice.isLocked ? Icons.lock_open : Icons.lock,
                    title: currentDevice.isLocked ? 'إلغاء القفل' : 'قفل الجهاز',
                    color: currentDevice.isLocked ? AppTheme.successColor : AppTheme.dangerColor,
                    onTap: () => _showConfirmationDialog(
                      title: currentDevice.isLocked ? 'إلغاء قفل الجهاز' : 'قفل الجهاز',
                      content: currentDevice.isLocked
                          ? 'هل تريد إلغاء قفل هذا الجهاز؟'
                          : 'هل تريد قفل هذا الجهاز؟',
                      onConfirm: () => _sendCommand(currentDevice.isLocked ? 'unlock' : 'lock'),
                      isDangerous: !currentDevice.isLocked,
                    ),
                  ),
                ),
                const SizedBox(width: AppConstants.paddingSmall),
                Expanded(
                  child: _buildQuickActionButton(
                    icon: Icons.restart_alt,
                    title: 'إعادة التشغيل',
                    color: AppTheme.warningColor,
                    onTap: () => _showConfirmationDialog(
                      title: 'إعادة تشغيل الجهاز',
                      content: 'هل تريد إعادة تشغيل هذا الجهاز؟',
                      onConfirm: () => _sendCommand('reboot_device'),
                      isDangerous: true,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: AppConstants.paddingSmall),
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedInfo() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              title: 'معلومات تفصيلية',
              icon: Icons.info_outline,
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingLarge),
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                boxShadow: AppTheme.cardShadow,
              ),
              child: Column(
                children: [
                  _buildDetailRow('الشركة المصنعة', currentDevice.manufacturer),
                  _buildDetailRow('الطراز', currentDevice.model),
                  _buildDetailRow('إصدار النظام', currentDevice.osVersion),
                  _buildDetailRow('مستوى SDK', '${currentDevice.sdkVersion}'),
                  _buildDetailRow('آخر ظهور', currentDevice.lastSeenText),
                  if (currentDevice.hasLocation) ...[
                    _buildDetailRow('خط العرض', '${currentDevice.latitude}'),
                    _buildDetailRow('خط الطول', '${currentDevice.longitude}'),
                    _buildDetailRow('العنوان', currentDevice.address ?? 'غير محدد'),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommandsSection() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              title: 'أوامر التحكم',
              icon: Icons.settings_remote,
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            EnhancedActionButton(
              label: currentDevice.cameraEnabled ? 'تعطيل الكاميرا' : 'تفعيل الكاميرا',
              icon: currentDevice.cameraEnabled ? Icons.camera_alt_outlined : Icons.camera_alt,
              onPressed: () => _sendCommand(
                currentDevice.cameraEnabled ? 'disable_camera' : 'enable_camera',
              ),
              backgroundColor: currentDevice.cameraEnabled ? AppTheme.dangerColor : AppTheme.successColor,
              isLoading: isLoading,
            ),
            EnhancedActionButton(
              label: currentDevice.playStoreEnabled ? 'تعطيل متجر بلاي' : 'تفعيل متجر بلاي',
              icon: Icons.shop,
              onPressed: () => _sendCommand(
                currentDevice.playStoreEnabled ? 'disable_playstore' : 'enable_playstore',
              ),
              backgroundColor: currentDevice.playStoreEnabled ? AppTheme.dangerColor : AppTheme.successColor,
              isLoading: isLoading,
            ),
            EnhancedActionButton(
              label: 'تحديث الموقع',
              icon: Icons.location_on,
              onPressed: () => _sendCommand('update_location'),
              isLoading: isLoading,
            ),
            const SizedBox(height: AppConstants.paddingLarge),
          ],
        ),
      ),
    );
  }

  Color _getBatteryColor(int level) {
    if (level >= 50) return AppTheme.successColor;
    if (level >= 20) return AppTheme.warningColor;
    return AppTheme.dangerColor;
  }
}

