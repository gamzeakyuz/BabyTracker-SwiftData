**🍼 BabyTracker - Akıllı Bebek Gelişim Takipçisi**

[![Swift](https://img.shields.io/badge/Swift-5.10-orange.svg?style=flat&logo=swift)](https://developer.apple.com/swift/)
[![Platform](https://img.shields.io/badge/Platform-iOS%2017.0%2B-blue.svg?style=flat&logo=apple)](https://developer.apple.com/ios/)
[![Storage](https://img.shields.io/badge/Storage-SwiftData-lightgrey.svg?style=flat&logo=icloud)](https://developer.apple.com/xcode/swiftdata/)
[![Charts](https://img.shields.io/badge/Charts-Swift%20Charts-red.svg?style=flat)](https://developer.apple.com/documentation/charts)
[![License](https://img.shields.io/badge/License-MIT-green.svg?style=flat)](LICENSE)

**BabyTracker**, ebeveynlerin bebeklerinin günlük rutinlerini, fiziksel gelişimlerini ve sağlık süreçlerini takip etmelerini sağlayan kapsamlı, **çevrimdışı öncelikli (offline-first)** bir iOS uygulamasıdır.

En güncel Apple teknolojileri (**SwiftUI, SwiftData, Swift Charts**) kullanılarak geliştirilmiş; **MVVM** mimarisi, **Unit/UI Testleri** ve **Clean Code** prensiplerine sadık kalınarak tasarlanmıştır.

---

## 📱 Ekran Görüntüleri

| Splash View / OnBoarding | Ana Akış (Timeline) | Create Profile | Edit Profile |
|:----:|:----:|:----:|:----:|
| <img src="https://github.com/user-attachments/assets/5e676855-cfc3-46f7-aca7-9c219630f635" width="220"/> | <img src="https://github.com/user-attachments/assets/16c00b8b-7b1b-4910-a536-30d91561bfc3" width="220"/> | <img src="https://github.com/user-attachments/assets/8f0352d7-0ed8-483b-ab38-5c91a62bb575" width="220"/> | <img src="https://github.com/user-attachments/assets/2ff5086d-157e-4cb0-9a82-8a59b0c5b68b" width="220"/> |

| Daily Routine View | Growth Chart | Healht & Vaccitinations | Teething Schedule |
|:----:|:----:|:----:|:----:|
| <img src="https://github.com/user-attachments/assets/d7ee5229-953b-4527-a449-abd053f89646" width="220"/> | <img src="https://github.com/user-attachments/assets/86fdccfc-d669-429c-9db7-9319c20b0333" width="220"/> | <img src="https://github.com/user-attachments/assets/cab3979e-62af-4f95-b623-3e321fa823a8" width="220"/> | <img src="https://github.com/user-attachments/assets/4805e9da-412d-4724-b31a-3f4ed1d9182c" width="220"/>

| Milestones View | Notifications Settings | Notifications |  |
|:----:|:----:|:----:|:----:|
| <img src="https://github.com/user-attachments/assets/404db0d4-25a3-45d8-a56a-6e733e3c083b" width="220"/> | <img src="https://github.com/user-attachments/assets/4d274482-2b89-4e16-b266-3932aca166ba" width="220"/> | <img src="https://github.com/user-attachments/assets/d3e1a0ef-f45f-4c3b-95e2-981588cfcdda" width="220"/> |


---

## ✨ Temel Özellikler

### 🗓️ Günlük Rutin Yönetimi
* **Detaylı Takip:** Beslenme (Anne Sütü/Mama), Uyku, Alt Değiştirme ve Ek Gıda kayıtları.
* **Akıllı Listeleme:** Kayıtlar günlere göre otomatik gruplanır, özet bilgiler (toplam ml, süre vb.) başlıkta gösterilir.
* **Hızlı Aksiyonlar:** Listeden kaydırma hareketiyle (Swipe Actions) silme ve düzenleme.

### 📈 Büyüme Analizi (Swift Charts)
* **WHO Standartları:** Bebeğin verileri, Dünya Sağlık Örgütü'nün (WHO) persentil eğrileriyle karşılaştırmalı olarak çizilir.
* **Dinamik Grafikler:** Kilo, Boy ve Baş Çevresi için `SegmentedPicker` ile anlık grafik değişimi.
* **Görsel Tutarlılık:** Veri noktaları ve referans eğrileri için özelleştirilmiş `Chart` bileşenleri.

### 🩺 Sağlık ve Hatırlatıcılar
* **Aşı Takvimi:** Aylara göre yapılması gereken aşıların takibi.
* **Diş Çıkarma:** Görsel ağız şeması üzerinde çıkan dişlerin işaretlenmesi.
* **Bildirimler:** İlaç ve rutinler için zengin içerikli (görselli) yerel bildirimler.

---

## 🛠️ Teknik Altyapı ve Mimari

Proje **%100 SwiftUI** ile geliştirilmiştir ve modern iOS geliştirme pratiklerini içerir.

* **SwiftData & Persistence:** * Veri modellemesi için `@Model` makroları.
  * Klasör izin hatalarını önleyen özel `FileManager` ve `ModelContainer` başlatma (init) mekanizması.
* **Swift Charts:**
  * Karmaşık veri setlerini görselleştirmek için `LineMark` ve `RuleMark` kullanımı.
  * `CatmullRom` interpolasyonu ile pürüzsüz eğriler.
* **Mimari Yaklaşım:**
  * **View Extraction:** Karmaşık görünümler (`DailyRoutineView`, `AddLogSheet`) alt bileşenlere ayrıldı.
  * **Reusable Modifiers:** Kartlar (`CardModifier`) ve etiketler (`TagStyle`) için özel ViewModifier'lar.
  * **Extensions:** Tarih formatlama ve String dönüşümleri için merkezi uzantılar.
* **Test Otomasyonu:**
  * **XCTest:** Profil oluşturma ve veri ekleme akışlarını doğrulayan UI Testleri.
  * `accessibilityIdentifier` kullanılarak test edilebilir UI tasarımı.

---
