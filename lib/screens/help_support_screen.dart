import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_widgets.dart';
import '../animations/page_transitions.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  final TextEditingController _feedbackController = TextEditingController();
  String selectedCategory = 'general';

  final List<FAQItem> faqItems = [
    FAQItem(
      question: 'كيف يمكنني إضافة جهاز جديد؟',
      answer: 'يمكنك إضافة جهاز جديد من خلال الذهاب إلى صفحة "إدارة الأجهزة" والضغط على زر "إضافة جهاز". ستحتاج إلى إدخال معلومات الجهاز مثل الاسم والنوع.',
      category: 'devices',
    ),
    FAQItem(
      question: 'لماذا لا يظهر موقع الجهاز؟',
      answer: 'تأكد من أن خدمة الموقع مفعلة على الجهاز وأن التطبيق لديه الأذونات اللازمة للوصول إلى الموقع. قد تحتاج أيضاً إلى التحقق من اتصال الإنترنت.',
      category: 'location',
    ),
    FAQItem(
      question: 'كيف يمكنني تغيير كلمة المرور؟',
      answer: 'اذهب إلى الإعدادات > الخصوصية والأمان > تغيير كلمة المرور. ستحتاج إلى إدخال كلمة المرور الحالية ثم كلمة المرور الجديدة.',
      category: 'security',
    ),
    FAQItem(
      question: 'هل يمكنني استخدام التطبيق بدون إنترنت؟',
      answer: 'بعض الميزات تعمل بدون إنترنت مثل عرض البيانات المحفوظة، لكن معظم الميزات تتطلب اتصال إنترنت للعمل بشكل صحيح.',
      category: 'general',
    ),
    FAQItem(
      question: 'كيف يمكنني إلغاء تثبيت تطبيق من جهاز بعيد؟',
      answer: 'اذهب إلى صفحة "إدارة التطبيقات"، اختر الجهاز المطلوب، ثم اضغط على التطبيق الذي تريد إلغاء تثبيته واختر "إلغاء التثبيت".',
      category: 'apps',
    ),
    FAQItem(
      question: 'ما هي متطلبات النظام للتطبيق؟',
      answer: 'يتطلب التطبيق Android 6.0 أو أحدث، و 2GB من الذاكرة العشوائية، و 100MB من مساحة التخزين.',
      category: 'technical',
    ),
    FAQItem(
      question: 'كيف يمكنني نسخ البيانات احتياطياً؟',
      answer: 'اذهب إلى الإعدادات > الخصوصية والأمان > النسخ الاحتياطي. يمكنك اختيار نسخ البيانات إلى التخزين السحابي أو محلياً.',
      category: 'backup',
    ),
    FAQItem(
      question: 'هل البيانات آمنة ومشفرة؟',
      answer: 'نعم، جميع البيانات مشفرة باستخدام تشفير AES-256 أثناء النقل والتخزين. نحن نتبع أعلى معايير الأمان لحماية بياناتك.',
      category: 'security',
    ),
  ];

  final List<ContactOption> contactOptions = [
    ContactOption(
      id: 'email',
      title: 'البريد الإلكتروني',
      subtitle: 'support@mdmapp.com',
      icon: Icons.email,
      color: AppTheme.primaryColor,
    ),
    ContactOption(
      id: 'phone',
      title: 'الهاتف',
      subtitle: '+966 50 123 4567',
      icon: Icons.phone,
      color: AppTheme.successColor,
    ),
    ContactOption(
      id: 'whatsapp',
      title: 'واتساب',
      subtitle: '+966 50 123 4567',
      icon: Icons.chat,
      color: AppTheme.accentColor,
    ),
    ContactOption(
      id: 'website',
      title: 'الموقع الإلكتروني',
      subtitle: 'www.mdmapp.com',
      icon: Icons.web,
      color: AppTheme.warningColor,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
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
    _feedbackController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _sendFeedback() {
    if (_feedbackController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى كتابة رسالتك أولاً'),
          backgroundColor: AppTheme.warningColor,
        ),
      );
      return;
    }

    // TODO: Send feedback to server
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('تم إرسال رسالتك بنجاح. سنرد عليك قريباً!'),
          ],
        ),
        backgroundColor: AppTheme.successColor,
      ),
    );

    _feedbackController.clear();
  }

  void _showTutorial() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        ),
        title: Row(
          children: [
            const Icon(Icons.school, color: AppTheme.primaryColor),
            const SizedBox(width: 8),
            const Text('دليل الاستخدام'),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '🚀 البدء السريع:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Text('1. أضف أجهزتك من قائمة "إدارة الأجهزة"'),
              Text('2. تأكد من تفعيل الأذونات المطلوبة'),
              Text('3. ابدأ في مراقبة وإدارة أجهزتك'),
              SizedBox(height: 16),
              Text(
                '📱 الميزات الأساسية:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Text('• مراقبة حالة الأجهزة في الوقت الفعلي'),
              Text('• إدارة التطبيقات عن بُعد'),
              Text('• تتبع مواقع الأجهزة'),
              Text('• إرسال أوامر التحكم'),
              Text('• إنشاء تقارير مفصلة'),
              SizedBox(height: 16),
              Text(
                '🔧 نصائح مفيدة:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Text('• استخدم البحث للعثور على الأجهزة بسرعة'),
              Text('• فعّل الإشعارات لتلقي التحديثات'),
              Text('• راجع الإعدادات لتخصيص التطبيق'),
              Text('• اعمل نسخ احتياطية دورية'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('فهمت'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('المساعدة والدعم'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // قسم البدء السريع
              _buildQuickStartCard(),

              const SizedBox(height: AppConstants.paddingLarge),

              // قسم الأسئلة الشائعة
              _buildSectionHeader('الأسئلة الشائعة', Icons.help_outline),
              const SizedBox(height: AppConstants.paddingMedium),
              _buildFAQCard(),

              const SizedBox(height: AppConstants.paddingLarge),

              // قسم التواصل
              _buildSectionHeader('تواصل معنا', Icons.contact_support),
              const SizedBox(height: AppConstants.paddingMedium),
              _buildContactCard(),

              const SizedBox(height: AppConstants.paddingLarge),

              // قسم إرسال الملاحظات
              _buildSectionHeader('إرسال ملاحظات', Icons.feedback),
              const SizedBox(height: AppConstants.paddingMedium),
              _buildFeedbackCard(),

              const SizedBox(height: AppConstants.paddingLarge),

              // قسم الموارد الإضافية
              _buildSectionHeader('موارد إضافية', Icons.library_books),
              const SizedBox(height: AppConstants.paddingMedium),
              _buildResourcesCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primaryColor, size: 24),
        const SizedBox(width: AppConstants.paddingSmall),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStartCard() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        boxShadow: AppTheme.elevatedShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.rocket_launch,
                color: AppTheme.textOnPrimary,
                size: 28,
              ),
              const SizedBox(width: AppConstants.paddingSmall),
              Text(
                'مرحباً بك!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppTheme.textOnPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          Text(
            'هل تحتاج مساعدة في البدء؟ نحن هنا لمساعدتك في كل خطوة.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.textOnPrimary.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: AppConstants.paddingLarge),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _showTutorial,
                  icon: const Icon(Icons.school),
                  label: const Text('دليل الاستخدام'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppTheme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppConstants.paddingMedium),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Open video tutorials
                  },
                  icon: const Icon(Icons.play_circle, color: Colors.white),
                  label: const Text('فيديوهات تعليمية', style: TextStyle(color: Colors.white)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white),
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
    );
  }

  Widget _buildFAQCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: faqItems.map((faq) {
          return ExpansionTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
              ),
              child: const Icon(
                Icons.help_outline,
                color: AppTheme.primaryColor,
                size: 20,
              ),
            ),
            title: Text(
              faq.question,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Text(
                  faq.answer,
                  style: const TextStyle(color: AppTheme.textSecondary),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildContactCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: contactOptions.map((option) {
          return Column(
            children: [
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: option.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                  ),
                  child: Icon(option.icon, color: option.color, size: 20),
                ),
                title: Text(
                  option.title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  option.subtitle,
                  style: const TextStyle(color: AppTheme.textSecondary),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // TODO: Handle contact option tap
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('فتح ${option.title}...'),
                      backgroundColor: option.color,
                    ),
                  );
                },
              ),
              if (option != contactOptions.last) _buildDivider(),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFeedbackCard() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'شاركنا رأيك',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: AppConstants.paddingSmall),
          const Text(
            'ملاحظاتك تساعدنا في تحسين التطبيق',
            style: TextStyle(color: AppTheme.textSecondary),
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          DropdownButtonFormField<String>(
            value: selectedCategory,
            decoration: InputDecoration(
              labelText: 'نوع الملاحظة',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
              ),
            ),
            items: const [
              DropdownMenuItem(value: 'general', child: Text('عام')),
              DropdownMenuItem(value: 'bug', child: Text('مشكلة تقنية')),
              DropdownMenuItem(value: 'feature', child: Text('اقتراح ميزة')),
              DropdownMenuItem(value: 'ui', child: Text('تحسين التصميم')),
            ],
            onChanged: (value) => setState(() => selectedCategory = value!),
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          TextField(
            controller: _feedbackController,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: 'رسالتك',
              hintText: 'اكتب ملاحظاتك أو اقتراحاتك هنا...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
              ),
            ),
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _sendFeedback,
              icon: const Icon(Icons.send),
              label: const Text('إرسال'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: AppTheme.textOnPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResourcesCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          _buildResourceTile(
            icon: Icons.article,
            title: 'دليل المستخدم',
            subtitle: 'دليل شامل لجميع ميزات التطبيق',
            onTap: () {
              // TODO: Open user manual
            },
            iconColor: AppTheme.primaryColor,
          ),
          _buildDivider(),
          _buildResourceTile(
            icon: Icons.video_library,
            title: 'مكتبة الفيديوهات',
            subtitle: 'شروحات مرئية لاستخدام التطبيق',
            onTap: () {
              // TODO: Open video library
            },
            iconColor: AppTheme.accentColor,
          ),
          _buildDivider(),
          _buildResourceTile(
            icon: Icons.forum,
            title: 'منتدى المجتمع',
            subtitle: 'تفاعل مع المستخدمين الآخرين',
            onTap: () {
              // TODO: Open community forum
            },
            iconColor: AppTheme.successColor,
          ),
          _buildDivider(),
          _buildResourceTile(
            icon: Icons.update,
            title: 'ملاحظات الإصدار',
            subtitle: 'اطلع على آخر التحديثات والميزات',
            onTap: () {
              // TODO: Show release notes
            },
            iconColor: AppTheme.warningColor,
          ),
        ],
      ),
    );
  }

  Widget _buildResourceTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color iconColor,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: AppTheme.textSecondary),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      color: AppTheme.dividerColor,
      indent: 16,
      endIndent: 16,
    );
  }
}

class FAQItem {
  final String question;
  final String answer;
  final String category;

  FAQItem({
    required this.question,
    required this.answer,
    required this.category,
  });
}

class ContactOption {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  ContactOption({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}

