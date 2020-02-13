#!/bin/bash
database="/root/usuarios.db"
tput setaf 7 ; tput setab 4 ; tput bold ; printf '%20s%s\n' "   Pakeiskite vienu metu veikiančių SSH jungciu limita   " ; tput sgr0
if [ ! -f "$database" ]
then
	tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Jo nera $database " ; echo "" ; tput sgr0
	exit 1
else
	tput setaf 2 ; tput bold ; echo ""; echo "Apribokite vienalaiki rysi su vartotojais:" ; tput sgr0
	tput setaf 3 ; tput bold ; echo "" ; cat $database ; echo "" ; tput sgr0
	read -p "Vartotojo vardas, jei norite pakeisti limita: " usuario
	if [[ -z $usuario ]]
	then
		tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Buvo ivestas vartotojo vardas, kurio nera sarase
!" ; echo "" ; tput sgr0
		exit 1
	else
		if [[ `grep -c "^$usuario " $database` -gt 0 ]]
		then
			read -p "Vienu metu vartotojui leidziamu prisijungimu skaicius: " sshnum
			if [[ -z $sshnum ]]
			then
				tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "ivestas galiojantis numeris!" ; echo "" ; tput sgr0
				exit 1
			else
				if (echo $sshnum | egrep [^0-9] &> /dev/null)
				then
					tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "ivestas galiojantis numeris!" ; echo "" ; tput sgr0
					exit 1
				else
					if [[ $sshnum -lt 1 ]]
					then
						tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Turite ivesti daugiau tuo pat metu veikianciu jungciu!" ; echo "" ; tput sgr0
						exit 1
					else
						grep -v ^$usuario[[:space:]] /root/usuarios.db > /tmp/a
						sleep 1
						mv /tmp/a /root/usuarios.db
						echo $usuario $sshnum >> /root/usuarios.db
						tput setaf 7 ; tput setab 1 ; tput bold ; echo "" ; echo "Vienu metu prisijungusių vartotojų skaičius $ $ pasikeitė:" ; tput sgr0
						tput setaf 3 ; tput bold ; echo "" ; cat $database ; echo "" ; tput sgr0
						exit
					fi
				fi
			fi			
		else
			tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Vartotojo $ vartotojo nera sarase!" ; echo "" ; tput sgr0
			exit 1
		fi
	fi
fi
