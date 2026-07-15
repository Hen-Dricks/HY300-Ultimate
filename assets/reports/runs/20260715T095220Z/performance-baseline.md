---
title: "Performance Baseline Report"
run_id: "20260715T095220Z"
generated_utc: "2026-07-15 09:53:41Z"
---

# Performance Baseline Report

This file records a static baseline. For meaningful comparisons, repeat collection under equivalent boot, temperature, network, and workload conditions.

## Memory

```text
MemTotal:        1979400 kB
MemFree:           42048 kB
MemAvailable:     647704 kB
Buffers:           15032 kB
Cached:           564720 kB
SwapCached:        34936 kB
Active:           284612 kB
Inactive:         331700 kB
Active(anon):     171972 kB
Inactive(anon):   184228 kB
Active(file):     112640 kB
Inactive(file):   147472 kB
Unevictable:        6344 kB
Mlocked:            2744 kB
SwapTotal:       1484536 kB
SwapFree:        1182968 kB
Dirty:               144 kB
Writeback:            20 kB
AnonPages:        330452 kB
Mapped:           196068 kB
Shmem:             27588 kB
KReclaimable:      58560 kB
Slab:             134108 kB
SReclaimable:      57604 kB
SUnreclaim:        76504 kB
KernelStack:       21056 kB
PageTables:        22792 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     1237116 kB
Committed_AS:   15078520 kB
VmallocTotal:   263061440 kB
VmallocUsed:       33296 kB
VmallocChunk:          0 kB
Percpu:             3552 kB
CmaTotal:          16384 kB
CmaAllocated:       2328 kB
CmaReleased:       14056 kB
CmaFree:               0 kB
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

## Running Processes

```text
USER           PID  PPID     VSZ    RSS STAT  NAME                       
root             1     0   45184   3960 S     init
root             2     0       0      0 S     [kthreadd]
root             3     2       0      0 I<    [rcu_gp]
root             4     2       0      0 I<    [rcu_par_gp]
root             8     2       0      0 I<    [mm_percpu_wq]
root             9     2       0      0 S     [ksoftirqd/0]
root            10     2       0      0 I     [rcu_preempt]
root            11     2       0      0 I     [rcu_sched]
root            12     2       0      0 I     [rcu_bh]
root            13     2       0      0 S     [migration/0]
root            15     2       0      0 S     [cpuhp/0]
root            16     2       0      0 S     [cpuhp/1]
root            17     2       0      0 S     [migration/1]
root            18     2       0      0 S     [ksoftirqd/1]
root            21     2       0      0 S     [cpuhp/2]
root            22     2       0      0 S     [migration/2]
root            23     2       0      0 S     [ksoftirqd/2]
root            26     2       0      0 S     [cpuhp/3]
root            27     2       0      0 S     [migration/3]
root            28     2       0      0 S     [ksoftirqd/3]
root            29     2       0      0 I     [kworker/3:0-sock_diag_events]
root            31     2       0      0 S     [kdevtmpfs]
root            32     2       0      0 I     [kworker/u8:1-cfg80211]
root            33     2       0      0 I<    [netns]
root            34     2       0      0 S     [rcu_tasks_kthre]
root            35     2       0      0 I     [kworker/3:1-events]
root            36     2       0      0 S     [kauditd]
root            38     2       0      0 I     [kworker/2:1-events]
root            39     2       0      0 S     [khungtaskd]
root            40     2       0      0 S     [oom_reaper]
root            41     2       0      0 I<    [writeback]
root            42     2       0      0 S     [kcompactd0]
root            43     2       0      0 I<    [crypto]
root            44     2       0      0 I<    [kblockd]
root            46     2       0      0 I<    [blk_crypto_wq]
root            47     2       0      0 I<    [devfreq_wq]
root            48     2       0      0 S     [watchdogd]
root            49     2       0      0 S     [cfinteractive]
root            50     2       0      0 I<    [cfg80211]
root            51     2       0      0 S     [kswapd0]
root            52     2       0      0 S     [irq/45-rockchip]
root            53     2       0      0 S     [irq/46-rockchip]
root            54     2       0      0 S     [irq/47-rockchip]
root            55     2       0      0 S     [irq/48-rockchip]
root            56     2       0      0 S     [queue_work0]
root            57     2       0      0 S     [irq/32-ff440000]
root            58     2       0      0 S     [irq/29-ff442400]
root            59     2       0      0 S     [irq/31-ff442000]
root            60     2       0      0 S     [hwrng]
root            61     2       0      0 I<    [gpu_power_off_w]
root            62     2       0      0 S     [mali-simple-pow]
root            64     2       0      0 I<    [kbase_job_fault]
root            65     2       0      0 D     [motor_run]
root            66     2       0      0 S     [dmabuf-deferred]
root            67     2       0      0 I<    [nvme-wq]
root            68     2       0      0 I<    [nvme-reset-wq]
root            69     2       0      0 I<    [nvme-delete-wq]
root            70     2       0      0 I     [kworker/u8:2-flush-179:0]
root            71     2       0      0 I<    [uas]
root            72     2       0      0 I<    [goodix_wq]
root            73     2       0      0 S     [irq/50-rk628_cs]
root            74     2       0      0 S     [irq/51-rk628_cs]
root            75     2       0      0 S     [irq/19-rockchip]
root            76     2       0      0 I<    [dm_bufio_cache]
root            78     2       0      0 I<    [cryptodev_queue]
root            79     2       0      0 S     [ion_system_heap]
root            80     2       0      0 I     [kworker/1:2-mm_percpu_wq]
root            81     2       0      0 I     [kworker/0:2-events]
root            82     2       0      0 I<    [ipv6_addrconf]
root            83     2       0      0 S<    [krfcommd]
root            84     2       0      0 I<    [mmc_complete]
root            86     2       0      0 I<    [kworker/0:1H-kblockd]
root            88     2       0      0 I<    [mmc_complete]
root            89     2       0      0 S     [irq/36-rga2]
root            94     2       0      0 I<    [kworker/2:1H-kblockd]
root            95     2       0      0 I<    [kworker/3:1H-kblockd]
root            96     2       0      0 S     [jbd2/mmcblk2p11]
root            97     2       0      0 I<    [ext4-rsv-conver]
root            98     2       0      0 I<    [kdmflush]
root            99     2       0      0 I<    [kdmflush]
root           100     2       0      0 I<    [kdmflush]
root           101     2       0      0 I<    [kdmflush]
root           102     2       0      0 I<    [kdmflush]
root           103     2       0      0 I<    [kdmflush]
root           104     2       0      0 I<    [kdmflush]
root           105     2       0      0 I<    [ext4-rsv-conver]
root           106     2       0      0 I<    [kworker/1:2H-kblockd]
root           107     2       0      0 I<    [ext4-rsv-conver]
root           108     2       0      0 I<    [ext4-rsv-conver]
root           109     2       0      0 I<    [ext4-rsv-conver]
root           110     2       0      0 I<    [ext4-rsv-conver]
root           112     2       0      0 I<    [ext4-rsv-conver]
root           113     2       0      0 I<    [ext4-rsv-conver]
root           116     1   13032   2272 S     init
root           118     1   13692   2516 S     ueventd
logd           130     1   16172   3224 SN    logd
lmkd           131     1    8596   2792 SL    lmkd
system         132     1   11964   3392 S     servicemanager
system         133     1   12240   3860 S     hwservicemanager
system         134     1   10908   2356 S     vndservicemanager
root           135     2       0      0 S     [psimon]
nobody         137     1   13864   3224 S     android.hardware.security.keymint-service.optee
root           138     1   21560   3760 S     vold
root           151     2       0      0 S     [jbd2/mmcblk2p10]
root           152     2       0      0 I<    [ext4-rsv-conver]
root           156     2       0      0 S     [jbd2/mmcblk2p14]
root           157     2       0      0 I<    [ext4-rsv-conver]
root           161     2       0      0 S     [jbd2/mmcblk2p12]
root           162     2       0      0 I<    [ext4-rsv-conver]
root           164     1   11056   1996 S     tee-supplicant
system         165     1   15000   3360 S     android.system.suspend@1.0-service
keystore       166     1   33032   5528 S     keystore2
system         172     1   86220  14316 S<    surfaceflinger
root           183     2       0      0 S     [jbd2/mmcblk2p16]
root           184     2       0      0 I<    [ext4-rsv-conver]
tombstoned     195     1    7704   1948 S     tombstoned
root           200     2       0      0 I<    [kbase_event]
system         211     1   16312   3120 S     android.hardware.graphics.allocator@4.0-service
system         221     1   65144   3436 S<    android.hardware.graphics.composer@2.1-service
statsd         266     1   20344   3196 S     statsd
root           267     1   32340   4876 S     netd
root           268     1 1226328  34780 S     zygote
system         272     1   10112   2492 S     android.hidl.allocator@1.0-service
audioserver    273     1   25832   2624 S     android.hardware.audio.service
bluetooth      274     1   17812   2344 S     android.hardware.bluetooth@1.0-service
cameraserver   275     1   25176   2704 S     android.hardware.camera.provider@2.4-external-service
cameraserver   276     1   30384   2864 S     android.hardware.camera.provider@2.4-service
system         277     1   12272   2316 S     android.hardware.gatekeeper@1.0-service.optee
root           278   267    7708   2080 S     iptables-restore
root           279   267    7708   2120 S     ip6tables-restore
system         281     1   11376   2844 S     android.hardware.health@2.1-service
mediacodec     282     1   33264   2044 S     android.hardware.media.c2@1.1-service
system         283     1   12604   2584 S     android.hardware.sensors@1.0-service
system         284     1   12688   2332 S     android.hardware.weaver@1.0-service
wifi           285     1   17280   2868 S     android.hardware.wifi@1.0-service
system         286     1   10664   3008 S     android.hardware.lights-service.rockchip
root           289     1   11012   3016 S     android.hardware.power-service.rockchip
media          291     1   18040   2368 S     rockchip.hardware.rockit.hw@1.0-service
audioserver    292     1   53392   5000 S     audioserver
credstore      293     1   13420   3516 S     credstore
gpu_service    294     1   18484   3372 S     gpuservice
drm            320     1   17112   3160 S     drmserver
cameraserver   322     1   41300   4064 S     cameraserver
incidentd      324     1   13964   3100 S     incidentd
root           325     1   17576   3576 S     installd
mediaex        326     1   39364   4548 S     media.extractor
media          327     1   22720   3436 S     media.metrics
root           328     2       0      0 S<    [skw_sdio_rx_thr]
media          331     1   45916   4416 S     mediaserver
root           334     1   16856   3324 SN    storaged
wifi           335     1   15528   3888 S     wificond
mediacodec     336     1   29244   2780 S     media.codec
mediacodec     344     1   51584   3924 S     media.swcodec
root           364     2       0      0 I<    [kworker/0:3H-mmc_complete]
root           365     2       0      0 I<    [skw_evt_wq.1]
mdnsr          405     1    2548    852 S     mdnsd
system         406     1   13932   3632 S     gatekeeperd
system         421   268 1847232 136864 S<    system_server
root           508     2       0      0 I<    [kworker/u9:3-fscrypt_read_queue]
wifi           592     1   19944   3980 S     wpa_supplicant
bluetooth      602   268 1098724  30912 S     com.android.bluetooth
secure_element 645   268 1048392  29360 S     com.android.se
webview_zygote 668   268 1172000  24288 S     webview_zygote
u0_a27         679   268 1115144  38064 S     com.android.systemui
system         693   268 1106008  52600 S<    com.android.tv.set
root           765     2       0      0 I<    [kbase_event]
root           848     1  818348   5160 S     daemon12138
root           884     2       0      0 S<    [loop0]
u0_a32         892   268 1082628  35676 S     com.android.providers.media.module
u0_a36         934   268 1210840  62476 S     com.spocky.projengmenu
u0_a19         948   268 1257304 104576 S     com.google.android.gms.persistent
u0_a19         976   268 1349276  57348 S     com.google.android.gms
root          1020     2       0      0 I<    [kworker/u9:4-fscrypt_read_queue]
system        1086   268 1055760  32528 S     com.shzhtxcz.txbox
u0_a20        1173   268 1243128  93908 S     com.android.vending
root          1218     2       0      0 I<    [kbase_event]
u0_a14        1315   268 1061600  30948 S     com.android.inputmethod.latin
system        1370   268 1050424  30164 S     com.rockchip.devicetest
system        1750   268 1423432  51960 S     com.bozee.usbdisplay
system        1847   268 1046928  31956 S     com.oranth.accessibility
system        1995   268 1343912  36368 S     com.huawei.connection
system        2387   268 1081632  48972 S     com.android.tv.settings
root          2403     2       0      0 I<    [kbase_event]
root          2443     2       0      0 I<    [kbase_event]
system        2472   268 1357228  49696 S     com.rockchip.itvbox
system        2516   268 1858260  39832 S     com.rockchip.itvbox:alive
root          2688   848  605356   8376 S     binary
root          3048  2688  620884  17312 S     systemServer6
root          3049  2688  625532   7056 S     systemServer11
root          3050  2688    2564   1484 S     systemServer14
root          3058  2688  539796  10828 S     systemServer1
root          3059  2688   12572   1400 S     systemServer2
root          3060  2688  534760   6684 S     systemServer5
shell         3177     1   27724   4484 S     adbd
root          3205     2       0      0 I     [kworker/2:0-events]
root          3206     2       0      0 I     [kworker/0:0-sock_diag_events]
root          3208     2       0      0 I<    [kworker/1:0H]
root          3217     2       0      0 I     [kworker/1:0-events]
root          3220     2       0      0 I<    [kworker/3:0H-kblockd]
root          3221     2       0      0 I<    [kworker/2:0H]
root          3345     2       0      0 I<    [kworker/u9:0-skw_txwq.1]
root          3346     2       0      0 I<    [kworker/u9:2-fscrypt_read_queue]
root          3347     2       0      0 I<    [kworker/u9:5-skw_txwq.1]
root          3358     2       0      0 I<    [kworker/0:2H]
root          3514     2       0      0 I     [kworker/2:2-events]
root          3515     2       0      0 I     [kworker/0:1-events]
root          3516     2       0      0 I     [kworker/1:1-events]
root          3518     2       0      0 I<    [kworker/1:1H-kblockd]
root          3520     2       0      0 I<    [kworker/2:2H-kblockd]
root          3524     2       0      0 I<    [kworker/3:2H-kblockd]
u0_a19        3543   268 1054936  45556 S     com.google.process.gapps
u0_a19        3559   268 1053336  47636 S     com.google.process.gservices
root          3594     2       0      0 I<    [kworker/0:0H-mmc_complete]
root          3661     2       0      0 I<    [kworker/3:3H]
root          3730     2       0      0 I<    [kbase_event]
root          3750     2       0      0 I     [kworker/u8:0]
shell         3861  3177    9452   3464 Rs    ps
```

## Power State

```text
POWER MANAGER (dumpsys power)

