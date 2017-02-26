# gentoo-dotfiles

## Post Windows 10 Install

http://www.rodsbooks.com/refind/installing.html#windows

## Preparation

### Disk Info

```shell
$ livecd ~ # blkid

/dev/loop0: TYPE="squashfs"
/dev/nvme0n1p1: LABEL="Recovery" UUID="A846966F46963DCE" TYPE="ntfs" PARTLABEL="Basic data partition" PARTUUID="c8b18cc5-d73e-46ab-8557-9cd7a0ad40bb"
/dev/nvme0n1p2: UUID="6096-AE34" TYPE="vfat" PARTLABEL="EFI system partition" PARTUUID="4b9eec98-6073-42d2-965a-c55b6d6b3aef"
/dev/nvme0n1p4: UUID="3E56A31C56A2D445" TYPE="ntfs" PARTLABEL="Basic data partition" PARTUUID="8fbe709f-e4c9-47f7-9f0b-1ddb0a44e02b"
/dev/nvme0n1: PTUUID="2a8a2c09-dc4c-4319-b412-f7d0fe2f289d" PTTYPE="gpt"
/dev/nvme0n1p3: PARTLABEL="Microsoft reserved partition" PARTUUID="cdfb3b05-67cf-449c-9f2c-b4372830c31c"

$ EFI_UUID="6096-AE34"
```

### Create Partitions

```shell
$ parted -a optimal /dev/nvme0n1

(parted) print list                                                       
Model: Unknown (unknown)
Disk /dev/nvme0n1: 1144642MiB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags: 

Number  Start    End        Size       File system  Name                          Flags
 1      1.00MiB  451MiB     450MiB     ntfs         Basic data partition          hidden, diag
 2      451MiB   550MiB     99.0MiB    fat32        EFI system partition          boot, esp
 3      550MiB   566MiB     16.0MiB                 Microsoft reserved partition  msftres
 4      566MiB   600000MiB  599434MiB  ntfs         Basic data partition          msftdata
 
(parted) print free                                                       
Model: Unknown (unknown)
Disk /dev/nvme0n1: 1144642MiB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags: 

Number  Start      End         Size       File system  Name                          Flags
        0.02MiB    1.00MiB     0.98MiB    Free Space
 1      1.00MiB    451MiB      450MiB     ntfs         Basic data partition          hidden, diag
 2      451MiB     550MiB      99.0MiB    fat32        EFI system partition          boot, esp
 3      550MiB     566MiB      16.0MiB                 Microsoft reserved partition  msftres
 4      566MiB     600000MiB   599434MiB  ntfs         Basic data partition          msftdata
        600000MiB  1144642MiB  544642MiB  Free Space

(parted) unit mib
(parted) mkpart primary 600001 600005
(parted) name 5 grub
(parted) set 5 bios_grub on                                               
(parted) print                                                            
Model: Unknown (unknown)
Disk /dev/nvme0n1: 1144642MiB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags: 

Number  Start      End        Size       File system  Name                          Flags
 1      1.00MiB    451MiB     450MiB     ntfs         Basic data partition          hidden, diag
 2      451MiB     550MiB     99.0MiB    fat32        EFI system partition          boot, esp
 3      550MiB     566MiB     16.0MiB                 Microsoft reserved partition  msftres
 4      566MiB     600000MiB  599434MiB  ntfs         Basic data partition          msftdata
 5      600001MiB  600005MiB  4.00MiB                 grub                          bios_grub

(parted) mkpart primary 600005 -1
(parted) name 6 gentoo 
(parted) print                                                            
Model: Unknown (unknown)
Disk /dev/nvme0n1: 1144642MiB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags: 

Number  Start      End         Size       File system  Name                          Flags
 1      1.00MiB    451MiB      450MiB     ntfs         Basic data partition          hidden, diag
 2      451MiB     550MiB      99.0MiB    fat32        EFI system partition          boot, esp
 3      550MiB     566MiB      16.0MiB                 Microsoft reserved partition  msftres
 4      566MiB     600000MiB   599434MiB  ntfs         Basic data partition          msftdata
 5      600001MiB  600005MiB   4.00MiB                 grub                          bios_grub
 6      600005MiB  1144641MiB  544636MiB               gentoo
 
$ livecd ~ # blkid                                                          
/dev/loop0: TYPE="squashfs"
/dev/sda1: LABEL="EFI" UUID="67E3-17ED" TYPE="vfat" PARTLABEL="EFI System Partition" PARTUUID="ca6aa3ac-5f95-4303-a3e6-87248d7879e2"
/dev/sda2: LABEL="FAT32" UUID="3C76-17EE" TYPE="vfat" PARTUUID="155289ad-2a00-4339-90d3-3c7e5a54f00b"
/dev/nvme0n1p1: LABEL="Recovery" UUID="A846966F46963DCE" TYPE="ntfs" PARTLABEL="Basic data partition" PARTUUID="c8b18cc5-d73e-46ab-8557-9cd7a0ad40bb"
/dev/nvme0n1p2: UUID="6096-AE34" TYPE="vfat" PARTLABEL="EFI system partition" PARTUUID="4b9eec98-6073-42d2-965a-c55b6d6b3aef"
/dev/nvme0n1p4: UUID="3E56A31C56A2D445" TYPE="ntfs" PARTLABEL="Basic data partition" PARTUUID="8fbe709f-e4c9-47f7-9f0b-1ddb0a44e02b"
/dev/nvme0n1: PTUUID="2a8a2c09-dc4c-4319-b412-f7d0fe2f289d" PTTYPE="gpt"
/dev/nvme0n1p3: PARTLABEL="Microsoft reserved partition" PARTUUID="cdfb3b05-67cf-449c-9f2c-b4372830c31c"
/dev/nvme0n1p5: PARTLABEL="grub" PARTUUID="71515af0-cfad-4f74-a148-66b3bcf31fcc"
/dev/nvme0n1p6: PARTLABEL="gentoo" PARTUUID="61ce7f83-536e-4163-a062-508fcc5e0c20"
```

