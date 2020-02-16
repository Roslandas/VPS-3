#!/bin/bash
tput setaf 7 ; tput setab 4 ; tput bold ; printf '%35s%s%-20s\n' "User Backup 1.2" ; tput sgr0
tput setaf 3 ; tput bold ; echo ""
echo "Demesio: tai yra eksperimentinis scriptas ir be garantiju, naudokites savo rizika."
echo "Sis scriptas yra naudojamas visų vartotojų ir slaptažodžio kopijoms sukurti"
echo "perkelti i nauja serveri."
echo "Venkite darbo kurdami visu vartotoju paskyras is naujo."
echo "I sia atsargine kopija ieina ir pagrindinio vartotojo slaptazodis!" ; tput sgr0

echo ""
echo "Ka tu nori padaryti?"
echo ""
echo "1 - SUKURKITE BACKUP"
echo "2 - ATKURTI BACKUP"
echo "3 - ISEITI"
echo ""

read -p "opcion: " -e -i 3 opcao

if [[ "$opcao" = '1' ]]; then
	if [ -f "/root/usuarios.db" ]
	then
		echo ""
		echo "Kurti backup..."
		echo ""
		tar cvf /root/backup.vps /root/usuarios.db /etc/shadow /etc/passwd /etc/group /etc/gshadow
		echo ""
		echo "Archyvas /root/backup.vps sukurta sekmingai."
		echo ""
	else
		echo ""
		echo "Kurti backup..."
		echo ""
		tar cvf /root/backup.vps /etc/shadow /etc/passwd /etc/group /etc/gshadow
		echo ""
		echo "Archyvas /root/backup.vps sukurta sekmingai."
		echo ""
	fi
fi
if [[ "$opcao" = '2' ]]; then
	if [ -f "/root/backup.vps" ]
	then
		echo ""
		echo "Atkuriamas backup..."
		echo ""
		sleep 1
		cp /root/backup.vps /backup.vps
		cd /
		tar -xvf backup.vps
		rm /backup.vps
		echo ""
		echo "Naudotojai ir slaptazodiai sekmingai importuoti."
		echo ""
		exit
	else
		echo ""
		echo "Bacup /root/backup.vps nerastas!"
		echo "Isitikinkite, kad jis yra kataloge /root/ com o nome backup.vps"
		echo ""
		exit
	fi
fi
