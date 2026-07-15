---
title: "Partition and Mount Report"
run_id: "20260715T095220Z"
generated_utc: "2026-07-15 09:53:41Z"
---

# Partition and Mount Report

## Named Partitions

```text
total 0
lrwxrwxrwx 1 root root 20 1970-01-01 00:00 backup -> /dev/block/mmcblk2p9
lrwxrwxrwx 1 root root 21 1970-01-01 00:00 baseparameter -> /dev/block/mmcblk2p13
lrwxrwxrwx 1 root root 20 1970-01-01 00:00 boot -> /dev/block/mmcblk2p7
lrwxrwxrwx 1 root root 21 1970-01-01 00:00 cache -> /dev/block/mmcblk2p10
lrwxrwxrwx 1 root root 21 1970-01-01 00:00 cust -> /dev/block/mmcblk2p14
lrwxrwxrwx 1 root root 20 1970-01-01 00:00 dtbo -> /dev/block/mmcblk2p5
lrwxrwxrwx 1 root root 21 1970-01-01 00:00 logo -> /dev/block/mmcblk2p12
lrwxrwxrwx 1 root root 21 1970-01-01 00:00 metadata -> /dev/block/mmcblk2p11
lrwxrwxrwx 1 root root 20 1970-01-01 00:00 misc -> /dev/block/mmcblk2p4
lrwxrwxrwx 1 root root 18 1970-01-01 00:00 mmcblk2 -> /dev/block/mmcblk2
lrwxrwxrwx 1 root root 23 1970-01-01 00:00 mmcblk2boot0 -> /dev/block/mmcblk2boot0
lrwxrwxrwx 1 root root 23 1970-01-01 00:00 mmcblk2boot1 -> /dev/block/mmcblk2boot1
lrwxrwxrwx 1 root root 20 1970-01-01 00:00 recovery -> /dev/block/mmcblk2p8
lrwxrwxrwx 1 root root 20 1970-01-01 00:00 security -> /dev/block/mmcblk2p1
lrwxrwxrwx 1 root root 21 1970-01-01 00:00 super -> /dev/block/mmcblk2p15
lrwxrwxrwx 1 root root 20 1970-01-01 00:00 trust -> /dev/block/mmcblk2p3
lrwxrwxrwx 1 root root 20 1970-01-01 00:00 uboot -> /dev/block/mmcblk2p2
lrwxrwxrwx 1 root root 21 1970-01-01 00:00 userdata -> /dev/block/mmcblk2p16
lrwxrwxrwx 1 root root 20 1970-01-01 00:00 vbmeta -> /dev/block/mmcblk2p6
```

## Kernel Partition Table

```text
major minor  #blocks  name

   1        0       8192 ram0
   1        1       8192 ram1
   1        2       8192 ram2
   1        3       8192 ram3
   1        4       8192 ram4
   1        5       8192 ram5
   1        6       8192 ram6
   1        7       8192 ram7
   1        8       8192 ram8
   1        9       8192 ram9
   1       10       8192 ram10
   1       11       8192 ram11
   1       12       8192 ram12
   1       13       8192 ram13
   1       14       8192 ram14
   1       15       8192 ram15
   7        0     262144 loop0
 254        0     742272 zram0
 179        0   30535680 mmcblk0
 179        1   30534639 mmcblk0p1
 179       32    7716864 mmcblk2
 179       33       4096 mmcblk2p1
 179       34       4096 mmcblk2p2
 179       35       4096 mmcblk2p3
 179       36       4096 mmcblk2p4
 179       37       4096 mmcblk2p5
 179       38       1024 mmcblk2p6
 179       39      40960 mmcblk2p7
 179       40     110592 mmcblk2p8
 179       41     380928 mmcblk2p9
 179       42     393216 mmcblk2p10
 179       43      16384 mmcblk2p11
 179       44      65536 mmcblk2p12
 179       45       1024 mmcblk2p13
 179       46      65536 mmcblk2p14
 179       47    2457600 mmcblk2p15
 179       48    4159456 mmcblk2p16
 253        0     774652 dm-0
 253        1      72868 dm-1
 253        2     279156 dm-2
 253        3      22032 dm-3
 253        4     838520 dm-4
 253        5        256 dm-5
 253        6     204532 dm-6
```

## Mounted Filesystems

