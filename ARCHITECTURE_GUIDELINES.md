# 🚀 دليل المعمارية البرمجية والمعايير النظيفة (Flutter Clean Architecture Blueprint)

### المستوى: Advanced MVVM + Repository Pattern (بدون تعقيد الـ Domain Layer)

هذا الملف هو **المرجع الدائم** لمعمارية المشاريع الخاصة بك، ومصمم ليكون دليلك الشامل ولأي أداة AI أو
مبرمج يعمل معك في المشاريع القادمة لتطبيق أعلى معايير الجودة والـ Clean Code فوراً.

---

## 📁 1. الهيكل النموذجي للمشروع (Folder Structure)

```
lib/
├── core/                         # كل ما هو مشترك ومساعد لكل التطبيق
│   ├── di/                       # ملف تهيئة الـ Dependency Injection (di_config.dart)
│   ├── errors/                   # كلاسات معالجة الأخطاء (Failures & Exceptions)
│   ├── network/                  # إعدادات Dio والـ Interceptors وروابط الـ Endpoints
│   ├── storage/                  # إعدادات وتخزين Hive و SharedPreferences
│   ├── theme/                    # الألوان والخطوط والـ AppTheme
│   ├── utils/                    # الثوابت (Constants) والـ Routes والـ Extensions
│   └── widgets/                  # الودجتس العامة المشتركة (Loading, Error, Buttons, etc.)
│
├── data/                         # طبقة البيانات ومصادرها
│   ├── models/                   # الموديلات (DTOs) التي تحتوي على fromJson و toJson و Hive Adapters
│   ├── datasources/
│   │   ├── local/                # مصادر البيانات المحلية (Hive)
│   │   │   ├── [feature]_local_data_source.dart
│   │   │   └── impl/[feature]_local_data_source_impl.dart
│   │   └── remote/               # مصادر البيانات عن بعد (Dio / API)
│   │       ├── [feature]_remote_data_source.dart
│   │       └── impl/[feature]_remote_data_source_impl.dart
│   └── repositories/             # إدارة وتنسيق مصادر البيانات
│       ├── [feature]_repository.dart
│       └── impl/[feature]_repository_impl.dart
│
└── ui/                           # طبقة واجهة المستخدم (مقسمة حسب الميزات Feature-First)
    └── [feature_name]/
        ├── cubit/                # إدارة الحالة الخاصة بالميزة (Cubit & States)
        ├── widgets/              # الودجتس الخاصة بهذه الشاشة فقط
        └── [feature]_screen.dart # الشاشة الرئيسية
```

---

## 🛡️ 2. التعامل الاحترافي مع الأخطاء (Either & Failures)

بدلاً من استخدام `throw Exception` الذي يؤدي لكراش التطبيق عند عدم توقعه، نستخدم نمط
`Either<Failure, T>` من حزمة `dartz`:

### أ) كلاسات الـ Failures (توضع في `core/errors/failures.dart`):

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

### ب) شكل دالة الـ Repository:

```dart
abstract class NewsRepository {
  Future<Either<Failure, NewsResponse>> getNews(String sourceId);
}
```

### ج) تنفيذ الـ Repository مع معالجة الأخطاء:

```dart
@Injectable(as: NewsRepository)
class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remoteDataSource;
  final NewsLocalDataSource localDataSource;

  NewsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, NewsResponse>> getNews(String sourceId) async {
    final connectivity = await Connectivity().checkConnectivity();
    final hasInternet = connectivity.contains(ConnectivityResult.mobile) ||
                        connectivity.contains(ConnectivityResult.wifi);

    if (hasInternet) {
      try {
        final response = await remoteDataSource.getNews(sourceId);

        // 1️⃣ فحص إذا كان الـ API رجع خطأ داخل الـ Body (مثل status == error):
        if (response.status == 'error') {
          return Left(ServerFailure(response.message ?? "حدث خطأ من السيرفر"));
        }

        // حفظ في الكاش وإرجاع النجاح:
        await localDataSource.saveNews(response, sourceId);
        return Right(response);

      } on DioException catch (dioError) {
        // 2️⃣ استخراج رسالة الخطأ القادمة من الـ API (مثل 400, 401, 404):
        if (dioError.response?.data != null && dioError.response?.data['message'] != null) {
          return Left(ServerFailure(dioError.response!.data['message']));
        } else if (dioError.type == DioExceptionType.connectionTimeout) {
          return Left(ServerFailure("انتهت مهلة الاتصال بالسيرفر، تأكد من سرعة النت"));
        } else {
          return Left(NetworkFailure("تعذر الاتصال بالسيرفر، تأكد من اتصالك"));
        }

      } catch (e) {
        // 3️⃣ أي خطأ برمجي غير متوقع:
        return Left(ServerFailure("حدث خطأ غير متوقع: ${e.toString()}"));
      }
    } else {
      try {
        final cachedData = await localDataSource.getNews(sourceId);
        if (cachedData != null) {
          return Right(cachedData);
        } else {
          return Left(CacheFailure("لا توجد أخبار مخزنة مسبقاً لهذا المصدر"));
        }
      } catch (e) {
        return Left(CacheFailure("فشل قراءة البيانات المخزنة: ${e.toString()}"));
      }
    }
  }
}
```

