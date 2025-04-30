  Скачать [Get the free Proxmox VE ISO installer](https://www.proxmox.com/en/downloads/category/iso-images-pve)
- Настройка bios сервера
	- ASPI Settings -> Enable Hibernation -> Disable
	- intel thunderbolt включить
	- IntelRCSetup->PCH Configuration->PCH Devices->AC Power Loss->Last State
	- Не забыть включить виртуализацию в биосе
-   Записать на флешку [balenaEtcher - Flash OS images to SD cards & USB drives](https://www.balena.io/etcher/) или [Rufus - Простое создание загрузочных USB-дисков](https://rufus.ie/ru/)
-   Образы машин Proxmox Helper - [https://tteck.github.io/Proxmox/](https://tteck.github.io/Proxmox/)
-   Устанавливаем Proxmox. Как это делать с Wifi я не понял
- Выбираем zfs(raid0)
- Размеры дисков по умолчанию ![[Pasted image 20241023220443.png]]
	-
-   Идем в браузер на другой машине этой сети, открываем хост из установки Порт 8006
-   У пользователя (правая верхняя кнопка) можно поменять язык или выбрать при входе
- pve -> обновления -> Репозитории
	- Добавить No-Subscription
	- отключить два репозитория энтерпрайз
-   Обновить Proxmox
		-   На сервере войти во вкладку "Обновления" и обновить, система выдаст ошибку 100. чтобы исправить:
		-   в консоли зайти на:
		- `nano /etc/apt/sources.list.d/pve-enterprise.list`
		- `nano /etc/apt/sources.list.d/ceph.list`
		-   комментируем строчку символом # и сохраняем
		-   apt update && apt upgrade -y можно и так
- или так:
	- редактируем
```
		nano /etc/apt/sources.list
```
		добавляем туда:
```
# Proxmox VE pve-no-subscription repository provided by proxmox.com
# NOT recommended for production use
deb http://download.proxmox.com/debian/pve bookworm pve-no-subscription

# Security updates
deb http://security.debian.org/debian-security bookworm-security main contrib
```
	коментируем все в:

```
nano /etc/apt/sources.list.d/pve-enterprise.list
```
	редактируем файл:
```
nano /etc/apt/sources.list.d/ceph.list
```
	коментируем то что есть и добавляем новое
```
#deb https://enterprise.proxmox.com/debian/ceph-quincy bookworm enterprise
deb http://download.proxmox.com/debian/ceph-quincy bookworm no-subscription
```
```
apt-get update && apt-get upgrade -y
```
	убираем надпись о платной версии
```
sed -Ezi.bak "s/(Ext.Msg.show\(\{\s+title: gettext\('No valid sub)/void\(\{ \/\/\1/g" /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js
```


-   fdisk -l посмотреть диски
-   mkfs.ext4 /dev/md127 если надо создать раздел
-   lsusb - список usb устройств
-   Расширение дискового пространства на 16 ГБ: qm resize 100 scsi0 +16G
- Создание диска
	- pve->Диски выбираем нужный
	- Очистить диск
	- ZFS -> Создать ZFS![[Pasted image 20241025000140.png]]
	- Не забыть включить виртуализацию в биосе
	- Понять, какая система загрузки GRUB или SYSTEMD `efibootmgr -v`
		- Если SYSTEMD `nano /etc/kernel/cmdline`
			- В конец добавляем `quiet intel_iommu=on iommu=pt` ![[Pasted image 20241026110658.png]]
		- Если GRUB `nano /etc/default/grub`
			- `GRUB_CMDLINE_LINUX_DEFAULT="quiet intel_iommu=on iommu=pt"
			- `update-grub`
		- `proxmox-boot-tool refresh`
	- Добавление модулей: в `/etc/modules` добавить
	-
	```
	vfio
	vfio_iommu_type1
	vfio_pci
	```
	-  `update-initramfs -u -k all` пересчитать
	- перезагрузиться
	- `lsmod | grep vfio` - проверить
- [[Базовая установка сервера]]



Edit the sources list

```
nano /etc/apt/sources.list
```

Add these lines at the bottom:

```
# Proxmox VE pve-no-subscription repository provided by proxmox.com
# NOT recommended for production use
deb http://download.proxmox.com/debian/pve bookworm pve-no-subscription

# Security updates
deb http://security.debian.org/debian-security bookworm-security main contrib
```

Disable the Production Repository

Next, disable the production repository by commenting out these lines in pve-enterprise.list:

```
nano /etc/apt/sources.list.d/pve-enterprise.list
```

Comment out this line:

```
#deb https://enterprise.proxmox.com/debian/pve bookworm pve-enterprise
```

Configure Ceph for No-Subscription

Open the Ceph repository file:

```
nano /etc/apt/sources.list.d/ceph.list
```

Comment out the enterprise repository: by adding this # in front of the next line

```
#deb https://enterprise.proxmox.com/debian/ceph-quincy bookworm enterprise
```

Add the no-subscription repository:

```
deb http://download.proxmox.com/debian/ceph-quincy bookworm no-subscription
```

```
apt-get update && apt-get upgrade -y
```


https://pve.proxmox.com/pve-docs/chapter-qm.html#_general_requirements

How to determing if you are using grub or cmdline
use `efibootmgr -v`

If you see something like “File(\EFI\SYSTEMD\SYSTEMD-BOOTX64.EFI)” then you are using systemd, not GRUB.

If you have GRUB edit config file:

```
nano /etc/default/grub
```

For Intel CPUs Intel CPUs add quiet intel_iommu=on:
```
GRUB_CMDLINE_LINUX_DEFAULT="quiet intel_iommu=on pt=on"
```

For AMD CPUs add quiet amd_iommu=on:

```
GRUB_CMDLINE_LINUX_DEFAULT="quiet amd_iommu=on pt=on"
```

Then update GRUB
```
update-grub
```

If you have cmdline edit config file
```
nano /etc/kernel/cmdline
```

insert in the end of the line
`quiet amd_iommu=on iommu=pt`

Then refresh boot tool
```
proxmox-boot-tool refresh
```
Then reboot


Add Modules

```
nano /etc/modules
```

Insert

```
vfio
vfio_iommu_type1
vfio_pci
vfio_virqfd #not necessary if kernel 6.2
```
Update modules
```
update-initramfs -u -k all
```
Reboot

Verify

`dmesg | grep -e DMAR -e IOMMU` or
`dmesg | grep -e DMAR -e IOMMU -e AMD-Vi`

GPU Isolation From the Host (amend the below to include the IDs of the device you want to isolate)

Get device IDs: ` lspci -nn `

```
echo "options vfio-pci ids=10de:____,10de:____ disable_vga=1" > /etc/modprobe.d/vfio.conf
```

Blacklist GPU drivers

```
echo "blacklist radeon" >> /etc/modprobe.d/blacklist.conf
echo "blacklist nouveau" >> /etc/modprobe.d/blacklist.conf
echo "blacklist nvidia" >> /etc/modprobe.d/blacklist.conf
echo "blacklist nvidiafb" >> /etc/modprobe.d/blacklist.conf
echo "blacklist nvidia_drm" >> /etc/modprobe.d/blacklist.conf
echo "blacklist i915" >> /etc/modprobe.d/blacklist.conf
```
Reboot

Passing HDD

```
ls -n /dev/disk/by-id/
```
then
```
/sbin/qm set [VM-ID] -virtio2 /dev/disk/by-id/[DISK-ID]
```

Disable No-Subscription Pop-Up
```
sed -Ezi.bak "s/(Ext.Msg.show\(\{\s+title: gettext\('No valid sub)/void\(\{ \/\/\1/g" /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js
```
### Proxmox iGPU passthrough to multiple LXC
Giving a LXC guest GPU access allows you to use a GPU in a guest while it is still available for use in the host machine. This is a big advantage over virtual machines where only a single host or guest can have access to a GPU at one time. Even better, multiple LXC guests can share a GPU with the host at the same time.

The information on this page is written for a host running Proxmox but should be easy to adapt to any machine running LXC/LXD.

Since a device is being shared between two systems there are almost certainly some security implications and I haven't been able to determine what degree of security you're giving up to share a GPU.


Determine Device Major/Minor Numbers

To allow a container access to the device you'll have to know the devices major/minor numbers. This can be found easily enough by running ls -l in /dev/. As an example to pass through the integated UHD GPU from an Pentium Gold N8505 you would first list the devices where are created under /dev/dri.

```
root@blackbox:~# ls -l /dev/dri
total 0
drwxr-xr-x 2 root root         80 May 12 21:54 by-path
crw-rw---- 1 root video  226,   0 May 12 21:54 card0
crw-rw---- 1 root render 226, 128 May 12 21:54 renderD128
```

From that you can see the major device number is 226 and the minors are 0 and 128.

Provide LXC Access

In the configuration file you'd then add lines to allow the LXC guest access to that device and then also bind mount the devices from the host into the guest. In the example above since both devices share the same major number it is possible to use a shorthand notation of 226:* to represent all minor numbers with major number 226.

```
# /etc/pve/lxc/*.conf
lxc.cgroup.devices.allow: c 226:* rwm
lxc.mount.entry: /dev/dri/card0 dev/dri/card0 none bind,optional,create=file,mode=0666
lxc.mount.entry: /dev/dri/renderD128 dev/dri/renderD128 none bind,optional,create=file
```

Allow unprivileged Containers Access

In the example above we saw that card0 and renderD128 are both owned by root and have their groups set to video and render. Because the "unprivilged" part of LXC unprivileged container works by mapping the UIDs (user IDs) and GIDs (group IDs) in the LXC guest namespace to an unused range of IDs on host, it is necessary to create a custom mapping for that namespace that maps those groups in the LXC guest namespace to the host groups while leaving the rest unchanged so you don't lose the added security of running an unprivilged container.

First you need to give root permission to map the group IDs. You can look in /etc/group to find the GIDs of those groups, but in this example video = 44 and render = 108 on our host system. You should add the following lines that allow root to map those groups to a new GID.

```
# /etc/subgid
root:44:1
root:108:1
```

Then you'll need to create the ID mappings. Since you're just dealing with group mappings the UID mapping can be performed in a single line as shown on the first line addition below. It can be read as "remap 65,536 of the LXC guest namespace UIDs from 0 through 65,536 to a range in the host starting at 100,000." You can tell this relates to UIDs because of the u denoting users. It wasn't necessary to edit /etc/subuid because that file already gives root permission to perform this mapping.

You have to do the same thing for groups which is the same concept but slightly more verbose. In this example when looking at /etc/group in the LXC guest it shows that video and render have GIDs of 44 and 106. Although you'll use g to denote GIDs everything else is the same except it is necessary to ensure the custom mappings cover the whole range of GIDs so it requires more lines. The only tricky part is the second to last line that shows mapping the LXC guest namespace GID for render (106) to the host GID for render (108) because the groups have different GIDs.

```
# /etc/pve/lxc/*.conf
lxc.cgroup.devices.allow: c 226:* rwm
lxc.mount.entry: /dev/dri/card0 dev/dri/card0 none bind,optional,create=file,mode=0666
lxc.mount.entry: /dev/dri/renderD128 dev/dri/renderD128 none bind,optional,create=file
lxc.idmap: u 0 100000 65536
lxc.idmap: g 0 100000 44
lxc.idmap: g 44 44 1
lxc.idmap: g 45 100045 62
lxc.idmap: g 107 104 1
lxc.idmap: g 108 100108 65428

```

Because it can get confusing to read I just wanted show each line with some comments...

```
lxc.idmap: u 0 100000 65536    // map UIDs 0-65536 (LXC namespace) to 100000-165535 (host namespace)
lxc.idmap: g 0 100000 44       // map GIDs 0-43 (LXC namspace) to 100000-100043 (host namespace)
lxc.idmap: g 44 44 1           // map GID  44 to be the same in both namespaces
lxc.idmap: g 45 100045 61      // map GIDs 45-105 (LXC namspace) to 100045-100105 (host namespace)
lxc.idmap: g 107 104 1         // map GID  106 (LXC namspace) to 108 (host namespace)
lxc.idmap: g 108 100108 65429  // map GIDs 107-65536 (LXC namspace) to 100107-165536 (host namespace)
```

Add root to Groups


Because root's UID and GID in the LXC guest's namespace isn't mapped to root on the host you'll have to add any users in the LXC guest to the groups video and render to have access the devices. As an example to give root in our LXC guest's namespace access to the devices you would simply add root to the video and render group.

```
usermod --append --groups video,render root
```

or

```
usermod -aG render,video root
```


Resources
Proxmox: Unprivileged LXC containers
https://pve.proxmox.com/wiki/Unprivileged_LXC_containers

Because root's UID and GID in the LXC guest's namespace isn't mapped to root on the host you'll have to add any users in the LXC guest to the groups video and render to have access the devices. As an example to give root in our LXC guest's namespace access to the devices you would simply add root to the video and render group.

usermod --append --groups video,render root

or

usermod -aG render,video root

Resources Proxmox: Unprivileged LXC containers https://pve.proxmox.com/wiki/Unprivileged_LXC_containers
