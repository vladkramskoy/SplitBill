# 💸 SplitBill

![Swift](https://img.shields.io/badge/Swift-5.9-orange?logo=swift)
![SwiftUI](https://img.shields.io/badge/SwiftUI-✓-blue?logo=swift)
![iOS](https://img.shields.io/badge/iOS-17.6%2B-lightgrey?logo=apple)
![Architecture](https://img.shields.io/badge/Архитектура-MVVM-green)
![Firebase](https://img.shields.io/badge/Firebase-Analytics%20%7C%20Crashlytics-orange?logo=firebase)
![License](https://img.shields.io/badge/Лицензия-MIT-blue)

> **SplitBill** — iOS-приложение на SwiftUI для удобного разделения счёта между друзьями и гостями. Три гибких режима расчёта, поддержка множества валют и чаевых — всё в одном приложении.

---

## 📸 Скриншоты

| Участники | Сумма счёта | Режим разделения | Результат |
|:---------:|:-----------:|:----------------:|:---------:|
| <!-- Добавьте скриншот сюда --> | <!-- Добавьте скриншот сюда --> | <!-- Добавьте скриншот сюда --> | <!-- Добавьте скриншот сюда --> |

---

## ✨ Возможности

### 👥 Участники
- Добавление любого количества участников с именами
- Каждому участнику автоматически присваивается уникальный цвет для удобной идентификации

### 💰 Ввод суммы счёта
- Ввод общей суммы счёта
- Расчёт чаевых двумя способами:
  - **Процент** — указать процент от суммы
  - **Фиксированная сумма** — указать конкретную сумму чаевых

### ➗ Три режима разделения счёта

| Режим | Описание |
|-------|----------|
| **Поровну** | Равномерное разделение итоговой суммы между всеми участниками |
| **По блюдам** | Разделение по конкретным позициям: название с эмодзи, количество, цена за единицу; каждую единицу можно назначить нескольким плательщикам |
| **По деньгам** | Произвольное распределение — вручную указать сумму для каждого участника |

### 🌍 Поддержка валют
- **12 популярных валют**: USD, EUR, RUB, GBP, TRY, THB, AED, JPY, IDR, CNY, KZT, GEL
- Полный список валют по стандарту ISO
- Валюта по умолчанию — RUB

### 📤 Результаты и шаринг
- Наглядное отображение доли каждого участника
- Возможность поделиться результатами расчёта (поровну, по блюдам, по деньгам)
- Встроенное модальное окно для шаринга

### 🎓 Онбординг
- Приветственный онбординг при первом запуске
- Подсказки для режима «По блюдам»
- Подсказки для режима «По деньгам»

---

## 🛠 Технический стек

| Технология | Назначение |
|------------|-----------|
| **Swift** | Язык разработки |
| **SwiftUI** | UI-фреймворк |
| **Observation (`@Observable`)** | Управление состоянием |
| **Firebase Analytics** | Аналитика пользовательских действий |
| **Firebase Crashlytics** | Мониторинг ошибок и крэшей |
| **NavigationPath** | Программная навигация |

---

## 🏗 Архитектура проекта

Приложение построено по паттерну **MVVM** (Model-View-ViewModel) с централизованным роутером.

```
SplitBill/
├── SplitBillApp.swift              # Точка входа, настройка Firebase
├── Model/                          # Модели данных
│   ├── Participant.swift           # Участник (имя, цвет)
│   ├── BillItem.swift              # Позиция счёта
│   ├── BillUnit.swift              # Единица позиции счёта
│   ├── PaymentShare.swift          # Доля оплаты участника
│   ├── Currency.swift              # Валюты (популярные + ISO)
│   └── TipCalculationType.swift    # Тип расчёта чаевых (% или сумма)
├── View/                           # UI-слой (SwiftUI Views)
│   ├── ContentView.swift           # Корневое представление
│   ├── ParticipantView.swift       # Экран добавления участников
│   ├── BillAmountView.swift        # Экран ввода суммы и чаевых
│   ├── SplitMethodView.swift       # Экран выбора режима разделения
│   ├── EqualSplitView.swift        # Режим «Поровну»
│   ├── ItemizedSplitView.swift     # Режим «По блюдам»
│   ├── CustomSplitView.swift       # Режим «По деньгам»
│   ├── CurrencyPickerView.swift    # Выбор валюты
│   └── Onboarding/
│       ├── WelcomeOnboarding/      # Приветственный онбординг
│       ├── ItemizedSplitOnboarding/# Онбординг «По блюдам»
│       ├── CustomSplitOnboarding/  # Онбординг «По деньгам»
│       └── Shared/                 # Общие компоненты онбординга
├── ViewModel/                      # Бизнес-логика
│   ├── ParticipantViewModel.swift
│   ├── BillAmountViewModel.swift
│   ├── ItemizedSplitViewModel.swift
│   └── CustomSplitViewModel.swift
├── Navigation/
│   ├── Router.swift                # Централизованный роутер
│   └── RouterViewModifier.swift
├── Services/
│   ├── AnalyticsService.swift      # Firebase-аналитика
│   ├── BillSession.swift           # Главное состояние сессии
│   ├── ShareService.swift          # Шаринг результатов
│   ├── OnboardingManager.swift     # Управление онбордингом
│   ├── DecimalFormatter.swift      # Форматирование чисел
│   └── ValidationService.swift     # Валидация ввода
├── DesignSystem/
│   ├── Components/                 # Переиспользуемые UI-компоненты
│   └── Tokens/
│       └── Colors.swift            # Цветовые токены
├── Extensions/
│   ├── BillSession+Sharing.swift   # Расширение для шаринга
│   └── DecimalFormatterKey.swift
└── Utilities/                      # Вспомогательные утилиты
```

---

## 🧭 Навигация в приложении

Навигация реализована через кастомный `Router` с использованием `NavigationPath` (programmatic navigation).

```
[Запуск приложения]
        │
        ▼
┌───────────────────┐
│  ParticipantView  │  ← Добавление участников
└────────┬──────────┘
         │ navigateToBillAmount()
         ▼
┌───────────────────┐
│  BillAmountView   │  ← Ввод суммы счёта и чаевых
└────────┬──────────┘
         │ navigateToSplitMethod()
         ▼
┌─────────────────────────────────────────────────┐
│               SplitMethodView                   │
│  ┌─────────────┬─────────────┬───────────────┐  │
│  │ EqualSplit  │ItemizedSplit│  CustomSplit  │  │
│  │  (Поровну)  │(По блюдам) │ (По деньгам) │  │
│  └─────────────┴─────────────┴───────────────┘  │
└─────────────────────────────────────────────────┘
```

---

## 🚀 Установка и запуск

### Требования
- **Xcode** 15.0 или новее
- **iOS** 17.6+
- **Swift** 5.9+
- Аккаунт Firebase (для Analytics и Crashlytics)

### Шаги

1. **Клонируйте репозиторий:**
   ```bash
   git clone https://github.com/vladkramskoy/SplitBill.git
   cd SplitBill
   ```

2. **Настройте Firebase:**
   - Создайте проект в [Firebase Console](https://console.firebase.google.com/)
   - Добавьте iOS-приложение с bundle ID вашего проекта
   - Скачайте файл `GoogleService-Info.plist`
   - Поместите его в папку `SplitBill/` (рядом с `Info.plist`)

3. **Откройте проект в Xcode:**
   ```bash
   open SplitBill.xcodeproj
   ```

4. **Выберите симулятор или реальное устройство** с iOS 17.6+ и нажмите **Run (⌘R)**

> **Примечание:** Без файла `GoogleService-Info.plist` приложение не скомпилируется. Если Firebase не нужен, удалите соответствующие зависимости из проекта.

---

## 📋 Требования

| Параметр | Значение |
|----------|----------|
| iOS | 17.6+ |
| Xcode | 15.0+ |
| Swift | 5.9+ |
| Архитектура | arm64 (iPhone, iPad) |

---

## 📄 Лицензия

<!-- Добавьте информацию о лицензии -->

Этот проект распространяется под лицензией **MIT**. Подробнее см. в файле [LICENSE](LICENSE).

---

## 👤 Автор

**Vladislav Kramskoy**

- GitHub: [@vladkramskoy](https://github.com/vladkramskoy)
