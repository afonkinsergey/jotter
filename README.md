# Jotter

Установлены Phoenix, Absinthe, Guardian (for encode-decode JWT tokens).

#### Работает создание юзера по условиям ТЗ:
- Обновление инфы юзера
- Создание дружбы (запрос, принятие, отклонение, удаление, кто друг, список запросов отправленных и полученных)
- Поиск юзеров по разным полям, при авторизации юзера герерация токена.
- Сделан Absinthe.Middleware; для теста работает только с одной функцией schema.ex/get_users

Так же есть создание постов, картинок и добавление аватар. 
Картинки и аватары нужно добавлять через модуль ARC (но его пока не изучил, нашёл туториал как это сделать).

***

#### TODO:
- Разобраться с тестами и сделать тесты для приложения.
- Сделать лайки для постов (количество и кто поставил).
- Разобраться с модулем ARC для загрузки картинок и аватар пользователя на локальный диск.
- Попробовать сделать чат.
