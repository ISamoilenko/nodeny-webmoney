# WebMoney модуль для NoDeny 49/50

Модуль для биллинговой системы NoDeny реализует протокол взаимодействия с [платежной системой WEBMONEY](http://www.webmoney.ru).

## Установка

- Скопировать скрипт webmoney.pl в директорию /usr/local/www/apache22/cgi-bin/webmoney
- Изменить настройки скрипта webmoney.pl (WMNUMBER, SECRETKEY)
- Указать нужную платежную категорию в webmoney.pl (CATEGORY)
- Создать файл /usr/local/nodeny/module/webmoney.log и обеспечить права записи для веб-сервера
- Скопировать Swebmoney.pl и SwebmoneyTerm.pl в директорию /usr/local/nodeny/web
- Изменить настройки в скриптах Swebmoney.pl и SwebmoneyTerm.pl (STATLINK, WMNUMBER)
- Добавить модуль в конфигурацию модулей биллинга (аналогично вложенному plugin_reestr.cfg)
- В административной панели биллинга добавить модуль Swebmoney и SwebmoneyTerm
- В клиентской статистике должен появиться новый раздел

## Maintainers and Authors

Yuriy Kolodovskyy (https://github.com/kolodovskyy)

## License

MIT License. Copyright 2013 [Yuriy Kolodovskyy](http://twitter.com/kolodovskyy)