```text
tmpfs on /dev type tmpfs (rw,seclabel,nosuid,relatime,size=493048k,nr_inodes=123262,mode=755)
devpts on /dev/pts type devpts (rw,seclabel,relatime,mode=600,ptmxmode=000)
proc on /proc type proc (rw,relatime,gid=3009,hidepid=2)
sysfs on /sys type sysfs (rw,seclabel,relatime)
selinuxfs on /sys/fs/selinux type selinuxfs (rw,relatime)
tmpfs on /mnt type tmpfs (rw,seclabel,nosuid,nodev,noexec,relatime,size=493048k,nr_inodes=123262,mode=755,gid=1000)
/dev/block/mmcblk2p11 on /metadata type ext4 (rw,sync,seclabel,nosuid,nodev,noatime,discard)
/dev/block/dm-0 on / type ext4 (ro,seclabel,nodev,relatime)
/dev/block/dm-2 on /vendor type ext4 (ro,seclabel,relatime)
/dev/block/dm-4 on /odm type ext4 (ro,seclabel,relatime)
/dev/block/dm-1 on /system_ext type ext4 (ro,seclabel,relatime)
/dev/block/dm-3 on /vendor_dlkm type ext4 (ro,seclabel,relatime)
/dev/block/dm-5 on /odm_dlkm type ext4 (ro,seclabel,relatime)
/dev/block/dm-6 on /product type ext4 (ro,seclabel,relatime)
tmpfs on /apex type tmpfs (rw,seclabel,nosuid,nodev,noexec,relatime,size=493048k,nr_inodes=123262,mode=755)
tmpfs on /linkerconfig type tmpfs (rw,seclabel,nosuid,nodev,noexec,relatime,size=493048k,nr_inodes=123262,mode=755)
tmpfs on /mnt/installer type tmpfs (rw,seclabel,nosuid,nodev,noexec,relatime,size=493048k,nr_inodes=123262,mode=755,gid=1000)
tmpfs on /mnt/androidwritable type tmpfs (rw,seclabel,nosuid,nodev,noexec,relatime,size=493048k,nr_inodes=123262,mode=755,gid=1000)
/dev/block/dm-0 on /apex/com.android.adbd type ext4 (ro,seclabel,relatime)
/dev/block/dm-0 on /apex/com.android.appsearch type ext4 (ro,seclabel,relatime)
/dev/block/dm-0 on /apex/com.android.art type ext4 (ro,seclabel,relatime)
/dev/block/dm-0 on /apex/com.android.conscrypt type ext4 (ro,seclabel,relatime)
/dev/block/dm-0 on /apex/com.android.i18n type ext4 (ro,seclabel,relatime)
/dev/block/dm-0 on /apex/com.android.ipsec type ext4 (ro,seclabel,relatime)
/dev/block/dm-0 on /apex/com.android.media type ext4 (ro,seclabel,relatime)
/dev/block/dm-0 on /apex/com.android.media.swcodec type ext4 (ro,seclabel,relatime)
/dev/block/dm-0 on /apex/com.android.mediaprovider type ext4 (ro,seclabel,relatime)
/dev/block/dm-0 on /apex/com.android.neuralnetworks type ext4 (ro,seclabel,relatime)
/dev/block/dm-0 on /apex/com.android.os.statsd type ext4 (ro,seclabel,relatime)
/dev/block/dm-0 on /apex/com.android.permission type ext4 (ro,seclabel,relatime)
/dev/block/dm-0 on /apex/com.android.resolv type ext4 (ro,seclabel,relatime)
/dev/block/dm-0 on /apex/com.android.runtime type ext4 (ro,seclabel,relatime)
/dev/block/dm-0 on /apex/com.android.scheduling type ext4 (ro,seclabel,relatime)
/dev/block/dm-0 on /apex/com.android.sdkext type ext4 (ro,seclabel,relatime)
/dev/block/dm-0 on /apex/com.android.tethering type ext4 (ro,seclabel,relatime)
/dev/block/dm-0 on /apex/com.android.tzdata type ext4 (ro,seclabel,relatime)
/dev/block/dm-0 on /apex/com.android.vndk.v32 type ext4 (ro,seclabel,relatime)
/dev/block/dm-0 on /apex/com.android.wifi type ext4 (ro,seclabel,relatime)
none on /dev/blkio type cgroup (rw,nosuid,nodev,noexec,relatime,blkio)
none on /sys/fs/cgroup type cgroup2 (rw,nosuid,nodev,noexec,relatime)
none on /dev/cpuctl type cgroup (rw,nosuid,nodev,noexec,relatime,cpu)
none on /dev/cpuset type cgroup (rw,nosuid,nodev,noexec,relatime,cpuset,noprefix,release_agent=/sbin/cpuset_release_agent)
none on /dev/memcg type cgroup (rw,nosuid,nodev,noexec,relatime,memory)
none on /dev/stune type cgroup (rw,nosuid,nodev,noexec,relatime,schedtune)
tmpfs on /linkerconfig type tmpfs (rw,seclabel,nosuid,nodev,noexec,relatime,size=493048k,nr_inodes=123262,mode=755)
tracefs on /sys/kernel/tracing type tracefs (rw,seclabel,relatime,gid=3012,mode=755)
/sys/kernel/debug on /sys/kernel/debug type debugfs (rw,seclabel,relatime)
/sys/kernel/debug/tracing on /sys/kernel/debug/tracing type tracefs (rw,seclabel,relatime,gid=3012,mode=755)
none on /config type configfs (rw,nosuid,nodev,noexec,relatime)
binder on /dev/binderfs type binder (rw,relatime,max=1048576,stats=global)
none on /sys/fs/fuse/connections type fusectl (rw,relatime)
bpf on /sys/fs/bpf type bpf (rw,nosuid,nodev,noexec,relatime)
pstore on /sys/fs/pstore type pstore (rw,seclabel,nosuid,nodev,noexec,relatime)
/dev/block/mmcblk2p10 on /cache type ext4 (rw,seclabel,nosuid,nodev,noatime,nodiratime,discard,noauto_da_alloc)
/dev/block/mmcblk2p14 on /cust type ext4 (rw,seclabel,nosuid,nodev,noatime,nodiratime,discard,noauto_da_alloc)
/dev/block/mmcblk2p12 on /logo type ext4 (rw,seclabel,nosuid,nodev,noatime,nodiratime,discard,noauto_da_alloc)
tmpfs on /storage type tmpfs (rw,seclabel,nosuid,nodev,noexec,relatime,size=493048k,nr_inodes=123262,mode=755,gid=1000)
/dev/block/mmcblk2p16 on /data type ext4 (rw,seclabel,nosuid,nodev,noatime,discard,noauto_da_alloc,resgid=1065,data=ordered)
/dev/block/mmcblk2p16 on /data/user/0 type ext4 (rw,seclabel,nosuid,nodev,noatime,discard,noauto_da_alloc,resgid=1065,data=ordered)
tmpfs on /data_mirror type tmpfs (rw,seclabel,nosuid,nodev,noexec,relatime,size=493048k,nr_inodes=123262,mode=700,gid=1000)
/dev/block/mmcblk2p16 on /data_mirror/data_ce/null type ext4 (rw,seclabel,nosuid,nodev,noatime,discard,noauto_da_alloc,resgid=1065,data=ordered)
/dev/block/mmcblk2p16 on /data_mirror/data_ce/null/0 type ext4 (rw,seclabel,nosuid,nodev,noatime,discard,noauto_da_alloc,resgid=1065,data=ordered)
/dev/block/mmcblk2p16 on /data_mirror/data_de/null type ext4 (rw,seclabel,nosuid,nodev,noatime,discard,noauto_da_alloc,resgid=1065,data=ordered)
/dev/block/mmcblk2p16 on /data_mirror/cur_profiles type ext4 (rw,seclabel,nosuid,nodev,noatime,discard,noauto_da_alloc,resgid=1065,data=ordered)
/dev/block/mmcblk2p16 on /data_mirror/ref_profiles type ext4 (rw,seclabel,nosuid,nodev,noatime,discard,noauto_da_alloc,resgid=1065,data=ordered)
adb on /dev/usb-ffs/adb type functionfs (rw,relatime)
mtp on /dev/usb-ffs/mtp type functionfs (rw,relatime)
ptp on /dev/usb-ffs/ptp type functionfs (rw,relatime)
/dev/fuse on /mnt/user/0/emulated type fuse (rw,lazytime,nosuid,nodev,noexec,noatime,user_id=0,group_id=0,allow_other)
/dev/fuse on /mnt/installer/0/emulated type fuse (rw,lazytime,nosuid,nodev,noexec,noatime,user_id=0,group_id=0,allow_other)
/dev/fuse on /mnt/androidwritable/0/emulated type fuse (rw,lazytime,nosuid,nodev,noexec,noatime,user_id=0,group_id=0,allow_other)
/dev/fuse on /storage/emulated type fuse (rw,lazytime,nosuid,nodev,noexec,noatime,user_id=0,group_id=0,allow_other)
/dev/block/mmcblk2p16 on /mnt/pass_through/0/emulated type ext4 (rw,seclabel,nosuid,nodev,noatime,discard,noauto_da_alloc,resgid=1065,data=ordered)
/dev/block/mmcblk2p16 on /mnt/user/0/emulated/0/Android/data type ext4 (rw,seclabel,nosuid,nodev,noatime,discard,noauto_da_alloc,resgid=1065,data=ordered)
/dev/block/mmcblk2p16 on /storage/emulated/0/Android/data type ext4 (rw,seclabel,nosuid,nodev,noatime,discard,noauto_da_alloc,resgid=1065,data=ordered)
/dev/block/mmcblk2p16 on /mnt/androidwritable/0/emulated/0/Android/data type ext4 (rw,seclabel,nosuid,nodev,noatime,discard,noauto_da_alloc,resgid=1065,data=ordered)
/dev/block/mmcblk2p16 on /mnt/installer/0/emulated/0/Android/data type ext4 (rw,seclabel,nosuid,nodev,noatime,discard,noauto_da_alloc,resgid=1065,data=ordered)
/dev/block/mmcblk2p16 on /mnt/user/0/emulated/0/Android/obb type ext4 (rw,seclabel,nosuid,nodev,noatime,discard,noauto_da_alloc,resgid=1065,data=ordered)
/dev/block/mmcblk2p16 on /storage/emulated/0/Android/obb type ext4 (rw,seclabel,nosuid,nodev,noatime,discard,noauto_da_alloc,resgid=1065,data=ordered)
/dev/block/mmcblk2p16 on /mnt/androidwritable/0/emulated/0/Android/obb type ext4 (rw,seclabel,nosuid,nodev,noatime,discard,noauto_da_alloc,resgid=1065,data=ordered)
/dev/block/mmcblk2p16 on /mnt/installer/0/emulated/0/Android/obb type ext4 (rw,seclabel,nosuid,nodev,noatime,discard,noauto_da_alloc,resgid=1065,data=ordered)
/dev/block/vold/public:179,1 on /mnt/media_rw/664B-19FD type vfat (rw,dirsync,nosuid,nodev,noexec,noatime,gid=1023,fmask=0007,dmask=0007,allow_utime=0020,codepage=437,iocharset=iso8859-1,shortname=mixed,utf8,errors=remount-ro)
/dev/fuse on /mnt/user/0/664B-19FD type fuse (rw,lazytime,nosuid,nodev,noexec,noatime,user_id=0,group_id=0,allow_other)
/dev/fuse on /mnt/installer/0/664B-19FD type fuse (rw,lazytime,nosuid,nodev,noexec,noatime,user_id=0,group_id=0,allow_other)
/dev/fuse on /mnt/androidwritable/0/664B-19FD type fuse (rw,lazytime,nosuid,nodev,noexec,noatime,user_id=0,group_id=0,allow_other)
/dev/fuse on /storage/664B-19FD type fuse (rw,lazytime,nosuid,nodev,noexec,noatime,user_id=0,group_id=0,allow_other)
/dev/block/vold/public:179,1 on /mnt/pass_through/0/664B-19FD type vfat (rw,dirsync,nosuid,nodev,noexec,noatime,gid=1023,fmask=0007,dmask=0007,allow_utime=0020,codepage=437,iocharset=iso8859-1,shortname=mixed,utf8,errors=remount-ro)
```

