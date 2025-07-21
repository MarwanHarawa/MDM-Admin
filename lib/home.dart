
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:mdm/notifications/notifications_helper.dart';

// // 1. تعريف سمة التطبيق (الألوان، الخطوط، التصميم)
// class AppTheme {
//   // الألوان الرئيسية
//   static const Color primaryColor = Color(0xFF2C3E50); // اللون الأساسي
//   static const Color accentColor = Color(0xFF3498DB);  // اللون الثانوي
//   static const Color successColor = Color(0xFF2ECC71); // لون النجاح
//   static const Color dangerColor = Color(0xFFE74C3C);   // لون الخطأ
//   static const Color lightGray = Color(0xFFECF0F1);     // رمادي فاتح
//   static const Color darkText = Color(0xFF333333);      // نص غامق
//   static const Color lightText = Color(0xFF7F8C8D);     // نص فاتح

//   // خط التطبيق
//   static const String fontFamily = 'Roboto';

//   // سمة التطبيق الفعلية
//   static ThemeData get lightTheme {
//     return ThemeData(
//       useMaterial3: true,
//       fontFamily: fontFamily,
      
//       // نظام الألوان
//       colorScheme: const ColorScheme.light(
//         primary: primaryColor,
//         secondary: accentColor,
//         surface: Colors.white,
//         background: lightGray,
//         error: dangerColor,
//         onPrimary: Colors.white,
//         onSecondary: Colors.white,
//         onSurface: darkText,
//         onBackground: darkText,
//         onError: Colors.white,
//       ),

//       // شريط التطبيق
//       appBarTheme: const AppBarTheme(
//         backgroundColor: primaryColor,
//         foregroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         titleTextStyle: TextStyle(
//           fontSize: 20,
//           fontWeight: FontWeight.bold,
//           color: Colors.white,
//           fontFamily: fontFamily,
//         ),
//       ),

//       // الأزرار المرفوعة
//       elevatedButtonTheme: ElevatedButtonThemeData(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: accentColor,
//           foregroundColor: Colors.white,
//           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           elevation: 2,
//           textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//         ),
//       ),

//       // البطاقات
//       cardTheme: CardThemeData(
//         elevation: 2,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         color: Colors.white,
//       ),

//       // شريط التنبيهات
//       snackBarTheme: SnackBarThemeData(
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         contentTextStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//       ),

//       // مؤشر التحميل
//       progressIndicatorTheme: const ProgressIndicatorThemeData(color: accentColor),
//     );
//   }
// }

// // 2. الودجات المخصصة (Custom Widgets)
// // --------------------------------------------------

// /// ودجت لعرض حالة فارغة مع رسالة
// class EmptyStateWidget extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String subtitle;
//   final String? buttonText;
//   final VoidCallback? onButtonPressed;

//   const EmptyStateWidget({
//     super.key,
//     required this.icon,
//     required this.title,
//     required this.subtitle,
//     this.buttonText,
//     this.onButtonPressed,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(32.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, size: 80, color: AppTheme.lightText),
//             const SizedBox(height: 16),
//             Text(title, style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
//             const SizedBox(height: 8),
//             Text(subtitle, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.lightText), textAlign: TextAlign.center),
//             if (buttonText != null && onButtonPressed != null) ...[
//               const SizedBox(height: 24),
//               ElevatedButton.icon(
//                 onPressed: onButtonPressed,
//                 icon: const Icon(Icons.refresh),
//                 label: Text(buttonText!),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }

// /// مؤشر تحميل مع رسالة
// class LoadingOverlay extends StatelessWidget {
//   final String message;
//   final bool isVisible;

//   const LoadingOverlay({super.key, required this.message, required this.isVisible});

//   @override
//   Widget build(BuildContext context) {
//     if (!isVisible) return const SizedBox.shrink();

//     return Container(
//       color: Colors.black.withOpacity(0.3),
//       child: Center(
//         child: Card(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//           child: Padding(
//             padding: const EdgeInsets.all(24.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const CircularProgressIndicator(),
//                 const SizedBox(height: 16),
//                 Text(message, style: Theme.of(context).textTheme.titleMedium),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// /// عرض رسالة تنبيه محسنة
// class CustomSnackBar {
//   static void show(
//     BuildContext context, {
//     required String message,
//     SnackBarType type = SnackBarType.info,
//     Duration duration = const Duration(seconds: 3),
//   }) {
//     // تحديد الألوان بناءً على النوع
//     Color backgroundColor;
//     Color textColor;
//     IconData icon;

