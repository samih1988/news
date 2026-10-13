# 📜 معايير وقواعد تطوير مشاريع فلاتر (Flutter Architecture & Development Rules)

### النمط المعتمد: Advanced MVVM + Repository Pattern (Modular & Clean)

هذا الملف يحدد **القواعد البرمجية الصارمة (Rules & Standards)** التي يجب اتباعها في أي مشروع
Flutter، لضمان إنتاج كود نظيف، قابل للاختبار، سهل الصيانة، وبمعايير الشركات الكبرى (
Enterprise-Level).

---

## 🏛️ القاعدة 1: فلسفة فصل المسؤوليات (Separation of Concerns)

يجب الالتزام الصارم بالدور الوظيفي المحدد لكل طبقة:

| المكوّن                  | المسؤولية المسموح بها                                                                                                             | ما يُمنع عليه منعاً باتاً                                                      |
|:-------------------------|:----------------------------------------------------------------------------------------------------------------------------------|:-------------------------------------------------------------------------------|
| **Model**                | مجرد وعاء للبيانات (DTO) يحتوي فقط على `fromJson` و `toJson` و الحقول.                                                            | ممنوع كتابة أي منطق أعمال (Business Logic) أو شروط برمجية بداخله.              |
| **Remote DataSource**    | الاتصال بالـ API الخارجي فقط وتنفيذ الـ HTTP Requests واسترجاع الـ Models.                                                        | ممنوع فحص الاتصال بالإنترنت، ممنوع التعامل مع الكاش، وممنوع إرجاع كلاسات UI.   |
| **Local DataSource**     | القراءة والكتابة في قاعدة البيانات المحلية (Hive / SQLite / SharedPreferences).                                                   | ممنوع إغلاق الـ Box، وممنوع إرجاع Non-nullable في دوال القراءة.                |
| **Repository**           | قائد البيانات والمترجم الوحيد: يقرر متى يجلب من السيرفر ومتى يجلب من الكاش، وهو المسؤول الحصري عن ترجمة كل المشاكل إلى `Failure`. | ممنوع إطلاق أي Exception غير معالج لأعلى، وممنوع استدعاء أي كود متعلق بالـ UI. |
| **Cubit / Bloc**         | إدارة حالات الشاشة (Loading, Success, Error) واستقبال أحداث المستخدم.                                                             | ممنوع فحص الـ JSON، ممنوع معرفة تفاصيل الـ API، وممنوع كتابة `try/catch`.      |
| **UI (Screen / Widget)** | الرسم والعرض بناءً على الـ States، وتمرير نقرات المستخدم للـ Cubit.                                                               | ممنوع طلب الداتا مباشرة من الـ Repository أو الـ DataSource.                   |

---

## 📁 القاعدة 2: الهيكل الموحد للمجلدات (Universal Folder Structure)

جميع المشاريع يجب أن تنظم بهذه الطريقة:

```
lib/
├── core/                         # الخدمات المشتركة لكل التطبيق
│   ├── di/                       # تهيئة الـ Dependency Injection (Injectable)
│   ├── errors/                   # كلاسات الـ Failures الموحدة
│   ├── network/                  # عميل Dio والـ Interceptors
│   ├── storage/                  # إعدادات التخزين المحلي (Hive, SharedPrefs)
│   ├── theme/                    # الألوان والخطوط والثيم
│   ├── utils/                    # الروابط، الثوابت العامة، دوال مساعدة
│   └── widgets/                  # الودجتس العامة المشتركة
│
├── data/                         # طبقة البيانات
│   ├── models/                   # الـ DTOs لكل الميزات
│   ├── datasources/
│   │   ├── local/                # الـ Interfaces والـ Implementations للكاش
│   │   └── remote/               # الـ Interfaces والـ Implementations للـ API
│   └── repositories/             # الـ Interfaces والـ Implementations للـ Repositories
│
└── ui/                           # طبقة واجهة المستخدم (مقسمة حسب الميزة Feature-First)
    └── [feature_name]/
        ├── cubit/                # الـ Cubit وحالاته للميزة
        ├── widgets/              # الودجتس الخاصة بهذه الشاشة فقط
        └── [feature]_screen.dart # الشاشة الرئيسية
```

---

## 🛡️ القاعدة 3: إدارة الأخطاء الصارمة (Strict Error Handling)

1. **إلزامية نمط `Either<Failure, T>`:**
    * جميع دوال الـ Repositories يجب أن تعيد `Future<Either<Failure, T>>` حصراً.
    * يُمنع استخدام `throw` لإرسال أخطاء إلى الـ Cubit.
2. **شجرة الـ Failures الأساسية (في `core/errors/failures.dart`):**
   ```dart
   abstract class Failure {
     final String message;
     const Failure(this.message);
   }

   class ServerFailure extends Failure {
     const ServerFailure(super.message);
   }

   class NetworkFailure extends Failure {
     const NetworkFailure([super.message = "لا يوجد اتصال بالإنترنت"]);
   }

   class CacheFailure extends Failure {
     const CacheFailure([super.message = "لا توجد بيانات مخزنة محلياً"]);
   }
   ```
