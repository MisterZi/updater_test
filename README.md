# README


== Установка и настройка

Реализовано на языке программирования Ruby v. 2.4.0 с использованием фреймворка Ruby on Rails v. 5.1.3 и базы данных PostgreSQL 9.5

Для запуска приложения Вам понадобятся установленные Ruby и PostgreSQL 

Внимание! Все команды выполняются с помощью консоли из корневой папки проекта.

Выполните следующие действия:

* Клонируйте git репозиторий

* Отредактируйте <tt>config/database.yml</tt> для настройки базы данных (максимальное кол-во соединений, название базы и т.д)

* Запустите <tt>bundle install</tt>

* Выполните <tt>rake db:create</tt>, <tt>rake db:migrate</tt>, <tt>rake db:seed</tt> для созданиия, миграции и заполнения базы соответственно.

База заполнится 50000 пользователями с полем shard_id = nil. Это может занять продолжительное время. Для изменения кол-ва записей отредактируйте <tt>db/seeds.rb</tt>

== Запуск

* Запустите локальный сервер командой <tt>rails s</tt>

* Для запуска задачи обновления пользователей выполните <tt>rake main:update_shard_id[MAX_CONNECTIONS_TO_DB]</tt>, где MAX_CONNECTIONS_TO_DB - максимальное кол-во подключений к базе (по-умолчанию - 5). 

* Для остановки задачи обновления пользователей используйте <tt>ctrl + c</tt>
