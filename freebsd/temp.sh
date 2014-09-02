#!/usr/local/bin/bash
# NET-SNMP helper script to publish CPU and disk temperature of FreeBSD hosts.
# This script reports the max and min temperatures of:
# - the CPU cores (found under sysctl dev.cpu.n.temperature)
# - the hard drives (probing all /dev/ada disks with a SMART utility)
# 
# Requirements:
# - smartctl needs to be installed to read disk temperature
# - user running this script needs to be able to access /dev/ada* devices


# How many CPU cores do we have?
ncpu=`sysctl hw.ncpu`
ncpu=${ncpu/hw.ncpu: /}
# We check all CPU cores temperature
for (( n=0 ; n<$ncpu ; n++ ))
do
	temp=$(/sbin/sysctl dev.cpu.$n.temperature | awk '{gsub(/..C$/,"",$2); print $2}')
	if [[ $temp != '' ]]; then
		if [[ $temp -gt ${max:=$temp} ]]; then
			max=$temp
		fi
		if [[ $temp -lt ${min:=$temp} ]]; then
			min=$temp
		fi
	fi
done
# We output the min and max values of cpu cores temperature
echo $min
echo $max

unset min
unset max

# We look for disk temperatures in the following devices list
for dev in $(ls /dev/ada?)
do
	temp=$(/usr/local/sbin/smartctl -l scttempsts $dev | awk '/^Current Temperature:/ {print $3}')
	if [[ $temp != '' ]]; then
		if [[ $temp -gt ${max:=$temp} ]]; then
			max=$temp
		fi
		if [[ $temp -lt ${min:=$temp} ]]; then
			min=$temp
		fi
	fi
done
# We output the min and max values of disk temperature
echo $min
echo $max

