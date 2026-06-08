# 3X-UI VLESS Reality Template

Шаблон для быстрого развёртывания **3X-UI + Xray + VLESS Reality** на VPS.

3X-UI — это web-панель для управления Xray-core, VLESS, Reality и другими proxy/VPN протоколами. Официальный проект поддерживает установку через install script и Docker Compose; после установки командой `x-ui` можно открыть меню управления, посмотреть/сбросить логин, пароль, web path, SSL и другие настройки.

## Важно

Этот репозиторий — **шаблон**.

Не выкладывай сюда:

- `.env`
- `db/x-ui.db`
- Reality private key
- client UUID
- QR-коды
- ссылки подключения
- SSL private keys
- реальные пароли
- backup базы

## Требования

- VPS(комп) с публичным IP
- Ubuntu 
- SSH-доступ
- Docker + Docker Compose
- Открытые порты:
  - `22/tcp` — SSH
  - `8443/tcp` — VLESS Reality
  - порт панели лучше закрыть наружу или открыть только для своего IP

## DNS

Создай A-запись у регистратора домена:

```text
vpn.example.com -> IP_ТВОЕГО_VPS

Пример:

vpn.example.com -> 123.123.123.123
Быстрая установка
git clone https://github.com/YOUR_USERNAME/3xui.git
cd 3xui

cp .env.example .env
nano .env

bash scripts/install-docker.sh
newgrp docker

docker compose up -d
docker ps
Файл .env

Пример:

HOSTNAME=vpn.example.com
PANEL_PORT=9834
VLESS_PORT=8443
Docker Compose

Контейнер запускается в host network mode, чтобы Xray/Reality слушал порты прямо на VPS.

services:
  3x-ui:
    image: ghcr.io/mhsanaei/3x-ui:latest
    container_name: 3x-ui
    hostname: ${HOSTNAME}
    volumes:
      - ./db:/etc/x-ui
      - ./cert:/root/cert
    environment:
      XRAY_VMESS_AEAD_FORCED: "false"
      XUI_ENABLE_FAIL2BAN: "true"
    tty: true
    network_mode: host
    restart: unless-stopped
Управление панелью

Открыть меню 3X-UI:

docker exec -it 3x-ui x-ui

В меню можно:

посмотреть логин и пароль
сменить логин и пароль
сменить web base path
сменить порт панели
настроить SSL
перезапустить панель
сделать backup/restore

Официальная 3X-UI wiki пишет, что installer генерирует случайный username, password и web base path, а команду x-ui можно использовать для управления панелью после установки.

Проверка контейнера
docker ps
docker logs --tail=100 3x-ui
Проверка портов
bash scripts/show-ports.sh

Или руками:

sudo ss -tulpn | grep -E 'x-ui|xray|8443|9834|443|80'
Настройка VLESS Reality

В панели 3X-UI:

Inbounds / Подключения
Add inbound / Создать подключение
Protocol: VLESS
Security: Reality
Port: 8443

Дальше:

Create client / Создать клиента
Скопировать ссылку или QR
Импортировать в клиентское приложение

Каждому человеку лучше создавать отдельного клиента.

Не надо давать всем один QR-код. Это не семейный борщ. 😄

Firewall

Минимально открыть:

sudo ufw allow 22/tcp
sudo ufw allow 8443/tcp
sudo ufw enable
sudo ufw status

Если панель открыта наружу, лучше ограничить её по IP или держать только за SSH-туннелем.

Безопасность после установки

Сразу после запуска:

Сменить логин панели.
Сменить пароль панели.
Поставить длинный случайный web path.
Включить 2FA.
Закрыть порт панели от всего интернета.
Создавать отдельного клиента для каждого пользователя.
Делать backup базы x-ui.db.
Backup
bash scripts/backup-xui.sh

Backup появится в папке:

backup/
Restore backup

Остановить контейнер:

docker compose down

Скопировать backup:

cp backup/x-ui-YYYY-MM-DD-HHMMSS.db db/x-ui.db

Запустить обратно:

docker compose up -d
Обновление
docker compose pull
docker compose up -d
docker image prune -f
Полезные команды
docker ps
docker logs --tail=100 3x-ui
docker compose restart
docker compose down
docker compose up -d
docker exec -it 3x-ui x-ui
Troubleshooting
Панель не открывается

Проверить контейнер:

docker ps
docker logs --tail=100 3x-ui

Проверить порты:

sudo ss -tulpn | grep -E 'x-ui|xray|8443|9834'
VLESS не подключается

Проверить:

открыт ли порт 8443
правильно ли импортирован client config
не занят ли порт другим сервисом
совпадает ли Reality public key / shortId / serverName
нет ли блокировки у провайдера VPS
Забыл пароль панели

Открыть меню:

docker exec -it 3x-ui x-ui

И выбрать пункт просмотра или сброса credentials.

Что нельзя коммитить

Проверь перед push:

git status

Не должно быть:

.env
db/
cert/
backup/
*.db
*.key
*.pem
Push в GitHub
git add .
git commit -m "Add 3x-ui VLESS Reality template"
git push origin main
Disclaimer

Используй только для личных и законных целей. 