## Filesystem Usage

```text
Filesystem            Size Used Avail Use% Mounted on
tmpfs                 481M 1.1M  480M   1% /dev
tmpfs                 481M    0  481M   0% /mnt
/dev/block/mmcblk2p11  11M 120K   11M   2% /metadata
/dev/block/dm-0       756M 753M     0 100% /
/dev/block/dm-2       272M 271M     0 100% /vendor
/dev/block/dm-4       819M 816M     0 100% /odm
/dev/block/dm-1        71M  71M     0 100% /system_ext
/dev/block/dm-3        21M  21M     0 100% /vendor_dlkm
/dev/block/dm-5       232K  32K  196K  15% /odm_dlkm
/dev/block/dm-6       200M 199M     0 100% /product
tmpfs                 481M 8.0K  481M   1% /apex
tmpfs                 481M 572K  481M   1% /linkerconfig
/dev/block/mmcblk2p10 356M 320K  344M   1% /cache
/dev/block/mmcblk2p14  58M  20K   56M   1% /cust
/dev/block/mmcblk2p12  58M 1.2M   52M   3% /logo
/dev/block/mmcblk2p16 3.7G 1.2G  2.4G  34% /data
tmpfs                 481M    0  481M   0% /data_mirror
/dev/fuse             3.7G 1.2G  2.4G  34% /storage/emulated
/dev/fuse              29G 2.3G   27G   9% /storage/664B-19FD
```

