#! /bin/bash
#set -e
#Первоначальная установка Debian

# Настройки цветов
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
WHITE='\033[1;37'
BLACK='\033[0;30'
CYAN='\033[0;36'
PURPLE='\033[0;35'
GRAY='\033[1;30'
NC='\033[0m' # Without Color

# Определение списка пакетов с описанием
packages=(
    "curl - Пакет для работы с HTTP"
    "flatpak - Система для установки приложений"
    "snap - Система.snap для управления приложениями"
    "mc - Midnight Commander — файловый менеджер"
    "ntfs-3g - Поддержка файловой системы NTFS"
    "gdebi - Утилита для установки.deb пакетов"
    "whois - Утилита для получения информации о доменах"
    "gpg - Система GnuPG для криптографии"
    "net-tools - Инструменты для настройки сетевых интерфейсов"
    "dnsutils - Инструменты для работы с DNS"
    "wget - Утилита для скачивания файлов по протоколу HTTP"
    "cifs-utils - Поддержка файловых систем CIFS/SMB"
    "zip - Утилита для работы с архивами ZIP"
    "iptables - Система управления таблицами NAT и防火长城"
    "resolvconf - Менеджер конфигурации DNS"
    "apache2-utils - Утилиты дляApache HTTP Server"
    "tree - Утилита для просмотра структуры каталогов"
    "ncdu - Утилита для анализа использования диска"
    "bash-completion - Автозавершение команд в bash"
    "ipcalc - Расчёт подсетей IP"
    "network-manager - Система управления сетями"
)

