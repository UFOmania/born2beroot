#!bin/bash

#Architecture ------------------------------------------------------------------------------
arch=$(uname -a)

#Memory Usage ------------------------------------------------------------------------------
m_usage=$(free -m | grep Mem: | awk '{printf("%d/%dMb (%.2f%%)", $3, $2, $3 / $2 * 100)}')

#Desk Usage ---------------------------------------------------------------------------------
gp="grep "^/dev" | grep -v "/boot""
d_used_mb=$(df -BM | eval $gp | awk '{x+=$3} END {print x}')
d_total_mb=$(df -BM | eval $gp | awk '{y+=$2} END {print y}')
d_total_gb=$(df -BG | eval $gp | awk '{y+=$2} END {print y}')
d_percentage=$(awk -v used=$d_used_mb -v total=$d_total_mb 'BEGIN {printf("(%.2f%%)",used/total*100)}')

#Cpu Load -----------------------------------------------------------------------------------
cpu_load=$(vmstat | awk 'NR==3 {printf "%.1f%%", 100-$15}')

#Last Boot ----------------------------------------------------------------------------------
last_boot=$(who -b | awk '{print $3" "$4}')


#LVM use ------------------------------------------------------------------------------------
lvm_use=$(if [ $(lsblk | grep lvm | wc -l) -eq 0 ]; then echo "no"; else echo "yes"; fi)

#Connection tcp------------------------------------------------------------------------------
connection_tcp=$(ss -t | grep ESTAB | wc -l)

#Network Ip ---------------------------------------------------------------------------------
net_ip=$(hostname -I)
net_mac=$(ip a | grep "link/ether" | awk '{print $2}')

#User log ----------------------------------------------------------------------------------
user_log=$(who | awk '{print $1}' | uniq | wc -l)

#Sudo ---------------------------------------------------------------------------------------
sudo_conter=$(journalctl _COMM=sudo | grep COMMAND | wc -l | awk '{print $1}')
wall "
    #Architecture: $(uname -a)
    #CPU physical : $(lscpu | grep "^CPU(s):" | awk '{print $2}')
    #vCPU : $(nproc)
    #Memory Usage: $m_usage
    #Desk Usage: $d_used_mb/$d_total_gb"Gb" $d_percentage
    #CPU load: ${cpu_load}
    #Last boot: $last_boot
    #LVM use: $lvm_use
    #Connection TCP : $connection_tcp ESTABLISHED
    #User log : $user_log
    #Network : IP $net_ip ($net_mac)
    #Sudo : $sudo_conter cmd "