//     switch (type) {
//       case SnackBarType.success:
//         backgroundColor = AppTheme.successColor;
//         textColor = Colors.white;
//         icon = Icons.check_circle;
//         break;
//       case SnackBarType.error:
//         backgroundColor = AppTheme.dangerColor;
//         textColor = Colors.white;
//         icon = Icons.error;
//         break;
//       case SnackBarType.warning:
//         backgroundColor = const Color(0xFFF39C12);
//         textColor = Colors.white;
//         icon = Icons.warning;
//         break;
//       default:
//         backgroundColor = AppTheme.accentColor;
//         textColor = Colors.white;
//         icon = Icons.info;
//     }

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(children: [
//           Icon(icon, color: textColor),
//           const SizedBox(width: 8),
//           Expanded(child: Text(message, style: TextStyle(color: textColor, fontWeight: FontWeight.w500))),
//         ]),
//         backgroundColor: backgroundColor,
//         duration: duration,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         margin: const EdgeInsets.all(16),
//       ),
//     );
//   }
// }

// enum SnackBarType { success, error, warning, info }

// /// زر إجراء مخصص
// class ActionButton extends StatelessWidget {
//   final String label;
//   final IconData icon;
//   final VoidCallback? onPressed;
//   final ActionButtonType type;
//   final bool isLoading;

//   const ActionButton({
//     super.key,
//     required this.label,
//     required this.icon,
//     this.onPressed,
//     this.type = ActionButtonType.primary,
//     this.isLoading = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     // تحديد لون الزر حسب النوع
//     Color backgroundColor = switch (type) {
//       ActionButtonType.primary => AppTheme.accentColor,
//       ActionButtonType.danger => AppTheme.dangerColor,
//       ActionButtonType.success => AppTheme.successColor,
//       ActionButtonType.secondary => AppTheme.lightText,
//     };

//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 6.0),
//       width: double.infinity,
//       child: ElevatedButton.icon(
//         onPressed: isLoading ? null : onPressed,
//         icon: isLoading
//             ? const SizedBox(
//                 width: 20,
//                 height: 20,
//                 child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
//               )
//             : Icon(icon, size: 20),
//         label: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
//         style: ElevatedButton.styleFrom(
//           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//           backgroundColor: backgroundColor,
//           foregroundColor: Colors.white,
//           disabledBackgroundColor: AppTheme.lightGray,
//           disabledForegroundColor: AppTheme.darkText.withOpacity(0.5),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           elevation: 2,
//         ),
//       ),
//     );
//   }
// }

// enum ActionButtonType { primary, danger, success, secondary }

// /// قائمة منسدلة مخصصة
// class CustomDropdown<T> extends StatelessWidget {
//   final T? value;
//   final List<T> items;
//   final String hint;
//   final IconData prefixIcon;
//   final String Function(T) itemBuilder;
//   final void Function(T?) onChanged;

//   const CustomDropdown({
//     super.key,
//     required this.value,
//     required this.items,
//     required this.hint,
//     required this.prefixIcon,
//     required this.itemBuilder,
//     required this.onChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//           color: Colors.white,
//         ),
//         child: DropdownButton<T>(
//           isExpanded: true,
//           value: value,
//           hint: Row(children: [
//             Icon(prefixIcon, color: AppTheme.accentColor),
//             const SizedBox(width: 8),
//             Text(hint, style: const TextStyle(color: AppTheme.darkText, fontSize: 16, fontWeight: FontWeight.w500)),
//           ]),
//           underline: const SizedBox(),
//           items: items.map((item) => DropdownMenuItem<T>(
//             value: item,
//             child: Row(children: [
//               const Icon(Icons.smartphone, color: AppTheme.accentColor, size: 20),
//               const SizedBox(width: 8),
//               Text(itemBuilder(item), style: const TextStyle(color: AppTheme.darkText, fontSize: 16)),
//             ]),
//           )).toList(),
//           onChanged: onChanged,
//         ),
//       ),
//     );
//   }
// }

// /// عنوان لقسم في الواجهة
// class SectionHeader extends StatelessWidget {
//   final String title;
//   final Color? color;
//   final IconData? icon;

//   const SectionHeader({super.key, required this.title, this.color, this.icon});

//   @override
//   Widget build(BuildContext context) {
//     return Row(children: [
//       if (icon != null) ...[
//         Icon(icon, color: color ?? AppTheme.darkText, size: 20),
//         const SizedBox(width: 8),
//       ],
//       Text(title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: color ?? AppTheme.darkText)),
//     ]);
//   }
// }

// /// حوار تأكيد
// class ConfirmationDialog extends StatelessWidget {
//   final String title;
//   final String content;
//   final String confirmText;
//   final String cancelText;
//   final VoidCallback onConfirm;
//   final VoidCallback? onCancel;
//   final bool isDangerous;

//   const ConfirmationDialog({
//     super.key,
//     required this.title,
//     required this.content,
//     required this.onConfirm,
//     this.confirmText = 'تأكيد',
//     this.cancelText = 'إلغاء',
//     this.onCancel,
//     this.isDangerous = false,
//   });

//   static Future<bool?> show(
//     BuildContext context, {
//     required String title,
//     required String content,
//     required VoidCallback onConfirm,
//     String confirmText = 'تأكيد',
//     String cancelText = 'إلغاء',
//     VoidCallback? onCancel,
//     bool isDangerous = false,
//   }) {
//     return showDialog<bool>(
//       context: context,
//       builder: (context) => ConfirmationDialog(
//         title: title,
//         content: content,
//         onConfirm: onConfirm,
//         confirmText: confirmText,
//         cancelText: cancelText,
//         onCancel: onCancel,
//         isDangerous: isDangerous,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       title: Text(title, style: Theme.of(context).textTheme.titleLarge),
//       content: Text(content, style: Theme.of(context).textTheme.bodyLarge),
//       actions: [
//         TextButton(
//           onPressed: () {
//             Navigator.of(context).pop(false);
//             onCancel?.call();
//           },
//           child: Text(cancelText),
//         ),
//         ElevatedButton(
//           onPressed: () {
//             Navigator.of(context).pop(true);
//             onConfirm();
//           },
//           style: ElevatedButton.styleFrom(
//             backgroundColor: isDangerous ? AppTheme.dangerColor : AppTheme.accentColor,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//           ),
//           child: Text(confirmText, style: const TextStyle(color: Colors.white)),
//         ),
//       ],
//     );
//   }
// }

// /// بطاقة عرض الموقع
// class LocationMapCard extends StatelessWidget {
//   final double latitude;
//   final double longitude;
//   final String address;

//   const LocationMapCard({super.key, required this.latitude, required this.longitude, required this.address});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SectionHeader(title: 'الموقع الحالي', icon: Icons.location_on, color: AppTheme.accentColor),
//             const SizedBox(height: 16),
//             Container(
//               height: 180,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12),
//                 color: AppTheme.lightGray,
//               ),
//               alignment: Alignment.center,
//               child: const Icon(Icons.map, size: 80, color: AppTheme.lightText),
//             ),
//             const SizedBox(height: 16),
//             Row(children: [
//               const Icon(Icons.gps_fixed, color: AppTheme.accentColor, size: 20),
//               const SizedBox(width: 8),
//               Expanded(child: Text('الإحداثيات: $latitude, $longitude', style: const TextStyle(fontSize: 14, color: AppTheme.darkText))),
//             ]),
//             const SizedBox(height: 8),
//             Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               const Icon(Icons.location_city, color: AppTheme.accentColor, size: 20),
//               const SizedBox(width: 8),
//               Expanded(child: Text('العنوان: $address', style: const TextStyle(fontSize: 14, color: AppTheme.darkText))),
//             ]),
//           ],
//         ),
//       ),
//     );
//   }
// }

// /// بطاقة عرض معلومات التطبيق
// class AppInfoCard extends StatelessWidget {
//   final String appName;
//   final String packageName;
//   final String version;
//   final String installDate;
//   final VoidCallback onUninstall;

//   const AppInfoCard({
//     super.key,
//     required this.appName,
//     required this.packageName,
//     required this.version,
//     required this.installDate,
//     required this.onUninstall,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 2,
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(children: [
//               Container(
//                 width: 50,
//                 height: 50,
//                 decoration: BoxDecoration(
//                   color: AppTheme.accentColor.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: const Icon(Icons.apps, color: AppTheme.accentColor),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                   Text(appName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.darkText)),
//                   const SizedBox(height: 4),
//                   Text(packageName, style: const TextStyle(fontSize: 14, color: AppTheme.lightText)),
//                 ]),
//               ),
//             ]),
//             const SizedBox(height: 16),
//             Row(children: [
//               const Icon(Icons.info_outline, size: 16, color: AppTheme.lightText),
//               const SizedBox(width: 8),
//               Text('الإصدار: $version', style: const TextStyle(fontSize: 14, color: AppTheme.darkText)),
//               const SizedBox(width: 16),
//               const Icon(Icons.calendar_today, size: 16, color: AppTheme.lightText),
//               const SizedBox(width: 8),
//               Text('التثبيت: $installDate', style: const TextStyle(fontSize: 14, color: AppTheme.darkText)),
//             ]),
//             const SizedBox(height: 16),
//             Row(children: [
//               Expanded(
//                 child: OutlinedButton.icon(
//                   onPressed: onUninstall, // إلغاء تثبيت التطبيق
//                   icon: const Icon(Icons.delete, size: 18),
//                   label: const Text('إلغاء التثبيت'),
//                   style: OutlinedButton.styleFrom(
//                     foregroundColor: AppTheme.dangerColor,
//                     side: const BorderSide(color: AppTheme.dangerColor),
//                     padding: const EdgeInsets.symmetric(vertical: 12),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: ElevatedButton.icon(
//                   onPressed: () {}, // تحديث التطبيق (يمكن إضافة منطق هنا لاحقًا)
//                   icon: const Icon(Icons.refresh, size: 18),
//                   label: const Text('تحديث'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppTheme.accentColor,
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(vertical: 12),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                   ),
//                 ),
//               ),
//             ]),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // 3. شاشة إدارة الأجهزة الرئيسية
// // --------------------------------------------------

// /// نموذج بيانات الجهاز
// class DeviceModel {
//   final String id;
//   final String name;
//   final String model;
//   final String osVersion;
//   final int batteryLevel;
//   final String token;
//   final bool isOnline;
//   final double? latitude;
//   final double? longitude;
//   final String? address;
//   final String manufacturer;
//   final int sdkVersion;
//   final List<dynamic>? installedApps;

//   DeviceModel({
//     required this.id,
//     required this.name,
//     required this.model,
//     required this.osVersion,
//     required this.batteryLevel,
//     required this.token,
//     required this.isOnline,
//     this.latitude,
//     this.longitude,
//     this.address,
//     required this.manufacturer,
//     required this.sdkVersion,
//     this.installedApps,
//   });

//   /// إنشاء نموذج من مستند Firestore
//   factory DeviceModel.fromFirestore(DocumentSnapshot doc) {
//     Map data = doc.data() as Map;
//     return DeviceModel(
//       id: doc.id,
//       name: data['deviceName'] ?? 'غير معروف',
//       model: data['model'] ?? 'غير معروف',
//       osVersion: data['osVersion'] ?? 'غير معروف',
//       batteryLevel: data['batteryLevel'] ?? 0,
//       token: data['token'] ?? '',
//       isOnline: data['isOnline'] ?? false,
//       latitude: (data['location'] as GeoPoint?)?.latitude,
//       longitude: (data['location'] as GeoPoint?)?.longitude,
//       address: data['address'] ?? 'لم يتم تحديد الموقع',
//       manufacturer: data['manufacturer'] ?? 'غير معروف',
//       sdkVersion: data['sdkVersion'] ?? 0,
//       installedApps: data['installedApps'] ?? [],
//     );
//   }
// }

// /// نموذج بيانات التطبيق
// class AppModel {
//   final String id;
//   final String name;
//   final String packageName;
//   final String version;
//   final String installDate;

//   AppModel({
//     required this.id,
//     required this.name,
//     required this.packageName,
//     required this.version,
//     required this.installDate,
//   });
// }

// /// الشاشة الرئيسية لإدارة الأجهزة
// class EnhancedDeviceManagementScreen extends StatefulWidget {
//   const EnhancedDeviceManagementScreen({super.key});

//   @override
//   State<EnhancedDeviceManagementScreen> createState() => _EnhancedDeviceManagementScreenState();
// }

// class _EnhancedDeviceManagementScreenState extends State<EnhancedDeviceManagementScreen> with TickerProviderStateMixin {
//   List<DeviceModel> devices = [];
//   List<AppModel> installedApps = [];
//   DeviceModel? selectedDevice;
//   bool isLoading = false;
//   bool isLocationLoading = false;
//   bool isAppsLoading = false;
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//   final TextEditingController _searchController = TextEditingController();
//   String _searchQuery = '';

//   @override
//   void initState() {
//     super.initState();
//     // تهيئة الرسوم المتحركة
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );
    
//     // جلب الأجهزة من Firestore
//     fetchDevices();
//     _animationController.forward();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     _searchController.dispose();
//     super.dispose();
//   }

//   /// جلب قائمة الأجهزة من Firestore
//   Future<void> fetchDevices() async {
//     setState(() => isLoading = true);
    
//     try {
//       final querySnapshot = await FirebaseFirestore.instance.collection('devices').get();
//       setState(() {
//         devices = querySnapshot.docs.map((doc) => DeviceModel.fromFirestore(doc)).toList();
//       });
//     } catch (e) {
//       print('Error getting devices: $e');
//       CustomSnackBar.show(context, message: 'فشل تحميل الأجهزة', type: SnackBarType.error);
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }

//   /// جلب التطبيقات المثبتة على الجهاز المحدد
//   Future<void> fetchInstalledApps(String deviceId) async {
//     if (selectedDevice == null) return;
    
//     setState(() => isAppsLoading = true);
    
//     try {
//       final doc = await FirebaseFirestore.instance.collection('devices').doc(deviceId).get();
//       if (doc.exists) {
//         setState(() {
//           installedApps = (doc.data()?['installedApps'] as List<dynamic>?)
//               ?.map((app) => AppModel(
//                     id: app['packageName'] ?? '',
//                     name: app['appName'] ?? 'غير معروف',
//                     packageName: app['packageName'] ?? '',
//                     version: app['version'] ?? '',
//                     installDate: app['installDate'] ?? '',
//                   ))
//               .toList() ?? [];
//         });
//       }
//     } catch (e) {
//       print('Error fetching apps: $e');
//       CustomSnackBar.show(context, message: 'فشل تحميل التطبيقات', type: SnackBarType.error);
//     } finally {
//       setState(() => isAppsLoading = false);
//     }
//   }

//   /// التحقق من اتصال الإنترنت
//   Future<bool> _checkInternet() async {
//     try {
//       final result = await InternetAddress.lookup('google.com');
//       return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
//     } on SocketException {
//       return false;
//     }
//   }

//   /// إرسال أمر إلى الجهاز/الأجهزة
//   Future<void> sendCommand({required String command, required bool toAll, String? packageName}) async {
//     if (isLoading) return;
    
//     // تأكيد للأوامر الخطيرة
//     if (toAll || command == "uninstall_app") {
//       bool? confirmed = await ConfirmationDialog.show(
//         context,
//         title: 'تأكيد الإرسال',
//         content: 'هل أنت متأكد من إرسال الأمر "$command" ${packageName != null ? 'للتطبيق $packageName' : ''} ${toAll ? 'إلى جميع الأجهزة' : ''}؟',
//         confirmText: 'نعم',
//         cancelText: 'إلغاء',
//         isDangerous: true,
//         onConfirm: () {},
//       );
//       if (confirmed != true) return;
//     }

//     setState(() => isLoading = true);

//     try {
//       if (!await _checkInternet()) throw Exception('لا يوجد اتصال بالإنترنت');

//       if (toAll) {
//         for (var device in devices) {
//           await NotificationService.sendNotification(
//             deviceToken: device.token,
//             title: "أمر من المسؤول",
//             body: "📱 تم تنفيذ أمر: $command",
//             data: {"command": command},
//             includeNotification: false,
//           );
//         }
//         CustomSnackBar.show(context, message: 'تم إرسال الأمر إلى جميع الأجهزة بنجاح', type: SnackBarType.success);
//       } else {
//         if (selectedDevice == null) {
//           throw Exception('يرجى اختيار جهاز أولاً');
//         }
//         await NotificationService.sendNotification(
//           deviceToken: selectedDevice!.token,
//           title: "أمر من المسؤول",
//           body: "📱 تم تنفيذ أمر: $command",
//           data: {"command": command, if (packageName != null) "package_name": packageName},
//           includeNotification: false,
//         );
//         CustomSnackBar.show(context, message: 'تم إرسال الأمر إلى الجهاز المحدد بنجاح', type: SnackBarType.success);
//       }
//     } catch (e) {
//       CustomSnackBar.show(context, message: 'حدث خطأ: ${e.toString()}', type: SnackBarType.error);
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }

//   /// تثبيت تطبيق جديد على الجهاز
//   Future<void> installApp() async {
//     if (selectedDevice == null) {
//       CustomSnackBar.show(context, message: 'يرجى اختيار جهاز أولاً', type: SnackBarType.warning);
//       return;
//     }

//     // هنا يمكن إضافة منطق لاختيار التطبيق المراد تثبيته (مثلاً من قائمة أو تحميل APK)
//     // حالياً، سنرسل أمرًا عامًا للتثبيت
//     await sendCommand(command: "install_app", toAll: false, packageName: "com.example.newapp"); // مثال لاسم حزمة
    
//     // بعد إرسال الأمر، يمكن تحديث قائمة التطبيقات بعد فترة
//     Future.delayed(const Duration(seconds: 5), () => fetchInstalledApps(selectedDevice!.id));
//   }

//   /// إلغاء تثبيت تطبيق من الجهاز
//   Future<void> uninstallApp(String packageName) async {
//     if (selectedDevice == null) {
//       CustomSnackBar.show(context, message: 'يرجى اختيار جهاز أولاً', type: SnackBarType.warning);
//       return;
//     }
//     await sendCommand(command: "uninstall_app", toAll: false, packageName: packageName);
//     // بعد إرسال الأمر، يمكن تحديث قائمة التطبيقات بعد فترة
//     Future.delayed(const Duration(seconds: 5), () => fetchInstalledApps(selectedDevice!.id));
//   }

//   /// تحديث موقع الجهاز
//   Future<void> updateLocation() async {
//     if (selectedDevice == null) return;
    
//     setState(() => isLocationLoading = true);
    
//     try {
//       // إرسال أمر تحديث الموقع
//       await NotificationService.sendNotification(
//         deviceToken: selectedDevice!.token,
//         title: "تحديث الموقع",
//         body: "جاري تحديث موقع الجهاز...",
//         data: {"command": "update_location"},
//         includeNotification: false,
//       );
      
//       CustomSnackBar.show(context, message: 'تم إرسال أمر تحديث الموقع', type: SnackBarType.success);
//     } catch (e) {
//       CustomSnackBar.show(context, message: 'فشل إرسال أمر التحديث: ${e.toString()}', type: SnackBarType.error);
//     } finally {
//       setState(() => isLocationLoading = false);
//     }
//   }