### د) استهلاك النتيجة في الـ Cubit بسهولة:

```dart
void getNews(String sourceId) async {
  emit(NewsLoadingState());
  final result = await newsRepository.getNews(sourceId);
  result.fold(
    (failure) => emit(NewsErrorState(errorMessage: failure.message)),
    (data) => emit(NewsSuccessState(news: data.articles ?? [])),
  );
}
```

---

## 💾 3. القواعد الذهبية للتعامل مع Hive (Local Caching)

1. **لا تغلق الـ Box أبداً داخل الدوال:** تجنب تماماً كتابة `await box.close()` داخل الـ Data
   Source. الـ Box يجب أن يظل مفتوحاً للاستخدام المستمر.
2. **الـ Null-Safety:** يجب أن يكون نوع إرجاع دوال الـ Local دائماً يقبل `null` (مثل:
   `Future<NewsResponse?>`) للتعامل الآمن مع عدم وجود كاش مسبق.
3. **توليد الـ Adapters:**
    - ضع الموديلات دائماً في ملف الـ adapters:
   ```dart
   @GenerateAdapters([AdapterSpec<MyModel>()])
   ```
    - نفذ أمر التوليد:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```
    - سجل الـ Adapters في `main.dart` فوراً بعد `Hive.initFlutter()`.

---

## 💉 4. إدارة الاعتماديات (Dependency Injection - Injectable & GetIt)

1. **الـ Data Source:**
   ```dart
   @Injectable(as: FeatureRemoteDataSource)
   class FeatureRemoteDataSourceImpl implements FeatureRemoteDataSource { ... }
   ```
2. **الـ Repository:**
   ```dart
   @Injectable(as: FeatureRepository)
   class FeatureRepositoryImpl implements FeatureRepository { ... }
   ```
3. **الـ Cubit:**
   ```dart
   @injectable
   class FeatureCubit extends Cubit<FeatureState> { ... }
   ```
4. **الـ Singletons (للخدمات المشتركة مثل Dio أو Prefs):**
   ```dart
   @singleton
   class DioManager { ... }
   ```

---

## 🖥️ 5. دورة حياة الـ Cubit في الـ UI (Lifecycle & Best Practices)

- **الطريقة القياسية لتمرير الـ Cubit للشاشة:**
  ```dart
  class NewsScreen extends StatelessWidget {
    final String sourceId;
    const NewsScreen({super.key, required this.sourceId});

    @override
    Widget build(BuildContext context) {
      return BlocProvider(
        create: (context) => getIt<NewsCubit>()..getNews(sourceId),
        child: const NewsView(),
      );
    }
  }
  ```
- **إذا تم إنشاء الـ Cubit داخل `StatefulWidget`:**
  يجب دائماً استدعاء `close()` داخل ميثود `dispose`:
  ```dart
  @override
  void dispose() {
    myCubit.close();
    super.dispose();
  }
  ```

---

## 🧹 6. معايير الـ Clean Code العامة

* **تسمية الملفات والمجلدات:** بحروف صغيرة مع شرطة سفلية `snake_case` (مثال:
  `news_repository_impl.dart`).
* **تسمية الكلاسات:** بحروف كبيرة لكل كلمة `PascalCase` (مثال: `NewsRepositoryImpl`).
* **تسمية المتغيرات والدوال:** بأول حرف صغير `camelCase` (مثال: `getNewsBySourceId`).
* **منع الكود الميت (Dead Code):** لا تترك ملفات أو أسطر معطلة (Commented Out) في المشروع النهائي.
* **فصل الـ UI عن المنطق:** أي كود يتضمن طلبات شبكة أو منطق أعمال يكون مكانه الـ Cubit، والـ Widget
  وظيفتها العرض فقط.

---

> 📌 **ملاحظة للمستقبل:** هذا الدليل هو الـ Blueprint المعتمد. عند بدء أي مشروع جديد، يمكنك نسخ هذا
> الملف أو الإشارة إليه، وسيتم بناء المشروع فوراً على هذه الأسس.