3. **أولوية استخراج رسائل الأخطاء في الـ Repository:**
    * **الأولوية الأولى:** استخراج رسالة الـ Backend من الـ Response Body (مثل:
      `response.status == 'error'` أو `dioError.response.data['message']`).
    * **الأولوية الثانية:** أخطاء الشبكة والـ Timeout (مثل: انقطاع الاتصال) تُحوّل إلى
      `NetworkFailure` أو `ServerFailure` برسالة واضحة.
    * **الأولوية الثالثة:** أي استثناء غير متوقع يُلف في `ServerFailure`.
4. **في الـ Cubit:**
    * يُمنع كتابة `try / catch` للعمليات التي تعود بـ `Either`.
    * يتم استهلاك النتيجة حصراً باستخدام دالة `.fold()`:
   ```dart
   result.fold(
     (failure) => emit(FeatureErrorState(errorMessage: failure.message)),
     (data) => emit(FeatureSuccessState(data: data)),
   );
   ```

---

## 💾 القاعدة 4: قواعد التخزين المحلي (Local Caching Rules)

1. **منع إغلاق الصناديق:** يُمنع استدعاء `box.close()` داخل دوال الـ Data Source. الصناديق تبقى
   مفتوحة طوال فترة عمل التطبيق.
2. **أمان القيم الفارغة (Null-Safety):** دوال جلب البيانات من الكاش يجب أن تعيد دائماً قيمة تقبل الـ
   Null:
   ```dart
   Future<FeatureModel?> getCachedFeature(String id);
   ```
3. **تسجيل الـ Adapters:**
    * عند استخدام كائنات مخصصة مع Hive، يجب توليد الـ Adapter باستخدام `build_runner`.
    * يجب استدعاء تسجيل الـ Adapters فوراً في `main.dart` بعد تهيئة الـ Hive وقبل تشغيل الواجهات.
4. **سلوك الكاش عند عدم وجود إنترنت:**
    * إذا وُجدت بيانات في الكاش ⬅ تُعاد كـ `Right(cachedData)`.
    * إذا لم توجد بيانات في الكاش ⬅ يُعاد `Left(CacheFailure("رسالة واضحة للمستخدم"))`.

---

## 💉 القاعدة 5: إدارة الاعتماديات (Dependency Injection Rules)

1. الاعتماد كلياً على `injectable` و `get_it`.
2. **الـ DataSources والـ Repositories:** تُسجل دائماً كـ Factory مع تحديد الـ Interface الخاص بها:
   ```dart
   @Injectable(as: FeatureRemoteDataSource)
   class FeatureRemoteDataSourceImpl implements FeatureRemoteDataSource { ... }

   @Injectable(as: FeatureRepository)
   class FeatureRepositoryImpl implements FeatureRepository { ... }
   ```
3. **الـ Cubits:** تُسجل دائماً بـ:
   ```dart
   @injectable
   class FeatureCubit extends Cubit<FeatureState> { ... }
   ```
4. **خدمات الشبكة والتخزين الموحدة (Dio, SharedPreferences):** تُسجل دائماً كـ Singleton:
   ```dart
   @singleton
   class DioClient { ... }
   ```
5. تشغيل أمر التوليد بعد أي تعديل في الـ Annotations:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

---

## 🔄 القاعدة 6: إدارة دورة حياة الـ State في الـ UI

1. **الـ States الموحدة لأي ميزة:**
    * `FeatureInitialState`
    * `FeatureLoadingState`
    * `FeatureSuccessState` (تحتوي على البيانات فقط)
    * `FeatureErrorState` (تحتوي على `String errorMessage` فقط)
2. **توفير الـ Cubit للشاشات:**
    * يُفضل توفير الـ Cubit عبر `BlocProvider` في أعلى الشاشة:
      ```dart
      BlocProvider(
        create: (context) => getIt<FeatureCubit>()..loadData(),
        child: const FeatureView(),
      )
      ```
    * في حال تم الاحتفاظ بـ Instance للـ Cubit داخل `StatefulWidget`، يجب إلزامياً استدعاء
      `cubit.close()` داخل `dispose()`.

---

## 🧼 القاعدة 7: الكود النظيف والتسميات (Clean Code Guidelines)

1. **التسميات (Conventions):**
    * أسماء الملفات والمجلدات: `snake_case` (مثال: `product_repository_impl.dart`).
    * أسماء الكلاسات: `PascalCase` (مثال: `ProductRepositoryImpl`).
    * أسماء المتغيرات والدوال: `camelCase` (مثال: `getProductById`).
2. **حظر الكود الميت (Zero Dead Code):**
    * يُمنع ترك ملفات قديمة غير مستخدمة أو أكواد معطلة بـ Comments في الكود النهائي.
    * إزالة أي `unused import` فور ظهورها.
3. **منع الأرقام والنصوص السحرية (No Magic Strings / Numbers):**
    * نصوص الـ Endpoints والـ BaseUrls توضع في ملف ثوابت موحد داخل `core/network/`.
    * مفاتيح التخزين (Storage Keys) توضع في ثوابت داخل `core/storage/`.
4. **قاعدة الوظيفة الواحدة (Single Responsibility):**
    * أي دالة تتجاوز 40 سطراً يجب مراجعتها وتفكيكها إلى دوال أصغر تؤدي كل واحدة منها وظيفة واحدة
      محددة.

---

> 🎯 **الهدف الدائم:** هذه القواعد هي المعيار الإلزامي لكل تطبيق نبنيه، وعند تطبيقها يخرج المشروع
> متماسكاً، احترافياً، وبأعلى معايير الـ Architecture.