# Функция добавления пользователя
add_user(){
    local install_type=$1

    username=jack
    if [ $install_type = "hand" ]; then
        echo -e "${GREEN}Введите имя нового пользователя:${NC}"
        read username
    fi

    # Проверка existence пользователя
    if id -u "$username" >/dev/null 2>&1; then
        echo "Пользователь $username уже существует."
    else
        # Сolicitud password with length check
        while true; do
            echo "Введите пароль для пользователя $username:"
            read -s password

            # Проверка длины пароля
            if [ ${#password} -lt 10 ]; then
                echo "Пароль слишком короткий. Минимум 10 символов."
            else
                break
            fi
        done
        # Создание пользователя
        useradd -m "$username"
        # Установка пароля
        echo "$username:$password" | chpasswd

    fi

    # Проверка existence группы sudo и её создание, если не существует
    if ! getent group sudo >/dev/null; then
        groupadd sudo
    fi

    # Добавление пользователя в группу sudo
    usermod -aG sudo "$username"

    # Проверка успешного завершения операций
    if [ $? -eq 0 ]; then
        echo "Пользователь $username успешно создан и добавлен в группу sudo."
    else
        echo "Ошибка при создании пользователя или назначении пароля."
    fi
}

sources_list_update(){
    local install_type=$1



# Проверка, является ли система Debian 12
if [ "$(grep VERSION_CODENAME /etc/os-release | cut -d'=' -f2)" != "bookworm" ]; then
    echo "Система не использует Debian 12."
else
    # Создание резервной копии файла sources.list
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak

# Вывод текущего содержимого файла
echo "Текущее содержимое /etc/apt/sources.list:"
cat /etc/apt/sources.list

# Замена содержимого файла
sudo tee /etc/apt/sources.list > /dev/null << 'EOF'
deb http://ftp.ru.debian.org/debian/ bookworm main non-free-firmware
deb-src http://ftp.ru.debian.org/debian/ bookworm main non-free-firmware
deb http://security.debian.org/debian-security bookworm-security main non-free-firmware
deb-src http://security.debian.org/debian-security bookworm-security main non-free-firmware
deb http://ftp.ru.debian.org/debian/ bookworm-updates main non-free-firmware
deb-src http://ftp.ru.debian.org/debian/ bookworm-updates main non-free-firmware
deb http://security.debian.org/ bookworm-security main
deb-src http://security.debian.org/ bookworm-security main
EOF

# Сообщение об успешной замене
echo -e "${BLUE}Содержимое /etc/apt/sources.list успешно изменено.${NC}"

fi


}

# Функция установки начальной конфигурации машины
local_mashine_settings(){

    local install_type=$1
    # для 64х битных дистрибутивов подключаем дополнительно 32х битную архитектуру
    sudo dpkg --add-architecture i386

    #Установка часового пояса
    sudo timedatectl set-timezone Europe/Moscow
}

# Применение текущих настроек sysctl
apply_sysctl() {
    echo -e "\nПрименение изменений..."
    sudo sysctl -p
}

# Функция установки начальной конфигурации сети
net_config(){

    local install_type=$1

    # Параметры, которые нужно проверить и установить
    declare -A params=(
        ["net.ipv4.ip_forward"]="1"
        ["net.ipv4.conf.all.forwarding"]="1"
        ["net.ipv6.conf.all.disable_ipv6"]="1"
    )

    # Файл конфигурации sysctl
    config_file="/etc/sysctl.conf"



    # Проверка и добавление параметров в config_file
    for param in "${!params[@]}"; do
        value="${params[$param]}"
        if ! grep -q "^${param}=[01]" "$config_file"; then
            echo "Добавление параметра: ${param}=${value}"
            echo "${param}=${value}" >> "$config_file"
        fi
    done

    # Проверка,載уже ли systemctl грузит sysctl при загрузке
    if ! grep -q "^net.ipv4.ip_forward" /etc/rc.local; then
        echo "Добавление команды в rc.local..."
        echo 'echo 1 > /proc/sys/net/ipv4/ip_forward' >> /etc/rc.local
    fi

    # Применение изменений
    apply_sysctl

    #echo "nameserver 192.168.27.10" | sudo tee /etc/resolv.conf > /dev/null
    #echo "nameserver 192.168.27.10" | sudo tee /etc/resolvconf/resolv.conf.d/tail > /dev/null

    # Сообщение об успешном завершении
    echo -e "\nПараметры сети установлены."
}

# Функция установки zsh
zsh_install(){

    local install_type=$1
    # Установка zsh
    sudo apt install zsh git curl


    # Проверить, exists ли файл
    if [ ! -d ~/.oh-my-zsh/ ]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi
    chsh -s /bin/zsh root
    chsh -s /bin/zsh $username

    # Определить домашнюю директорию текущего пользователя
    HOME_DIR=$HOME

    # Путь к файлу .zshrc
    ZSHRC_FILE="$HOME/.zshrc"

    # Проверить, exists ли файл
    if [ ! -f "$ZSHRC_FILE" ]; then
        echo "Файл $ZSHRC_FILE не найден."
    else
        # Функция для изменения параметров в .zshrc
        change_parameter() {
            local parameter=$1
            local value=$2

            # Проверить, содержится ли already в файле
            if ! grep -q "^$parameter=" "$ZSHRC_FILE"; then
                echo "Не найден параметр $parameter в файле $ZSHRC_FILE."
                return 1
            fi
            if [[ "$value" =~ ^\(.+\)$ ]]; then
                new_value=$value
            else
                new_value="\"$value\""
            fi
            # Заменить значение параметра
            sed -i "s/^$parameter=.*$/$parameter=$new_value/" "$ZSHRC_FILE"


        }

        # Изменить ZSH_THEME на sonicradish
        echo "Изменение ZSH_THEME..."
        change_parameter "ZSH_THEME" "sonicradish"

        # Изменить plugins на (git docker docker-compose)
        echo "Изменение plugins..."
        change_parameter "plugins" "(git docker docker-compose)"

        # Сообщение об успешном завершении
        echo -e "\nСкрипт завершил работу успешно."
    fi
    cp ~/.zshrc /home/$username/.zshrc
    cp -R ~/.oh-my-zsh /home/$username/.oh-my-zsh
    chown -R $username:$username /home/$username/.oh-my-zsh
    chown $username:$username /home/$username/.zshrc
}

# Функция для редактирования конфига SSH
edit_ssh_config() {
    # Бэкапим файл конфигурации
    cp ${SSHD_CONFIG} ${SSHD_CONFIG}.bkp
    # Меняем настройки
    sed -i "/^Port/d" ${SSHD_CONFIG}
    echo "Port $NEW_PORT" >> ${SSHD_CONFIG}
    sed -i "/^PermitRootLogin/d" ${SSHD_CONFIG}
    echo "PermitRootLogin $ROOT_LOGIN" >> ${SSHD_CONFIG}
    sed -i "/^PubkeyAuthentication/d" ${SSHD_CONFIG}
    echo "PubkeyAuthentication $SSH_KEY_AUTH" >> ${SSHD_CONFIG}
}
# Функция для добавления ключа в authorized_keys
add_ssh_key() {
    # Проверяем пользователя
    # Путь к файлам SSH
    SSHD_CONFIG=/etc/ssh/sshd_config
    if ! id -u $username &> /dev/null; then
        echo "Пользователь $username не существует"
        exit 1
    fi
    cd "/home/$username/"
    mkdir -p .ssh
    chmod 700 .ssh
    if [ ! -f "/home/$username/.ssh/authorized_keys" ]; then
        touch "/home/$username/.ssh/authorized_keys"
    fi
    if ! grep -q "$SSH_PUBLIC_KEY" /home/$username/.ssh/authorized_keys; then
        echo "$SSH_PUBLIC_KEY" >> /home/$username/.ssh/authorized_keys
    fi
    chmod 600 /home/$username/.ssh/authorized_keys
    chown -R $username:$username /home/$username/.ssh
}
# Функция настройки ssh
ssh_settings(){
    local install_type=$1
    # Изменение параметров ssh
    # Путь к файлам SSH
    SSHD_CONFIG=/etc/ssh/sshd_config
    #AUTHORIZED_KEYS=/home/$USER/.ssh/authorized_keys

    # Новый порт для SSH
    NEW_PORT=2233

    # Запретить логин корня
    ROOT_LOGIN=no

    # Разрешить аутентификацию по ключам
    SSH_KEY_AUTH=yes

    # SSH-ключ который будем добавлять
    SSH_PUBLIC_KEY="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG7pSKDKnQmkZsVsS4NK0qaSwNIp3AkG0ciUWKn6XuuH jack"



    # Выполняем редактирование конфига SSH
    edit_ssh_config

    # Добавляем ключ в authorized_keys
    add_ssh_key

    # Перезагружаем SSH
    sudo systemctl restart sshd
    echo -e "${BLUE}Настройки SSH и ключи успешно изменены. Не забудьте отключить вход по паролю.${NC}"

}

ssh_root_disable(){
    local install_type=$1


        sed -i "/^PasswordAuthentication/d" ${SSHD_CONFIG}
        echo "PasswordAuthentication no" >> ${SSHD_CONFIG}

        sed -i "/^UsePAM/d" ${SSHD_CONFIG}
        echo "UsePAM no" >> ${SSHD_CONFIG}

        # Перезагружаем SSH
        sudo systemctl restart sshd
        echo -e "${BLUE}Отключен вход по паролю.${NC}"

}

# Установка доп пакетов
install_packege(){
    local install_type=$1
    sudo apt install -y flatpak snap mc ntfs-3g gdebi whois gpg net-tools dnsutils wget cifs-utils zip iptables resolvconf apache2-utils git tree ncdu bash-completion ipcalc network-manager ufw
}

# Установка fail2ban
install_fail2ban(){
    local install_type=$1
    sudo apt install -y fail2ban
    sudo systemctl enable fail2ban
    echo -e "${BLUE}Установлен fail2ban.${NC}"
}

# Установка docker
install_docker(){
    local install_type=$1
    # Add Docker's official GPG key:
    sudo apt-get update
    sudo apt-get install ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    # Add the repository to Apt sources:
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo systemctl enable docker.service
    sudo systemctl start docker.service
    echo -e "${BLUE}Установлен docker.${NC}"
}

# Установка qemu-guest-agent
install_qemu-guest-agent(){
    local install_type=$1
    sudo apt install qemu-guest-agent
    sudo systemctl enable qemu-guest-agent
    echo "Установлен qemu-guest-agent."
}

# Функция для настройки локали
configure_locale() {
    clear
    echo -e "${BLUE}=== Настройка локали ===${NC}"
    echo ""
    read -p "Введите желаемую локаль (например, en_US.UTF-8): " locale
    echo "$locale" > /etc/default/locale
    echo -e "${GREEN}Локаль успешно изменена на $locale.${NC}"
    sleep 2
}

# Функция для включения/выключения SSH Daemon
toggle_sshd() {
    clear
    echo -e "${BLUE}=== Управление SSH Daemon ===${NC}"
    echo ""
    if sudo systemctl is-enabled sshd > /dev/null; then
        echo -e "${GREEN}SSH Daemon включен.${NC}"
        read -p "Хотите выключить? (Y/n): " answer
        if [[ $answer == "Y" || $answer == "y" ]]; then
            sudo systemctl disable sshd
            sudo systemctl stop sshd
            echo -e "${GREEN}SSH Daemon отключен.${NC}"
        fi
    else
        echo -e "${RED}SSH Daemon выключен.${NC}"
        read -p "Хотите включить? (Y/n): " answer
        if [[ $answer == "Y" || $answer == "y" ]]; then
            sudo systemctl enable sshd
            sudo systemctl start sshd
            echo -e "${GREEN}SSH Daemon включен.${NC}"
        fi
    fi
    sleep 2
}





# Функция инициализации
init() {
    clear
    if [ $UID != 0 ]; then
        echo "Этот скрипт должен быть запущен под пользователем root."
        exit 1
    fi
    apt install sudo dialog
    # Определение дистрибутива Linux и его версии
    if [ -f /etc/os-release ]; then
        . /etc/os-release 2>/dev/null || true
    fi

    ID="${ID}"
    VERSION_ID="${VERSION_ID}"

    echo "Определённый дистрибутив: $ID"
    echo "Версия дистрибутива: $VERSION_ID"

    # Проверка на Proxmox VE
    if [ -f /etc/proxmox/ve-release ]; then
        PROXMOX_VERSION=$(cat /etc/proxmox/ve-release)
        echo "Установлена Proxmox VE версии: $PROXMOX_VERSION"
    else
        echo "Proxmox VE не установлена."
    fi

    # Проверка на OPNsense (на основе FreeBSD)
    if [ -f /etc/opnsense/version ]; then
        OPNSENSE_VERSION=$(cat /etc/opnsense/version)
        echo "Установлен OPNsense версии: $OPNSENSE_VERSION"
    else
        echo "OPNsense не установлены"
    fi

    # Проверка на TrueNAS (на основе Debian)
    if [ "$ID" == "debian" ] && dpkg --get-selections | grep -q truenas; then
        TRUENAS_DEBIANInstalled="Да"
        echo "Установлен TrueNAS на базе Debian."
    elif [ $(uname -s) = "FreeBSD" ]; then
        # Проверка TrueNAS на FreeBSD (оставьте как есть)
        if [ -f /etc/truenas/version ]; then
            TRUENAS_VERSION=$(cat /etc/truenas/version)
            echo "Установлен TrueNAS версии: $TRUENAS_VERSION"
        else
            echo "TrueNAS не установлен."
        fi
    else
        echo "TrueNAS не обнаружен на этом системе."
    fi

    # Переменные с результатами
    echo "ID: $ID"
    echo "VERSION_ID: $VERSION_ID"
    echo "PROXMOX_VERSION: $PROXMOX_VERSION"
    echo "OPNSENSE_VERSION: $OPNSENSE_VERSION"

}

# Основная функция
main() {
    select_packages
    add_user $install_type
    echo -e "${GREEN}Хотите изменить список пакетов? (Y/n):${NC}"
    read answer
    if [[ $answer == "Y" || $answer == "y" || $answer == "н" || $answer == "Н" || $answer == "" ]]; then
        sources_list_update $install_type
    fi
    # Обновление списка пакетов
    sudo apt update && apt upgrade -y && apt autoremove && echo "Список пакетов обновлен."
    local_mashine_settings $install_type
    echo -e "${GREEN}Хотите установить параметры сети? (Y/n):${NC}"
    read answer
    if [[ $answer == "Y" || $answer == "y" || $answer == "н" || $answer == "Н" || $answer == "" ]]; then
        net_config $install_type
    fi
    echo -e "${GREEN}Хотите установить zsh? (Y/n):${NC}"
    read answer
    if [[ $answer == "Y" || $answer == "y" || $answer == "н" || $answer == "Н" || $answer == "" ]]; then
        zsh_install $install_type
    fi
    echo -e "${GREEN}Хотите настроить ssh? (Y/n):${NC}"
    read answer
    if [[ $answer == "Y" || $answer == "y" || $answer == "н" || $answer == "Н" || $answer == "" ]]; then
        ssh_settings $install_type
    fi
    echo -e "${GREEN}Хотите запретить вход по паролю? (Y/n):${NC}"
    read answer
    if [[ $answer == "Y" || $answer == "y" || $answer == "н" || $answer == "Н" || $answer == "" ]]; then
        ssh_root_disable $install_type
    fi
    echo -e "${GREEN}Хотите установить дополнительные пакеты? (Y/n):${NC}"
    read answer
    if [[ $answer == "Y" || $answer == "y" || $answer == "н" || $answer == "Н" || $answer == "" ]]; then
        install_packege $install_type
    fi
    echo -e "${GREEN}Хотите установить fail2ban? (Y/n):${NC}"
    read answer
    if [[ $answer == "Y" || $answer == "y" || $answer == "н" || $answer == "Н" || $answer == "" ]]; then
        install_fail2ban $install_type
    fi
    echo -e "${GREEN}Хотите установить docker? (Y/n):${NC}"
    read answer
    if [[ $answer == "Y" || $answer == "y" || $answer == "н" || $answer == "Н" || $answer == "" ]]; then
        install_docker $install_type
    fi
    echo -e "${GREEN}Хотите установить qemu-guest-agent? (Y/n):${NC}"
    read answer
    if [[ $answer == "Y" || $answer == "y" || $answer == "н" || $answer == "Н" || $answer == "" ]]; then
        install_qemu-guest-agent $install_type
    fi


}

# Функция для выбора пакетов для установки
select_packages() {
    #clear
    echo -e "${BLUE}=== Выбор пакетов ===${NC}"
    echo ""
    echo "Доступные пакеты:"
    echo "1. Автоматическая установка сервер"
    echo "2. Автоматическая установка рабочая станция"
    echo "3. Ручная установка"
    echo ""
    read -p "Введите номера пакета: " packages
    for pkg in $packages; do
        case $pkg in
            1)
                install_type="server"
                ;;
            2)
                install_type="desctop"
                ;;
            3)
                install_type="hand"
                ;;
            *)
                echo -e "${RED}Неверный номер пакета.${NC}"
                ;;
        esac
    done
}

install_type="";
init;
main;
exit 0
