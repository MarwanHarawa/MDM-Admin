import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mdm/notifications/notifications_helper.dart';

class DeviceModel {
  final String name;
  final String token;

  DeviceModel({required this.name, required this.token});
}

class EnhancedSendCommandScreen extends StatefulWidget {
  const EnhancedSendCommandScreen({Key? key}) : super(key: key);

  @override
  State<EnhancedSendCommandScreen> createState() => _EnhancedSendCommandScreenState();
}

class _EnhancedSendCommandScreenState extends State<EnhancedSendCommandScreen>
    with TickerProviderStateMixin {
  List<DeviceModel> devices = [];
  DeviceModel? selectedDevice;
  bool isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // تعريف نظام الألوان
  static const Color primaryColor = Color(0xFF2C3E50);
  static const Color accentColor = Color(0xFF3498DB);
  static const Color successColor = Color(0xFF2ECC71);
  static const Color dangerColor = Color(0xFFE74C3C);
  static const Color lightGray = Color(0xFFECF0F1);
  static const Color darkText = Color(0xFF333333);

  @override
  void initState() {
    super.initState();
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
    
    fetchDevices();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> fetchDevices() async {
    setState(() => isLoading = true);
    
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
    } catch (e) {
      print('Error getting devices: $e');
      _showSnackBar('فشل تحميل الأجهزة', isError: true);
    } finally {
      setState(() => isLoading = false);
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

  Future<void> sendCommand({required String command, required bool toAll}) async {
    if (isLoading) return;
    
    // تأكيد للأوامر الخطيرة
    if (toAll) {
      bool? confirmed = await _showConfirmationDialog(
        'تأكيد الإرسال',
        'هل أنت متأكد من إرسال الأمر "$command" إلى جميع الأجهزة؟',
      );
      if (confirmed != true) return;
    }

    setState(() => isLoading = true);

    try {
      if (!await _checkInternet()) {
        throw Exception('لا يوجد اتصال بالإنترنت');
      }

      if (toAll) {
        for (var device in devices) {
          await NotificationService.sendNotification(
            deviceToken: device.token,
            // title: "أمر من المسؤول",
            // body: "📱 تم تنفيذ أمر: $command",
            data: {"command": command},
            // includeNotification: false, 
          );
        }
        _showSnackBar('تم إرسال الأمر إلى جميع الأجهزة بنجاح', isSuccess: true);
      } else {
        if (selectedDevice == null) {
          throw Exception('يرجى اختيار جهاز أولاً');
        }
        await NotificationService.sendNotification(
          deviceToken: selectedDevice!.token,
          // title: "أمر من المسؤول",
          // body: "📱 تم تنفيذ أمر: $command",
          data: {"command": command},
          //  includeNotification: false,
        );
        _showSnackBar('تم إرسال الأمر إلى الجهاز المحدد بنجاح', isSuccess: true);
      }
    } catch (e) {
      _showSnackBar('حدث خطأ: ${e.toString()}', isError: true);
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<bool?> _showConfirmationDialog(String title, String content) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: darkText,
            ),
          ),
          content: Text(
            content,
            style: const TextStyle(color: darkText),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(
                'إلغاء',
                style: TextStyle(color: darkText),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: dangerColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'تأكيد',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSnackBar(String message, {bool isError = false, bool isSuccess = false}) {
    Color backgroundColor = lightGray;
    Color textColor = darkText;
    IconData icon = Icons.info;

    if (isError) {
      backgroundColor = dangerColor;
      textColor = Colors.white;
      icon = Icons.error;
    } else if (isSuccess) {
      backgroundColor = successColor;
      textColor = Colors.white;
      icon = Icons.check_circle;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: textColor),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Widget _buildDeviceDropdown() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: DropdownButton<DeviceModel>(
          isExpanded: true,
          value: selectedDevice,
          hint: Row(
            children: const [
              Icon(Icons.devices, color: accentColor),
              SizedBox(width: 8),
              Text(
                "اختر جهاز",
                style: TextStyle(
                  color: darkText,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          underline: const SizedBox(),
          items: devices.map((device) {
            return DropdownMenuItem<DeviceModel>(
              value: device,
              child: Row(
                children: [
                  const Icon(Icons.smartphone, color: accentColor, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    device.name,
                    style: const TextStyle(
                      color: darkText,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedDevice = value;
            });
          },
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required String command,
    required IconData icon,
    bool toAll = false,
  }) {
    Color buttonColor = toAll ? dangerColor : accentColor;
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : () => sendCommand(command: command, toAll: toAll),
        icon: Icon(icon, size: 20),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          backgroundColor: buttonColor,
          foregroundColor: Colors.white,
          disabledBackgroundColor: lightGray,
          disabledForegroundColor: darkText.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      color: Colors.black.withOpacity(0.3),
      child: const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                ),
                SizedBox(height: 16),
                Text(
                  'جاري الإرسال...',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: darkText,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.devices_other,
            size: 80,
            color: lightGray,
          ),
          const SizedBox(height: 16),
          const Text(
            "لا توجد أجهزة متاحة",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: darkText,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "تأكد من إضافة الأجهزة إلى النظام",
            style: TextStyle(
              fontSize: 14,
              color: darkText,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: fetchDevices,
            icon: const Icon(Icons.refresh),
            label: const Text('إعادة تحميل'),
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGray,
      appBar: AppBar(
        title: const Text(
          'إدارة الأجهزة',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          if (devices.isEmpty && !isLoading)
            _buildEmptyState()
          else
            FadeTransition(
              opacity: _fadeAnimation,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // قسم اختيار الجهاز
                    const Text(
                      'اختيار الجهاز',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: darkText,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildDeviceDropdown(),
                    
                    const SizedBox(height: 24),
                    
                    // قسم الأوامر الفردية
                    const Text(
                      'أوامر الجهاز المحدد',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: darkText,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    _buildActionButton(
                      label: "🔒 قفل الجهاز",
                      command: "lock",
                      icon: Icons.lock,
                    ),
                    _buildActionButton(
                      label: "📷 تعطيل الكاميرا",
                      command: "disable_camera",
                      icon: Icons.camera_alt_outlined,
                    ),
                                        _buildActionButton(
                      label: "📷 تفعيل الكاميرا",
                      command: "enable_camera",
                      icon: Icons.camera_alt_outlined,
                    ),
                                        _buildActionButton(
                      label: "تعطيل متجر بلاي",
                      command: "disable_playstore",
                      icon: Icons.camera_alt_outlined,
                    ),
                                        _buildActionButton(
                      label: "تفعيل متجر بلاي",
                      command: "enable_playstore",
                      icon: Icons.camera_alt_outlined,
                    ),
                    // _buildActionButton(
                    //   label: "🔓 فتح القفل",
                    //   command: "unlock",
                    //   icon: Icons.lock_open,
                    // ),
                    _buildActionButton(
                      label: "🔁 إعادة تشغيل",
                      command: "reboot_device",
                      icon: Icons.restart_alt,
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // فاصل بصري
                    const Divider(
                      thickness: 2,
                      color: primaryColor,
                      indent: 20,
                      endIndent: 20,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // قسم الأوامر الجماعية
                    const Text(
                      'أوامر جماعية (جميع الأجهزة)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: dangerColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    _buildActionButton(
                      label: "🚨 قفل جميع الأجهزة",
                      command: "lock",
                      icon: Icons.security,
                      toAll: true,
                    ),
                    
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          
          // مؤشر التحميل
          if (isLoading) _buildLoadingIndicator(),
        ],
      ),
    );
  }
}

