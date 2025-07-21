import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/device_model.dart';
import '../widgets/custom_widgets.dart';
import '../theme/app_theme.dart';
import '../notifications/notifications_helper.dart';

class CommandsScreen extends StatefulWidget {
  const CommandsScreen({super.key});

  @override
  State<CommandsScreen> createState() => _CommandsScreenState();
}

class _CommandsScreenState extends State<CommandsScreen>
    with TickerProviderStateMixin {
  List<DeviceModel> devices = [];
  DeviceModel? selectedDevice;
  bool isLoading = false;
  bool isSendingCommand = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  String selectedCategory = 'security'; // security, system, apps, location

  final Map<String, List<CommandItem>> commands = {
    'security': [
      CommandItem(
        id: 'lock',
        title: 'قفل الجهاز',
        description: 'قفل الجهاز فوراً',
        icon: Icons.lock,
        color: AppTheme.dangerColor,
        isDangerous: true,
      ),
      CommandItem(
        id: 'unlock',
        title: 'إلغاء قفل الجهاز',
        description: 'إلغاء قفل الجهاز',
        icon: Icons.lock_open,
        color: AppTheme.successColor,
      ),
      CommandItem(
        id: 'disable_camera',
        title: 'تعطيل الكاميرا',
        description: 'منع استخدام الكاميرا',
        icon: Icons.camera_alt_outlined,
        color: AppTheme.dangerColor,
        isDangerous: true,
      ),
      CommandItem(
        id: 'enable_camera',
        title: 'تفعيل الكاميرا',
        description: 'السماح باستخدام الكاميرا',
        icon: Icons.camera_alt,
        color: AppTheme.successColor,
      ),
    ],
    'system': [
      CommandItem(
        id: 'reboot_device',
        title: 'إعادة تشغيل الجهاز',
        description: 'إعادة تشغيل الجهاز فوراً',
        icon: Icons.restart_alt,
        color: AppTheme.warningColor,
        isDangerous: true,
      ),
      CommandItem(
        id: 'shutdown_device',
        title: 'إيقاف تشغيل الجهاز',
        description: 'إيقاف تشغيل الجهاز تماماً',
        icon: Icons.power_settings_new,
        color: AppTheme.dangerColor,
        isDangerous: true,
      ),
      CommandItem(
        id: 'clear_cache',
        title: 'مسح ذاكرة التخزين المؤقت',
        description: 'مسح ملفات التخزين المؤقت',
        icon: Icons.cleaning_services,
        color: AppTheme.accentColor,
      ),
      CommandItem(
        id: 'update_system',
        title: 'تحديث النظام',
        description: 'البحث عن تحديثات النظام',
        icon: Icons.system_update,
        color: AppTheme.primaryColor,
      ),
    ],
    'apps': [
      CommandItem(
        id: 'disable_playstore',
        title: 'تعطيل متجر بلاي',
        description: 'منع الوصول إلى متجر بلاي',
        icon: Icons.shop,
        color: AppTheme.dangerColor,
        isDangerous: true,
      ),
      CommandItem(
        id: 'enable_playstore',
        title: 'تفعيل متجر بلاي',
        description: 'السماح بالوصول إلى متجر بلاي',
        icon: Icons.shop,
        color: AppTheme.successColor,
      ),
      CommandItem(
        id: 'force_stop_apps',
        title: 'إيقاف جميع التطبيقات',
        description: 'إيقاف جميع التطبيقات قسرياً',
        icon: Icons.stop,
        color: AppTheme.warningColor,
        isDangerous: true,
      ),
      CommandItem(
        id: 'backup_apps',
        title: 'نسخ احتياطي للتطبيقات',
        description: 'إنشاء نسخة احتياطية من التطبيقات',
        icon: Icons.backup,
        color: AppTheme.accentColor,
      ),
    ],
    'location': [
      CommandItem(
        id: 'update_location',
        title: 'تحديث الموقع',
        description: 'الحصول على الموقع الحالي',
        icon: Icons.my_location,
        color: AppTheme.accentColor,
      ),
      CommandItem(
        id: 'enable_gps',
        title: 'تفعيل GPS',
        description: 'تفعيل خدمات الموقع',
        icon: Icons.gps_fixed,
        color: AppTheme.successColor,
      ),
      CommandItem(
        id: 'disable_gps',
        title: 'تعطيل GPS',
        description: 'تعطيل خدمات الموقع',
        icon: Icons.gps_off,
        color: AppTheme.dangerColor,
        isDangerous: true,
      ),
      CommandItem(
        id: 'track_device',
        title: 'تتبع الجهاز',
        description: 'بدء تتبع الجهاز المستمر',
        icon: Icons.track_changes,
        color: AppTheme.warningColor,
      ),
    ],
  };

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _fetchDevices();
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

  Future<void> _fetchDevices() async {
    setState(() => isLoading = true);

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('devices')
          .get();

      setState(() {
        devices = querySnapshot.docs
            .map((doc) => DeviceModel.fromFirestore(doc))
            .toList();
      });
    } catch (e) {
      _showErrorSnackBar('فشل في تحميل الأجهزة');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _sendCommand(CommandItem command, {bool toAllDevices = false}) async {
    // تأكيد للأوامر الخطيرة
    if (command.isDangerous || toAllDevices) {
      final confirmed = await _showConfirmationDialog(
        title: toAllDevices ? 'إرسال أمر لجميع الأجهزة' : 'إرسال أمر للجهاز',
        content: toAllDevices
            ? 'هل تريد إرسال أمر "${command.title}" لجميع الأجهزة المتصلة؟'
            : 'هل تريد إرسال أمر "${command.title}" للجهاز المحدد؟',
        isDangerous: command.isDangerous,
      );

      if (!confirmed) return;
    }

    setState(() => isSendingCommand = true);

    try {
      if (toAllDevices) {
        final onlineDevices = devices.where((device) => device.isOnline).toList();
        
        for (final device in onlineDevices) {
          await NotificationService.sendNotification(
            deviceToken: device.token,
            // title: "أمر من المسؤول",
            // body: "تم تنفيذ أمر: ${command.title}",
            data: {"command": command.id},
            // includeNotification: false,
          );
        }

        _showSuccessSnackBar('تم إرسال الأمر لـ ${onlineDevices.length} جهاز');
      } else {
        if (selectedDevice == null) {
          _showErrorSnackBar('يرجى اختيار جهاز أولاً');
          return;
        }

        await NotificationService.sendNotification(
          deviceToken: selectedDevice!.token,
          // title: "أمر من المسؤول",
          // body: "تم تنفيذ أمر: ${command.title}",
          data: {"command": command.id},
          // includeNotification: false,
        );

        _showSuccessSnackBar('تم إرسال الأمر للجهاز المحدد');
      }
    } catch (e) {
      _showErrorSnackBar('فشل في إرسال الأمر: ${e.toString()}');
    } finally {
      setState(() => isSendingCommand = false);
    }
  }

  Future<bool> _showConfirmationDialog({
    required String title,
    required String content,
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
            onPressed: () => Navigator.of(context).pop(true),
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

    return result ?? false;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('أوامر التحكم'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchDevices,
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            _buildDeviceSelector(),
            _buildCategoryTabs(),
            Expanded(child: _buildCommandsList()),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceSelector() {
    return Container(
      margin: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'اختيار الجهاز المستهدف',
            icon: Icons.devices,
          ),
          const SizedBox(height: AppConstants.paddingSmall),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
              boxShadow: AppTheme.cardShadow,
            ),
            child: DropdownButton<DeviceModel>(
              isExpanded: true,
              value: selectedDevice,
              hint: const Row(
                children: [
                  Icon(Icons.smartphone, color: AppTheme.accentColor),
                  SizedBox(width: 8),
                  Text('اختر جهازاً محدداً'),
                ],
              ),
              underline: const SizedBox(),
              items: [
                const DropdownMenuItem<DeviceModel>(
                  value: null,
                  child: Row(
                    children: [
                      Icon(Icons.all_inclusive, color: AppTheme.primaryColor),
                      SizedBox(width: 8),
                      Text(
                        'جميع الأجهزة',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                ...devices.map((device) {
                  return DropdownMenuItem<DeviceModel>(
                    value: device,
                    child: Row(
                      children: [
                        Icon(
                          Icons.smartphone,
                          color: device.isOnline ? AppTheme.successColor : AppTheme.textSecondary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                device.name,
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Text(
                                device.isOnline ? 'متصل' : 'غير متصل',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: device.isOnline ? AppTheme.successColor : AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
              onChanged: (device) {
                setState(() => selectedDevice = device);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    final categories = {
      'security': {'title': 'الأمان', 'icon': Icons.security},
      'system': {'title': 'النظام', 'icon': Icons.settings},
      'apps': {'title': 'التطبيقات', 'icon': Icons.apps},
      'location': {'title': 'الموقع', 'icon': Icons.location_on},
    };

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: categories.entries.map((entry) {
            final isSelected = selectedCategory == entry.key;
            final categoryData = entry.value;
            
            return GestureDetector(
              onTap: () => setState(() => selectedCategory = entry.key),
              child: Container(
                margin: const EdgeInsets.only(right: AppConstants.paddingSmall),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingLarge,
                  vertical: AppConstants.paddingMedium,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primaryColor : AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                  boxShadow: isSelected ? AppTheme.elevatedShadow : AppTheme.cardShadow,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      categoryData['icon'] as IconData,
                      color: isSelected ? AppTheme.textOnPrimary : AppTheme.textSecondary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      categoryData['title'] as String,
                      style: TextStyle(
                        color: isSelected ? AppTheme.textOnPrimary : AppTheme.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCommandsList() {
    final categoryCommands = commands[selectedCategory] ?? [];

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      itemCount: categoryCommands.length,
      itemBuilder: (context, index) {
        final command = categoryCommands[index];
        return _buildCommandCard(command);
      },
    );
  }

  Widget _buildCommandCard(CommandItem command) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        boxShadow: AppTheme.cardShadow,
        border: Border.all(
          color: command.isDangerous
              ? AppTheme.dangerColor.withOpacity(0.3)
              : command.color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: command.color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                  ),
                  child: Icon(
                    command.icon,
                    color: command.color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppConstants.paddingMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              command.title,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (command.isDangerous)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.dangerColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'خطير',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppTheme.dangerColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        command.description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingLarge),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isSendingCommand
                        ? null
                        : () => _sendCommand(command, toAllDevices: selectedDevice == null),
                    icon: isSendingCommand
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.send, size: 18),
                    label: Text(
                      selectedDevice == null ? 'إرسال للكل' : 'إرسال للجهاز',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: command.isDangerous ? AppTheme.dangerColor : command.color,
                      foregroundColor: AppTheme.textOnPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                      ),
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
}

class CommandItem {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final bool isDangerous;

  CommandItem({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    this.isDangerous = false,
  });
}