Power Manager State:
  Settings power_manager_constants:
    no_cached_wake_locks=true
  mDirty=0x0
  mWakefulness=Awake
  mWakefulnessChanging=false
  mIsPowered=true
  mPlugType=1
  mBatteryLevel=50
  mBatteryLevelWhenDreamStarted=0
  mDockState=0
  mStayOn=false
  mProximityPositive=false
  mBootCompleted=true
  mSystemReady=true
  mEnhancedDischargeTimeElapsed=0
  mLastEnhancedDischargeTimeUpdatedElapsed=0
  mEnhancedDischargePredictionIsPersonalized=false
  mHalAutoSuspendModeEnabled=false
  mHalInteractiveModeEnabled=true
  mWakeLockSummary=0x0
  mNotifyLongScheduled=+26s464ms
  mNotifyLongDispatched=-34s605ms
  mNotifyLongNextCheck=(none)
  mRequestWaitForNegativeProximity=false
  mInterceptedPowerKeyForProximity=false
  mSandmanScheduled=false
  mBatteryLevelLow=false
  mLightDeviceIdleMode=false
  mDeviceIdleMode=false
  mDeviceIdleWhitelist=[2000, 10007, 10019, 10025]
  mDeviceIdleTempWhitelist=[]
  mLastWakeTime=0 (923791 ms ago)
  mLastSleepTime=0 (923791 ms ago)
  mLastSleepReason=application
  mLastInteractivePowerHintTime=259340 (664451 ms ago)
  mLastScreenBrightnessBoostTime=0 (923791 ms ago)
  mScreenBrightnessBoostInProgress=false
  mHoldingWakeLockSuspendBlocker=false
  mHoldingDisplaySuspendBlocker=true
  mLastFlipTime=0
  mIsFaceDown=false

