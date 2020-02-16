#!/bin/bash
tput setaf 7 ; tput setab 4 ; tput bold ; printf '%30s%s%-15s\n' "Sukurti vartotoja" ; tput sgr0
echo ""
read -p "vartotojo vardas: " username
awk -F : ' { print $1 }' /etc/passwd > /tmp/users 
if grep -Fxq "$username" /tmp/users
then
	tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Sio vartotojo nera. Sukurkite vartotoja kitu vardu." ; echo "" ; tput sgr0
	exit 1	
else
	if (echo $username | egrep [^a-zA-Z0-9.-_] &> /dev/null)
	then
		tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "ivestas galiojantis vartotojo vardas!" ; tput setab 1 ; echo "naudokite tik raides, skaicius, taskus ir spindulius." ; tput setab 4 ; echo "Kosmoso irankyje akcentai ar specialieji zenklai!" ; echo "" ; tput sgr0
		exit 1
	else
		sizemin=$(echo ${#username})
		if [[ $sizemin -lt 2 ]]
		then
			tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Buvo ivestas labai trumpas vartotojo vardas," ; echo "naudoti maziau nei simbolius!" ; echo "" ; tput sgr0
			exit 1
		else
			sizemax=$(echo ${#username})
			if [[ $sizemax -gt 32 ]]
			then
				tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Buvo ivestas labai didelis vartotojo vardas," ; echo "naudoti ne daugiau kaip 32 simbolius!" ; echo "" ; tput sgr0
				exit 1
			else
				if [[ -z $username ]]
				then
					tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Buvo ivestas laisvos vietos vartotojo vardas!" ; echo "" ; tput sgr0
					exit 1
				else	
					read -p "slaptazodis: " password
					if [[ -z $password ]]
					then
						tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Pristate priesinga darbo vieta!" ; echo "" ; tput sgr0
						exit 1
					else
						sizepass=$(echo ${#password})
						if [[ $sizepass -lt 6 ]]
						then
							tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Yra labai trumpas slaptazodis!" ; echo "Noredami islaikyti saugu vartotojo naudojima, naudokite bent 6 simbolius" ; echo "skirtingu raidziu ir skaiciu derinys!" ; echo "" ; tput sgr0
							exit 1
						else	
							read -p "Iki datos: " dias
							if (echo $dias | egrep '[^0-9]' &> /dev/null)
							then
								tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Ivestas galiojantis dienu skaicius!" ; echo "" ; tput sgr0
								exit 1
							else
								if [[ -z $dias ]]
								then
									tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Jus nurodete dienu skaiciu laisvai darbo vietai pasibaigti!" ; echo "" ; tput sgr0
									exit 1
								else	
									if [[ $dias -lt 1 ]]
									then
										tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Privalote pristatyti daugiau nei 20 dienu!" ; echo "" ; tput sgr0
										exit 1
									else
										read -p "leidziama vienu metu jungtis: " sshlimiter
										if (echo $sshlimiter | egrep '[^0-9]' &> /dev/null)
										then
											tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Ivestas galiojantis jungciu skaicius!" ; echo "" ; tput sgr0
											exit 1
										else
											if [[ -z $sshlimiter ]]
											then
												tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Jus nurodete vienu metu veikianciu jungciu skaiciu!" ; echo "" ; tput sgr0
												exit 1
											else
												if [[ $sshlimiter -lt 1 ]]
												then
													tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Turite ivesti daugiau tuo pat metu veikianciu jungciu!" ; echo "" ; tput sgr0
													exit 1
												else
													final=$(date "+%Y-%m-%d" -d "+$dias days")
													gui=$(date "+%d/%m/%Y" -d "+$dias days")
													pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
													useradd -e $final -M -s /bin/false -p $pass $username
													[ $? -eq 0 ] && tput setaf 2 ; tput bold ; echo ""; echo "Vartotojas $username creado" ; echo "Galiojimo laikas: $gui" ; echo "leidziama vienu metu jungtis: $sshlimiter" ; echo "" || echo "Negaliu sukurti vartotojo!" ; tput sgr0
													echo "$username $sshlimiter" >> /root/usuarios.db
												fi
											fi
										fi
									fi
								fi
							fi
						fi
					fi
				fi
			fi
		fi
	fi	
fi