## fstab Sources

```text
.
./odm
./odm/lost+found
./odm/bundled_uninstall_back-app
./odm/bundled_uninstall_back-app/Xuper5.1.1
./odm/bundled_uninstall_back-app/Xuper5.1.1/lib
./odm/bundled_uninstall_back-app/Xuper5.1.1/lib/arm
./odm/bundled_uninstall_back-app/Xuper5.1.1/lib/arm/libc++_shared.so
./odm/bundled_uninstall_back-app/Xuper5.1.1/lib/arm/libijkplayer.so
./odm/bundled_uninstall_back-app/Xuper5.1.1/lib/arm/libcrashlytics.so
./odm/bundled_uninstall_back-app/Xuper5.1.1/lib/arm/libijkffmpeg.so
./odm/bundled_uninstall_back-app/Xuper5.1.1/lib/arm/libijksdl.so
./odm/bundled_uninstall_back-app/Xuper5.1.1/lib/arm/libcrashlytics-common.so
./odm/bundled_uninstall_back-app/Xuper5.1.1/lib/arm/libboost_multidex.so
./odm/bundled_uninstall_back-app/Xuper5.1.1/lib/arm/libcrashlytics-handler.so
./odm/bundled_uninstall_back-app/Xuper5.1.1/lib/arm/libumeng-spy.so
./odm/bundled_uninstall_back-app/Xuper5.1.1/lib/arm/libtnet-3.1.14.so
./odm/bundled_uninstall_back-app/Xuper5.1.1/lib/arm/libcrashlytics-trampoline.so
./odm/bundled_uninstall_back-app/Xuper5.1.1/lib/arm/libcrashsdk.so
./odm/bundled_uninstall_back-app/Xuper5.1.1/lib/arm/libranger-jni.so
./odm/bundled_uninstall_back-app/Xuper5.1.1/Xuper5.1.1.apk
./odm/bundled_uninstall_back-app/TX_emualtor
./odm/bundled_uninstall_back-app/TX_emualtor/TX_emualtor.apk
./odm/bundled_uninstall_back-app/TX_emualtor/lib
./odm/bundled_uninstall_back-app/TX_emualtor/lib/arm
./odm/bundled_uninstall_back-app/TX_emualtor/lib/arm/libretroarch-activity.so
./odm/bundled_uninstall_back-app/netflix
./odm/bundled_uninstall_back-app/netflix/netflix.apk
./odm/bundled_uninstall_back-app/netflix/lib
./odm/bundled_uninstall_back-app/netflix/lib/arm
./odm/bundled_uninstall_back-app/netflix/lib/arm/libtensorflowlite_jni_gms_client.so
./odm/bundled_uninstall_back-app/netflix/lib/arm/libbugsnag-plugin-android-anr.so
./odm/bundled_uninstall_back-app/netflix/lib/arm/libcronet.113.0.5672.61.so
./odm/bundled_uninstall_back-app/netflix/lib/arm/libc++_shared.so
./odm/bundled_uninstall_back-app/netflix/lib/arm/libtwilio_voice_android_so.so
./odm/bundled_uninstall_back-app/netflix/lib/arm/libef5f.so
./odm/bundled_uninstall_back-app/netflix/lib/arm/libmediastreamer_voip.so
./odm/bundled_uninstall_back-app/netflix/lib/arm/liblinphone.so
./odm/bundled_uninstall_back-app/netflix/lib/arm/libortp.so
./odm/bundled_uninstall_back-app/netflix/lib/arm/libmediastreamer_base.so
./odm/bundled_uninstall_back-app/netflix/lib/arm/libavif_android.so
./odm/bundled_uninstall_back-app/netflix/lib/arm/libmswebrtc.so
./odm/bundled_uninstall_back-app/netflix/lib/arm/libbctoolbox.so
./odm/bundled_uninstall_back-app/netflix/lib/arm/libbugsnag-root-detection.so
./odm/bundled_uninstall_back-app/netflix/lib/arm/libandroidx.graphics.path.so
./odm/bundled_uninstall_back-app/netflix/lib/arm/libbugsnag-ndk.so
./odm/bundled_uninstall_back-app/YouTube_for_Android_TV
./odm/bundled_uninstall_back-app/YouTube_for_Android_TV/lib
./odm/bundled_uninstall_back-app/YouTube_for_Android_TV/lib/arm
./odm/bundled_uninstall_back-app/YouTube_for_Android_TV/lib/arm/libelements.so
./odm/bundled_uninstall_back-app/YouTube_for_Android_TV/lib/arm/libcronet.88.0.4304.4.so
./odm/bundled_uninstall_back-app/YouTube_for_Android_TV/lib/arm/libnativecrashdetector.so
./odm/bundled_uninstall_back-app/YouTube_for_Android_TV/lib/arm/libcoat.so
./odm/bundled_uninstall_back-app/YouTube_for_Android_TV/YouTube_for_Android_TV.apk
./odm/bundled_uninstall_back-app/TX_PSP
./odm/bundled_uninstall_back-app/TX_PSP/TX_PSP.apk
./odm/bundled_uninstall_back-app/TX_PSP/lib
./odm/bundled_uninstall_back-app/TX_PSP/lib/arm
./odm/bundled_uninstall_back-app/TX_PSP/lib/arm/libppsspp_jni.so
./odm/bundled_uninstall_back-app/TX_PSP/lib/arm/libzstd.so
./odm/bundled_uninstall_back-app/TX_PSP/lib/arm/libVkLayer_khronos_validation.so
./odm/bundled_uninstall_back-app/tx3326_3566_20250103
./odm/bundled_uninstall_back-app/tx3326_3566_20250103/lib
./odm/bundled_uninstall_back-app/tx3326_3566_20250103/lib/arm
./odm/bundled_uninstall_back-app/tx3326_3566_20250103/lib/arm/libfba.so
./odm/bundled_uninstall_back-app/tx3326_3566_20250103/tx3326_3566_20250103.apk
./odm/bundled_uninstall_back-app/TX_mupen
./odm/bundled_uninstall_back-app/TX_mupen/lib
./odm/bundled_uninstall_back-app/TX_mupen/lib/arm
./odm/bundled_uninstall_back-app/TX_mupen/lib/arm/libmupen64plus-audio-android.so
./odm/bundled_uninstall_back-app/TX_mupen/lib/arm/libmupen64plus-video-rice.so
./odm/bundled_uninstall_back-app/TX_mupen/lib/arm/libmupen64plus-video-gln64.so
./odm/bundled_uninstall_back-app/TX_mupen/lib/arm/libmupen64plus-input-raphnet.so
./odm/bundled_uninstall_back-app/TX_mupen/lib/arm/libmupen64plus-rsp-parallel.so
./odm/bundled_uninstall_back-app/TX_mupen/lib/arm/libmupen64plus-video-parallel.so
./odm/bundled_uninstall_back-app/TX_mupen/lib/arm/libc++_shared.so
./odm/bundled_uninstall_back-app/TX_mupen/lib/arm/libmupen64plus-audio-android-fp.so
./odm/bundled_uninstall_back-app/TX_mupen/lib/arm/libmupen64plus-video-glide64mk2-egl.so
./odm/bundled_uninstall_back-app/TX_mupen/lib/arm/libmupen64plus-rsp-cxd4.so
./odm/bundled_uninstall_back-app/TX_mupen/lib/arm/libsoundtouch_fp.so
./odm/bundled_uninstall_back-app/TX_mupen/lib/arm/libnatpmp.so
./odm/bundled_uninstall_back-app/TX_mupen/lib/arm/libminiupnp-build.so
./odm/bundled_uninstall_back-app/TX_mupen/lib/arm/libmupen64plus-rsp-hle.so
./odm/bundled_uninstall_back-app/TX_mupen/lib/arm/libmupen64plus-input-android.so
./odm/bundled_uninstall_back-app/TX_mupen/lib/arm/libhidapi.so
./odm/bundled_uninstall_back-app/TX_mupen/lib/arm/libmupen64plus-video-GLideN64.so
./odm/bundled_uninstall_back-app/TX_mupen/lib/arm/libjnidispatch.so
./odm/bundled_uninstall_back-app/TX_mupen/lib/arm/libfreetype.so
./odm/bundled_uninstall_back-app/TX_mupen/lib/arm/libmupen64plus-video-glide64mk2.so
./odm/bundled_uninstall_back-app/TX_mupen/lib/arm/libminiupnp-bridge.so
./odm/bundled_uninstall_back-app/TX_mupen/lib/arm/libusb1.0.so
./odm/bundled_uninstall_back-app/TX_mupen/lib/arm/libsoundtouch.so
./odm/bundled_uninstall_back-app/TX_mupen/lib/arm/libae-bridge.so
./odm/bundled_uninstall_back-app/TX_mupen/lib/arm/liboboe.so
./odm/bundled_uninstall_back-app/TX_mupen/lib/arm/libSDL2_net.so
./odm/bundled_uninstall_back-app/TX_mupen/lib/arm/libmupen64plus-core.so
./odm/bundled_uninstall_back-app/TX_mupen/lib/arm/libmupen64plus-video-angrylion-plus.so
./odm/bundled_uninstall_back-app/TX_mupen/TX_mupen.apk
./odm/lib
./odm/lib/modules
./odm/etc
./odm/etc/NOTICE.xml.gz
./odm/etc/fs_config_dirs
./odm/etc/package_performance.xml
./odm/etc/passwd
./odm/etc/fs_config_files
./odm/etc/build.prop
./odm/etc/group
./odm/etc/selinux
./odm/etc/selinux/precompiled_sepolicy.product_sepolicy_and_mapping.sha256
./odm/etc/selinux/precompiled_sepolicy
./odm/etc/selinux/precompiled_sepolicy.system_ext_sepolicy_and_mapping.sha256
./odm/etc/selinux/precompiled_sepolicy.plat_sepolicy_and_mapping.sha256
./odm/bundled_persist-app
./odm/bundled_persist-app/QuickShare-Projector-Tianxing-3326-A-release-3.5.43
./odm/bundled_persist-app/QuickShare-Projector-Tianxing-3326-A-release-3.5.43/QuickShare-Projector-Tianxing-3326-A-release-3.5.43.apk
./odm/bundled_persist-app/QuickShare-Projector-Tianxing-3326-A-release-3.5.43/lib
./odm/bundled_persist-app/QuickShare-Projector-Tianxing-3326-A-release-3.5.43/lib/arm
./odm/bundled_persist-app/QuickShare-Projector-Tianxing-3326-A-release-3.5.43/lib/arm/librtp.so
./odm/bundled_persist-app/QuickShare-Projector-Tianxing-3326-A-release-3.5.43/lib/arm/libAudioDecoderWrapper.so
./odm/bundled_persist-app/QuickShare-Projector-Tianxing-3326-A-release-3.5.43/lib/arm/librsjni.so
./odm/bundled_persist-app/QuickShare-Projector-Tianxing-3326-A-release-3.5.43/lib/arm/libiosusbmirror.so
./odm/bundled_persist-app/QuickShare-Projector-Tianxing-3326-A-release-3.5.43/lib/arm/librtsp.so
./odm/bundled_persist-app/QuickShare-Projector-Tianxing-3326-A-release-3.5.43/lib/arm/libDecoderWrapper.so
./odm/bundled_persist-app/QuickShare-Projector-Tianxing-3326-A-release-3.5.43/lib/arm/libqs-ios-usb-server.so
./odm/bundled_persist-app/QuickShare-Projector-Tianxing-3326-A-release-3.5.43/lib/arm/libc++_shared.so
./odm/bundled_persist-app/QuickShare-Projector-Tianxing-3326-A-release-3.5.43/lib/arm/libactivate-lib.so
./odm/bundled_persist-app/QuickShare-Projector-Tianxing-3326-A-release-3.5.43/lib/arm/libexpng.so
./odm/bundled_persist-app/QuickShare-Projector-Tianxing-3326-A-release-3.5.43/lib/arm/libRSSupport.so
./odm/bundled_persist-app/QuickShare-Projector-Tianxing-3326-A-release-3.5.43/lib/arm/libijkplayer.so
./odm/bundled_persist-app/QuickShare-Projector-Tianxing-3326-A-release-3.5.43/lib/arm/libregister-lib.so
./odm/bundled_persist-app/QuickShare-Projector-Tianxing-3326-A-release-3.5.43/lib/arm/libijkffmpeg.so
./odm/bundled_persist-app/QuickShare-Projector-Tianxing-3326-A-release-3.5.43/lib/arm/libijksdl.so
./odm/bundled_persist-app/QuickShare-Projector-Tianxing-3326-A-release-3.5.43/lib/arm/libsonic.so
./odm/bundled_persist-app/QuickShare-Projector-Tianxing-3326-A-release-3.5.43/lib/arm/libfdk-aac.so
./odm/bundled_persist-app/QuickShare-Projector-Tianxing-3326-A-release-3.5.43/lib/arm/libnstackx_util.so
./odm/bundled_persist-app/QuickShare-Projector-Tianxing-3326-A-release-3.5.43/lib/arm/libopenGlDisplay.so
./odm/bundled_persist-app/QuickShare-Projector-Tianxing-3326-A-release-3.5.43/lib/arm/libnativeActivate.so
./odm/bundled_persist-app/QuickShare-Projector-Tianxing-3326-A-release-3.5.43/lib/arm/libNativeMouse-lib.so
./odm/bundled_persist-app/QuickShare-Projector-Tianxing-3326-A-release-3.5.43/lib/arm/libmirror.so
./odm/bundled_persist-app/QuickShare-Projector-Tianxing-3326-A-release-3.5.43/lib/arm/libnf_onehop.so
./odm/bundled_persist-app/QuickShare-Projector-Tianxing-3326-A-release-3.5.43/lib/arm/libsecurec.so
./odm/bundled_persist-app/QuickShare-Projector-Tianxing-3326-A-release-3.5.43/lib/arm/libConnectAuthNative.so
./odm/bundled_persist-app/QuickShare-Projector-Tianxing-3326-A-release-3.5.43/lib/arm/libjniHelper.so
./odm/bundled_persist-app/QuickShare-Projector-Tianxing-3326-A-release-3.5.43/lib/arm/libnstackx_dmsg.so
./odm/bundled_persist-app/QuickShare-Projector-Tianxing-3326-A-release-3.5.43/lib/arm/libmpeg.so
./odm/bundled_persist-app/QuickShare-Projector-Tianxing-3326-A-release-3.5.43/lib/arm/libblackBorder.so
./odm/bundled_persist-app/QuickShare-Projector-Tianxing-3326-A-release-3.5.43/lib/arm/libjniCodec.so
./odm/bundled_persist-app/QuickShare-Projector-Tianxing-3326-A-release-3.5.43/lib/arm/libpl_droidsonroids_gif.so
./odm/bundled_persist-app/QuickShare-Projector-Tianxing-3326-A-release-3.5.43/lib/arm/libBzAirplay-lib.so
./odm/bundled_persist-app/QuickShare-Projector-Tianxing-3326-A-release-3.5.43/lib/arm/libffmpegJNI.so
./odm/bundled_persist-app/QuickShare-Projector-Tianxing-3326-A-release-3.5.43/lib/arm/libjniFtSocketSink.so
./odm/bundled_persist-app/QuickShare-Projector-Tianxing-3326-A-release-3.5.43/lib/arm/libdlna-lib.so
./odm/bundled_persist-app/QuickShare-Projector-Tianxing-3326-A-release-3.5.43/lib/arm/libVirtualTouch-lib.so
./odm/bundled_persist-app/QuickShare-Projector-Tianxing-3326-A-release-3.5.43/lib/arm/libusbserver.so
./odm/bundled_persist-app/QuickShare-Projector-Tianxing-3326-A-release-3.5.43/lib/arm/libHwDeviceAuthSDK.so
./odm/bundled_persist-app/QuickShare-Projector-Tianxing-3326-A-release-3.5.43/lib/arm/libcrypto_1_1.so
./odm/bundled_persist-app/QuickShare-Projector-Tianxing-3326-A-release-3.5.43/lib/arm/libusb_server.so
./odm/bundled_persist-app/QuickShare-Projector-Tianxing-3326-A-release-3.5.43/lib/arm/libHwKeystoreSDK.so
./odm/bundled_persist-app/QuickShare-Projector-Tianxing-3326-A-release-3.5.43/lib/arm/libmiracast-lib.so
./odm/bundled_persist-app/QuickShare-Projector-Tianxing-3326-A-release-3.5.43/lib/arm/libairplay_sdk.so
./odm/bundled_persist-app/QuickShare-Projector-Tianxing-3326-A-release-3.5.43/lib/arm/libVirtualInput-lib.so
./odm/bundled_persist-app/QuickShare-Projector-Tianxing-3326-A-release-3.5.43/lib/arm/libnear_field_onehop_jni.so
./odm/bundled_persist-app/QuickShare-Projector-Tianxing-3326-A-release-3.5.43/lib/arm/librsjni_androidx.so
./odm/bundled_persist-app/QuickShare-Projector-Tianxing-3326-A-release-3.5.43/lib/arm/libnstackx_ctrl.so
./odm/bundled_persist-app/QuickShare-Projector-Tianxing-3326-A-release-3.5.43/lib/arm/libnative_codec_jni.so
./odm/bundled_persist-app/QuickShare-Projector-Tianxing-3326-A-release-3.5.43/lib/arm/liboboe.so
./odm/bundled_persist-app/QuickShare-Projector-Tianxing-3326-A-release-3.5.43/lib/arm/libssl_1_1.so
./odm/bundled_persist-app/QuickShare-Projector-Tianxing-3326-A-release-3.5.43/lib/arm/librtmp-jni.so
./odm/bundled_persist-app/QuickShare-Projector-Tianxing-3326-A-release-3.5.43/lib/arm/libmarsxlog.so
./odm/bundled_persist-app/QuickShare-Projector-Tianxing-3326-A-release-3.5.43/lib/arm/libwired-ios.so
./odm/bundled_persist-app/QuickShare-Projector-Tianxing-3326-A-release-3.5.43/lib/arm/libffmpeg.so
./odm/bundled_persist-app/QuickShare-Projector-Tianxing-3326-A-release-3.5.43/lib/arm/libRegisterClient.so
./odm_dlkm
./odm_dlkm/etc
./odm_dlkm/etc/build.prop
./odm_dlkm/etc/fs_config_dirs
./odm_dlkm/etc/NOTICE.xml.gz
./odm_dlkm/etc/fs_config_files
./odm_dlkm/lost+found
./postinstall
./apex
./apex/apex-info-list.xml
./apex/com.android.wifi
./apex/com.android.wifi/apex_manifest.pb
./apex/com.android.wifi/apex_pubkey
./apex/com.android.wifi/app
./apex/com.android.wifi/app/OsuLogin
./apex/com.android.wifi/app/OsuLogin/OsuLogin.apk
./apex/com.android.wifi/etc
./apex/com.android.wifi/etc/security
./apex/com.android.wifi/etc/security/cacerts_wfa
./apex/com.android.wifi/etc/security/cacerts_wfa/674b5f5b.0
./apex/com.android.wifi/etc/security/cacerts_wfa/21125ccd.0
./apex/com.android.wifi/etc/security/cacerts_wfa/ea93cb5b.0
./apex/com.android.wifi/etc/classpaths
./apex/com.android.wifi/etc/classpaths/bootclasspath.pb
./apex/com.android.wifi/javalib
./apex/com.android.wifi/javalib/framework-wifi.jar
./apex/com.android.wifi/javalib/service-wifi.jar
./apex/com.android.wifi/priv-app
./apex/com.android.wifi/priv-app/ServiceWifiResources
./apex/com.android.wifi/priv-app/ServiceWifiResources/ServiceWifiResources.apk
./apex/com.android.vndk.v32
./apex/com.android.vndk.v32/apex_manifest.pb
./apex/com.android.vndk.v32/apex_pubkey
./apex/com.android.vndk.v32/lib
./apex/com.android.vndk.v32/lib/libunwindstack.so
./apex/com.android.vndk.v32/lib/libstagefright_foundation.so
./apex/com.android.vndk.v32/lib/hw
./apex/com.android.vndk.v32/lib/hw/android.hidl.memory@1.0-impl.so
./apex/com.android.vndk.v32/lib/android.hardware.gnss-V1-ndk_platform.so
./apex/com.android.vndk.v32/lib/android.hardware.light-V1-ndk_platform.so
./apex/com.android.vndk.v32/lib/libxml2.so
./apex/com.android.vndk.v32/lib/libion.so
./apex/com.android.vndk.v32/lib/android.hardware.security.keymint-V1-ndk_platform.so
./apex/com.android.vndk.v32/lib/libssl.so
./apex/com.android.vndk.v32/lib/libstagefright_bufferqueue_helper.so
./apex/com.android.vndk.v32/lib/android.hardware.vibrator-V2-ndk_platform.so
./apex/com.android.vndk.v32/lib/libstagefright_omx.so
./apex/com.android.vndk.v32/lib/libRSCpuRef.so
./apex/com.android.vndk.v32/lib/libutilscallstack.so
./apex/com.android.vndk.v32/lib/libjsoncpp.so
./apex/com.android.vndk.v32/lib/libbase.so
./apex/com.android.vndk.v32/lib/libhidlbase.so
./apex/com.android.vndk.v32/lib/libblas.so
./apex/com.android.vndk.v32/lib/android.hardware.graphics.mapper@2.0.so
./apex/com.android.vndk.v32/lib/libhardware.so
./apex/com.android.vndk.v32/lib/libsqlite.so
./apex/com.android.vndk.v32/lib/libgatekeeper.so
./apex/com.android.vndk.v32/lib/android.hardware.health.storage-V1-ndk_platform.so
./apex/com.android.vndk.v32/lib/libbacktrace.so
./apex/com.android.vndk.v32/lib/android.hardware.graphics.common@1.0.so
./apex/com.android.vndk.v32/lib/libdmabufheap.so
./apex/com.android.vndk.v32/lib/android.system.keystore2-V1-ndk_platform.so
./apex/com.android.vndk.v32/lib/libprocessgroup.so
./apex/com.android.vndk.v32/lib/libstagefright_bufferpool@2.0.so
./apex/com.android.vndk.v32/lib/android.hardware.automotive.occupant_awareness-V1-ndk_platform.so
./apex/com.android.vndk.v32/lib/android.hardware.power-V2-ndk_platform.so
./apex/com.android.vndk.v32/lib/libRSDriver.so
./apex/com.android.vndk.v32/lib/android.hardware.rebootescrow-V1-ndk_platform.so
./apex/com.android.vndk.v32/lib/libexpat.so
./apex/com.android.vndk.v32/lib/android.hardware.graphics.common-V2-ndk_platform.so
./apex/com.android.vndk.v32/lib/libbinder.so
./apex/com.android.vndk.v32/lib/android.hardware.identity-V3-ndk_platform.so
./apex/com.android.vndk.v32/lib/libcutils.so
./apex/com.android.vndk.v32/lib/android.hidl.safe_union@1.0.so
./apex/com.android.vndk.v32/lib/libgralloctypes.so
./apex/com.android.vndk.v32/lib/android.hardware.graphics.mapper@4.0.so
./apex/com.android.vndk.v32/lib/android.hardware.power.stats-V1-ndk_platform.so
./apex/com.android.vndk.v32/lib/android.hardware.graphics.mapper@3.0.so
./apex/com.android.vndk.v32/lib/libcompiler_rt.so
./apex/com.android.vndk.v32/lib/android.hardware.memtrack-V1-ndk_platform.so
./apex/com.android.vndk.v32/lib/libmedia_omx.so
./apex/com.android.vndk.v32/lib/android.hidl.memory.token@1.0.so
./apex/com.android.vndk.v32/lib/libstagefright_omx_utils.so
./apex/com.android.vndk.v32/lib/libgui.so
./apex/com.android.vndk.v32/lib/android.hardware.graphics.mapper@2.1.so
./apex/com.android.vndk.v32/lib/android.hardware.security.sharedsecret-V1-ndk_platform.so
./apex/com.android.vndk.v32/lib/android.hardware.graphics.common@1.2.so
./apex/com.android.vndk.v32/lib/android.hardware.graphics.common@1.1.so
./apex/com.android.vndk.v32/lib/libbcinfo.so
./apex/com.android.vndk.v32/lib/libc++.so
./apex/com.android.vndk.v32/lib/android.hardware.common.fmq-V1-ndk_platform.so
./apex/com.android.vndk.v32/lib/android.hardware.oemlock-V1-ndk_platform.so
./apex/com.android.vndk.v32/lib/android.hardware.security.secureclock-V1-ndk_platform.so
./apex/com.android.vndk.v32/lib/android.hardware.authsecret-V1-ndk_platform.so
./apex/com.android.vndk.v32/lib/libz.so
./apex/com.android.vndk.v32/lib/libRS_internal.so
./apex/com.android.vndk.v32/lib/android.hardware.renderscript@1.0.so
./apex/com.android.vndk.v32/lib/android.hardware.common-V2-ndk_platform.so
./apex/com.android.vndk.v32/lib/libutils.so
./apex/com.android.vndk.v32/lib/libstagefright_xmlparser.so
./apex/com.android.vndk.v32/lib/libui.so
./apex/com.android.vndk.v32/lib/android.hidl.memory@1.0.so
./apex/com.android.vndk.v32/lib/android.hardware.weaver-V1-ndk_platform.so
./apex/com.android.vndk.v32/lib/liblzma.so
./apex/com.android.vndk.v32/lib/libcrypto.so
./apex/com.android.vndk.v32/lib/libhidlmemory.so
./apex/com.android.vndk.v32/etc
./apex/com.android.vndk.v32/etc/vndkcore.libraries.32.txt
./apex/com.android.vndk.v32/etc/vndkproduct.libraries.32.txt
./apex/com.android.vndk.v32/etc/vndksp.libraries.32.txt
./apex/com.android.vndk.v32/etc/vndkprivate.libraries.32.txt
./apex/com.android.vndk.v32/etc/llndk.libraries.32.txt
./apex/com.android.tzdata
./apex/com.android.tzdata/apex_manifest.pb
./apex/com.android.tzdata/apex_pubkey
./apex/com.android.tzdata/etc
./apex/com.android.tzdata/etc/icu
./apex/com.android.tzdata/etc/icu/icu_tzdata.dat
./apex/com.android.tzdata/etc/tz
./apex/com.android.tzdata/etc/tz/tzlookup.xml
./apex/com.android.tzdata/etc/tz/tzdata
./apex/com.android.tzdata/etc/tz/telephonylookup.xml
./apex/com.android.tzdata/etc/tz/tz_version
./apex/com.android.tethering
./apex/com.android.tethering/apex_manifest.pb
./apex/com.android.tethering/apex_pubkey
./apex/com.android.tethering/lib
./apex/com.android.tethering/lib/libframework-connectivity-jni.so
./apex/com.android.tethering/lib/libservice-connectivity.so
./apex/com.android.tethering/etc
./apex/com.android.tethering/etc/sdkinfo.pb
./apex/com.android.tethering/etc/bpf
./apex/com.android.tethering/etc/bpf/offload.o
./apex/com.android.tethering/etc/bpf/test.o
./apex/com.android.tethering/etc/classpaths
./apex/com.android.tethering/etc/classpaths/bootclasspath.pb
./apex/com.android.tethering/javalib
./apex/com.android.tethering/

[Output truncated in report; see raw log.]
```
