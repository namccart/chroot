# Performance tweaks
# Run this once on boot-up from an Android shell

# Stop uneeded services to free RAM
/system/bin/stop bt-dun
/system/bin/stop bluetoothd
/system/bin/stop dbus
/system/bin/stop qcamerasvr
/system/bin/stop drm
/system/bin/stop hdmid


# Stop service that makes cpu on/off & throttle decisions
/system/bin/stop mpdecision

# Prevent cpu speed changes due to thermal protection
# /system/bin/stop sensors
/system/bin/stop thermald

# Disable power collapse
echo 0 > /sys/module/pm_8x60/modes/cpu0/power_collapse/suspend_enabled
echo 0 > /sys/module/pm_8x60/modes/cpu1/power_collapse/suspend_enabled
echo 0 > /sys/module/pm_8x60/modes/cpu0/standalone_power_collapse/suspend_enabled
echo 0 > /sys/module/pm_8x60/modes/cpu1/standalone_power_collapse/suspend_enabled
echo 0 > /sys/module/pm_8x60/modes/cpu0/standalone_power_collapse/idle_enabled
echo 0 > /sys/module/pm_8x60/modes/cpu1/standalone_power_collapse/idle_enabled
echo 0 > /sys/module/pm_8x60/modes/cpu0/power_collapse/idle_enabled

# Force second Krait core online
echo 1 > /sys/devices/system/cpu/cpu1/online

# Define CPU speed limits for Krait cores
# This is a quick way to prevent the scaling governor or other processes from choosing a slower speed
cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
cat /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq > /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq

# cpu core frequency choices can be found here:
# cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies
# 384000 486000 594000 702000 810000 918000 1026000 1134000 1242000 1350000 1458000 1512000 
# echo 1026000 > /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq

# cpu core power scheme choices can be found here:
# cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors
# ondemand userspace powersave performance
echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor

echo "$0: CPU 0, CPU 1 current freq (kHz):"
cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
cat /sys/devices/system/cpu/cpu1/cpufreq/scaling_cur_freq

echo "$0: Once-per-boot performance improvements applied."
