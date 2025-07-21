import 'package:cloud_firestore/cloud_firestore.dart';

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
  final String manufacturer;
  final int sdkVersion;
  final List<AppModel>? installedApps;
  final DateTime? lastSeen;
  final String? deviceType;
  final Map<String, dynamic>? deviceInfo;
  final List<String>? permissions;
  final bool isLocked;
  final bool cameraEnabled;
  final bool playStoreEnabled;

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
    required this.manufacturer,
    required this.sdkVersion,
    this.installedApps,
    this.lastSeen,
    this.deviceType,
    this.deviceInfo,
    this.permissions,
    this.isLocked = false,
    this.cameraEnabled = true,
    this.playStoreEnabled = true,
  });

  /// إنشاء نموذج من مستند Firestore
  factory DeviceModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    return DeviceModel(
      id: doc.id,
      name: data['deviceName'] ?? 'جهاز غير معروف',
      model: data['model'] ?? 'غير محدد',
      osVersion: data['osVersion'] ?? 'غير محدد',
      batteryLevel: (data['batteryLevel'] ?? 0).toInt(),
      token: data['token'] ?? '',
      isOnline: data['isOnline'] ?? false,
      latitude: (data['location'] as GeoPoint?)?.latitude,
      longitude: (data['location'] as GeoPoint?)?.longitude,
      address: data['address'] ?? 'الموقع غير محدد',
      manufacturer: data['manufacturer'] ?? 'غير محدد',
      sdkVersion: (data['sdkVersion'] ?? 0).toInt(),
      installedApps: (data['installedApps'] as List<dynamic>?)
          ?.map((app) => AppModel.fromMap(app))
          .toList(),
      lastSeen: (data['lastSeen'] as Timestamp?)?.toDate(),
      deviceType: data['deviceType'] ?? 'Android',
      deviceInfo: data['deviceInfo'] as Map<String, dynamic>?,
      permissions: (data['permissions'] as List<dynamic>?)?.cast<String>(),
      isLocked: data['isLocked'] ?? false,
      cameraEnabled: data['cameraEnabled'] ?? true,
      playStoreEnabled: data['playStoreEnabled'] ?? true,
    );
  }

  /// تحويل النموذج إلى خريطة للحفظ في Firestore
  Map<String, dynamic> toMap() {
    return {
      'deviceName': name,
      'model': model,
      'osVersion': osVersion,
      'batteryLevel': batteryLevel,
      'token': token,
      'isOnline': isOnline,
      'location': latitude != null && longitude != null 
          ? GeoPoint(latitude!, longitude!) 
          : null,
      'address': address,
      'manufacturer': manufacturer,
      'sdkVersion': sdkVersion,
      'installedApps': installedApps?.map((app) => app.toMap()).toList(),
      'lastSeen': lastSeen != null ? Timestamp.fromDate(lastSeen!) : null,
      'deviceType': deviceType,
      'deviceInfo': deviceInfo,
      'permissions': permissions,
      'isLocked': isLocked,
      'cameraEnabled': cameraEnabled,
      'playStoreEnabled': playStoreEnabled,
    };
  }

  /// نسخ النموذج مع تعديل بعض الخصائص
  DeviceModel copyWith({
    String? id,
    String? name,
    String? model,
    String? osVersion,
    int? batteryLevel,
    String? token,
    bool? isOnline,
    double? latitude,
    double? longitude,
    String? address,
    String? manufacturer,
    int? sdkVersion,
    List<AppModel>? installedApps,
    DateTime? lastSeen,
    String? deviceType,
    Map<String, dynamic>? deviceInfo,
    List<String>? permissions,
    bool? isLocked,
    bool? cameraEnabled,
    bool? playStoreEnabled,
  }) {
    return DeviceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      model: model ?? this.model,
      osVersion: osVersion ?? this.osVersion,
      batteryLevel: batteryLevel ?? this.batteryLevel,
      token: token ?? this.token,
      isOnline: isOnline ?? this.isOnline,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      manufacturer: manufacturer ?? this.manufacturer,
      sdkVersion: sdkVersion ?? this.sdkVersion,
      installedApps: installedApps ?? this.installedApps,
      lastSeen: lastSeen ?? this.lastSeen,
      deviceType: deviceType ?? this.deviceType,
      deviceInfo: deviceInfo ?? this.deviceInfo,
      permissions: permissions ?? this.permissions,
      isLocked: isLocked ?? this.isLocked,
      cameraEnabled: cameraEnabled ?? this.cameraEnabled,
      playStoreEnabled: playStoreEnabled ?? this.playStoreEnabled,
    );
  }

  /// الحصول على حالة البطارية كنص
  String get batteryStatus {
    if (batteryLevel >= 80) return 'ممتازة';
    if (batteryLevel >= 50) return 'جيدة';
    if (batteryLevel >= 20) return 'منخفضة';
    return 'ضعيفة جداً';
  }

  /// الحصول على لون حالة البطارية
  String get batteryColor {
    if (batteryLevel >= 50) return 'success';
    if (batteryLevel >= 20) return 'warning';
    return 'danger';
  }

  /// الحصول على حالة الاتصال كنص
  String get connectionStatus => isOnline ? 'متصل' : 'غير متصل';

  /// الحصول على الوقت منذ آخر ظهور
  String get lastSeenText {
    if (lastSeen == null) return 'غير محدد';
    
    final now = DateTime.now();
    final difference = now.difference(lastSeen!);
    
    if (difference.inMinutes < 1) return 'الآن';
    if (difference.inMinutes < 60) return 'منذ ${difference.inMinutes} دقيقة';
    if (difference.inHours < 24) return 'منذ ${difference.inHours} ساعة';
    if (difference.inDays < 7) return 'منذ ${difference.inDays} يوم';
    
    return 'منذ أكثر من أسبوع';
  }

  /// التحقق من وجود موقع
  bool get hasLocation => latitude != null && longitude != null;

  /// عدد التطبيقات المثبتة
  int get appsCount => installedApps?.length ?? 0;
}