### Create Filesystems

```shell
$ mkfs.btrfs /dev/nvme0n1p6
```

### Mount Root

``` shell
$ mount /dev/nvme0n1p6 /mnt/gentoo
```

### Mount Boot

```shell
$ mkdir -p /mnt/gentoo/mnt/efi
$ mkdir -p /mnt/gentoo/boot
$ mount "UUID=6096-AE34" /mnt/gentoo/mnt/efi
$ mkdir -p /mnt/gentoo/mnt/efi/EFI/Gentoo
$ mount --rbind /mnt/gentoo/mnt/efi/EFI/Gentoo /mnt/gentoo/boot
```

### Install Stage3

```shell
$ tar xvjf /mnt/cdrom/stage3-amd64-20170209.tar.bz2 -C /mnt/gentoo --overwrite
```

### Copy Networking

```shell
$ cp -L /etc/resolv.conf /mnt/gentoo/etc/
```

### Mount Install

```shell
$ mount -t proc proc /mnt/gentoo/proc
$ mount --rbind /sys /mnt/gentoo/sys
$ mount --make-rslave /mnt/gentoo/sys
$ mount --rbind /dev /mnt/gentoo/dev
$ mount --make-rslave /mnt/gentoo/dev
$ chroot /mnt/gentoo /bin/bash
```

## Gentoo Install

### Update Env

### Configure Portage

```shell
$ vi /mnt/gentoo/etc/portage/make.conf
GENTOO_MIRRORS="http://mirrors.rit.edu/gentoo"
MAKEOPTS="-j21 -l20"
FEATURES="distlocks sandbox userpriv usersandbox ccacheparallel-fetch parallel-install multilib-strict candy unmerge-orphans fixlafiles -preserve-libs"
CCACHE_SIZE="5G"
EMERGE_DEFAULT_OPTS="--jobs=20 --load-average=20 --with-bdeps=y --complete-graph=y"
PORTAGE_NICENESS="3"
AUTOCLEAN="yes"
ACCEPT_KEYWORDS="amd64"
ACCEPT_LICENSE="8"
GRUB_PLATFORMS="efi-64"
LINGUAS="en_US"
ABI_X86="64"
PYTHON_TARGETS="python3_4 python2_7"
PYTHON_SINGLE_TARGET="python3_4"
VIDEO_CARDS="nvidia"
INPUT_DEVICES="evdev"
CURL_SSL="openssl"
```

