alias h5='head -5'
unalias h5

ls -l bac installl.log > log.txt 2>&1
ls  					 &> log.txt

echo "passwd" | passwd --stdin root > /dev/null

id tom >> user 2>> error


bash命令之间的
&&:前一句执行成功才执行后一句
||:前一句执行失败才执行后一句 
id tom &> /dev/null && echo "tom exist" || echo "no such user"


jobs 后台挂起的进程
fg 1  将后台进程 前台

NAME=tomcat
echo $NAME
typeset -r NAME只读

declare INT_NUMBER
typeset -i INT_NUMBER
INT_NUMBER=200
echo INT_NUMBER

read P_NUMBER
read -p "input a number" P_NUMBER

set 查看所有系统变量
unset P_NUMBER 删除变量

设置为环境变量
export P_NUMBER
export NAME=tom

PATH=$PATH:/root

变量的展开和替换
NAME=tom
echo ${NAME:-no user};echo NAME  如果没有就输出no user

USR=$(head -1 /etc/passwd)
删除
echo ${USR#*:}
${USR%:*}
替换
${USR/root/admin}
${USR//root/admin}

A[1]=11
A[2]=22
echo ${A[*]}

B=(aa bb c)
echo $B{[0]}
echo ${#B[@]}	 3
echo ${#B[0]}    2


$((x+y))
expr arg1 + arg2

test -d /etc/ && echo "Y" || echo "N"
[ -d /etc/ ] && echo "Y" || echo "N"



## sed 指令
sed '2a TYPE=Ethernet' test.txt
sed '3i TYPE=Ethernet' test.txt
sed 's/yes/no/g' test.test
sed '3,4d' test.txt

正则
sed '/ONBOOT/a TYPE=Ethernet' test.txt
sed '/^GATEWAY/d' test.txt

sed -f sed.sh test.txt


sed 's/yes/no/;s/static/dhcp/' test.txt
sed -e 's/yes/no/' -e 's/static/dhcp/' test.txt

sed -n '1~2p' test.txt






#shell

文字排序
for i in {1..80}
do 
	cut -c$i $1 >> one.txt
	cut -c$i $2 >> two.txt
done
grep "[[:alnum:]]" one.txt > onebak.tmp
grep "[[:alnum:]]" two.txt > twobak.tmp
sort onebak.tmp | uniq -c |sort -k1,1n -k2,2n |tail -30 > oneresult
sort twobak.tmp | uniq -c |sort -k1,1n -k2,2n |tail -30 > tworesult


if [ "$(id -u)" -eq "0" ];then
	tar -czf /root/etc.tar.gz /etc & > /dev/null
fi


read -p "enter password" password
if [ "%password" == "pass" ];then
	echo "ok"
else
	echo "error"
fi


if [ $1 -ge 80];then
	echo "excellence"
elif [ $1 -ge 70 ];then
	echo "fine"
elif [ $1 -ge 60 ];then
	echo "pass"
else
	echo "f"
fi



DATE=$(date +%a)
TIME=$(date +%Y%m%d)
case %DATE in
	Wed | Fri)
tar -czf /usr/srv/${TIME}_log_tar.gz /var/log/ &> /dev/null
;;
	*)
echo "today neither wed nor fri."
esac
	

case $1 in 
	[a-z]|[A-Z])
echo "you have type a character"
;;
	[[:digit:]])
echo "number"
;;
	*)
echo "error"
esac	



case $1 in
	start)
firefox &
;;
	stop)
pkill firefox
;;
	restart)
pkill firefox
firefox &
;;
	*)
echo "test"
esac


domain=gamil.com
for mail_u in tom jerry smith
do
	mail -s "log" $mail_u$domain < /var/log/messages
done


for num in {1..20}
do
	echo $num
done


for i in {1..9}
do
	for ((j=1;j<=i;j++))
	do
		printf "%-8s" $j*$i=$((j*i))
	done
	echo
done


u_num=1
while [ $u_num -le 20 ]
do
	useradd user${u_num}
	u_num=$((u_num+1))
done


FILE=/etc/sysconfig/network-scripts/ifcfg-ens33
while read -r line
do
	echo $line
done < $FILE


u_num=20
until [ $u_num -eq 0 ] 
do
	userdel user${u_num}
	u_num=$((u_num-1))
done


echo "where you from"
select var in "beijing" "shanghai"
do
	break
done
echo "you are from $var"

for i in $@
do
	echo $1
	shift
done



for ip in ${1..254}
do
	case $ip in 
		10)
			continue
			;;
		15)
			break
	esac
	echo $ip
done
sleep 5
exit






HINT(){
read -p "please enter to continue"
}

cat /proc/cpuinfo | awk 'BEGIN {FS=":"} /model name/{print "cpu model:"$2}'
cat /proc/cpuinfo | wak 'BEGIN {FS=":"} /cpu MHz/{print "cpu speed"$2"MHz"}'
grep -Eq 'svm|vmx' /proc/cpuinfo