#!/bin/bash

# Author: Lorinc Pongor (pongorlorinc@gmail.com)
# script to download BAM segments from TCGA repo
# This script is a practice (learning) script, in case any bugs are found, please let me know!

function quit {
	echo "Usage: ./$0 <TOKEN> <SAMPLE> <TARGETS>"
	echo ""
	echo -e "Parameters:"
	echo -e "\tTOKEN info [required]"
	echo -e "\t-t|--token\ttoken file from gdc\n"

	echo -e "\tSAMPLE info [required]"
	echo -e "\t-u|--uuid\tsample sheet from gdc website"
	echo -e "\t-n|--uuidname\tIf -u specifies a single UUID (not sample sheet file),"
	echo -e "\t\t\tthen use this as output prefix name\n"

	echo -e "\tTARGETS to download [required]"
	echo -e "\t-c|--coord\teither a coorinate, or file with coordinate(s)."
	echo -e "\t\t\tCoordinate format: \"chr:start-end\""
	echo -e "\t-g|--gene\tEither a single gene name, of file with list of gene(s)\n"

	echo -e "\tOUTPUT info"
	echo -e "\t-d|--outfolder\toutput folder path (will be created), default: \"./\"\n"
	exit
}

outfolder="./"
gene=""
uuid=""
uuidname=""
coord=""

token=""

featfile=1
regionfile=""
feattype=""

uuidtype=1

regions=""


POSITIONAL=()
while [[ $# -gt 0 ]]
do
	key="$1"

	case $key in
	-c|--coord)
		coord="$2"
		shift
		shift
	;;

	-g|--gene)
		gene="$2"
		shift
		shift
	;;

	-t|--token)
		token="$2"
		shift
		shift
	;;

	-u|--uuid)
		uuid="$2"
		shift
		shift
	;;

	-n|--uuidname)
		uuidname="$2"
		shift
		shift
	;;

	-d|--outfolder)
		outfolder="$2"
		shift
		shift
	;;

	*)    # unknown option
	POSITIONAL+=("$1")
	shift
	;;
	esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

if [ ${#gene} -ge 2 ]
then
	feattype="Gene name"

	if [ -e $gene ]
	then
		regionfile=${gene}

		while IFS= read -r line
		do
			if [ ${#regions} -ge 2 ]
			then
				regions="${regions}&gencode=${line}"
			else
				regions="gencode=${line}"
			fi
		done <"$gene"
	else
		regions="gencode=$gene"
		featfile=0
	fi
fi

if [ ${#coord} -ge 2 ]
then
	feattype="Genomic coordinate"

	if [ -e ${coord} ]
	then
		regionfile=$coord

		while IFS= read -r line
		do
			if [ ${#regions} -ge 2 ]
			then
				regions="${regions}&region=${line}"
			else
				regions="region=${line}"
			fi
		done <"$coord"
	else
		regions="region=${coord}"
		featfile=0
	fi
fi

if [ ${#uuid} -ge 2 ]
then
	if [ -e $uuid ]
	then
		uuidtype=1
	else
		uuidtype=0
		bamname=$(basename $uuid).bam

		if [ ${#uuidname} -ge 2 ]
		then
			bamname=$uuidname.bam
		fi
	fi
fi

if [ ! ${#feattype} -ge 2 ]
then
	echo "ERROR: No feature was specified"
	quit
fi

if [ ! ${#uuid} -ge 2 ]
then
	echo "ERROR: No UUID entry or file was specified"
	quit
fi

if [ ! -e $token ] || [ ! -e ${token} ]
then
	echo "ERROR: Token file not found"
	quit
fi

echo "########################"
echo "#      PARAMETERS      #"
echo "########################"
echo -e "Token file:\t$token"

if [ $featfile -eq 1 ]
then
	echo -e "Feature file:\t$regionfile"
else
	echo -e "Feature:\tfrom single CMD entry"
	echo -e "Feature entry:\t$regions"
fi

echo -e "Feature:\t$feattype"

if [ $uuidtype -eq 1 ]
then
	echo -e "UUID:\t\t$uuid (file name)"
else
	echo -e "UUID:\t\t$uuid (single entry)"
	echo -e "UUID name:\t$bamname"
fi
echo -e "Output folder:\t$outfolder"

echo "########################"


token=$(<$token)

if [ ! -d $outfolder ]
then
	mkdir -p $outfolder

	if [ ! -d $outfolder ]
	then
		echo "ERROR: Could not create ${outfolder}"
		quit
	fi
fi

if [ -e $uuid ]
then
	sed 1d $uuid | while IFS= read -r line
	do
		IFS=$'\t'
		tmp=($line)

		echo -e "\nDownloading: ${tmp[0]} [${tmp[6]}]"
		curl -H "X-Auth-Token: $token" "https://gdc-api.nci.nih.gov/slicing/view/${tmp[0]}?${regions}" --output ${outfolder}/${tmp[6]}.bam

		if [ -e ${outfolder}/${tmp[6]}.bam ]
		then
			samtools index ${outfolder}/${tmp[6]}.bam
		fi

	done
else
	if [ ${#geme} -ge 2 ]
	then
		echo "Gene: ${tmp[0]} ${tmp[6]}: $regions"
		regions="gencode=$gene"
	else
		echo "Coords: ${tmp[0]} ${tmp[6]}: $regions"
		regions="region=$coord"
	fi

	curl -H "X-Auth-Token: $token" "https://gdc-api.nci.nih.gov/slicing/view/${uuid}?${regions}" --output ${outfolder}/${uuidname}.bam

	if [ -e ${outfolder}/${uuidname}.bam ]
	then
		samtools index ${outfolder}/${uuidname}.bam
	fi
fi


exit