class AppModel {
  final String id;
  final String name;
  final String packageName;
  final String version;
  final String installDate;
  final int? size;
  final String? icon;
  final bool isSystemApp;
  final List<String>? permissions;
  final DateTime? lastUsed;

  AppModel({
    required this.id,
    required this.name,
    required this.packageName,
    required this.version,
    required this.installDate,
    this.size,
    this.icon,
    this.isSystemApp = false,
    this.permissions,
    this.lastUsed,
  });

  /// إنشاء نموذج من خريطة
  factory AppModel.fromMap(Map<String, dynamic> map) {
    return AppModel(
      id: map['packageName'] ?? '',
      name: map['appName'] ?? 'تطبيق غير معروف',
      packageName: map['packageName'] ?? '',
      version: map['version'] ?? 'غير محدد',
      installDate: map['installDate'] ?? 'غير محدد',
      size: map['size']?.toInt(),
      icon: map['icon'],
      isSystemApp: map['isSystemApp'] ?? false,
      permissions: (map['permissions'] as List<dynamic>?)?.cast<String>(),
      lastUsed: map['lastUsed'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['lastUsed'])
          : null,
    );
  }

  /// تحويل النموذج إلى خريطة
  Map<String, dynamic> toMap() {
    return {
      'appName': name,
      'packageName': packageName,
      'version': version,
      'installDate': installDate,
      'size': size,
      'icon': icon,
      'isSystemApp': isSystemApp,
      'permissions': permissions,
      'lastUsed': lastUsed?.millisecondsSinceEpoch,
    };
  }

  /// الحصول على حجم التطبيق كنص
  String get sizeText {
    if (size == null) return 'غير محدد';
    
    if (size! < 1024 * 1024) {
      return '${(size! / 1024).toStringAsFixed(1)} KB';
    } else if (size! < 1024 * 1024 * 1024) {
      return '${(size! / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(size! / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }

  /// الحصول على آخر استخدام كنص
  String get lastUsedText {
    if (lastUsed == null) return 'غير محدد';
    
    final now = DateTime.now();
    final difference = now.difference(lastUsed!);
    
    if (difference.inMinutes < 1) return 'الآن';
    if (difference.inMinutes < 60) return 'منذ ${difference.inMinutes} دقيقة';
    if (difference.inHours < 24) return 'منذ ${difference.inHours} ساعة';
    if (difference.inDays < 7) return 'منذ ${difference.inDays} يوم';
    
    return 'منذ أكثر من أسبوع';
  }
}

