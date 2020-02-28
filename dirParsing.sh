#!/bin/bash

if [ "$1" == "" ]
then
	echo -e "\e[31mDIRECTORY FINDER -by RAIJ"
	echo -e "\e[31mUsage: $0 <site>"
else
	#faz um download do arquivo index salvando como index.html
	wget $1 1> /dev/null 2>&1

	#filtra o arquivo index.html para achar apenas links
	grep "href=" index.html | grep -v "#" | cut -d '"' -f 2 | sort -u 1> parsing-links.txt
	rm -f index.html

	echo ""
	echo -e "\e[91mDirectory Finder -by RAIJ"
	echo ""

	#for para percorrer todos os links
	for linha in $(cat parsing-links.txt)
	do
		#armazena o http_code de diretorio, subdominio ou link externo
		httpCode=$(curl -w "%{http_code}" --url $1/$linha -o /dev/null -s)

		#checa se existe ou nao
		if [ "$httpCode" != "404" ]
		then
			echo -e "\e[92mFOUND [$httpCode] ==> $1/$linha"
		fi
	done
	rm -f parsing-links.txt
fi
