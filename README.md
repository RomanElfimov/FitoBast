# Fito Bast

Приложение, предназначенное для управления фитолампой по протоколу MQTT. Пользователь может дистанционно задавать режимы работы устройству, а также добавлять и сохранять персональные шаблоны работы лампы. 

# Оглавление

1. [Стек](#Стек)
2. [Скриншоты](#Скриншоты)
    1. [Проверка подключения к устройству](#Проверка-подключения-к-устройству)
    2. [Главный экран](#Главный-экран)
    3. [Меню](#Меню)
    4. [Пользовательские шаблоны](#Пользовательские-шаблоны)
    5. [Создание шаблона работы](#Создание-шаблона-работы)
    6. [Избранные шаблоны](#Избранные-шаблоны)
    7. [Темная тема](#Темная-тема)
    


# Стек
- Сетевая логика: **MQTT**
- Архитектура: **MVC**
- Хранение данных: **Realm, UserDefaults**
- Интерфейс: **верстка кодом, Lottie, UICollection View Compositional Layout, UIView animations, UISwipeGestureRecognizer**

# Скриншоты
## Проверка подключения к устройству
При запуске приложение подключается к MQTT брокеру и слушает топик /status. Если устройство не в сети, выводится alert. Когда устройство появляется в сети, alert автоматически пропадает.
<div>
    <img src="https://github.com/RomanElfimov/FitoBast/blob/main/Screenshots/1.svg" width="400" height="790">
</div>

## Главный экран
На главном экране пользователь может выбрать один из избранных сценариев и поставить его в работу. Включается таймер и устройство работает, пока не закончится время.
<div>
<img src="https://github.com/RomanElfimov/FitoBast/blob/main/Screenshots/2.svg" height="700">
</div>

## Меню

<div>
<img src="https://github.com/RomanElfimov/FitoBast/blob/main/Screenshots/3.svg" width="400" height="790">
</div>

## Пользовательские шаблоны
Пользователю доступны стандартные, уже предустановленные шаблоны: Биколор, Бело-Синий и Бело-Красный. Кроме того, пользователь может создать свой собственный шаблон.
<div>
<img src="https://github.com/RomanElfimov/FitoBast/blob/main/Screenshots/4.svg" width="400" height="790">
</div>

## Создание шаблона работы
Для создания нового пользовательского шаблона необходимо указать имя шаблона, его длительность, и цвет. Перед сохранением шаблона пользователь может посмотреть шаблон на устройстве.
<div>
<img src="https://github.com/RomanElfimov/FitoBast/blob/main/Screenshots/5.svg" height="700">
</div>

## Избранные шаблоны
Часто используемые шаблоны можно добавить в избранное, чтобы иметь к ним быстрый доступ из главного меню.
<div>
<img src="https://github.com/RomanElfimov/FitoBast/blob/main/Screenshots/6.svg" width="400" height="790">
</div>

## Темная тема

<div>
<img src="https://github.com/RomanElfimov/FitoBast/blob/main/Screenshots/7.svg" height="700">
</div>