Settings and Configuration:
  mDecoupleHalAutoSuspendModeFromDisplayConfig=false
  mDecoupleHalInteractiveModeFromDisplayConfig=false
  mWakeUpWhenPluggedOrUnpluggedConfig=true
  mWakeUpWhenPluggedOrUnpluggedInTheaterModeConfig=false
  mTheaterModeEnabled=false
  mSuspendWhenScreenOffDueToProximityConfig=false
  mDreamsSupportedConfig=true
  mDreamsEnabledByDefaultConfig=true
  mDreamsActivatedOnSleepByDefaultConfig=true
  mDreamsActivatedOnDockByDefaultConfig=true
  mDreamsEnabledOnBatteryConfig=true
  mDreamsBatteryLevelMinimumWhenPoweredConfig=-1
  mDreamsBatteryLevelMinimumWhenNotPoweredConfig=15
  mDreamsBatteryLevelDrainCutoffConfig=5
  mDreamsEnabledSetting=true
  mDreamsActivateOnSleepSetting=true
  mDreamsActivateOnDockSetting=true
  mDozeAfterScreenOff=true
  mMinimumScreenOffTimeoutConfig=10000
  mMaximumScreenDimDurationConfig=7000
  mMaximumScreenDimRatioConfig=0.20000005
  mAttentiveTimeoutConfig=-1
  mAttentiveTimeoutSetting=-1
  mAttentiveWarningDurationConfig=30000
  mScreenOffTimeoutSetting=900000
  mSleepTimeoutSetting=-1
  mMaximumScreenOffTimeoutFromDeviceAdmin=9223372036854775807 (enforced=false)
  mStayOnWhilePluggedInSetting=0
  mScreenBrightnessModeSetting=0
  mScreenBrightnessOverrideFromWindowManager=NaN
  mUserActivityTimeoutOverrideFromWindowManager=-1
  mUserInactiveOverrideFromWindowManager=false
  mDozeScreenStateOverrideFromDreamManager=0
  mDrawWakeLockOverrideFromSidekick=false
  mDozeScreenBrightnessOverrideFromDreamManager=-1
  mScreenBrightnessMinimum=0.035433073
  mScreenBrightnessMaximum=1.0
  mScreenBrightnessDefault=0.39763778
  mDoubleTapWakeEnabled=false
  mIsVrModeEnabled=false
  mForegroundProfile=0
  mUserId=0