//   /// فلترة الأجهزة حسب بحث المستخدم
//   List<DeviceModel> get filteredDevices {
//     if (_searchQuery.isEmpty) return devices;
//     return devices.where((device) {
//       return device.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
//           device.model.toLowerCase().contains(_searchQuery.toLowerCase()) ||
//           device.osVersion.toLowerCase().contains(_searchQuery.toLowerCase());
//     }).toList();
//   }

//   /// بناء واجهة اختيار الجهاز
//   Widget _buildDeviceDropdown() {
//     return CustomDropdown<DeviceModel>(
//       value: selectedDevice,
//       items: filteredDevices,
//       hint: 'اختر جهاز',
//       prefixIcon: Icons.devices,
//       itemBuilder: (device) => device.name,
//       onChanged: (value) {
//         setState(() {
//           selectedDevice = value;
//           if (value != null) fetchInstalledApps(value.id);
//         });
//       },
//     );
//   }

//   /// بناء بطاقة معلومات الجهاز
//   Widget _buildDeviceInfoCard() {
//     if (selectedDevice == null) return const SizedBox();
    
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SectionHeader(title: 'معلومات الجهاز', icon: Icons.info, color: AppTheme.accentColor),
//             const SizedBox(height: 16),
//             Row(children: [
//               Container(
//                 width: 60,
//                 height: 60,
//                 decoration: BoxDecoration(
//                   color: AppTheme.lightGray,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: const Icon(Icons.phone_android, size: 40, color: AppTheme.darkText),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                   Text(selectedDevice!.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.darkText)),
//                   const SizedBox(height: 4),
//                   Text("${selectedDevice!.manufacturer} - ${selectedDevice!.model}", style: const TextStyle(fontSize: 14, color: AppTheme.lightText)),
//                 ]),
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                 decoration: BoxDecoration(
//                   color: selectedDevice!.isOnline 
//                     ? AppTheme.successColor.withOpacity(0.2) 
//                     : AppTheme.dangerColor.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Text(
//                   selectedDevice!.isOnline ? 'متصل' : 'غير متصل',
//                   style: TextStyle(
//                     color: selectedDevice!.isOnline ? AppTheme.successColor : AppTheme.dangerColor,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ]),
//             const SizedBox(height: 16),
//             Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
//               _buildInfoItem(icon: Icons.battery_std, label: 'البطارية', value: '${selectedDevice!.batteryLevel}%', color: AppTheme.accentColor),
//               _buildInfoItem(icon: Icons.android, label: 'الإصدار', value: "Android ${selectedDevice!.osVersion}", color: AppTheme.successColor),
//               _buildInfoItem(icon: Icons.update, label: 'SDK', value: "API ${selectedDevice!.sdkVersion}", color: AppTheme.darkText),
//             ]),
//           ],
//         ),
//       ),
//     );
//   }

//   /// عنصر معلومات في بطاقة الجهاز
//   Widget _buildInfoItem({required IconData icon, required String label, required String value, required Color color}) {
//     return Column(children: [
//       Icon(icon, size: 28, color: color),
//       const SizedBox(height: 8),
//       Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.lightText)),
//       const SizedBox(height: 4),
//       Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.darkText)),
//     ]);
//   }

//   /// زر إجراء مخصص للأوامر
//   Widget _buildActionButton({
//     required String label,
//     required String command,
//     required IconData icon,
//     bool toAll = false,
//     String? packageName,
//   }) {
//     return ActionButton(
//       label: label,
//       icon: icon,
//       onPressed: isLoading ? null : () => sendCommand(command: command, toAll: toAll, packageName: packageName),
//       type: toAll ? ActionButtonType.danger : ActionButtonType.primary,
//       isLoading: isLoading,
//     );
//   }

//   /// مؤشرات التحميل
//   Widget _buildLoadingIndicator() => LoadingOverlay(message: 'جاري الإرسال...', isVisible: isLoading);
//   Widget _buildAppsLoadingIndicator() => LoadingOverlay(message: 'جاري تحميل التطبيقات...', isVisible: isAppsLoading);
//   Widget _buildLocationLoadingIndicator() => LoadingOverlay(message: 'جاري تحديث الموقع...', isVisible: isLocationLoading);

//   /// قسم التطبيقات المثبتة
//   Widget _buildAppsSection() {
//     if (selectedDevice == null) {
//       return const Center(child: Text('يرجى اختيار جهاز لعرض التطبيقات', style: TextStyle(fontSize: 16, color: AppTheme.lightText)));
//     }

//     if (installedApps.isEmpty) {
//       return EmptyStateWidget(
//         icon: Icons.apps,
//         title: "لا توجد تطبيقات",
//         subtitle: "لم يتم العثور على تطبيقات مثبتة على هذا الجهاز",
//         buttonText: 'إعادة تحميل',
//         onButtonPressed: () => fetchInstalledApps(selectedDevice!.id),
//       );
//     }

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
      
//       children: [
//         SectionHeader(title: 'التطبيقات المثبتة (${installedApps.length})', icon: Icons.apps, color: AppTheme.accentColor),
//         const SizedBox(height: 16),
//         ...installedApps.map((app) => AppInfoCard(
//           appName: app.name,
//           packageName: app.packageName,
//           version: app.version,
//           installDate: app.installDate,
//           onUninstall: () => uninstallApp(app.packageName),
//         )).toList(),
//         const SizedBox(height: 24),
//         ActionButton(
//           label: 'تثبيت تطبيق جديد',
//           icon: Icons.add,
//           onPressed: installApp,
//           type: ActionButtonType.success,
//         ),
//       ],
//     );
//   }

//   /// قسم تتبع الموقع
//   Widget _buildLocationSection() {
//     if (selectedDevice == null) {
//       return const Center(child: Text('يرجى اختيار جهاز لعرض الموقع', style: TextStyle(fontSize: 16, color: AppTheme.lightText)));
//     }

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SectionHeader(title: 'تتبع الموقع', icon: Icons.location_on, color: AppTheme.accentColor),
//         const SizedBox(height: 16),
//         if (selectedDevice!.latitude != null && selectedDevice!.longitude != null)
//           LocationMapCard(
//             latitude: selectedDevice!.latitude!,
//             longitude: selectedDevice!.longitude!,
//             address: selectedDevice!.address ?? 'لم يتم تحديد العنوان',
//           )
//         else
//           const EmptyStateWidget(
//             icon: Icons.location_off,
//             title: "الموقع غير متوفر",
//             subtitle: "لم يتم تحديد موقع هذا الجهاز بعد",
//           ),
//         const SizedBox(height: 16),
//         ActionButton(
//           label: 'تحديث الموقع',
//           icon: Icons.refresh,
//           onPressed: updateLocation,
//         ),
//       ],
//     );
//   }

//   /// شريط البحث
//   Widget _buildSearchBar() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))],
//       ),
//       child: Row(children: [
//         const Icon(Icons.search, color: AppTheme.lightText),
//         const SizedBox(width: 8),
//         Expanded(
//           child: TextField(
//             controller: _searchController,
//             decoration: const InputDecoration(
//               hintText: 'بحث عن جهاز...',
//               border: InputBorder.none,
//               hintStyle: TextStyle(color: AppTheme.lightText),
//             ),
//             onChanged: (value) => setState(() => _searchQuery = value),
//           ),
//         ),
//         if (_searchQuery.isNotEmpty)
//           IconButton(
//             icon: const Icon(Icons.clear, size: 20),
//             onPressed: () => setState(() {
//               _searchController.clear();
//               _searchQuery = '';
//             }),
//           ),
//       ]),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppTheme.lightGray,
//       appBar: AppBar(
//         title: const Text('إدارة الأجهزة عن بُعد', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
//         centerTitle: true,
//         backgroundColor: AppTheme.primaryColor,
//         foregroundColor: Colors.white,
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: fetchDevices,
//             tooltip: 'تحديث القائمة',
//           ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           // حالة عدم وجود أجهزة
//           if (devices.isEmpty && !isLoading)
//             EmptyStateWidget(
//               icon: Icons.devices_other,
//               title: "لا توجد أجهزة متاحة",
//               subtitle: "تأكد من إضافة الأجهزة إلى النظام",
//               buttonText: 'إعادة تحميل',
//               onButtonPressed: fetchDevices,
//             )
//           // عرض محتوى الشاشة الرئيسي
//           else
//             FadeTransition(
//               opacity: _fadeAnimation,
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // شريط البحث
//                     _buildSearchBar(),
//                     const SizedBox(height: 16),
                    
//                     // قسم اختيار الجهاز
//                     const SectionHeader(title: 'اختيار الجهاز', icon: Icons.devices),
//                     const SizedBox(height: 12),
//                     _buildDeviceDropdown(),
//                     const SizedBox(height: 24),
                    
//                     // معلومات الجهاز المحدد
//                     if (selectedDevice != null) ...[
//                       _buildDeviceInfoCard(),
//                       const SizedBox(height: 24),
//                     ],
                    
//                     // أوامر الجهاز المحدد
//                     const SectionHeader(title: 'أوامر الجهاز المحدد', icon: Icons.send),
//                     const SizedBox(height: 12),
                    
//                     _buildActionButton(label: "🔒 قفل الجهاز", command: "lock", icon: Icons.lock),
//                     _buildActionButton(label: "📷 تعطيل الكاميرا", command: "disable_camera", icon: Icons.camera_alt_outlined),
//                     _buildActionButton(label: "📷 تفعيل الكاميرا", command: "enable_camera", icon: Icons.camera_alt_outlined),
//                     _buildActionButton(label: "تعطيل متجر بلاي", command: "disable_playstore", icon: Icons.shop),
//                     _buildActionButton(label: "تفعيل متجر بلاي", command: "enable_playstore", icon: Icons.shop),
//                     _buildActionButton(label: "🔁 إعادة تشغيل", command: "reboot_device", icon: Icons.restart_alt),
//                     const SizedBox(height: 24),
                    
//                     // فاصل بصري
//                     const Divider(thickness: 2, color: AppTheme.primaryColor, indent: 20, endIndent: 20),
//                     const SizedBox(height: 16),
                    
//                     // أوامر جماعية لجميع الأجهزة
//                     const SectionHeader(title: 'أوامر جماعية (جميع الأجهزة)', icon: Icons.all_inclusive, color: AppTheme.dangerColor),
//                     const SizedBox(height: 12),
//                     _buildActionButton(label: "🚨 قفل جميع الأجهزة", command: "lock", icon: Icons.security, toAll: true),
//                     const SizedBox(height: 24),
                    
//                     // قسم التطبيقات المثبتة
//                     const SectionHeader(title: 'إدارة التطبيقات', icon: Icons.apps, color: AppTheme.successColor),
//                     const SizedBox(height: 16),
//                     _buildAppsSection(),
//                     const SizedBox(height: 24),
                    
//                     // قسم تتبع الموقع
//                     const SectionHeader(title: 'تتبع الموقع', icon: Icons.location_on, color: AppTheme.accentColor),
//                     const SizedBox(height: 16),
//                     _buildLocationSection(),
//                     const SizedBox(height: 40),
//                   ],
//                 ),
//               ),
//             ),
          
//           // مؤشرات التحميل
//           _buildLoadingIndicator(),
//           _buildAppsLoadingIndicator(),
//           _buildLocationLoadingIndicator(),
//         ],
//       ),
//     );
//   }
// }



// // [file name]: custom_widgets.dart
// // [file content begin]
// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:mdm/notifications/notifications_helper.dart';

// /// Widget مخصص لعرض حالة فارغة مع رسالة وأيقونة
// class EmptyStateWidget extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String subtitle;
//   final String? buttonText;
//   final VoidCallback? onButtonPressed;

//   const EmptyStateWidget({
//     Key? key,
//     required this.icon,
//     required this.title,
//     required this.subtitle,
//     this.buttonText,
//     this.onButtonPressed,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(32.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               icon,
//               size: 80,
//               color: AppTheme.lightText,
//             ),
//             const SizedBox(height: 16),
//             Text(
//               title,
//               style: Theme.of(context).textTheme.headlineSmall,
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 8),
//             Text(
//               subtitle,
//               style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                 color: AppTheme.lightText,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             if (buttonText != null && onButtonPressed != null) ...[
//               const SizedBox(height: 24),
//               ElevatedButton.icon(
//                 onPressed: onButtonPressed,
//                 icon: const Icon(Icons.refresh),
//                 label: Text(buttonText!),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }

