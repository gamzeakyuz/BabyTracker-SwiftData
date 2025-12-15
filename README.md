[![Swift](https://img.shields.io/badge/Swift-5.10-orange.svg?style=flat&logo=swift)](https://developer.apple.com/swift/)
[![Platform](https://img.shields.io/badge/Platform-iOS%2017.0%2B-blue.svg?style=flat&logo=apple)](https://developer.apple.com/ios/)
[![Storage](https://img.shields.io/badge/Storage-SwiftData-lightgrey.svg?style=flat&logo=icloud)](https://developer.apple.com/xcode/swiftdata/)
[![Charts](https://img.shields.io/badge/Charts-Swift%20Charts-red.svg?style=flat)](https://developer.apple.com/documentation/charts)
[![License](https://img.shields.io/badge/License-MIT-green.svg?style=flat)](LICENSE)

**🍼 BabyTracker - Smart Baby Development Tracker**

**BabyTracker** is a comprehensive **offline-first** iOS application that enables parents to track their babies’ daily routines, physical development, and health processes.

It is developed using the latest Apple technologies **(SwiftUI, SwiftData, Swift Charts)** and designed in accordance with **MVVM architecture, Unit/UI Tests, and Clean Code principles.**

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
## ✨ Key Features

### 🗓️ Daily Routine & Data Management
* **Detailed Tracking:** Feeding (Breast Milk / Formula), Sleep, Diaper Changes, and Solid Food logs.
* **Practical Data Management:** Any listed record (feeding, sleep, etc.) can be easily deleted via a **Long Press** menu.
* **Profile Management:** Users can permanently delete the baby profile and **all associated historical data with a single tap**.

### 🎨 UX
* **Dark & Light Mode:** Automatically adapts to system settings, with **Dark Mode** support to reduce eye strain during night feedings.
* **Smart Listing:** Records are automatically grouped by day, with summary information (total ml, duration, etc.) displayed in headers.
* **Visual Cues:** Customized icons and color codes for each activity type.

### 📈 Growth Analysis (Swift Charts)
* **WHO Standards:** Baby’s data is plotted against World Health Organization (WHO) percentile curves for comparison.
* **Dynamic Charts:** Instant chart switching for Weight, Height, and Head Circumference using `SegmentedPicker`
* **Visual Consistency:** Customized `Chart` components for data points and reference curves.

### 🩺 Health & Reminders
* **Vaccination Schedule:** Track required vaccinations by month.
* **Teething:** Mark emerging teeth on a visual mouth diagram.
* **Notifications:** Rich local notifications (with visuals) for medications and routines.

---

## 🛠️ Technical Infrastructure & Architecture

* **SwiftData & Persistence:**
* * `@Model`  macros for data modeling.
  * Custom `FileManager` and `ModelContainer` initialization mechanisms to prevent folder permission errors.
* **Swift Charts:**
  * Use of `LineMark` and `RuleMark` for visualizing complex datasets.
  * Smooth curves with `CatmullRom` interpolation.
* **Architectural Approach:**
  * **View Extraction:** Complex views (`DailyRoutineView`, `AddLogSheet`) are broken down into subcomponents.
  * **Reusable Modifiers:** Custom ViewModifiers for cards (`CardModifier`) ve tags (`TagStyle`)
  * **Extensions:** Centralized extensions for date formatting and string conversions.
* **Test Automation:**
  * **XCTest:** UI tests validating profile creation and data entry flows.
  *  Testable UI design using `accessibilityIdentifier`.

---