Attentive timeout: -1 ms
Sleep timeout: -1 ms
Screen off timeout: 900000 ms
Screen dim duration: 7000 ms

UID states (changing=false changed=false):
  UID 1000:   ACTIVE  count=0 state=0
  UID 1002:   ACTIVE  count=0 state=0
  UID 1068:   ACTIVE  count=0 state=0
  UID u0a14:   ACTIVE  count=0 state=7
  UID u0a19:   ACTIVE  count=0 state=5
  UID u0a20:   ACTIVE  count=0 state=5
  UID u0a27:   ACTIVE  count=0 state=0
  UID u0a32:   ACTIVE  count=0 state=0
  UID u0a36:   ACTIVE  count=0 state=5

Looper state:
  Looper (PowerManagerService, tid 46) {f7d4fa7}
    Message 0: { when=+26s463ms what=4 target=android.os.Handler }
    Message 1: { when=+3m48s548ms what=1 target=android.os.Handler }
    (Total messages: 2, polling=true, quitting=false)

Wake Locks: size=0

Suspend Blockers: size=4
  PowerManagerService.WakeLocks: ref count=0
  PowerManagerService.Display: ref count=1
  PowerManagerService.Broadcasts: ref count=0
  PowerManagerService.WirelessChargerDetector: ref count=0