// /// Widget مخصص لمؤشر التحميل مع رسالة
// class LoadingOverlay extends StatelessWidget {
//   final String message;
//   final bool isVisible;

//   const LoadingOverlay({
//     Key? key,
//     required this.message,
//     required this.isVisible,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     if (!isVisible) return const SizedBox.shrink();

//     return Container(
//       color: Colors.black.withOpacity(0.3),
//       child: Center(
//         child: Card(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(24.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const CircularProgressIndicator(),
//                 const SizedBox(height: 16),
//                 Text(
//                   message,
//                   style: Theme.of(context).textTheme.titleMedium,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// /// Widget مخصص لعرض SnackBar محسن
// class CustomSnackBar {
//   static void show(
//     BuildContext context, {
//     required String message,
//     SnackBarType type = SnackBarType.info,
//     Duration duration = const Duration(seconds: 3),
//   }) {
//     Color backgroundColor;
//     Color textColor;
//     IconData icon;

//     switch (type) {
//       case SnackBarType.success:
//         backgroundColor = AppTheme.successColor;
//         textColor = Colors.white;
//         icon = Icons.check_circle;
//         break;
//       case SnackBarType.error:
//         backgroundColor = AppTheme.dangerColor;
//         textColor = Colors.white;
//         icon = Icons.error;
//         break;
//       case SnackBarType.warning:
//         backgroundColor = AppTheme.statusColors['warning']!;
//         textColor = Colors.white;
//         icon = Icons.warning;
//         break;
//       case SnackBarType.info:
//       default:
//         backgroundColor = AppTheme.accentColor;
//         textColor = Colors.white;
//         icon = Icons.info;
//         break;
//     }

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             Icon(icon, color: textColor),
//             const SizedBox(width: 8),
//             Expanded(
//               child: Text(
//                 message,
//                 style: TextStyle(
//                   color: textColor,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         backgroundColor: backgroundColor,
//         duration: duration,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         margin: const EdgeInsets.all(16),
//       ),
//     );
//   }
// }

// enum SnackBarType { success, error, warning, info }

// /// Widget مخصص للأزرار مع أيقونات وتصميم موحد
// class ActionButton extends StatelessWidget {
//   final String label;
//   final IconData icon;
//   final VoidCallback? onPressed;
//   final ActionButtonType type;
//   final bool isLoading;

//   const ActionButton({
//     Key? key,
//     required this.label,
//     required this.icon,
//     this.onPressed,
//     this.type = ActionButtonType.primary,
//     this.isLoading = false,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     Color backgroundColor;
//     Color foregroundColor = Colors.white;

//     switch (type) {
//       case ActionButtonType.primary:
//         backgroundColor = AppTheme.accentColor;
//         break;
//       case ActionButtonType.danger:
//         backgroundColor = AppTheme.dangerColor;
//         break;
//       case ActionButtonType.success:
//         backgroundColor = AppTheme.successColor;
//         break;
//       case ActionButtonType.secondary:
//         backgroundColor = AppTheme.lightText;
//         break;
//     }

//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 6.0),
//       width: double.infinity,
//       child: ElevatedButton.icon(
//         onPressed: isLoading ? null : onPressed,
//         icon: isLoading
//             ? const SizedBox(
//                 width: 20,
//                 height: 20,
//                 child: CircularProgressIndicator(
//                   strokeWidth: 2,
//                   valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                 ),
//               )
//             : Icon(icon, size: 20),
//         label: Text(
//           label,
//           style: const TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         style: ElevatedButton.styleFrom(
//           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//           backgroundColor: backgroundColor,
//           foregroundColor: foregroundColor,
//           disabledBackgroundColor: AppTheme.lightGray,
//           disabledForegroundColor: AppTheme.darkText.withOpacity(0.5),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           elevation: 2,
//         ),
//       ),
//     );
//   }
// }

