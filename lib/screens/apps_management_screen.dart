import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/device_model.dart';
import '../widgets/custom_widgets.dart';
import '../theme/app_theme.dart';
import '../notifications/notifications_helper.dart';

class AppsManagementScreen extends StatefulWidget {
  const AppsManagementScreen({super.key});

  @override
  State<AppsManagementScreen> createState() => _AppsManagementScreenState();
}

class _AppsManagementScreenState extends State<AppsManagementScreen>
    with TickerProviderStateMixin {
  List<DeviceModel> devices = [];
  DeviceModel? selectedDevice;
  List<AppModel> apps = [];
  List<AppModel> filteredApps = [];
  bool isLoading = false;
  bool isAppsLoading = false;
  String searchQuery = '';
  String filterType = 'all'; // all, system, user
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final TextEditingController _searchController = TextEditingController();

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
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchDevices() async {
    setState(() => isLoading = true);

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('devices')
          // .where('isOnline', isEqualTo: true)
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

  Future<void> _fetchApps(String deviceId) async {
    setState(() => isAppsLoading = true);

    try {
      final doc = await FirebaseFirestore.instance
          .collection('devices')
          .doc(deviceId)
          .get();

      if (doc.exists) {
        final deviceData = doc.data() as Map<String, dynamic>;
        final appsData = deviceData['installedApps'] as List<dynamic>? ?? [];
        
        setState(() {
          apps = appsData.map((app) => AppModel.fromMap(app)).toList();
          _filterApps();
        });
      }
    } catch (e) {
      _showErrorSnackBar('فشل في تحميل التطبيقات');
    } finally {
      setState(() => isAppsLoading = false);
    }
  }

  void _filterApps() {
    setState(() {
      filteredApps = apps.where((app) {
        // فلترة حسب النوع
        bool typeMatch = true;
        if (filterType == 'system') {
          typeMatch = app.isSystemApp;
        } else if (filterType == 'user') {
          typeMatch = !app.isSystemApp;
        }

        // فلترة حسب البحث
        bool searchMatch = searchQuery.isEmpty ||
            app.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
            app.packageName.toLowerCase().contains(searchQuery.toLowerCase());

        return typeMatch && searchMatch;
      }).toList();

      // ترتيب التطبيقات حسب الاسم
      filteredApps.sort((a, b) => a.name.compareTo(b.name));
    });
  }

  Future<void> _uninstallApp(AppModel app) async {
    if (selectedDevice == null) return;

    final confirmed = await _showConfirmationDialog(
      title: 'إلغاء تثبيت التطبيق',
      content: 'هل تريد إلغاء تثبيت "${app.name}"؟\nهذا الإجراء لا يمكن التراجع عنه.',
      isDangerous: true,
    );

    if (!confirmed) return;

    setState(() => isLoading = true);

    try {
      await NotificationService.sendNotification(
        deviceToken: selectedDevice!.token,
        // title: "إلغاء تثبيت تطبيق",
        // body: "جاري إلغاء تثبيت ${app.name}",
        data: {
          "command": "uninstall_app",
          "package_name": app.packageName,
        },
        // includeNotification: false,
      );

      _showSuccessSnackBar('تم إرسال أمر إلغاء التثبيت');
      
      // تحديث قائمة التطبيقات بعد فترة
      Future.delayed(const Duration(seconds: 3), () {
        if (selectedDevice != null) {
          _fetchApps(selectedDevice!.id);
        }
      });
    } catch (e) {
      _showErrorSnackBar('فشل في إرسال الأمر');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _installApp() async {
    if (selectedDevice == null) return;

    // TODO: Implement app installation logic
    // This would typically involve selecting an APK file or from a store
    _showInfoDialog(
      title: 'تثبيت تطبيق',
      content: 'هذه الميزة قيد التطوير. سيتم إضافة إمكانية تثبيت التطبيقات قريباً.',
    );
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

  void _showInfoDialog({required String title, required String content}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        ),
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
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
        title: const Text('إدارة التطبيقات'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              if (selectedDevice != null) {
                _fetchApps(selectedDevice!.id);
              }
            },
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            _buildDeviceSelector(),
            if (selectedDevice != null) ...[
              _buildFilterTabs(),
              _buildSearchBar(),
              _buildAppsStats(),
              Expanded(child: _buildAppsList()),
            ] else
              const Expanded(
                child: EmptyStateWidget(
                  icon: Icons.devices,
                  title: 'اختر جهازاً',
                  subtitle: 'يرجى اختيار جهاز لعرض التطبيقات المثبتة عليه',
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: selectedDevice != null
          ? FloatingActionButton.extended(
              onPressed: _installApp,
              icon: const Icon(Icons.add),
              label: const Text('تثبيت تطبيق'),
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: AppTheme.textOnPrimary,
            )
          : null,
    );
  }

  Widget _buildDeviceSelector() {
    return Container(
      margin: const EdgeInsets.all(AppConstants.paddingMedium),
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
            Text('اختر جهازاً'),
          ],
        ),
        underline: const SizedBox(),
        items: devices.map((device) {
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
                        '${device.appsCount} تطبيق',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        onChanged: (device) {
          setState(() {
            selectedDevice = device;
            apps.clear();
            filteredApps.clear();
          });
          if (device != null) {
            _fetchApps(device.id);
          }
        },
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
      child: Row(
        children: [
          Expanded(
            child: _buildFilterTab('all', 'الكل', apps.length),
          ),
          const SizedBox(width: AppConstants.paddingSmall),
          Expanded(
            child: _buildFilterTab(
              'user',
              'المستخدم',
              apps.where((app) => !app.isSystemApp).length,
            ),
          ),
          const SizedBox(width: AppConstants.paddingSmall),
          Expanded(
            child: _buildFilterTab(
              'system',
              'النظام',
              apps.where((app) => app.isSystemApp).length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab(String type, String label, int count) {
    final isSelected = filterType == type;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          filterType = type;
          _filterApps();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingMedium,
          vertical: AppConstants.paddingSmall,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
          boxShadow: isSelected ? AppTheme.elevatedShadow : AppTheme.cardShadow,
        ),
        child: Column(
          children: [
            Text(
              '$count',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isSelected ? AppTheme.textOnPrimary : AppTheme.primaryColor,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? AppTheme.textOnPrimary : AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return EnhancedSearchBar(
      hintText: 'البحث عن تطبيق...',
      controller: _searchController,
      onChanged: (query) {
        setState(() {
          searchQuery = query;
          _filterApps();
        });
      },
      onClear: () {
        setState(() {
          searchQuery = '';
          _filterApps();
        });
      },
    );
  }

  Widget _buildAppsStats() {
    final userApps = apps.where((app) => !app.isSystemApp).length;
    final systemApps = apps.where((app) => app.isSystemApp).length;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            icon: Icons.apps,
            label: 'إجمالي التطبيقات',
            value: '${apps.length}',
            color: AppTheme.accentColor,
          ),
          _buildStatItem(
            icon: Icons.person,
            label: 'تطبيقات المستخدم',
            value: '$userApps',
            color: AppTheme.successColor,
          ),
          _buildStatItem(
            icon: Icons.settings,
            label: 'تطبيقات النظام',
            value: '$systemApps',
            color: AppTheme.warningColor,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildAppsList() {
    if (isAppsLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (filteredApps.isEmpty) {
      return EmptyStateWidget(
        icon: searchQuery.isNotEmpty ? Icons.search_off : Icons.apps,
        title: searchQuery.isNotEmpty ? 'لا توجد نتائج' : 'لا توجد تطبيقات',
        subtitle: searchQuery.isNotEmpty
            ? 'لم يتم العثور على تطبيقات تطابق البحث'
            : 'لم يتم العثور على تطبيقات في هذا الجهاز',
        buttonText: 'تحديث',
        onButtonPressed: () {
          if (selectedDevice != null) {
            _fetchApps(selectedDevice!.id);
          }
        },
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      itemCount: filteredApps.length,
      itemBuilder: (context, index) {
        final app = filteredApps[index];
        return _buildAppCard(app);
      },
    );
  }

  Widget _buildAppCard(AppModel app) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingSmall),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        boxShadow: AppTheme.cardShadow,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(AppConstants.paddingMedium),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: app.isSystemApp
                ? AppTheme.warningColor.withOpacity(0.2)
                : AppTheme.accentColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          ),
          child: Icon(
            app.isSystemApp ? Icons.settings : Icons.apps,
            color: app.isSystemApp ? AppTheme.warningColor : AppTheme.accentColor,
          ),
        ),
        title: Text(
          app.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              app.packageName,
              style: Theme.of(context).textTheme.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  'الإصدار: ${app.version}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (app.size != null) ...[
                  const SizedBox(width: 16),
                  Text(
                    'الحجم: ${app.sizeText}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ],
            ),
          ],
        ),
        trailing: !app.isSystemApp
            ? IconButton(
                icon: const Icon(Icons.delete, color: AppTheme.dangerColor),
                onPressed: () => _uninstallApp(app),
                tooltip: 'إلغاء التثبيت',
              )
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.warningColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'نظام',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppTheme.warningColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
      ),
    );
  }
}

