#!/bin/bash
#Скрипт по пакетной установки программ с возможностью их выбора в сборку Debian 11 
#Автор: Александр Клич, сайт https://prostolinux.my1.ru
echo "Скрипт установуит выбранные Вами программы из предложенного списка."
echo "Работа скрипта может быть продолжительной и зависит от"
echo "количества выбранных программ и скорости интернета."
echo "=================================================="
cd ~
#sudo dpkg --add-architecture i386
sudo apt -y update
#sudo apt install gdebi -y

# Загрузка дополнительных данных для скрипта.
wget https://prostolinux.my1.ru/sideb11/temp-d11.tar.xz
tar xvf temp-d11.tar.xz
rm -rf temp-d11.tar.xz
#cp temp/gdebi.desktop ~/.local/share/applications/

sudo apt -y upgrade

#gsettings set org.gnome.gedit.preferences.encodings candidate-encodings "['UTF-8', 'WINDOWS-1251', 'KOI8-R', 'CURRENT', 'ISO-8859-15', 'UTF-16']"

# Установка программ по выбору.
sudo apt install dialog
cmd=(dialog --separate-output --checklist "Выберите программное обеспечение, которое вы хотите установить:" 22 76 16)
	options=(1 "Audacity - аудиоредактор" off 
		2 "Anydesk - удаленная помощь" off
		3 "Aisleriot - игра пасьянс" off
		4 "Audacious - аудиоплеер" off
		5 "AbiWord - текстовый процессор" off
		6 "Brasero-запись CD и DVD диков" off
		7 "Brave-browser - конфиденциальный браузер" off
		8 "Cairo-dock - doc-панель, отключает Plank" off
		9 "Cpu-x- информация о железе компьютера" off
		10 "Celluloid - медиаплеер + IPTV" on
		11 "Cheese - работа с вебкамерой" off
		12 "Cherrytree - записная книга" on
		13 "Compiz - композитный менеджер" off
		14 "Clamav - антивирусный сканер" off
		15 "Clementine - аудиоплеер" off
		16 "Easytag - редактор аудиотегов" off
		17 "Fbreader - чтение электронных книг" on
		18 "Filezilla - ftp загрузчик" off
		19 "Fluidsynth - midi синтезатор" off
		20 "Freeoffice - офисный пакет" off
		21 "Gimagereader - Текст с картинки в текстовой файл" off
		22 "Google-Chrome - браузер" off
		23 "Gkrellm - системный монитор" off
		24 "Guvcview - захват и просмотр видео с камеры" off
		25 "Gufw - файервол" on
		26 "Gimp - графический редактор" off
		27 "Gnome-disk-utility - управление диск.устройствами" on
		28 "Gpick - пипетка" off
		29 "Gpicview - лёгкий просмотрщик изображений" on
		30 "Grub-customizer - настройка загрузчика Grub" on
		31 "Gvidm - быстрое изменение разрешения экрана" off
		32 "Inkscape-редактор векторной графики" off
		33 "ISO Master - редактор ISO-образов" off
		34 "Kdenlive - видеоредактор" off
		35 "Kodi - медиацентр" off
		36 "Libreoffice - офисный пакет+RU" on
		37 "Leafpad - легкий текстовой редактор" off
		38 "Mediainfo - метаданные видео-аудио" off
		39 "Mintstick - форматирование флешек" off
		40 "Menulibre - редактор пускового меню" off
		41 "Mkvtoolnix - редактор видео файлов" off
		42 "Modem-manager-gui -usb модемы" off
		43 "Onlyoffice - офисный пакет" off
		44 "Openshot - видеоредактор" off
		45 "Opera - браузер (требует выбрать вариант обновления)" off
		46 "Pale Moon - легкий браузер" off
		47 "Pdf2djvu - конвертор из PDF в DjVu (консольная)" off
		48 "Portproton - установка windows-программ" off
		49 "Pinta - графический редактор" off
		50 "Psensor - монитор сенсоров" off
		51 "Puddletag - редактор mp3 тегов" off
		52 "Pulseeffects - аудиоэффекты для приложений" off
		53 "Qbittorrent - торрент клиент" on
		54 "Qmmp - аудиоплеер" off
		55 "Qshutdown - выключение по расписанию" off
		56 "Qsynth - подключения midi синтезаторов" off
		57 "RLinux5 - восстановление стертых данных" off
		58 "Simplescreenrecorder - запись видео с экрана" off
		59 "Seahorse - редактор ключей" on
		60 "Skype - месенджер" off
		61 "Soundconverter - аудиоконвертер" off
		62 "Steam - игровой сервис" off
		63 "Teamviewer - дистанционная помощь" off
		64 "Telegram telegram-desktop- месенджер" off
		65 "Timidity - midi синтезатор" off
		66 "Timeshift-резервное копирование" off
		67 "Uget - загрузчик файлов" off
		68 "Viber - мессенджер" off
		69 "Virtualbox - виртуальная машина" off
		70 "Vlc - мультимедийный плеер" on
		71 "Winff - видеоконвертер" off
		72 "Wine - использование win-программ" off
		73 "WhatsApp - месенджер, (не официальное приложение)" off
		74 "XTREME DOWNLOAD MANAGER - загрузчик файлов" off
		75 "Zoom - конференция" off
		76 "Yandex-browser - веб-браузер" off
		77 "Включить поддержку Bluetooth" off
		78 "Шифровальщик Veracrypt" off)
		
		choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
		clear
		for choice in $choices
		do
		    case $choice in
	        	1)
	            		#Install audacity*
				echo "================ Установка Audacity ================"
				sudo apt install audacity -y
				;;
						
			2)
				#Install Anydesk*
				echo "================ Установка Anydesk ================"
				sudo apt install anydesk -y
				#cp temp/autostart/anydesk_global_tray.desktop ~/.config/autostart/
				sudo systemctl disable anydesk
				;;
				
			3)
				#Install aisleriot*
				echo "================ Установка Aisleriot ================"
				sudo apt install aisleriot -y
				;;
				
			4)
				#Install audacious*
				echo "================ Установка Audacious ================"
				sudo apt install audacious -y
				;;
				
			5)
				#Install abiword*
				echo "================ Установка AbiWord ================"
				sudo apt install abiword -y
				;;
				
			6)
				#Install brasero*
				echo "================ Установка Brasero ================"
				sudo apt install brasero -y
				;;
				
			7)
				#Install brave-browser*
				echo "================ Установка Brave-browser ================"
				sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
				echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
				sudo apt update -y
				sudo apt install brave-browser -y
				;;
			8)
              			#install cairo-dock*
              			echo "================ Установка cairo-dock ================"
              			sudo apt-get install cairo-dock cairo-dock-plug-ins -y
				cp temp/autostart/cairo-dock.desktop ~/.config/autostart/
				cp -R temp/cairo-dock ~/.config/
				#sudo apt remove --purge plank
				sudo rm /etc/xdg/autostart/plank.desktop
				#rm -R ~/.config/plank
              			;;	
	
			9)
				#Install cpu-x*
				echo "================ Установка Cpu-x ================"
				sudo apt install cpu-x -y
				;;
				
			10)
				#Install Celluloid*
				echo "================ Установка Celluloid ================"
				sudo apt install celluloid -y
				#cp -R /temp/celluloid/ ~/.config/
				#cp -R temp/TV ~/'Рабочий стол'/
				;;
			
			11)
				#Install Cheese*
				echo "================ Установка Cheese ================"
				sudo apt install cheese -y
				;;
			
			12)
				#Install Cherrytree*
				echo "================ Установка Cherrytree ================"
				sudo apt install cherrytree -y
				cp -R temp/cherrytree ~/.config/
				;;
				
			13)
				#Install Compiz*
				echo "================ Установка Compiz ================"
				sudo apt install -y compiz compiz-core compiz-plugins compiz-plugins-default compiz-plugins-experimental compiz-plugins-extra compiz-plugins-main compizconfig-settings-manager emerald emerald-themes
				cp temp/autostart/3D.desktop ~/.config/autostart/
				cp temp/autostart/Emerald.desktop ~/.config/autostart/
				cp temp/compiz/compiz-start.desktop ~/.local/share/applications/
				cp temp/compiz/menulibre-compiz-выкл.desktop ~/.local/share/applications/
				cp temp/compiz/Emerald.desktop ~/.local/share/applications/
				cp -R temp/.emerald ~/
				cp -R temp/compiz ~/.config/
				rm ~/.config/compiz/compiz-start.desktop
				rm ~/.config/compiz/Emerald.desktop
				rm ~/.config/compiz/menulibre-compiz-выкл.desktop
				;;
				
			14)
				#Install clamav*
				echo "================ Установка Clamav ================"
				sudo apt install clamav clamtk -y
				;;
				
			15)
				#Install clementine*
				echo "================ Установка Clementine ================"
				sudo apt install clementine -y
				;;
				
			16)
				#Install Easytag*
				echo "================ Установка Easytag ================"
				sudo apt install esytag -y
				;;
				
			17)
				#Install fbreader*
				echo "================ Установка Fbreader ================"
				sudo apt install fbreader -y
				;;
				
			18)
				#Install filezilla*
				echo "================ Установка Filezilla ================"
				sudo apt install filezilla -y
				;;
				
			19)
				#Install fluidsynth*
				echo "================ Установка Fluidsynth ================"
				sudo apt install fluidsynth fluid-soundfont-gm fluid-soundfont-gs -y
				;;
				
			20)
				#Install Freeoffice*
				echo "================ Установка Freeoffice ================"
				sudo apt install softmaker-freeoffice-2021 -y
				;;
				
			21)
				#Install gimagereader*
				echo "================ Установка Gimagereader"
				sudo apt install gimagereader tesseract-ocr-rus -y
				;;
				
			22)
				#Install google-chrome*
				echo "================ Установка Chrome ================"
				sudo apt install google-chrome-stable -y
				#wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
				#sudo dpkg -i google-chrome-stable_current_amd64.deb
				#sudo apt install -f -y
				#rm -rf google-chrome-stable_current_amd64.deb
				;;
				
			23)
				#Install gkrellm*
				echo "================ Установка Gkrellm ================"
				sudo apt install gkrellm -y
				cp temp/autostart/gkrellm.desktop ~/.config/autostart/
				cp -R temp/.gkrellm2 ~/
				;;
				
			24)
				#Install Guvcview*
				echo "================ Установка Guvcview ================"
				sudo apt install guvcview -y
				;;
			
			25)
				#Install gufw*
				echo "================ Установка gufw ================"
				sudo apt install ufw gufw -y
				;;
			
			26)
				#Install gimp*
				echo "================ Установка Gimp ================"
				sudo apt install gimp -y
				;;
				
			27)
				#Install gnome-disk-utility*
				echo "================ Установка Gnome-disk-utility ================"
				sudo apt install gnome-disk-utility -y
				;;
				
			28)
				#Install gpick*
				echo "================ Установка Gpick ================"
				sudo apt install gpick -y
				;;
				
			29)
				#Install gpicview*
				echo "================ Установка Gpicview ================"
				sudo apt install gpicview -y
				;;
				
			30)
				#Install Grub-customizer*
				echo "================ Установка Grub-customizer ================"
				sudo apt install grub-customizer -y
				;;
				
			31)
				#Install Gvidm*
				echo "================ Установка Gvidm ================"
				sudo apt install gvidm -y
				;;
			
			32)
				#Install inkscape*
				echo "================ Установка Inkscape ================"
				sudo apt install inkscape -y
				;;
				
			33)
				#Install Isomaster*
				echo "================ Установка ISO Master ================"
				sudo apt install isomaster -y
				;;
				
			34)
				#Install Kdenlive*
				echo "================ Установка Kdenlive ================"
				sudo apt install kdenlive -y
				#sudo apt install -f -y
				;;
				
			35)
				#Install Kodi*
				echo "================ Установка Kodi ================"
				cp -R temp/.kodi ~/
				sudo apt install kodi -y
				;;
				
			36)
				#Install libreoffice*
				echo "================ Установка Libreoffice ================"
				sudo apt-mark hold firefox-esr*
				sudo apt install libreoffice libreoffice-l10n-ru libreoffice-help-ru -y
				;;
				
			37)
				#Install Leafpad*
				echo "================ Установка Leafpad ================"
				wget https://http.kali.org/kali/pool/main/l/leafpad/leafpad_0.8.18.1-5_amd64.deb
				sudo dpkg -i leafpad_0.8.18.1-5_amd64.deb
				sudo apt install -f -y
				rm -rf leafpad_0.8.18.1-5_amd64.deb
				;;
				
			38)
				#Install mediainfo*
				echo "================ Установка Mediainfo ================"
				sudo apt install mediainfo mediainfo-gui -y
				;;
				
			39)
				#Install mintstick*
				echo "================ Установка Mintstick ================"
				#wget http://packages.linuxmint.com/pool/main/m/mintstick/mintstick_1.4.1_all.deb  
				wget http://packages.linuxmint.com/pool/main/m/mint-translations/mint-translations_2020.01.06_all.deb
				sudo apt install mintstick -y
				sudo dpkg -i mint-translations_2020.01.06_all.deb
				sudo apt install -f -y
				#rm -rf mintstick_1.4.1_all.deb
				rm -rf mint-translations_2020.01.06_all.deb
				;;
				
			40)
				#Install Menulibre*
				echo "================ Установка Menulibre ================"
				sudo apt install menulibre -y
				;;
				
			41)
				#Install mkvtoolnix*
				echo "================ Установка Mkvtoolnix ================"
				sudo apt install mkvtoolnix mkvtoolnix-gui -y
				;;
				
			42)
				#Install Modem-manager-gui*
				echo "================ Установка Modem-manager-gui ================"
				sudo apt install modem-manager-gui -y
				;;
				
			43)
				#Install Onlyoffice*
				echo "================ Установка Onlyoffice ================"
				wget https://download.onlyoffice.com/install/desktop/editors/linux/onlyoffice-desktopeditors_amd64.deb
				sudo dpkg -i onlyoffice-desktopeditors_amd64.deb
				sudo apt install -f -y
				rm -rf onlyoffice-desktopeditors_amd64.deb
				;;
				
			44)
				#Install Openshot*
				echo "================ Установка Openshot ================"
				sudo apt install openshot-qt -y
				;;
				
			45)
				#Install Opera-stable*
				echo "================ Установка Opera-stable ================"
				#wget -qO- https://deb.opera.com/archive.key | sudo apt-key add -
				#sudo echo "deb [arch=i386,amd64] https://deb.opera.com/opera-stable/ stable non-free" > /etc/apt/sources.list.d/opera-stable.list
				#sudo apt update -y
				sudo apt install opera-stable -y
				;;	
				
			46)
				#Install Pale Moon*
				echo "================ Установка Palemoon ================"
				sudo apt install palemoon -y
				wget https://prostolinux.my1.ru/moon.tar.xz
				tar xvf moon.tar.xz
				rm -rf moon.tar.xz
				chmod u+x '.moonchild productions'
				;;
				
			47)
				#Install Pdf2djvu*
				echo "================ Установка Pdf2djvu ================"
				sudo apt install pdf2djvu -y
				;;
				
			48)
				#Install portproton*
				echo "================ Установка Portproton ================"
				sudo apt install bubblewrap curl gamemode icoutils tar wget zenity zstd libvulkan1 libvulkan1:i386 cabextract -y
				wget https://prostolinux.my1.ru/sideb12/portproton_amd64.deb
				sudo dpkg -i portproton_amd64.deb
				sudo apt install -f -y
				rm -rf portproton_amd64.deb
				;;
				
			49)
				#Install Pinta*
				echo "================ Установка Pinta ================"
				wget http://archive.ubuntu.com/ubuntu/pool/universe/p/pinta/pinta_1.6-2.1_all.deb
				sudo dpkg -i pinta_1.6-2.1_all.deb
				sudo apt install -f -y
				rm -rf pinta_1.6-2.1_all.deb
				;;
				
			50)
				#Install Psensor*
				echo "================ Установка Psensor ================"
				sudo apt install psensor -y
				;;
				
			51)
				#Install Puddletag*
				echo "================ Установка Puddletag ================"
				sudo apt install puddletag -y
				;;
							
			52)		
				#install pulseeffects*
				echo "================ Установка pulseeffects ================"
				sudo apt-get -y install pulseeffects -y
				;;
				
			53)
				#Install Qbittorrent*
				echo "================ Установка Qbittorrent ================"
				sudo apt install qbittorrent -y
				;;
				
			54)
				#Install Qmmp*
				echo "================ Установка Qmmp ================"
				sudo apt install qmmp -y
				;;
				
			55)
				#Install Qshutdown*
				echo "================ Установка Qshutdown ================"
				sudo apt install qshutdown -y
				;;
				
			56)
				#Install Qsynth*
				echo "================ Установка Qsynth ================"
				sudo apt install qsynth -y
				;;
				
			57)
				#Install RLinux5*
				echo "================ Установка RLinux5 ================"
				wget https://www.r-studio.com/downloads/RLinux5_x64.deb
				sudo dpkg -i RLinux5_x64.deb
				sudo apt install -f -y
				rm -rf RLinux5_x64.deb
				;;
				
			58)
				#Install Simplescreenrecorder*
				echo "================ Установка Simplescreenrecorder ================"
				sudo apt install simplescreenrecorder -y
				;;
				
			59)
				#Install Seahorse*
				echo "================ Установка Seahorse ================"
				sudo apt install seahorse -y
				;;
				
			60)
				#Install Skype*
				echo "================ Установка Skype ================"
				sudo apt install skypeforlinux -y
				#wget https://go.skype.com/skypeforlinux-64.deb
				#sudo dpkg -i skypeforlinux-64.deb
				#sudo apt install -f -y
				#rm -rf skypeforlinux-64.deb
				;;
				
			61)
				#Install Soundconverter*
				echo "================ Установка Soundconverter ================"
				sudo apt install soundconverter -y
				;;
				
			62)
				#Install Steam*
				echo "================ Установка Steam ================"
				sudo apt install -y libfontconfig1:i386 libgtk2.0-0:i386 libasound2:i386 libnss3:i386 libstdc++6:i386 libxss1:i386 libopenal1:i386 libtcmalloc-minimal4:i386 libxxf86vm1:i386 libpci3:i386 libgl1-mesa-glx:i386 libsdl2-2.0-0:i386
				wget https://steamcdn-a.akamaihd.net/client/installer/steam.deb
				sudo dpkg -i steam.deb
				sudo apt install -f -y
				rm -rf steam.deb
				;;
				
			63)
				#Install Teamviewer*
				echo "================ Установка Teamviewer ================"
				wget https://download.teamviewer.com/download/linux/teamviewer_amd64.deb
				sudo dpkg -i teamviewer_amd64.deb
				sudo apt install -f -y
				rm -rf teamviewer_amd64.deb
				;;
				
			64)
				#Install Telegram*
				echo "================ Установка Telegram ================"
				sudo apt install telegram-desktop -y
				;;	
				
			65)
				#Install Timidity*
				echo "================ Установка Timidity ================"
				sudo apt install timidity -y
				;;
				
			66)
				#Install Timeshift*
				echo "================ Установка Timeshift ================"
				sudo apt install timeshift -y
				;;
				
			67)
				#Install Uget*
				echo "================ Установка Uget ================"
				sudo apt install uget -y
				;;
				
			68)
				#Install Viber*
				echo "================ Установка Viber ================"
				wget https://download.cdn.viber.com/cdn/desktop/Linux/viber.deb
				sudo dpkg -i viber.deb
				sudo apt install -f -y
				rm -rf viber.deb
				;;
				
			69)
				#Install Virtualbox*
				echo "================ Установка Virtualbox ================"
				wget https://download.virtualbox.org/virtualbox/7.0.12/virtualbox-7.0_7.0.12-159484~Debian~bookworm_amd64.deb
				wget https://download.virtualbox.org/virtualbox/7.0.12/Oracle_VM_VirtualBox_Extension_Pack-7.0.12-159484.vbox-extpack
				sudo dpkg -i virtualbox-7.0_7.0.12-159484~Debian~bookworm_amd64.deb
				sudo apt install -f -y
				rm -rf virtualbox-7.0_7.0.12-159484~Debian~bookworm_amd64.deb
				;;
				
			70)
				#Install vlc*
				echo "================ Установка VLC ================"
				sudo apt install vlc -y
				;;
			
			71)
				#Install winff*
				echo "================ Установка Winff ================"
				sudo apt install winff -y
				;;
				
			72)
				#Install Wine*
				echo "================ Установка Wine ================"
				sudo apt install -y wine wine32 fonts-wine
				cp -R temp/Wine ~/.local/share/applications
				;;
				
			73)
				#Install WhatsApp*
				echo "================ Установка WhatsApp ================"
				#cp temp/web/Whatsapp_in_Firefox.desktop ~/.local/share/applications/
				wget https://github.com/eneshecan/whatsapp-for-linux/releases/download/v1.4.4/whatsapp-for-linux_1.4.4_amd64.deb
				sudo dpkg -i whatsapp-for-linux_1.4.4_amd64.deb
				sudo apt install -f -y
				rm -rf whatsapp-for-linux_1.4.4_amd64.deb
				;;
			
			74)
				#Install XTREME DOWNLOAD MANAGER*
				echo "================ Установка XTREME DOWNLOAD MANAGER ================"
				wget https://github.com/subhra74/xdm/releases/download/8.0.29/xdman_gtk_8.0.29_amd64.deb
				sudo dpkg -i xdman_gtk_8.0.29_amd64.deb
				sudo apt install -f -y
				rm -rf xdman_gtk_8.0.29_amd64.deb
				;;

			75)
				#Install Zoom*
				echo "================ Установка Zoom ================"
				wget https://zoom.us/client/latest/zoom_amd64.deb
				sudo dpkg -i zoom_amd64.deb
				sudo apt install -f -y
				rm -rf zoom_amd64.deb
				sudo dpkg-divert --package im-config --rename /usr/bin/ibus-daemon
				;;
				
			76)
				#Install Yandex-browser*
				echo "================ Установка Yandex-browser ================"
				sudo apt install yandex-browser-stable -y
				;;
				
			77)
				#Install bluetooth*
				echo "================ Включить поддержку Bluetooth ================"
				sudo apt install bluetooth blueman bluez -y
				;;
						
			78)
				#Install Veracrypt*
				echo "================ Установка Veracrypt ================"
				wget https://prostolinux.my1.ru/sideb12/veracrypt-amd64.deb
				sudo dpkg -i veracrypt-amd64.deb
				sudo apt install -f -y
				rm -rf veracrypt-amd64.deb
				;;


	    esac
	done


#cp temp/autostart/print-applet.desktop ~/.config/autostart/
rm -rf temp
sudo apt install -y linux-headers-$(uname -r|sed 's,[^-]*-[^-]*-,,')
rm ~/Загрузки/grub-pc*.deb
#rm ~/Загрузки/grub-pc-bin*.deb
echo "Скрипт работу закончил."
echo "Некоторые программы могут нуждаться в перезагрузке системы."
sleep 120s