Display Power: com.android.server.power.PowerManagerService$1@8c9fc54

Battery saving stats:
  Battery Saver is currently: OFF
    Times full enabled: 0
    Times adaptive enabled: 0
  
  Drain stats:
                     Battery saver OFF                          ON
  NonDoze NonIntr:      0m      0mAh(  0%)      0.0mAh/h          0m      0mAh(  0%)      0.0mAh/h
             Intr:      0m      0mAh(  0%)      0.0mAh/h          0m      0mAh(  0%)      0.0mAh/h
  Deep    NonIntr:      0m      0mAh(  0%)      0.0mAh/h          0m      0mAh(  0%)      0.0mAh/h
             Intr:      0m      0mAh(  0%)      0.0mAh/h          0m      0mAh(  0%)      0.0mAh/h
  Light   NonIntr:      0m      0mAh(  0%)      0.0mAh/h          0m      0mAh(  0%)      0.0mAh/h
             Intr:      0m      0mAh(  0%)      0.0mAh/h          0m      0mAh(  0%)      0.0mAh/h

Battery saver policy (*NOTE* they only apply when battery saver is ON):
  Settings: battery_saver_constants
    value: 
  Settings: (overlay)
    value: 
  DeviceConfig: battery_saver
    N/A
  mAccessibilityEnabled=false
  mAutomotiveProjectionActive=false
  mPolicyLevel=0
  
  Policy 'default full'
    advertise_is_enabled=true
    disable_vibration=true
    disable_animation=false
    defer_full_backup=true
    defer_keyvalue_backup=true
    enable_firewall=true
    enable_datasaver=false
    disable_launch_boost=true
    enable_brightness_adjustment=false
    adjust_brightness_factor=0.5
    location_mode=3
    force_all_apps_standby=true
    force_background_check=true
    disable_optional_sensors=true
    disable_aod=true
    soundtrigger_mode=1
    enable_quick_doze=true
    enable_night_mode=true
    Interactive File values:
      N/A
    
    Noninteractive File values:
      N/A
  
  Policy 'current full'
    advertise_is_enabled=true
    disable_vibration=true
    disable_animation=false
    defer_full_backup=true
    defer_keyvalue_backup=true
    enable_firewall=true
    enable_datasaver=false
    disable_launch_boost=true
    enable_brightness_adjustment=false
    adjust_brightness_factor=0.5
    location_mode=3
    force_all_apps_standby=true
    force_background_check=true
    disable_optional_sensors=true
    disable_aod=true
    soundtrigger_mode=1
    enable_quick_doze=true
    enable_night_mode=true
    Interactive File values:
      N/A
    
    Noninteractive File values:
      N/A
  
  Policy 'default adaptive'
    advertise_is_enabled=false
    disable_vibration=false
    disable_animation=false
    defer_full_backup=false
    defer_keyvalue_backup=false
    enable_firewall=false
    enable_datasaver=false
    disable_launch_boost=false
    enable_brightness_adjustment=false
    adjust_brightness_factor=1.0
    location_mode=0
    force_all_apps_standby=false
    force_background_check=false
    disable_optional_sensors=false
    disable_aod=false
    soundtrigger_mode=0
    enable_quick_doze=false
    enable_night_mode=false
    Interactive File values:
      N/A
    
    Noninteractive File values:
      N/A
  
  Policy 'current adaptive'
    advertise_is_enabled=false
    disable_vibration=false
    disable_animation=false
    defer_full_backup=false
    defer_keyvalue_backup=false
    enable_firewall=false
    enable_datasaver=false
    disable_launch_boost=false
    enable_brightness_adjustment=false
    adjust_brightness_factor=1.0
    location_mode=0
    force_all_apps_standby=false
    force_background_check=false
    disable_optional_sensors=false
    disable_aod=false
    soundtrigger_mode=0
    enable_quick_doze=false
    enable_night_mode=false
    Interactive File values:
      N/A
    
    Noninteractive File values:
      N/A
  
  Policy 'effective'
    advertise_is_enabled=false
    disable_vibration=false
    disable_animation=false
    defer_full_backup=false
    defer_keyvalue_backup=false
    enable_firewall=false
    enable_datasaver=false
    disable_launch_boost=false
    enable_brightness_adjustment=false
    adjust_brightness_factor=1.0
    location_mode=0
    force_all_apps_standby=false
    force_background_check=false
    disable_optional_sensors=false
    disable_aod=false
    soundtrigger_mode=0
    enable_quick_doze=false
    enable_night_mode=false
    Interactive File values:
      N/A
    
    Noninteractive File values:
      N/A

