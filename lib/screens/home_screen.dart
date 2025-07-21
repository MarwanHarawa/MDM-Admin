import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/device_model.dart';
import '../widgets/custom_widgets.dart';
import '../theme/app_theme.dart';
import 'device_details_screen.dart';
import 'devices_management_screen.dart';
import 'apps_management_screen.dart';
import 'location_tracking_screen.dart';
import 'commands_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  List<DeviceModel> devices = [];
  List<DeviceModel> filteredDevices = [];
  bool isLoading = false;
  String searchQuery = '';
  late AnimationController _headerAnimationController;
  late AnimationController _listAnimationController;
  late Animation<double> _headerFadeAnimation;
  late Animation<Offset> _headerSlideAnimation;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _fetchDevices();
  }

  void _setupAnimations() {
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _listAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _headerFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _headerAnimationController,
      curve: Curves.easeOut,
    ));

    _headerSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _headerAnimationController,
      curve: Curves.elasticOut,
    ));

    _headerAnimationController.forward();
  }

  @override
  void dispose() {
    _headerAnimationController.dispose();
    _listAnimationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchDevices() async {
    setState(() => isLoading = true);

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('devices')
          .orderBy('lastSeen', descending: true)
          .get();

      final fetchedDevices = querySnapshot.docs
          .map((doc) => DeviceModel.fromFirestore(doc))
          .toList();

      setState(() {
        devices = fetchedDevices;
        filteredDevices = fetchedDevices;
      });

      _listAnimationController.forward();
    } catch (e) {
      _showErrorSnackBar('فشل في تحميل الأجهزة: ${e.toString()}');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _filterDevices(String query) {
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        filteredDevices = devices;
      } else {
        filteredDevices = devices.where((device) {
          return device.name.toLowerCase().contains(query.toLowerCase()) ||
              device.model.toLowerCase().contains(query.toLowerCase()) ||
              device.manufacturer.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
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

  void _navigateToScreen(Widget screen) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: AppConstants.animationDuration,
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
          _buildQuickStats(),
          _buildQuickActions(),
          _buildSearchBar(),
          _buildDevicesList(),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: SafeArea(
            child: SlideTransition(
              position: _headerSlideAnimation,
              child: FadeTransition(
                opacity: _headerFadeAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingLarge),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'إدارة الأجهزة',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: AppTheme.textOnPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'تحكم في جميع أجهزتك من مكان واحد',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.textOnPrimary.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh, color: AppTheme.textOnPrimary),
          onPressed: _fetchDevices,
          tooltip: 'تحديث',
        ),
        IconButton(
          icon: const Icon(Icons.settings, color: AppTheme.textOnPrimary),
          onPressed: () {
            // TODO: Navigate to settings
          },
          tooltip: 'الإعدادات',
        ),
      ],
    );
  }

  Widget _buildQuickStats() {
    final onlineDevices = devices.where((d) => d.isOnline).length;
    final totalApps = devices.fold<int>(0, (sum, device) => sum + device.appsCount);
    final averageBattery = devices.isEmpty
        ? 0
        : devices.fold<int>(0, (sum, device) => sum + device.batteryLevel) ~/
            devices.length;

    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.devices,
                title: 'الأجهزة المتصلة',
                value: '$onlineDevices/${devices.length}',
                color: AppTheme.successColor,
              ),
            ),
            const SizedBox(width: AppConstants.paddingSmall),
            Expanded(
              child: _buildStatCard(
                icon: Icons.apps,
                title: 'إجمالي التطبيقات',
                value: '$totalApps',
                color: AppTheme.accentColor,
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
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingMedium,
          vertical: AppConstants.paddingSmall,
        ),
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
                  child: _buildQuickActionCard(
                    icon: Icons.comment,
                    title: 'الأوامر',
                    subtitle: 'إرسال أوامر للأجهزة',
                    color: AppTheme.primaryColor,
                    onTap: () => _navigateToScreen(const CommandsScreen()),
                  ),
                ),
                const SizedBox(width: AppConstants.paddingSmall),
                Expanded(
                  child: _buildQuickActionCard(
                    icon: Icons.apps,
                    title: 'التطبيقات',
                    subtitle: 'إدارة التطبيقات',
                    color: AppTheme.accentColor,
                    onTap: () => _navigateToScreen(const AppsManagementScreen()),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionCard(
                    icon: Icons.location_on,
                    title: 'الموقع',
                    subtitle: 'تتبع المواقع',
                    color: AppTheme.warningColor,
                    onTap: () => _navigateToScreen(const LocationTrackingScreen()),
                  ),
                ),
                const SizedBox(width: AppConstants.paddingSmall),
                Expanded(
                  child: _buildQuickActionCard(
                    icon: Icons.settings,
                    title: 'الإدارة',
                    subtitle: 'إدارة شاملة',
                    color: AppTheme.successColor,
                    onTap: () => _navigateToScreen(const DevicesManagementScreen()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
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
            Icon(icon, color: color, size: 32),
            const SizedBox(height: AppConstants.paddingSmall),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: color.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return SliverToBoxAdapter(
      child: EnhancedSearchBar(
        hintText: 'البحث عن جهاز...',
        controller: _searchController,
        onChanged: _filterDevices,
        onClear: () => _filterDevices(''),
      ),
    );
  }

  Widget _buildDevicesList() {
    if (isLoading) {
      return const SliverFillRemaining(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (filteredDevices.isEmpty) {
      return SliverFillRemaining(
        child: EmptyStateWidget(
          icon: searchQuery.isNotEmpty ? Icons.search_off : Icons.devices_other,
          title: searchQuery.isNotEmpty ? 'لا توجد نتائج' : 'لا توجد أجهزة',
          subtitle: searchQuery.isNotEmpty
              ? 'لم يتم العثور على أجهزة تطابق البحث'
              : 'لم يتم تسجيل أي أجهزة بعد',
          buttonText: 'تحديث',
          onButtonPressed: _fetchDevices,
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final device = filteredDevices[index];
          return AnimatedBuilder(
            animation: _listAnimationController,
            builder: (context, child) {
              final animationValue = Curves.easeOut.transform(
                (_listAnimationController.value - (index * 0.1)).clamp(0.0, 1.0),
              );
              
              return Transform.translate(
                offset: Offset(0, 50 * (1 - animationValue)),
                child: Opacity(
                  opacity: animationValue,
                  child: EnhancedDeviceCard(
                    deviceName: device.name,
                    deviceModel: device.model,
                    manufacturer: device.manufacturer,
                    batteryLevel: device.batteryLevel,
                    isOnline: device.isOnline,
                    lastSeen: device.lastSeenText,
                    appsCount: device.appsCount,
                    onTap: () => _navigateToDeviceDetails(device),
                    onLongPress: () {
                      // TODO: Show device options
                    },
                  ),
                ),
              );
            },
          );
        },
        childCount: filteredDevices.length,
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: _fetchDevices,
      icon: const Icon(Icons.refresh),
      label: const Text('تحديث'),
      backgroundColor: AppTheme.primaryColor,
      foregroundColor: AppTheme.textOnPrimary,
    );
  }

  Color _getBatteryColor(int level) {
    if (level >= 50) return AppTheme.successColor;
    if (level >= 20) return AppTheme.warningColor;
    return AppTheme.dangerColor;
  }
}

