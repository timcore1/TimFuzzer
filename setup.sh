#!/bin/bash

# Создаем основную структуру директорий
mkdir -p timfuzzer/{lib,bin,config,modules,payloads,reports}

# Создаем Gemfile
cat > timfuzzer/Gemfile << 'EOL'
source 'https://rubygems.org'

gem 'nokogiri'
gem 'mechanize'
gem 'thor'
gem 'colorize'
gem 'parallel'
gem 'json'
EOL

# Создаем исполняемый файл
touch timfuzzer/bin/timfuzzer
chmod +x timfuzzer/bin/timfuzzer

# Создаем директории для модулей
mkdir -p timfuzzer/lib/timfuzzer

# Создаем директорию для локальных гемов
mkdir -p ~/.gem
mkdir -p timfuzzer/vendor/bundle

# Устанавливаем права
chmod -R 755 timfuzzer

# Создаем символическую ссылку
SCRIPT_PATH=$(readlink -f timfuzzer/bin/timfuzzer)
sudo ln -sf "$SCRIPT_PATH" /usr/local/bin/timfuzzer

echo "Установка завершена. Теперь выполните:"
echo "cd timfuzzer"
echo "bundle install --path vendor/bundle"
echo ""
echo "После этого вы можете использовать команду 'timfuzzer' из любой директории"

# Исправляем символы конца строки
find timfuzzer -type f -name "*.rb" -exec sed -i 's/\r$//' {} \;