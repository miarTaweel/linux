getTest() {

#grep -w "$1" medicalTest
local test=$(sed -n "/$1/p" medicalTest  )
#echo "test = $test"
#echo "test = $2"

getRange "$test" $2 "$3"

}

getRange() {
#echo "hello $1  $2 $3"
value=$(printf "%.0f" "$2") #turn into int
range=$(echo "$1" | cut -d';' -f2 | cut -d':' -f2)
UpperLimit=$( echo "$range" | tr -d ' ' | cut -d'<' -f2  )
LowerLimit=$( echo "$range" | tr -d ' ' | cut -d'<' -f1 | cut -d'>' -f2 | tr -d ',' | tr -d ' ') 
#echo " hi = $UpperLimit"
#LowerLimit=${LowerLimit:-0}
#if [ -z "$LowerLimit" ] 
#then
#LowerLimit=1
#fi


if [[ "$UpperLimit" =~ ^[0-9]+(.[0-9]+)$ ]]
then 
intUpperLimit=$(printf "%.0f" "$UpperLimit")
floatUpperLimit="$intUpperLimit"
floatUpperLimit=$(printf "%.2f" "$intUpperLimit")
else
#intUpperLimit=$(printf "%.0f" "$UpperLimit")
floatUpperLimit=$(printf "%.2f" "$UpperLimit")
fi

if [[ "$LowerLimit" =~ ^[0-9]+(.[0-9]+)$ ]]
then 
intLowerLimit=$(printf "%.0f" "$intLowerLimit")
floatLowerLimit="$LowerLimit"
floatLowerLimit=$(printf "%.2f" "$intLowerLimit")
else
#intLowerLimit=$(printf "%.0f" "$LowerLimit")
floatLowerLimit=$(printf "%.2f" "$LowerLimit")
fi

intValue=$(printf "%.0f" "$value")
#echo "upper limit = $intUpperLimit"
#echo "lower limit = $intLowerLimit"
#echo "value = $intValue"

#half=$(echo "($intUpperLimit + $intLowerLimit ) / 2" | bc)
#echo $half

#if [[ $intValue -lt $half ]]
#then
#intValue=$intValue+1
#elif [[ $intValue -ge $half ]]
#then
#intValue=$intValue-1
#fi


#echo $floatUpperLimit

#echo $floatLowerLimit

#echo $2

#if [[ "$intUpperLimit" -gt "$intValue" ]]
#then
#if [[ "$intLowerLimit" -lt "$intValue" ]]
#then
#normalFLAG=1
#echo "$3"
#fi
#fi


normalTest=$(echo "$2 > $floatLowerLimit && $2 < $floatUpperLimit" | bc)
if [[ $normalTest -eq 1 ]]
then
normalFLAG=1
echo "$3"
fi


#echo "$range"

}

normalFLAG=0
periodFLAG=0
statusFLAG=0

if [ "$1" -eq 1 ]
then 
echo "$( sed -n "/$2/p" medicalRecord )"

elif [ "$1" -eq 2 ]
then
if [ -e Tests.txt ]
then
sed -n "/$2/p" medicalRecord > Tests.txt
else 
touch Tests.txt
sed -n "/$2/p" medicalRecord > Tests.txt
fi

while IFS= read -r record
do

TName=$( echo $record | cut -d':' -f2 | cut -d',' -f1 )
 

TValue=$( echo $record | cut -d':' -f2 | cut -d',' -f3 )
#echo "$TName $TValue"

getTest $TName $TValue "$record" # to get the test info



done < Tests.txt




elif [ "$1" -eq 3 ]
then
if [ -e Tests.txt ]
then
sed -n "/$2/p" medicalRecord > Tests.txt
else 
touch Tests.txt
sed -n "/$2/p" medicalRecord > Tests.txt
fi
run=0

while [ $run -ge 0 ]
do

while [ $run -eq 0 ]
do
echo
echo "Enter the date of the beginning of the period in the following format YYYY-MM"
read StartDate
if [[ $StartDate =~ ^[0-9]{4}-[0-9]{2}$ ]]
then
year1=$( echo $StartDate | cut -d'-' -f1 )
month1=$( echo $StartDate | cut -d'-' -f2 )
if [ $month1 -ge 1 -a $month1 -le 12 ]
then
run=2
break
else
echo
echo "make sure you're writng a valid month"
continue
fi
else
echo
echo "write the date in the following form YYYY-MM e.g. 2024-08" 
continue
fi
done


while [ $run -eq 2 ]
do
echo
echo "Enter the date of the end of the period in the following format YYYY-MM"
read EndDate
echo
if [[ $EndDate =~ ^[0-9]{4}-[0-9]{2}$ ]]
then
year2=$( echo $EndDate | cut -d'-' -f1 )
month2=$( echo $EndDate | cut -d'-' -f2 )
if [ $month2 -ge 1 -a $month2 -le 12 ]
then
run=0
echo "The tests from ${StartDate} to ${EndDate} are: "
echo
break
else
echo
echo "make sure you're writng a valid month"
continue
fi
else
echo
echo "write the date in the following form YYYY-MM e.g. 2024-08" 
continue
fi
done


if [ $year1 -gt $year2 ]
then
echo
echo "Enter The beginning date before the end date"
continue
elif [ $year1 -eq $year2 -a $month1 -gt $month2 ]
then
echo
echo "Enter The beginning date before the end date"
echo
continue
elif [ $year1 -eq $year2 -a $month1 -eq $month2 ]
then
run=-1
else
run=-1
fi

done
while IFS= read -r record
do

TDate=$( echo $record | cut -d':' -f2 | cut -d',' -f2 )
 
start=$( echo $StartDate | tr -d '-') 
end=$( echo $EndDate | tr -d '-')
date=$( echo $TDate | tr -d '-')

if [[ $date -le $end && $date -ge $start ]]
then
periodFLAG=1
echo $record
fi

done < Tests.txt

elif [ "$1" -eq 4 ]
then
if [ -e Tests.txt ]
then
sed -n "/$2/p" medicalRecord > Tests.txt
else 
touch Tests.txt
sed -n "/$2/p" medicalRecord > Tests.txt
fi

echo
echo "all the tests with the ${3} status: " 
echo

statusOUT="$( sed -n "/$2/ { /$3/ p; }" medicalRecord )" 
echo "$statusOUT"

if [ -z "$statusOUT" ]
then
:
else
statusFLAG=1
fi



fi



if [[ $normalFLAG -ne 1 && "$1" -eq 2 ]]
then
echo "no normal tests "


elif [[ $periodFLAG -ne 1 && "$1" -eq 3 ]]
then
echo "no tests for this patient in the given period"


elif [[ $statusFLAG -ne 1 && "$1" -eq 4 ]]
then
echo "no tests with the chosen status for this patient"
fi




exit