Battery saver state machine:
  Enabled=false
    full=false
    adaptive=false
  mState=1
  mLastChangedIntReason=0
  mLastChangedStrReason=null
  mBootCompleted=true
  mSettingsLoaded=true
  mBatteryStatusSet=true
  mIsPowered=true
  mBatteryLevel=50
  mIsBatteryLevelLow=false
  mSettingAutomaticBatterySaver=0
  mSettingBatterySaverEnabled=false
  mSettingBatterySaverEnabledSticky=false
  mSettingBatterySaverStickyAutoDisableEnabled=true
  mSettingBatterySaverStickyAutoDisableThreshold=90
  mSettingBatterySaverTriggerThreshold=0
  mBatterySaverStickyBehaviourDisabled=false
  mDynamicPowerSavingsDefaultDisableThreshold=80
  mDynamicPowerSavingsDisableThreshold=80
  mDynamicPowerSavingsEnableBatterySaver=false
  mLastAdaptiveBatterySaverChangedExternallyElapsed=0
AttentionDetector:
 mIsSettingEnabled=false
 mMaxExtensionMillis=900000
 mPreDimCheckDurationMillis=2000
 mEffectivePostDimTimeout=0
 mLastUserActivityTime(excludingAttention)=259340
 mAttentionServiceSupported=false
 mRequested=false

