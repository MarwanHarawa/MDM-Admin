import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/device_model.dart';
import '../widgets/custom_widgets.dart';
import '../theme/app_theme.dart';
import 'device_details_screen.dart';

class DevicesManagementScreen extends StatefulWidget {
  const DevicesManagementScreen({super.key});

  @override
  State<DevicesManagementScreen> createState() => _DevicesManagementScreenState();
}

class _DevicesManagementScreenState extends State<DevicesManagementScreen>
    with TickerProviderStateMixin {
  List<DeviceModel> devices = [];
  List<DeviceModel> filteredDevices = [];
  bool isLoading = false;
  String searchQuery = '';
  String filterStatus = 'all'; // all, online, offline
  String sortBy = 'name'; // name, lastSeen, battery
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
          .get();

      final fetchedDevices = querySnapshot.docs
          .map((doc) => DeviceModel.fromFirestore(doc))
          .toList();

      setState(() {
        devices = fetchedDevices;
        _applyFiltersAndSort();
      });
    } catch (e) {
      _showErrorSnackBar('فشل في تحميل الأجهزة');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _applyFiltersAndSort() {
    setState(() {
      // تطبيق الفلترة
      filteredDevices = devices.where((device) {
        // فلترة حسب الحالة
        bool statusMatch = true;
        if (filterStatus == 'online') {
          statusMatch = device.isOnline;
        } else if (filterStatus == 'offline') {
          statusMatch = !device.isOnline;
        }

        // فلترة حسب البحث
        bool searchMatch = searchQuery.isEmpty ||
            device.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
            device.model.toLowerCase().contains(searchQuery.toLowerCase()) ||
            device.manufacturer.toLowerCase().contains(searchQuery.toLowerCase());

        return statusMatch && searchMatch;
      }).toList();

      // تطبيق الترتيب
      switch (sortBy) {
        case 'name':
          filteredDevices.sort((a, b) => a.name.compareTo(b.name));
          break;
        case 'lastSeen':
          filteredDevices.sort((a, b) {
            if (a.lastSeen == null && b.lastSeen == null) return 0;
            if (a.lastSeen == null) return 1;
            if (b.lastSeen == null) return -1;
            return b.lastSeen!.compareTo(a.lastSeen!);
          });
          break;
        case 'battery':
          filteredDevices.sort((a, b) => b.batteryLevel.compareTo(a.batteryLevel));
          break;
      }
    });
  }

  void _navigateToDeviceDetails(DeviceModel device) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            DeviceDetailsScreen(device: device),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: AppConstants.animationDuration,
      ),
    );
  }

  void _showDeviceOptions(DeviceModel device) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppConstants.radiusXLarge),
            topRight: Radius.circular(AppConstants.radiusXLarge),
          ),
        ),
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: AppConstants.paddingLarge),
            Text(
              device.name,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            _buildOptionTile(
              icon: Icons.info,
              title: 'عرض التفاصيل',
              onTap: () {
                Navigator.pop(context);
                _navigateToDeviceDetails(device);
              },
            ),
            _buildOptionTile(
              icon: Icons.edit,
              title: 'تعديل الاسم',
              onTap: () {
                Navigator.pop(context);
                _showRenameDialog(device);
              },
            ),
            _buildOptionTile(
              icon: Icons.delete,
              title: 'حذف الجهاز',
              color: AppTheme.dangerColor,
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation(device);
              },
            ),
            const SizedBox(height: AppConstants.paddingMedium),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppTheme.textPrimary),
      title: Text(
        title,
        style: TextStyle(
          color: color ?? AppTheme.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      ),
    );
  }

  void _showRenameDialog(DeviceModel device) {
    final controller = TextEditingController(text: device.name);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        ),
        title: const Text('تعديل اسم الجهاز'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'اسم الجهاز',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _renameDevice(device, controller.text.trim());
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  Future<void> _renameDevice(DeviceModel device, String newName) async {
    if (newName.isEmpty) return;

    try {
      await FirebaseFirestore.instance
          .collection('devices')
          .doc(device.id)
          .update({'deviceName': newName});

      _showSuccessSnackBar('تم تعديل اسم الجهاز بنجاح');
      _fetchDevices();
    } catch (e) {
      _showErrorSnackBar('فشل في تعديل اسم الجهاز');
    }
  }

  void _showDeleteConfirmation(DeviceModel device) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        ),
        title: const Text('حذف الجهاز'),
        content: Text('هل تريد حذف الجهاز "${device.name}"؟\nهذا الإجراء لا يمكن التراجع عنه.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteDevice(device);
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

  Future<void> _deleteDevice(DeviceModel device) async {
    try {
      await FirebaseFirestore.instance
          .collection('devices')
          .doc(device.id)
          .delete();

      _showSuccessSnackBar('تم حذف الجهاز بنجاح');
      _fetchDevices();
    } catch (e) {
      _showErrorSnackBar('فشل في حذف الجهاز');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('إدارة الأجهزة'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchDevices,
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: (value) {
              setState(() {
                sortBy = value;
                _applyFiltersAndSort();
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'name',
                child: Row(
                  children: [
                    Icon(Icons.sort_by_alpha),
                    SizedBox(width: 8),
                    Text('ترتيب حسب الاسم'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'lastSeen',
                child: Row(
                  children: [
                    Icon(Icons.access_time),
                    SizedBox(width: 8),
                    Text('ترتيب حسب آخر ظهور'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'battery',
                child: Row(
                  children: [
                    Icon(Icons.battery_std),
                    SizedBox(width: 8),
                    Text('ترتيب حسب البطارية'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            _buildDevicesStats(),
            _buildSearchAndFilter(),
            Expanded(child: _buildDevicesList()),
          ],
        ),
      ),
    );
  }

  Widget _buildDevicesStats() {
    final onlineDevices = devices.where((d) => d.isOnline).length;
    final offlineDevices = devices.length - onlineDevices;
    final averageBattery = devices.isEmpty
        ? 0
        : devices.fold<int>(0, (sum, device) => sum + device.batteryLevel) ~/
            devices.length;

    return Container(
      margin: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              icon: Icons.devices,
              title: 'إجمالي الأجهزة',
              value: '${devices.length}',
              color: AppTheme.accentColor,
            ),
          ),
          const SizedBox(width: AppConstants.paddingSmall),
          Expanded(
            child: _buildStatCard(
              icon: Icons.wifi,
              title: 'متصل',
              value: '$onlineDevices',
              color: AppTheme.successColor,
            ),
          ),
          const SizedBox(width: AppConstants.paddingSmall),
          Expanded(
            child: _buildStatCard(
              icon: Icons.wifi_off,
              title: 'غير متصل',
              value: '$offlineDevices',
              color: AppTheme.dangerColor,
            ),
          ),
          const SizedBox(width: AppConstants.paddingSmall),
          Expanded(
            child: _buildStatCard(
              icon: Icons.battery_std,
              title: 'متوسط البطارية',
              value: '$averageBattery%',
              color: _getBatteryColor(averageBattery),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
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
          Icon(icon, color: color, size: 24),
          const SizedBox(height: AppConstants.paddingSmall),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Column(
      children: [
        EnhancedSearchBar(
          hintText: 'البحث عن جهاز...',
          controller: _searchController,
          onChanged: (query) {
            setState(() {
              searchQuery = query;
              _applyFiltersAndSort();
            });
          },
          onClear: () {
            setState(() {
              searchQuery = '';
              _applyFiltersAndSort();
            });
          },
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
          child: Row(
            children: [
              Expanded(
                child: _buildFilterButton('all', 'الكل', devices.length),
              ),
              const SizedBox(width: AppConstants.paddingSmall),
              Expanded(
                child: _buildFilterButton(
                  'online',
                  'متصل',
                  devices.where((d) => d.isOnline).length,
                ),
              ),
              const SizedBox(width: AppConstants.paddingSmall),
              Expanded(
                child: _buildFilterButton(
                  'offline',
                  'غير متصل',
                  devices.where((d) => !d.isOnline).length,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterButton(String filter, String label, int count) {
    final isSelected = filterStatus == filter;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          filterStatus = filter;
          _applyFiltersAndSort();
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
                fontSize: 16,
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

  Widget _buildDevicesList() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (filteredDevices.isEmpty) {
      return EmptyStateWidget(
        icon: searchQuery.isNotEmpty ? Icons.search_off : Icons.devices_other,
        title: searchQuery.isNotEmpty ? 'لا توجد نتائج' : 'لا توجد أجهزة',
        subtitle: searchQuery.isNotEmpty
            ? 'لم يتم العثور على أجهزة تطابق البحث'
            : 'لم يتم تسجيل أي أجهزة بعد',
        buttonText: 'تحديث',
        onButtonPressed: _fetchDevices,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      itemCount: filteredDevices.length,
      itemBuilder: (context, index) {
        final device = filteredDevices[index];
        return EnhancedDeviceCard(
          deviceName: device.name,
          deviceModel: device.model,
          manufacturer: device.manufacturer,
          batteryLevel: device.batteryLevel,
          isOnline: device.isOnline,
          lastSeen: device.lastSeenText,
          appsCount: device.appsCount,
          onTap: () => _navigateToDeviceDetails(device),
          onLongPress: () => _showDeviceOptions(device),
        );
      },
    );
  }

  Color _getBatteryColor(int level) {
    if (level >= 50) return AppTheme.successColor;
    if (level >= 20) return AppTheme.warningColor;
    return AppTheme.dangerColor;
  }
}

