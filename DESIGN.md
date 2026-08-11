---
name: Умный Водитель
description: Дизайн-система рабочего приложения водителя «Умная логистика»
colors:
  primary: "#FE4500"
  primary-light-1: "#FE6A33"
  primary-light-2: "#FE8F66"
  blue: "#337FFF"
  green-web: "#00F55F"
  error: "#D32F2F"
  graphite: "#25252A"
  gray-dark: "#57575C"
  gray-mid: "#888B8F"
  gray: "#B2B7BC"
  gray-light: "#CBD0D6"
  gray-lighter: "#DAE0E5"
  white: "#FFFFFF"
  paper-warm: "#FFFFFCF7"
typography:
  display:
    fontFamily: "Bebas Neue, sans-serif"
    fontSize: "40px"
    fontWeight: 400
    lineHeight: 1.1
    letterSpacing: "0.5px"
  headline:
    fontFamily: "Montserrat, sans-serif"
    fontSize: "28px"
    fontWeight: 700
    lineHeight: 1.25
  title:
    fontFamily: "Montserrat, sans-serif"
    fontSize: "18px"
    fontWeight: 600
    lineHeight: 1.35
  body:
    fontFamily: "Montserrat, sans-serif"
    fontSize: "14px"
    fontWeight: 400
    lineHeight: 1.5
  label:
    fontFamily: "Montserrat, sans-serif"
    fontSize: "12px"
    fontWeight: 500
    lineHeight: 1.4
  action:
    fontFamily: "Montserrat, sans-serif"
    fontSize: "15px"
    fontWeight: 600
    lineHeight: 1.35
rounded:
  sm: "8px"
  md: "12px"
  lg: "16px"
  pill: "999px"
spacing:
  sm: "8px"
  md: "12px"
  lg: "16px"
  xl: "24px"
components:
  button-primary:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.white}"
    rounded: "{rounded.md}"
    padding: "14px 24px"
  button-outlined:
    backgroundColor: "{colors.white}"
    textColor: "{colors.graphite}"
    rounded: "{rounded.md}"
    padding: "14px 24px"
  button-destructive:
    backgroundColor: "{colors.white}"
    textColor: "{colors.error}"
    rounded: "{rounded.md}"
    padding: "14px 24px"
  input-filled:
    backgroundColor: "{colors.white}"
    textColor: "{colors.graphite}"
    rounded: "{rounded.md}"
    padding: "16px"
  card:
    backgroundColor: "{colors.white}"
    textColor: "{colors.graphite}"
    rounded: "{rounded.md}"
    padding: "16px"
  chip:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.graphite}"
    rounded: "{rounded.pill}"
    padding: "4px 10px"
---

# Design System: Умный Водитель

## 1. Overview

**Creative North Star: «Приборная панель грузовика»**

Дизайн-система построена вокруг функциональной ясности: водитель должен получить ответ на вопрос «что делать дальше?» одним взглядом, без декора и отвлекающих элементов. Интерфейс чистый и уверенный — он помогает работать, а не привлекает к себе внимания. Белые карточки на тёплом бумажном фоне образуют рабочее пространство; сигнальный оранжевый используется точечно и решительно для действий и статусов.

Система отвергает всё, что противоречит рабочему контексту: игрофикацию, бюрократическую серость и тёмный кибер-эстетизм. Глубина создаётся не тенями, а тональным разделением поверхностей и чёткими границами карточек.

**Key Characteristics:**
- Плотность в пользу водителя: важные действия крупные, контрастные и доступны одним касанием.
- Плоское слоение: глубина за счёт тёплого фона, белых карточек и серых рамок, а не размытых теней.
- Уверенная типографика: Montserrat для всего интерфейса, Bebas Neue — для крупных заголовков.
- Сдержанная палитра: один доминирующий акцент (оранжевый), синий, зелёный и красный — только для семантики статусов.
- Понятные аффордансы: кнопки выглядят нажимаемыми, карточки — нажимаемыми, поля — редактируемыми.

## 2. Colors

Палитра выстроена вокруг сигнального оранжевого на тёплом бумажном фоне, с прохладной серой шкалой и семантическими акцентами для статусов.

### Primary
- **Signal Orange** (`#FE4500`): основные действия, активная навигация, статус «В работе», фон аватара по умолчанию.
- **Signal Orange Light 1** (`#FE6A33`): статус «Погружен», более мягкие оранжевые акценты.
- **Signal Orange Light 2** (`#FE8F66`): инфографика, лёгкие оранжевые тона.

### Secondary
- **Info Blue** (`#337FFF`): статус «Новая», информационные акценты.

### Tertiary
- **Go Green** (`#00F55F`): статус «Завершена», состояния успеха. Только для экранов.
- **Error Red** (`#D32F2F`): ошибки, деструктивные действия, статус «Отказ».

### Neutral
- **Asphalt** (`#25252A`): основной текст, жирные заголовки, фон снекбаров.
- **Dark Gray** (`#57575C`): вторичный текст, вспомогательные подписи.
- **Mid Gray** (`#888B8F`): плейсхолдеры, подсказки неактивных состояний, иконки пустых состояний.
- **Gray** (`#B2B7BC`): декоративные иконки, малозначимые разделители.
- **Light Gray** (`#CBD0D6`): границы полей ввода, разделители.
- **Lighter Gray** (`#DAE0E5`): рамки карточек, тонкие линии.
- **White** (`#FFFFFF`): фон карточек, поверхности, текст на тёмном.
- **Warm Paper** (`#FFFFFCF7`): фон скaffold'а приложения, едва тёплый нейтральный.

