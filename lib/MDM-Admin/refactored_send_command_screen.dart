import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mdm/notifications/notifications_helper.dart';
import 'app_theme.dart';
import 'custom_widgets.dart';

class DeviceModel {
  final String name;
  final String token;

  DeviceModel({required this.name, required this.token});
}

class RefactoredSendCommandScreen extends StatefulWidget {
  const RefactoredSendCommandScreen({Key? key}) : super(key: key);

  @override
  State<RefactoredSendCommandScreen> createState() => _RefactoredSendCommandScreenState();
}

class _RefactoredSendCommandScreenState extends State<RefactoredSendCommandScreen>
    with TickerProviderStateMixin {
  List<DeviceModel> devices = [];
  DeviceModel? selectedDevice;
  bool isLoading = false;
  bool isInitialLoading = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _fetchDevices();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
      curve: Curves.easeInOut,
    ));
  }

  Future<void> _fetchDevices() async {
    setState(() {
      isInitialLoading = true;
    });

    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('devices').get();
      setState(() {
        devices = querySnapshot.docs
            .map((doc) => DeviceModel(
                  name: doc['deviceName'],
                  token: doc['token'],
                ))
            .toList();
      });
      _animationController.forward();
    } catch (e) {
      print('Error getting devices: $e');
      CustomSnackBar.show(
        context,
        message: 'فشل تحميل الأجهزة',
        type: SnackBarType.error,
      );
    } finally {
      setState(() {
        isInitialLoading = false;
      });
    }
  }

  Future<bool> _checkInternet() async {
    try {
      var result = await InternetAddress.lookup("google.com");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException {
      return false;
    }
    return false;
  }

  Future<void> _sendCommand({
    required String command,
    required bool toAll,
    required String commandLabel,
  }) async {
    if (isLoading) return;

    // تأكيد للأوامر الخطيرة
    if (toAll) {
      bool? confirmed = await ConfirmationDialog.show(
        context,
        title: 'تأكيد الإرسال',
        content: 'هل أنت متأكد من إرسال الأمر "$commandLabel" إلى جميع الأجهزة؟',
        isDangerous: true,
        onConfirm: () {  },
      );
      if (confirmed != true) return;
    }

    setState(() => isLoading = true);

    try {
      if (!await _checkInternet()) {
        throw Exception('لا يوجد اتصال بالإنترنت');
      }

      if (toAll) {
        await _sendToAllDevices(command);
        CustomSnackBar.show(
          context,
          message: 'تم إرسال الأمر إلى جميع الأجهزة بنجاح',
          type: SnackBarType.success,
        );
      } else {
        await _sendToSelectedDevice(command);
        CustomSnackBar.show(
          context,
          message: 'تم إرسال الأمر إلى الجهاز المحدد بنجاح',
          type: SnackBarType.success,
        );
      }
    } catch (e) {
      print('Error sending command: $e');
      CustomSnackBar.show(
        context,
        message: 'حدث خطأ: ${e.toString()}',
        type: SnackBarType.error,
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _sendToAllDevices(String command) async {
    for (var device in devices) {
      await NotificationService.sendNotification(
        deviceToken: device.token,
        // title: "أمر من المسؤول",
        // body: "📱 تم تنفيذ أمر: $command",
        data: {"command": command},
        // includeNotification: false,
      );
    }
  }

  Future<void> _sendToSelectedDevice(String command) async {
    if (selectedDevice == null) {
      throw Exception('يرجى اختيار جهاز أولاً');
    }
    await NotificationService.sendNotification(
      deviceToken: selectedDevice!.token,
      // title: "أمر من المسؤول",
      // body: "📱 تم تنفيذ أمر: $command",
      data: {"command": command},
      // includeNotification: false,
    );
  }

  Widget _buildDeviceSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'اختيار الجهاز',
          icon: Icons.devices,
        ),
        const SizedBox(height: 12),
        CustomDropdown<DeviceModel>(
          value: selectedDevice,
          items: devices,
          hint: "اختر جهاز",
          prefixIcon: Icons.devices,
          itemBuilder: (device) => device.name,
          onChanged: (value) {
            setState(() {
              selectedDevice = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildIndividualCommands() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'أوامر الجهاز المحدد',
          icon: Icons.smartphone,
        ),
        const SizedBox(height: 12),
        ActionButton(
          label: "🔒 قفل الجهاز",
          icon: Icons.lock,
          onPressed: () => _sendCommand(
            command: "lock",
            toAll: false,
            commandLabel: "قفل الجهاز",
          ),
          isLoading: isLoading,
        ),
        ActionButton(
          label: "📷 تعطيل الكاميرا",
          icon: Icons.camera_alt_outlined,
          onPressed: () => _sendCommand(
            command: "disable_camera",
            toAll: false,
            commandLabel: "تعطيل الكاميرا",
          ),
          isLoading: isLoading,
        ),
        ActionButton(
          label: "🔓 فتح القفل",
          icon: Icons.lock_open,
          onPressed: () => _sendCommand(
            command: "unlock",
            toAll: false,
            commandLabel: "فتح القفل",
          ),
          isLoading: isLoading,
          type: ActionButtonType.success,
        ),
        ActionButton(
          label: "🔁 إعادة تشغيل",
          icon: Icons.restart_alt,
          onPressed: () => _sendCommand(
            command: "reboot",
            toAll: false,
            commandLabel: "إعادة تشغيل",
          ),
          isLoading: isLoading,
          type: ActionButtonType.secondary,
        ),
      ],
    );
  }

  Widget _buildBulkCommands() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'أوامر جماعية (جميع الأجهزة)',
          icon: Icons.security,
          color: AppTheme.dangerColor,
        ),
        const SizedBox(height: 12),
        ActionButton(
          label: "🚨 قفل جميع الأجهزة",
          icon: Icons.security,
          onPressed: () => _sendCommand(
            command: "lock",
            toAll: true,
            commandLabel: "قفل جميع الأجهزة",
          ),
          type: ActionButtonType.danger,
          isLoading: isLoading,
        ),
        ActionButton(
          label: "🔄 إعادة تشغيل جميع الأجهزة",
          icon: Icons.restart_alt,
          onPressed: () => _sendCommand(
            command: "reboot",
            toAll: true,
            commandLabel: "إعادة تشغيل جميع الأجهزة",
          ),
          type: ActionButtonType.danger,
          isLoading: isLoading,
        ),
      ],
    );
  }

  Widget _buildMainContent() {
    if (isInitialLoading) {
      return const LoadingOverlay(
        message: 'جاري تحميل الأجهزة...',
        isVisible: true,
      );
    }

    if (devices.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.devices_other,
        title: "لا توجد أجهزة متاحة",
        subtitle: "تأكد من إضافة الأجهزة إلى النظام",
        buttonText: "إعادة تحميل",
        onButtonPressed: _fetchDevices,
      );
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDeviceSelection(),
            const SizedBox(height: 24),
            _buildIndividualCommands(),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            _buildBulkCommands(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGray,
      appBar: AppBar(
        title: const Text('إدارة الأجهزة'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchDevices,
            tooltip: 'إعادة تحميل الأجهزة',
          ),
        ],
      ),
      body: Stack(
        children: [
          _buildMainContent(),
          LoadingOverlay(
            message: 'جاري الإرسال...',
            isVisible: isLoading,
          ),
        ],
      ),
    );
  }
}