// enum ActionButtonType { primary, danger, success, secondary }

// /// Widget مخصص للقائمة المنسدلة مع تصميم محسن
// class CustomDropdown<T> extends StatelessWidget {
//   final T? value;
//   final List<T> items;
//   final String hint;
//   final IconData prefixIcon;
//   final String Function(T) itemBuilder;
//   final void Function(T?) onChanged;

//   const CustomDropdown({
//     Key? key,
//     required this.value,
//     required this.items,
//     required this.hint,
//     required this.prefixIcon,
//     required this.itemBuilder,
//     required this.onChanged,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//           color: Colors.white,
//         ),
//         child: DropdownButton<T>(
//           isExpanded: true,
//           value: value,
//           hint: Row(
//             children: [
//               Icon(prefixIcon, color: AppTheme.accentColor),
//               const SizedBox(width: 8),
//               Text(
//                 hint,
//                 style: const TextStyle(
//                   color: AppTheme.darkText,
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//           underline: const SizedBox(),
//           items: items.map((item) {
//             return DropdownMenuItem<T>(
//               value: item,
//               child: Row(
//                 children: [
//                   Icon(
//                     Icons.smartphone,
//                     color: AppTheme.accentColor,
//                     size: 20,
//                   ),
//                   const SizedBox(width: 8),
//                   Text(
//                     itemBuilder(item),
//                     style: const TextStyle(
//                       color: AppTheme.darkText,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }).toList(),
//           onChanged: onChanged,
//         ),
//       ),
//     );
//   }
// }

// /// Widget مخصص لعرض عنوان القسم
// class SectionHeader extends StatelessWidget {
//   final String title;
//   final Color? color;
//   final IconData? icon;

//   const SectionHeader({
//     Key? key,
//     required this.title,
//     this.color,
//     this.icon,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         if (icon != null) ...[
//           Icon(
//             icon,
//             color: color ?? AppTheme.darkText,
//             size: 20,
//           ),
//           const SizedBox(width: 8),
//         ],
//         Text(
//           title,
//           style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//             color: color ?? AppTheme.darkText,
//           ),
//         ),
//       ],
//     );
//   }
// }

// /// Widget مخصص لمربع حوار التأكيد
// class ConfirmationDialog extends StatelessWidget {
//   final String title;
//   final String content;
//   final String confirmText;
//   final String cancelText;
//   final VoidCallback onConfirm;
//   final VoidCallback? onCancel;
//   final bool isDangerous;

//   const ConfirmationDialog({
//     Key? key,
//     required this.title,
//     required this.content,
//     required this.onConfirm,
//     this.confirmText = 'تأكيد',
//     this.cancelText = 'إلغاء',
//     this.onCancel,
//     this.isDangerous = false,
//   }) : super(key: key);

//   static Future<bool?> show(
//     BuildContext context, {
//     required String title,
//     required String content,
//     required VoidCallback onConfirm,
//     String confirmText = 'تأكيد',
//     String cancelText = 'إلغاء',
//     VoidCallback? onCancel,
//     bool isDangerous = false,
//   }) {
//     return showDialog<bool>(
//       context: context,
//       builder: (BuildContext context) {
//         return ConfirmationDialog(
//           title: title,
//           content: content,
//           onConfirm: onConfirm,
//           confirmText: confirmText,
//           cancelText: cancelText,
//           onCancel: onCancel,
//           isDangerous: isDangerous,
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       title: Text(
//         title,
//         style: Theme.of(context).textTheme.titleLarge,
//       ),
//       content: Text(
//         content,
//         style: Theme.of(context).textTheme.bodyLarge,
//       ),
//       actions: [
//         TextButton(
//           onPressed: () {
//             Navigator.of(context).pop(false);
//             onCancel?.call();
//           },
//           child: Text(cancelText),
//         ),
//         ElevatedButton(
//           onPressed: () {
//             Navigator.of(context).pop(true);
//             onConfirm();
//           },
//           style: ElevatedButton.styleFrom(
//             backgroundColor: isDangerous ? AppTheme.dangerColor : AppTheme.accentColor,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//           ),
//           child: Text(
//             confirmText,
//             style: const TextStyle(color: Colors.white),
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mdm/MDM-Admin/custom_widgets.dart';
import 'package:mdm/notifications/notifications_helper.dart';

/// Widget مخصص لعرض موقع الجهاز على الخريطة
class LocationMapCard extends StatelessWidget {
  final double latitude;
  final double longitude;
  final String address;

  const LocationMapCard({
    Key? key,
    required this.latitude,
    required this.longitude,
    required this.address,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              title: 'الموقع الحالي',
              icon: Icons.location_on,
              color: AppTheme.accentColor,
            ),
            const SizedBox(height: 16),
            Container(
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppTheme.lightGray,
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.map,
                size: 80,
                color: AppTheme.lightText,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.gps_fixed, color: AppTheme.accentColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  'الإحداثيات: $latitude, $longitude',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.darkText,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.location_city, color: AppTheme.accentColor, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'العنوان: $address',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.darkText,
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


/// Widget مخصص لعرض معلومات التطبيق
class AppInfoCard extends StatelessWidget {
  final String appName;
  final String packageName;
  final String version;
  final String installDate;

  const AppInfoCard({
    Key? key,
    required this.appName,
    required this.packageName,
    required this.version,
    required this.installDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppTheme.accentColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.apps, color: AppTheme.accentColor),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        packageName,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.lightText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.info_outline, size: 16, color: AppTheme.lightText),
                const SizedBox(width: 8),
                Text(
                  'الإصدار: $version',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.darkText,
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.calendar_today, size: 16, color: AppTheme.lightText),
                const SizedBox(width: 8),
                Text(
                  'التثبيت: $installDate',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.darkText,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.delete, size: 18),
                    label: const Text('إلغاء التثبيت'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.dangerColor,
                      side: const BorderSide(color: AppTheme.dangerColor),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('تحديث'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
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
// [file content end]

// [file name]: app_theme.dart
// [file content begin]



class AppTheme {
  // تعريف الألوان
  static const Color primaryColor = Color(0xFF2C3E50);
  static const Color accentColor = Color(0xFF3498DB);
  static const Color successColor = Color(0xFF2ECC71);
  static const Color dangerColor = Color(0xFFE74C3C);
  static const Color lightGray = Color(0xFFECF0F1);
  static const Color darkText = Color(0xFF333333);
  static const Color lightText = Color(0xFF7F8C8D);

  // تعريف الخطوط
  static const String fontFamily = 'Roboto';

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: fontFamily,
      
      // نظام الألوان
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: accentColor,
        surface: Colors.white,
        background: lightGray,
        error: dangerColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: darkText,
        onBackground: darkText,
        onError: Colors.white,
      ),

      // شريط التطبيق
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamily: fontFamily,
        ),
      ),

      // الأزرار المرفوعة
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: fontFamily,
          ),
        ),
      ),

      // الأزرار النصية
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accentColor,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: fontFamily,
          ),
        ),
      ),

      // البطاقات
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Colors.white,
      ),

      // مربعات الحوار
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titleTextStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: darkText,
          fontFamily: fontFamily,
        ),
        contentTextStyle: const TextStyle(
          fontSize: 16,
          color: darkText,
          fontFamily: fontFamily,
        ),
      ),

      // شريط التنبيهات
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentTextStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          fontFamily: fontFamily,
        ),
      ),

      // مؤشر التحميل
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: accentColor,
      ),

      // الفواصل
      dividerTheme: const DividerThemeData(
        color: primaryColor,
        thickness: 2,
        indent: 20,
        endIndent: 20,
      ),

      // النصوص
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: darkText,
          fontFamily: fontFamily,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: darkText,
          fontFamily: fontFamily,
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: darkText,
          fontFamily: fontFamily,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: darkText,
          fontFamily: fontFamily,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: darkText,
          fontFamily: fontFamily,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: darkText,
          fontFamily: fontFamily,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: darkText,
          fontFamily: fontFamily,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          color: lightText,
          fontFamily: fontFamily,
        ),
      ),
    );
  }

  // ألوان مخصصة للحالات المختلفة
  static const Map<String, Color> statusColors = {
    'success': successColor,
    'error': dangerColor,
    'warning': Color(0xFFF39C12),
    'info': accentColor,
  };

  // أحجام الخطوط المخصصة
  static const Map<String, double> fontSizes = {
    'small': 12.0,
    'medium': 14.0,
    'large': 16.0,
    'xlarge': 18.0,
    'xxlarge': 20.0,
    'title': 24.0,
  };

  // المسافات المعيارية
  static const Map<String, double> spacing = {
    'xs': 4.0,
    'sm': 8.0,
    'md': 16.0,
    'lg': 24.0,
    'xl': 32.0,
    'xxl': 48.0,
  };

  // نصف أقطار الحدود
  static const Map<String, double> borderRadius = {
    'small': 8.0,
    'medium': 12.0,
    'large': 16.0,
    'xlarge': 24.0,
  };
}
// [file content end]

