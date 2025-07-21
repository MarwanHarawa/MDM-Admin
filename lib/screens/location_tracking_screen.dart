import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/device_model.dart';
import '../widgets/custom_widgets.dart';
import '../theme/app_theme.dart';
import '../notifications/notifications_helper.dart';

class LocationTrackingScreen extends StatefulWidget {
  const LocationTrackingScreen({super.key});

  @override
  State<LocationTrackingScreen> createState() => _LocationTrackingScreenState();
}

class _LocationTrackingScreenState extends State<LocationTrackingScreen>
    with TickerProviderStateMixin {
  List<DeviceModel> devices = [];
  List<DeviceModel> devicesWithLocation = [];
  bool isLoading = false;
  bool isUpdatingLocation = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  String selectedView = 'list'; // list, map

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

      final fetchedDevices = querySnapshot.docs
          .map((doc) => DeviceModel.fromFirestore(doc))
          .toList();

      setState(() {
        devices = fetchedDevices;
        devicesWithLocation = fetchedDevices
            .where((device) => device.hasLocation)
            .toList();
      });
    } catch (e) {
      _showErrorSnackBar('فشل في تحميل الأجهزة');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _updateLocationForDevice(DeviceModel device) async {
    setState(() => isUpdatingLocation = true);

    try {
      await NotificationService.sendNotification(
        deviceToken: device.token,
        // title: "تحديث الموقع",
        // body: "جاري تحديث موقع الجهاز...",
        data: {"command": "update_location"},
        // includeNotification: false,
      );

      _showSuccessSnackBar('تم إرسال أمر تحديث الموقع لـ ${device.name}');
      
      // تحديث البيانات بعد فترة
      Future.delayed(const Duration(seconds: 5), _fetchDevices);
    } catch (e) {
      _showErrorSnackBar('فشل في إرسال أمر التحديث');
    } finally {
      setState(() => isUpdatingLocation = false);
    }
  }

  Future<void> _updateLocationForAllDevices() async {
    final confirmed = await _showConfirmationDialog(
      title: 'تحديث موقع جميع الأجهزة',
      content: 'هل تريد إرسال أمر تحديث الموقع لجميع الأجهزة المتصلة؟',
    );

    if (!confirmed) return;

    setState(() => isUpdatingLocation = true);

    try {
      final onlineDevices = devices.where((device) => device.isOnline).toList();
      
      for (final device in onlineDevices) {
        await NotificationService.sendNotification(
          deviceToken: device.token,
          // title: "تحديث الموقع",
          // body: "جاري تحديث موقع الجهاز...",
          data: {"command": "update_location"},
          // includeNotification: false,
        );
      }

      _showSuccessSnackBar('تم إرسال أمر تحديث الموقع لـ ${onlineDevices.length} جهاز');
      
      // تحديث البيانات بعد فترة
      Future.delayed(const Duration(seconds: 5), _fetchDevices);
    } catch (e) {
      _showErrorSnackBar('فشل في إرسال أوامر التحديث');
    } finally {
      setState(() => isUpdatingLocation = false);
    }
  }

  Future<bool> _showConfirmationDialog({
    required String title,
    required String content,
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
              backgroundColor: AppTheme.primaryColor,
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
        title: const Text('تتبع المواقع'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchDevices,
          ),
          IconButton(
            icon: Icon(selectedView == 'list' ? Icons.map : Icons.list),
            onPressed: () {
              setState(() {
                selectedView = selectedView == 'list' ? 'map' : 'list';
              });
            },
            tooltip: selectedView == 'list' ? 'عرض الخريطة' : 'عرض القائمة',
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            _buildLocationStats(),
            _buildViewToggle(),
            Expanded(
              child: selectedView == 'list'
                  ? _buildDevicesList()
                  : _buildMapView(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: isUpdatingLocation ? null : _updateLocationForAllDevices,
        icon: isUpdatingLocation
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : const Icon(Icons.location_on),
        label: const Text('تحديث الكل'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: AppTheme.textOnPrimary,
      ),
    );
  }

  Widget _buildLocationStats() {
    final onlineDevices = devices.where((d) => d.isOnline).length;
    final devicesWithLocationCount = devicesWithLocation.length;
    final devicesWithoutLocation = devices.length - devicesWithLocationCount;

    return Container(
      margin: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              icon: Icons.devices,
              title: 'إجمالي الأجهزة',
              value: '${devices.length}',
              subtitle: '$onlineDevices متصل',
              color: AppTheme.accentColor,
            ),
          ),
          const SizedBox(width: AppConstants.paddingSmall),
          Expanded(
            child: _buildStatCard(
              icon: Icons.location_on,
              title: 'مع الموقع',
              value: '$devicesWithLocationCount',
              subtitle: 'جهاز محدد الموقع',
              color: AppTheme.successColor,
            ),
          ),
          const SizedBox(width: AppConstants.paddingSmall),
          Expanded(
            child: _buildStatCard(
              icon: Icons.location_off,
              title: 'بدون موقع',
              value: '$devicesWithoutLocation',
              subtitle: 'جهاز غير محدد',
              color: AppTheme.dangerColor,
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
          Icon(icon, color: color, size: 28),
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
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildViewToggle() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
      child: Row(
        children: [
          Expanded(
            child: _buildToggleButton(
              'list',
              'قائمة الأجهزة',
              Icons.list,
              selectedView == 'list',
            ),
          ),
          const SizedBox(width: AppConstants.paddingSmall),
          Expanded(
            child: _buildToggleButton(
              'map',
              'عرض الخريطة',
              Icons.map,
              selectedView == 'map',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String value, String label, IconData icon, bool isSelected) {
    return GestureDetector(
      onTap: () => setState(() => selectedView = value),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.textOnPrimary : AppTheme.textSecondary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppTheme.textOnPrimary : AppTheme.textSecondary,
                fontWeight: FontWeight.w600,
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

    if (devices.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.devices_other,
        title: 'لا توجد أجهزة',
        subtitle: 'لم يتم تسجيل أي أجهزة بعد',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      itemCount: devices.length,
      itemBuilder: (context, index) {
        final device = devices[index];
        return _buildLocationCard(device);
      },
    );
  }

  Widget _buildLocationCard(DeviceModel device) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingSmall),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        boxShadow: AppTheme.cardShadow,
        border: Border.all(
          color: device.hasLocation
              ? AppTheme.successColor.withOpacity(0.3)
              : AppTheme.dangerColor.withOpacity(0.3),
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
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: device.hasLocation
                        ? AppTheme.successColor.withOpacity(0.2)
                        : AppTheme.dangerColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                  ),
                  child: Icon(
                    device.hasLocation ? Icons.location_on : Icons.location_off,
                    color: device.hasLocation ? AppTheme.successColor : AppTheme.dangerColor,
                  ),
                ),
                const SizedBox(width: AppConstants.paddingMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        device.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${device.manufacturer} • ${device.model}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: device.isOnline
                        ? AppTheme.successColor.withOpacity(0.1)
                        : AppTheme.textSecondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    device.isOnline ? 'متصل' : 'غير متصل',
                    style: TextStyle(
                      color: device.isOnline ? AppTheme.successColor : AppTheme.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppConstants.paddingMedium),
            
            // معلومات الموقع
            if (device.hasLocation) ...[
              Container(
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                decoration: BoxDecoration(
                  color: AppTheme.successColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                  border: Border.all(
                    color: AppTheme.successColor.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.gps_fixed, color: AppTheme.successColor, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          'الإحداثيات',
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: AppTheme.successColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${device.latitude!.toStringAsFixed(6)}, ${device.longitude!.toStringAsFixed(6)}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    if (device.address != null && device.address!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.location_city, color: AppTheme.successColor, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            'العنوان',
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: AppTheme.successColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        device.address!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.paddingMedium),
              
              // خريطة مصغرة (محاكاة)
              Container(
                height: 120,
                decoration: BoxDecoration(
                  color: AppTheme.accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                  border: Border.all(color: AppTheme.accentColor.withOpacity(0.3)),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.map, size: 40, color: AppTheme.accentColor),
                      SizedBox(height: 8),
                      Text(
                        'عرض الموقع على الخريطة',
                        style: TextStyle(color: AppTheme.accentColor),
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                decoration: BoxDecoration(
                  color: AppTheme.dangerColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                  border: Border.all(
                    color: AppTheme.dangerColor.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_off, color: AppTheme.dangerColor),
                    const SizedBox(width: AppConstants.paddingMedium),
                    const Expanded(
                      child: Text(
                        'الموقع غير متوفر',
                        style: TextStyle(
                          color: AppTheme.dangerColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            
            const SizedBox(height: AppConstants.paddingMedium),
            
            // زر تحديث الموقع
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: device.isOnline && !isUpdatingLocation
                    ? () => _updateLocationForDevice(device)
                    : null,
                icon: isUpdatingLocation
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.my_location, size: 18),
                label: const Text('تحديث الموقع'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: device.hasLocation ? AppTheme.accentColor : AppTheme.primaryColor,
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
      ),
    );
  }

  Widget _buildMapView() {
    return Container(
      margin: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          // رأس الخريطة
          Container(
            padding: const EdgeInsets.all(AppConstants.paddingLarge),
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppConstants.radiusLarge),
                topRight: Radius.circular(AppConstants.radiusLarge),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.map, color: AppTheme.textOnPrimary),
                const SizedBox(width: AppConstants.paddingSmall),
                Text(
                  'خريطة المواقع',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.textOnPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  '${devicesWithLocation.length} جهاز',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textOnPrimary.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          
          // منطقة الخريطة (محاكاة)
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.accentColor.withOpacity(0.05),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(AppConstants.radiusLarge),
                  bottomRight: Radius.circular(AppConstants.radiusLarge),
                ),
              ),
              child: devicesWithLocation.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.location_off, size: 80, color: AppTheme.textSecondary),
                          SizedBox(height: 16),
                          Text(
                            'لا توجد أجهزة محددة الموقع',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'قم بتحديث مواقع الأجهزة لعرضها على الخريطة',
                            style: TextStyle(color: AppTheme.textSecondary),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : Stack(
                      children: [
                        // خلفية الخريطة
                        Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                AppTheme.accentColor.withOpacity(0.1),
                                AppTheme.primaryColor.withOpacity(0.05),
                              ],
                            ),
                          ),
                        ),
                        
                        // نقاط الأجهزة
                        ...devicesWithLocation.asMap().entries.map((entry) {
                          final index = entry.key;
                          final device = entry.value;
                          
                          // توزيع الأجهزة بشكل عشوائي على الخريطة
                          final left = 50.0 + (index % 3) * 100.0;
                          final top = 50.0 + (index ~/ 3) * 80.0;
                          
                          return Positioned(
                            left: left,
                            top: top,
                            child: GestureDetector(
                              onTap: () {
                                // TODO: Show device details popup
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: device.isOnline ? AppTheme.successColor : AppTheme.dangerColor,
                                  shape: BoxShape.circle,
                                  boxShadow: AppTheme.elevatedShadow,
                                ),
                                child: const Icon(
                                  Icons.smartphone,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        
                        // مؤشر الخريطة
                        const Positioned(
                          bottom: 16,
                          right: 16,
                          child: Icon(
                            Icons.map,
                            size: 60,
                            color: AppTheme.accentColor,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