### Named Rules
**The One Accent Rule.** Оранжевый — единственный брендовый акцент. Синий, зелёный и красный зарезервированы для семантики статусов и никогда не конкурируют с оранжевым за внимание.

**The Flat Background Rule.** Поверхности плоские. Глубина создаётся через тёплый фон → белую карточку → серую рамку, а не через drop-shadow.

## 3. Typography

**Display Font:** Bebas Neue (fallback: sans-serif)  
**Body Font:** Montserrat (fallback: sans-serif)

Паринг функциональный и прямой: Montserrat несёт весь UI-текст и отлично читается мелкими кеглями, а Bebas Neue отвечает за крупные дисплейные моменты с характером.

### Hierarchy
- **Display** (regular, 40px/1.1, letter-spacing 0.5px): крупные заголовки, онбординг.
- **Headline** (bold, 28px/1.25): заголовки экранов, крупные разделы.
- **Title** (semi-bold, 18px/1.35): заголовки карточек, заголовки AppBar, заголовки элементов списка.
- **Body** (regular, 14px/1.5): основной читаемый текст, подписи к формам, описания. Максимальная длина строки 65–75ch для прозы.
- **Label** (medium, 12px/1.4): чипы, подписи, временные метки, статусный микротекст.

### Named Rules
**The One Glance Rule.** Заголовки и тайтлы никогда не бывают декоративными. Они должны за один взгляд сообщить следующее действие или текущий статус.

## 4. Elevation

Система по умолчанию плоская. Тени используются только для нижней панели навигации (`elevation: 8`), чтобы отделить её от прокручиваемого контента. Карточки, кнопки и поля ввода лежат на тёплом фоне и определяются 1px-рамками, а не тенями.

### Shadow Vocabulary
- **Navigation Bar** (`0 -2px 8px rgba(37, 37, 42, 0.08)`): только нижняя навигация; создаёт разделение без визуального «подъёма» панели.

### Named Rules
**The Border-Not-Shadow Rule.** Карточки и контейнеры используют 1px-рамку `gray-lighter` для определения границ. Drop-shadow на карточках и элементах списка запрещены.

## 5. Components

### Buttons
- **Shape:** скруглённый прямоугольник (12px), на мобильных формах — во всю ширину (min-height 52px).
- **Primary:** фон Signal Orange (`#FE4500`), белый текст, padding 14px 24px. В disabled — фон Light Gray.
- **Outlined:** белый фон, текст Asphalt, рамка 1px Light Gray.
- **Destructive:** белый фон, текст и рамка Error Red (`#D32F2F`), min-height 52px. Используется только для необратимых действий («Отказаться от заявки»). Располагается отдельно от основных действий с визуальным разделением.
- **Text:** текст Primary цвета, без фона, для вторичных навигационных ссылок.

### Cards / Containers
- **Corner Style:** 12px.
- **Background:** White (`#FFFFFF`).
- **Border:** 1px Lighter Gray (`#DAE0E5`).
- **Internal Padding:** 16px.
- **Shadow Strategy:** none.

### Inputs / Fields
- **Style:** залитый белый фон, рамка 1px Light Gray, 12px radius.
- **Focus:** рамка переходит в Signal Orange, ширина 1.5px.
- **Error:** рамка переходит в Error Red.
- **Padding:** 16px по горизонтали и вертикали.
- **Placeholder:** текст Mid Gray.

### Chips
- **Style:** пилюлевидная форма (999px radius), фон из цвета с opacity 15%, текст Asphalt (`#25252A`).
- **State:** цвет кодирует статус (синий — новая, оранжевый — в работе, красный — отказ, зелёный — завершена, светло-оранжевый — погружен). Текст никогда не бывает цветом статуса — он должен обеспечивать контраст ≥4.5:1 на тонированном фоне.
- **Accessibility:** чип обёрнут в `Semantics` с меткой статуса для скринридеров.

### Navigation
- **Bottom Navigation:** белый фон, индикатор Signal Orange с opacity 12%, неактивные иконки/лейблы — Asphalt/Mid Gray.
- **Tabs:** активный индикатор и лейбл — Signal Orange, неактивный — Mid Gray.

### Status Chip (Signature Component)
Пилюля статуса заказа, который сопоставляет статус с семантическим цветом. Фон — 12% opacity цвета, текст — тот же цвет сплошным. Статусные цвета никогда не используются вне контекста чипа статуса.

## 6. Do's and Don'ts

### Do:
- **Do** использовать Signal Orange только для первичных действий, активных состояний и фона аватара по умолчанию.
- **Do** держать основной текст в цвете Asphalt на белом или тёплом фоне для контраста ≥4.5:1.
- **Do** использовать 12px radius для карточек, кнопок и полей ввода.
- **Do** резервировать синий, зелёный и красный для семантики статусов.
- **Do** поддерживать `prefers-reduced-motion` для всех анимаций.

### Don't:
- **Don't** использовать игрофицированные элементы: бейджи, стрики, мультяшные награды.
- **Don't** использовать бюрократическую серость: плотные сетки, канцеляризмы, безрадостные формы.
- **Don't** использовать тёмный кибер/терминальный эстетизм с неоном на чёрном.
- **Don't** использовать side-stripe границы (border-left > 1px цветным акцентом) на карточках или элементах списка.
- **Don't** использовать gradient text или декоративный glassmorphism.
- **Don't** сочетать 1px-рамку с широкой мягкой тенью на одном элементе.
- **Don't** использовать border-radius больше 16px на карточках; pill-radius зарезервирован для чипов и бейджей.