// [file name]: enhanced_device_management_screen.dart
// [file content begin]


class DeviceModel {
  final String id;
  final String name;
  final String model;
  final String osVersion;
  final int batteryLevel;
  final String token;
  final bool isOnline;
  final double? latitude;
  final double? longitude;
  final String? address;

  DeviceModel({
    required this.id,
    required this.name,
    required this.model,
    required this.osVersion,
    required this.batteryLevel,
    required this.token,
    required this.isOnline,
    this.latitude,
    this.longitude,
    this.address,
  });

  factory DeviceModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return DeviceModel(
      id: doc.id,
      name: data['deviceName'] ?? 'غير معروف',
      model: data['model'] ?? 'غير معروف',
      osVersion: data['osVersion'] ?? 'غير معروف',
      batteryLevel: data['batteryLevel'] ?? 0,
      token: data['token'] ?? '',
      isOnline: data['isOnline'] ?? false,
      latitude: data['latitude']?.toDouble(),
      longitude: data['longitude']?.toDouble(),
      address: data['address'] ?? 'لم يتم تحديد الموقع',
    );
  }
}

class AppModel {
  final String id;
  final String name;
  final String packageName;
  final String version;
  final String installDate;

  AppModel({
    required this.id,
    required this.name,
    required this.packageName,
    required this.version,
    required this.installDate,
  });
}

class EnhancedDeviceManagementScreen extends StatefulWidget {
  const EnhancedDeviceManagementScreen({Key? key}) : super(key: key);

  @override
  State<EnhancedDeviceManagementScreen> createState() => _EnhancedDeviceManagementScreenState();
}