Profile power states: size=0
Display Group User Activity:
  displayGroupId=0
  userActivitySummary=0x1
  lastUserActivityTime=259340 (664479 ms ago)
  lastUserActivityTimeNoChangeLights=0 (923819 ms ago)
  mWakeLockSummary=0x0

Wireless Charger Detector State:
  mGravitySensor=null
  mPoweredWirelessly=false
  mAtRest=false
  mRestX=0.0, mRestY=0.0, mRestZ=0.0
  mDetectionInProgress=false
  mDetectionStartTime=0 (never)
  mMustUpdateRestPosition=false
  mTotalSamples=0
  mMovingSamples=0
  mFirstSampleX=0.0, mFirstSampleY=0.0, mFirstSampleZ=0.0
  mLastSampleX=0.0, mLastSampleY=0.0, mLastSampleZ=0.0
Wake Lock Log
  12-04 06:25:40.885 - 1000 - ACQ NetworkStats (partial)
  12-04 06:25:40.916 - 1000 - ACQ WiredAccessoryManager (partial)
  12-04 06:25:40.936 - 1000 - REL NetworkStats
  12-04 06:25:40.959 - 1000 - ACQ NetworkStats (partial)
  12-04 06:25:41.001 - 1000 - REL NetworkStats
  12-04 06:25:41.006 - 1000 - ACQ NetworkStats (partial)
  12-04 06:25:41.045 - 1000 - REL NetworkStats
  12-04 06:25:41.051 - 1000 - ACQ NetworkStats (partial)
  12-04 06:25:41.092 - 1000 - REL NetworkStats
  12-04 06:25:41.096 - 1000 - ACQ NetworkStats (partial)
  12-04 06:25:41.145 - 1000 - REL NetworkStats
  12-04 06:25:41.173 - 1000 - ACQ NetworkStats (partial)
  12-04 06:25:41.206 - 1000 - REL NetworkStats
  12-04 06:25:41.222 - 1000 - ACQ NetworkStats (partial)
  12-04 06:25:41.274 - 1000 - REL NetworkStats
  12-04 06:25:41.280 - 1000 - ACQ NetworkStats (partial)
  12-04 06:25:41.329 - 1000 - REL NetworkStats
  12-04 06:25:41.346 - 1000 - ACQ NetworkStats (partial)
  12-04 06:25:41.417 - 1000 - REL NetworkStats
  12-04 06:25:41.448 - 1000 - ACQ NetworkStats (partial)
  12-04 06:25:41.509 - 1000 - REL NetworkStats
  12-04 06:25:41.527 - 1000 - ACQ NetworkStats (partial)
  12-04 06:25:41.565 - 1000 - REL NetworkStats
  12-04 06:25:41.597 - 1000 - ACQ NetworkStats (partial)
  12-04 06:25:41.632 - 1000 - REL NetworkStats
  12-04 06:25:41.636 - 1000 - ACQ NetworkStats (partial)
  12-04 06:25:41.681 - 1000 - REL NetworkStats
  12-04 06:25:41.686 - 1000 - ACQ NetworkStats (partial)
  12-04 06:25:41.720 - 1000 - REL NetworkStats
  12-04 06:25:41.724 - 1000 - ACQ NetworkStats (partial)
  12-04 06:25:41.755 - 1000 - REL NetworkStats
  12-04 06:25:42.503 - 1000 - REL WiredAccessoryManager
  12-04 06:25:43.906 - 1002 - ACQ bluetooth_timer (partial)
  12-04 06:25:43.908 - 1002 - REL bluetooth_timer
  12-04 06:25:43.917 - 1002 - ACQ bluetooth_timer (partial)
  12-04 06:25:43.925 - 1002 - REL bluetooth_timer
  12-04 06:25:43.935 - 1002 - ACQ bluetooth_timer (partial)
  12-04 06:25:43.937 - 1002 - REL bluetooth_timer
  12-04 06:25:43.960 - 1002 - ACQ bluetooth_timer (pa

[Output truncated in report; see raw log.]
```
