# TimFuzzer
<p align="center">
 <img src="Fuzzer.png" alt="TimFuzzer Banner" width="800"/>
</p>
<p align="center">
 <a href="https://opensource.org/licenses/MIT">
   <img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="License: MIT">
 </a>
 <a href="https://www.ruby-lang.org/">
   <img src="https://img.shields.io/badge/Ruby-2.7%2B-red" alt="Ruby Version">
 </a>
</p>
TimFuzzer — это мощный инструмент для фаззинг-тестирования веб-приложений, написанный на Ruby. Он предназначен для автоматического тестирования веб-приложений на наличие различных уязвимостей.

## 🚀 Возможности
- **Множество типов уязвимостей:**
 - SQL-инъекции
 - Cross-Site Scripting (XSS)
 - Local File Inclusion (LFI)
 - Command Injection

   
 **Многопоточное сканирование**
 
 **Подробные отчеты в JSON формате**
 
 **Гибкая настройка через YAML конфигурацию**
 
 **Модульная архитектура**
 
## 📋 Требования

- Ruby 2.7+
 RubyGems
 Bundler

## 💻 Установка


Обновляем систему

`sudo apt update`

`sudo apt upgrade -y`

Устанавливаем необходимые пакеты

`sudo apt install -y ruby ruby-dev ruby-bundler git build-essential`

Клонируем репозиторий

`git clone https://github.com/timcore1/TimFuzzer.git`

`cd TimFuzzer`

Настраиваем инструмент

`chmod +x setup.sh`

`./setup.sh`

Устанавливаем зависимости

`cd timfuzzer`

`bundle install`


## 🔧 Использование

### Базовые команды

Показать справку

`timfuzzer help`

Показать список доступных модулей

`timfuzzer list-modules`

Запустить сканирование

`timfuzzer scan http://target.com`


### Примеры использования

Сканирование с определенными модулями

`timfuzzer scan http://target.com -M sql_injection,xss`

Сканирование с методом POST

`timfuzzer scan http://target.com -m POST`

Настройка количества потоков

`timfuzzer scan http://target.com -t 10`

Использование пользовательского конфига

`timfuzzer scan http://target.com -c custom_config.yml`

Сохранение отчета в определенный файл

`timfuzzer scan http://target.com -o scan_results.json`


## ⚙️ Конфигурация

TimFuzzer использует YAML файлы для конфигурации. Пример конфигурационного файла:

yaml 

general:

timeout: 30

max_threads: 10

user_agent: "TimFuzzer/1.0"

follow_redirects: true

modules:

sql_injection:

enabled: true

timeout: 10

max_payloads: 100


## 📝 Отчеты

Результаты сканирования сохраняются в JSON формате и содержат подробную информацию о найденных уязвимостях:

json

{

"scan_date": "2024-01-20T15:30:00",

"total_vulnerabilities": 2,

"results": {

"sql_injection": [

{

"url": "http://target.com/page.php?id=1",

"payload": "' OR '1'='1",

"response_code": 200

}

]

}

}


## ⚠️ Предупреждение

Используйте TimFuzzer только для тестирования систем, на которые у вас есть разрешение. Неавторизованное тестирование может быть незаконным.

## 👤 Автор

**Mikhail Tarasov (Timcore)**
- GitHub: [@timcore1](https://github.com/timcore1)

## 📄 Лицензия

Этот проект распространяется под лицензией MIT. Подробности в файле [LICENSE](LICENSE).