```shell
$ mkdir -p /usr/portage
$ env-update
$ source /etc/profile
```

### Emerge GCC

```shell
$ emerge --sync
$ mkdir -p /etc/portage/package.accept_keywords
$ echo "sys-devel/gcc ~amd64" > /etc/portage/package.accept_keywords/gcc
$ emerge --oneshot gcc
$ gcc-config -l
 [1] x86_64-pc-linux-gnu-4.9.4 *
 [2] x86_64-pc-linux-gnu-5.4.0
$ gcc-config x86_64-pc-linux-gnu-5.4.0
```

### Update Portage Config

```shell
$ gcc -v -E -x c -march=native -mtune=native - < /dev/null 2>&1 | grep cc1 | perl -pe 's/ -mno-\S+//g; s/^.* - //g;'
-march=broadwell -mmmx -msse -msse2 -msse3 -mssse3 -mcx16 -msahf -mmovbe -maes -mpclmul -mpopcnt -mabm -mfma -mbmi -mbmi2 -mavx -mavx2 -msse4.2 -msse4.1 -mlzcnt -mrtm -mhle -mrdrnd -mf16c -mfsgsbase -mrdseed -mprfchw -madx -mfxsr -mxsave -mxsaveopt --param l1-cache-size=32 --param l1-cache-line-size=64 --param l2-cache-size=25600 -mtune=broadwell -fstack-protector-strong

$ emerge app-portage/cpuid2cpuflags
$ cpuinfo2cpuflags-x86
CPU_FLAGS_X86="aes avx avx2 fma3 mmx mmxext popcnt sse sse2 sse3 sse4_1 sse4_2 ssse3"

$ vi /mnt/gentoo/etc/portage/make.conf

CFLAGS="-O3 -pipe -march=broadwell -mmmx -msse -msse2 -msse3 -mssse3 -mcx16 -msahf -mmovbe -maes -mpclmul -mpopcnt -mabm -mfma -mbmi -mbmi2 -mavx -mavx2 -msse4.2 -msse4.1 -mlzcnt -mrtm -mhle -mrdrnd -mf16c -mfsgsbase -mrdseed -mprfchw -madx -mfxsr -mxsave -mxsaveopt --param l1-cache-size=32 --param l1-cache-line-size=64 --param l2-cache-size=25600 -mtune=broadwell -fstack-protector-strong"

...

CPU_FLAGS_X86="aes avx avx2 fma3 mmx mmxext popcnt sse sse2 sse3 sse4_1 sse4_2 ssse3"

...

USE="-* aes avx avx2 fma3 mmx mmxext popcnt sse sse2 sse3 sse4_1 sse4_2 ssse3 nptl threads ssl udev bzip2 tryetype unicode ncurses python xattr zlib vim-syntax branding device-mapper hscolour acl tools acpi suid dbus nvidia curl alsa tcpd cxx vdpau dri video sound opengl gtk3 icu minizip usb git pcre16 ipv6 color iptables glx btrfs udisks upower automount hostname arp jack text opencl colord corefonts clipboard"
```

### Rebuild GCC with new GCC

```shell
$ emerge --oneshot gcc
```

### Setup Timezone and Locale

```
$ echo "America/New_York" > /etc/timezone
$ emerge --config sys-libs/timezone-data
$ nano -w /etc/locale.gen

en_US ISO-8859-1
en_US.UTF-8 UTF-8

$ locale-gen
$ eselect locale list
Available targets for the LANG variable:
  [1]   C
  [2]   en_US
  [3]   en_US.iso88591
  [4]   en_US.utf8
  [5]   POSIX
$ eselect locale set 4
$ env-update
$ source /etc/profile
```

### Emerge utils

```shell
$ emerge dev-util/ccache
$ emerge --oneshot binutils glibc
$ emerge --oneshot portage gentoolkit
$ emerge --update --nodeps udev-init-scripts procps
$ emerge --update shadow openrc udev
```

### Emerge System

```shell
$ sh /usr/portage/scripts/bootstrap.sh
$ emerge -e eyetem
```
