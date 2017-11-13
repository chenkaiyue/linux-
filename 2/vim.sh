:s/root/admin/g
:%s/root/admin/g

useradd
groupadd
usermod -g mail tom


mkdir -p /var/{teach,office,finance,admin,market}
groupadd teach
groupadd finance

useradd -g teach op_teach
useradd -g finance op_finance

useradd -g teach 111
useradd -g finance 222

gpasswd -A op_teach teach
gpasswd -A op_finance  finance

chown op_teach:teach /var/teach
chown op_finance:finance /var/finance

chmod 755 /var/{teach,finance}




##ACL访问控制 设置针对用户或者组的访问权限
getfacl install.log
setfacl -m u:user1:rw install.log
setfacl -m g:user1:r test.txt
setfacl -x u:user1 install.log 
setfacl -b test.txt #删除所有acl规则





##存储管理
sd
sda sdb ...
mbr分区方式，最多分为4个区
扩展分区中创建逻辑分区，一定以5的编号开始
fdisk /dev/sdb #分区

partprobe /dev/sdb
#立即读取新的分区


GPT分区支持多个分区
#修改分区表格式
parted /dev/sdb mkalbel gpt
#打印
parted /dev/sdb print
parted /dev/sdc mkpart primary ext3 1 2G
parted /dev/sdc mkpart primary ext3 2G 4G
parted /dev/sdc rm 2 #删除分区

###格式化
mkfs.xfs /dev/sdc1
mkswap /dev/sdc2

###挂载
mount /dev/sdc1 /data1/
mount /dev/cdrom /media/

修改/etc/fstab 重启后依旧生效
/dev/sdc1  /data1 xfs defaults 0 0
mount -admin #挂载/etc/fstab中的所有文件系统
mount #查看所有的文件系统


###LVM逻辑卷
创建物理卷
pvcreate /dev/sdc /dev/sd3
pvcreate /dev/sdb{1,2,3}
创建卷组
vgcreate test_vg1 /dev/sdb5 /dev/sdb6
创建逻辑卷
lvcreate -L 2G -n testl_lv1 test_vg1


fdisk /dev/sdb
pvcreate /dev/sdb{1,2,3,5}
pvdisplay
vgcreate test_vg /dev/sdb{1,2,3,5}
vgdisplay
lvcreate -n test_web -L 120G test_vg
lvdisplay

mkfs.xfs /dev/test_vg/test_web

cat >> /etc/fstab <<EOF
>/dev/test_vg/test_web /test/web xfs defaults 0 0 
EOF


###修改LVM分区容量

卷组还有剩余容量的时候
lvextend -L +120G /dev/test_vg/test_web
xfs_growfs /dev/test_vg/test_web
df -h

卷组没有剩余容量的时候卷组
fdisk /dev/sdb 创建新分区
pvcreate /dev/sdb6
vgextend test_vg /dev/sdb6
vgdisplay test_vg
lvextend -L 360G /dev/test_vg/test_web
xfs_growfs /dev/test_vg/test_web
df -h

##删除lvm分区
unmount /dev/test_vg/test_web
lvremove /dev/test_vg/test_web
vgremove test_vg
pvremove /dev/sdb{1,2,3,5,6}


LVM修改分区标签的时候对应的是8e

## RAID
LVM修改分区标签的时候对应的是fd


创建RAID
mdadm -C /dev/md0 -l 0 -n 3 /dev/sdb1 /dev/sdc1 /dev/sdd1
mdadm --detail /dev/md0
mkfs.xfs /dev/md0
mount /dev/md0 /raid0

echo "DEVICE /dev/sdb1 /dev/sdc1" > /etc/mdadm.conf
echo "/dev/md0 /raid0 xfs defaults 0 0" >>　/etc/fstab

测试速度 dd用于复制文件
time dd if=/dev/zero of=txt bs=1M count=1000

模拟故障
mdadm /dev/md0 -f /dev/sdb1
mdadm --detail /dev/md0


## 软件管理
RPM
rpm -i ftp.rpm 安装
rpm -e ftp 卸载
rpm -q ftp 查询
rpm -V bash 查看改动

YUM
yum install 
yum -y 
yum remove dialog 卸载
yum clean all



systemctl start sshd
systemctl stop sshd
systemctl status sshd

systemctl reload sshd
systemctl condrestart sshd

systemctl enable sshd
systemctl disable sshd



##计划任务
一次任务
at 23:11
tar -cjf log.tar.bz2 /var/log

at -l
at -c 1
ad -d 1

周期执行任务
crontab -e


##性能监控
cpu使用情况 uptime
内存交换分区使用情况  free
磁盘使用情况 df -h  	df -i
网络使用情况 ip a s 		查看网卡流量信息ip -s link show ens33
netstat -nutlp
netstat -s
进程使用情况
ps -e
ps -ef
top -d 1 -p 1,2


## 网络设置
网络接口参数
通过命令行设置
ifconfig ens33 192.168.0.31 netmask 255.255.255.0
ifconfig ens33 down
ifconfig ens33 up

修改网卡配置文件/etc/sysconfig/network-scripts/ifcfg-<iface>
systemctl restart network



主机名参数
通过命令行设置
hostnamectl status
hostnamectl set-hostname centos

/etc/hostname



路由参数
通过命令行设置
route -n 
route add default gw 192.168.0.254
route add -net 172.16.0.0/16 gw 192.168.0.254
route add -net 192.56.76.0 netmask 255.255.255.0 dev ens33
route del default gw 192.168.0.254
route del -net 172.16.0.0/16

/etc/sysconfig/network-scripts/route-<iface>
systemctl restart network



网络故障排错
ping

traceroute linux默认使用udp实现，可以指定ICMP
traceroute -I www.baidu.com

DNS服务
nslookup 
dig

netstat -an
netstat -nutlp