class _EnhancedDeviceManagementScreenState extends State<EnhancedDeviceManagementScreen>
    with TickerProviderStateMixin {
  List<DeviceModel> devices = [];
  List<AppModel> installedApps = [];
  DeviceModel? selectedDevice;
  bool isLoading = false;
  bool isLocationLoading = false;
  bool isAppsLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

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
    _searchController.dispose();
    super.dispose();
  }

  Future<void> fetchDevices() async {
    setState(() => isLoading = true);
    
    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('devices').get();
      setState(() {
        devices = querySnapshot.docs
            .map((doc) => DeviceModel.fromFirestore(doc))
            .toList();
      });
    } catch (e) {
      print('Error getting devices: $e');
      CustomSnackBar.show(
        context,
        message: 'فشل تحميل الأجهزة',
        type: SnackBarType.error,
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchInstalledApps(String deviceId) async {
    if (selectedDevice == null) return;
    
    setState(() => isAppsLoading = true);
    
    try {
      // محاكاة جلب التطبيقات المثبتة
      await Future.delayed(const Duration(seconds: 1));
      
      setState(() {
        installedApps = [
          AppModel(
            id: '1',
            name: 'WhatsApp',
            packageName: 'com.whatsapp',
            version: '2.22.25.76',
            installDate: '2023-10-15',
          ),
          AppModel(
            id: '2',
            name: 'YouTube',
            packageName: 'com.google.youtube',
            version: '17.45.36',
            installDate: '2023-09-20',
          ),
          AppModel(
            id: '3',
            name: 'Google Maps',
            packageName: 'com.google.android.apps.maps',
            version: '11.67.2',
            installDate: '2023-11-05',
          ),
          AppModel(
            id: '4',
            name: 'Telegram',
            packageName: 'org.telegram.messenger',
            version: '9.2.1',
            installDate: '2023-08-12',
          ),
        ];
      });
    } catch (e) {
      print('Error fetching apps: $e');
      CustomSnackBar.show(
        context,
        message: 'فشل تحميل التطبيقات',
        type: SnackBarType.error,
      );
    } finally {
      setState(() => isAppsLoading = false);
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
      bool? confirmed = await ConfirmationDialog.show(
        context,
        title: 'تأكيد الإرسال',
        content: 'هل أنت متأكد من إرسال الأمر "$command" إلى جميع الأجهزة؟',
        confirmText: 'نعم',
        cancelText: 'إلغاء',
        isDangerous: true, onConfirm: () {  },
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
        CustomSnackBar.show(
          context,
          message: 'تم إرسال الأمر إلى جميع الأجهزة بنجاح',
          type: SnackBarType.success,
        );
      } else {
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
        CustomSnackBar.show(
          context,
          message: 'تم إرسال الأمر إلى الجهاز المحدد بنجاح',
          type: SnackBarType.success,
        );
      }
    } catch (e) {
      CustomSnackBar.show(
        context,
        message: 'حدث خطأ: ${e.toString()}',
        type: SnackBarType.error,
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> installApp() async {
    if (selectedDevice == null) {
      CustomSnackBar.show(
        context,
        message: 'يرجى اختيار جهاز أولاً',
        type: SnackBarType.warning,
      );
      return;
    }

    // محاكاة عملية تثبيت التطبيق
    setState(() => isAppsLoading = true);
    
    try {
      await Future.delayed(const Duration(seconds: 2));
      CustomSnackBar.show(
        context,
        message: 'تم تثبيت التطبيق بنجاح على ${selectedDevice!.name}',
        type: SnackBarType.success,
      );
      fetchInstalledApps(selectedDevice!.id);
    } catch (e) {
      CustomSnackBar.show(
        context,
        message: 'فشل تثبيت التطبيق: ${e.toString()}',
        type: SnackBarType.error,
      );
    } finally {
      setState(() => isAppsLoading = false);
    }
  }

  Future<void> updateLocation() async {
    if (selectedDevice == null) return;
    
    setState(() => isLocationLoading = true);
    
    try {
      // محاكاة تحديث الموقع
      await Future.delayed(const Duration(seconds: 1));
      CustomSnackBar.show(
        context,
        message: 'تم تحديث موقع ${selectedDevice!.name} بنجاح',
        type: SnackBarType.success,
      );
    } catch (e) {
      CustomSnackBar.show(
        context,
        message: 'فشل تحديث الموقع: ${e.toString()}',
        type: SnackBarType.error,
      );
    } finally {
      setState(() => isLocationLoading = false);
    }
  }

  List<DeviceModel> get filteredDevices {
    if (_searchQuery.isEmpty) return devices;
    return devices.where((device) {
      return device.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          device.model.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          device.osVersion.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  Widget _buildDeviceDropdown() {
    return CustomDropdown<DeviceModel>(
      value: selectedDevice,
      items: filteredDevices,
      hint: 'اختر جهاز',
      prefixIcon: Icons.devices,
      itemBuilder: (device) => device.name,
      onChanged: (value) {
        setState(() {
          selectedDevice = value;
          if (value != null) {
            fetchInstalledApps(value.id);
          }
        });
      },
    );
  }

  Widget _buildDeviceInfoCard() {
    if (selectedDevice == null) return const SizedBox();
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              title: 'معلومات الجهاز',
              icon: Icons.info,
              color: AppTheme.accentColor,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppTheme.lightGray,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.phone_android, size: 40, color: AppTheme.darkText),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedDevice!.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        selectedDevice!.model,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.lightText,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: selectedDevice!.isOnline ? AppTheme.successColor.withOpacity(0.2) : AppTheme.dangerColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    selectedDevice!.isOnline ? 'متصل' : 'غير متصل',
                    style: TextStyle(
                      color: selectedDevice!.isOnline ? AppTheme.successColor : AppTheme.dangerColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoItem(
                  icon: Icons.battery_std,
                  label: 'البطارية',
                  value: '${selectedDevice!.batteryLevel}%',
                  color: AppTheme.accentColor,
                ),
                _buildInfoItem(
                  icon: Icons.android,
                  label: 'الإصدار',
                  value: selectedDevice!.osVersion,
                  color: AppTheme.successColor,
                ),
                _buildInfoItem(
                  icon: Icons.update,
                  label: 'الحالة',
                  value: selectedDevice!.isOnline ? 'نشط' : 'غير نشط',
                  color: selectedDevice!.isOnline ? AppTheme.successColor : AppTheme.dangerColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, size: 28, color: color),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.lightText,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.darkText,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required String command,
    required IconData icon,
    bool toAll = false,
  }) {
    Color buttonColor = toAll ? AppTheme.dangerColor : AppTheme.accentColor;
    
    return ActionButton(
      label: label,
      icon: icon,
      onPressed: isLoading ? null : () => sendCommand(command: command, toAll: toAll),
      type: toAll ? ActionButtonType.danger : ActionButtonType.primary,
      isLoading: isLoading,
    );
  }

  Widget _buildLoadingIndicator() {
    return LoadingOverlay(
      message: 'جاري الإرسال...',
      isVisible: isLoading,
    );
  }

  Widget _buildAppsLoadingIndicator() {
    return LoadingOverlay(
      message: 'جاري تحميل التطبيقات...',
      isVisible: isAppsLoading,
    );
  }

  Widget _buildLocationLoadingIndicator() {
    return LoadingOverlay(
      message: 'جاري تحديث الموقع...',
      isVisible: isLocationLoading,
    );
  }

  Widget _buildAppsSection() {
    if (selectedDevice == null) {
      return const Center(
        child: Text(
          'يرجى اختيار جهاز لعرض التطبيقات',
          style: TextStyle(
            fontSize: 16,
            color: AppTheme.lightText,
          ),
        ),
      );
    }

    if (installedApps.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.apps,
        title: "لا توجد تطبيقات",
        subtitle: "لم يتم العثور على تطبيقات مثبتة على هذا الجهاز",
        buttonText: 'إعادة تحميل',
        onButtonPressed: () => fetchInstalledApps(selectedDevice!.id),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'التطبيقات المثبتة',
          icon: Icons.apps,
          color: AppTheme.accentColor,
        ),
        const SizedBox(height: 16),
        ...installedApps.map((app) => AppInfoCard(
          appName: app.name,
          packageName: app.packageName,
          version: app.version,
          installDate: app.installDate,
        )).toList(),
        const SizedBox(height: 24),
        ActionButton(
          label: 'تثبيت تطبيق جديد',
          icon: Icons.add,
          onPressed: installApp,
          type: ActionButtonType.success,
        ),
      ],
    );
  }

  Widget _buildLocationSection() {
    if (selectedDevice == null) {
      return const Center(
        child: Text(
          'يرجى اختيار جهاز لعرض الموقع',
          style: TextStyle(
            fontSize: 16,
            color: AppTheme.lightText,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'تتبع الموقع',
          icon: Icons.location_on,
          color: AppTheme.accentColor,
        ),
        const SizedBox(height: 16),
        if (selectedDevice!.latitude != null && selectedDevice!.longitude != null)
          LocationMapCard(
            latitude: selectedDevice!.latitude!,
            longitude: selectedDevice!.longitude!,
            address: selectedDevice!.address ?? 'لم يتم تحديد العنوان',
          )
        else
          const EmptyStateWidget(
            icon: Icons.location_off,
            title: "الموقع غير متوفر",
            subtitle: "لم يتم تحديد موقع هذا الجهاز بعد",
          ),
        const SizedBox(height: 16),
        ActionButton(
          label: 'تحديث الموقع',
          icon: Icons.refresh,
          onPressed: updateLocation,
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: AppTheme.lightText),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'بحث عن جهاز...',
                border: InputBorder.none,
                hintStyle: TextStyle(color: AppTheme.lightText),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          if (_searchQuery.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear, size: 20),
              onPressed: () {
                setState(() {
                  _searchController.clear();
                  _searchQuery = '';
                });
              },
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGray,
      appBar: AppBar(
        title: const Text(
          'إدارة الأجهزة عن بُعد',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchDevices,
            tooltip: 'تحديث القائمة',
          ),
        ],
      ),
      body: Stack(
        children: [
          if (devices.isEmpty && !isLoading)
            EmptyStateWidget(
              icon: Icons.devices_other,
              title: "لا توجد أجهزة متاحة",
              subtitle: "تأكد من إضافة الأجهزة إلى النظام",
              buttonText: 'إعادة تحميل',
              onButtonPressed: fetchDevices,
            )
          else
            FadeTransition(
              opacity: _fadeAnimation,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // شريط البحث
                    _buildSearchBar(),
                    const SizedBox(height: 16),
                    
                    // قسم اختيار الجهاز
                    const SectionHeader(
                      title: 'اختيار الجهاز',
                      icon: Icons.devices,
                    ),
                    const SizedBox(height: 12),
                    _buildDeviceDropdown(),
                    
                    const SizedBox(height: 24),
                    
                    // معلومات الجهاز المحدد
                    if (selectedDevice != null) ...[
                      _buildDeviceInfoCard(),
                      const SizedBox(height: 24),
                    ],
                    
                    // أوامر الجهاز المحدد
                    const SectionHeader(
                      title: 'أوامر الجهاز المحدد',
                      icon: Icons.send,
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
                      icon: Icons.shop,
                    ),
                    _buildActionButton(
                      label: "تفعيل متجر بلاي",
                      command: "enable_playstore",
                      icon: Icons.shop,
                    ),
                    _buildActionButton(
                      label: "🔁 إعادة تشغيل",
                      command: "reboot_device",
                      icon: Icons.restart_alt,
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // فاصل بصري
                    const Divider(
                      thickness: 2,
                      color: AppTheme.primaryColor,
                      indent: 20,
                      endIndent: 20,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // قسم الأوامر الجماعية
                    const SectionHeader(
                      title: 'أوامر جماعية (جميع الأجهزة)',
                      icon: Icons.all_inclusive,
                      color: AppTheme.dangerColor,
                    ),
                    const SizedBox(height: 12),
                    
                    _buildActionButton(
                      label: "🚨 قفل جميع الأجهزة",
                      command: "lock",
                      icon: Icons.security,
                      toAll: true,
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // قسم التطبيقات المثبتة
                    const SectionHeader(
                      title: 'إدارة التطبيقات',
                      icon: Icons.apps,
                      color: AppTheme.successColor,
                    ),
                    const SizedBox(height: 16),
                    _buildAppsSection(),
                    
                    const SizedBox(height: 24),
                    
                    // قسم تتبع الموقع
                    const SectionHeader(
                      title: 'تتبع الموقع',
                      icon: Icons.location_on,
                      color: AppTheme.accentColor,
                    ),
                    const SizedBox(height: 16),
                    _buildLocationSection(),
                    
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          
          // مؤشرات التحميل
          _buildLoadingIndicator(),
          _buildAppsLoadingIndicator(),
          _buildLocationLoadingIndicator(),
        ],
      ),
    );
  }
}
// [file content end]


