flag1=0
flag2=0
flag3=0
flag4=0
flag5=0
newunit=""
while [ $flag1 -eq 0 ]
do
echo
echo -n "Enter the Patient ID: "
read patient_ID
if [[ $patient_ID =~ ^[0-9]{7}$ ]]
then 
break
else
echo
echo "it should be exactly 7 numeric digits. try again"
continue
fi
done
testOPT=0
run=0
TestName=0
while [ 0 -eq 0 ]
      do
        echo ""
	echo  "Choose a new test type: "
	tests=$(cat medicalTest | wc -l )
	k=1
	#printing the test type menu
	while [ $k -le $tests ]
	do
	  line=$(sed -n ""$k"p" medicalTest)
	  name=$(echo $line | cut -d':' -f2 | cut -d';' -f1 )

	  echo "$k-$name :"
	  k=$((k+1))
	done
	
	echo -n "option: "
	read option
	if [ $option -le $tests ]
	then
	
	TestName=$(cat medicalTest |sed -n ""$option"p"|cut -d':' -f2 | cut -d'(' -f2 | cut -d')' -f1 )
	newunit=$(cat medicalTest |sed -n ""$option"p"|cut -d':' -f4|cut -d' ' -f2)
	
	
	break
	
	else
	echo "invalid option, Please try again"
	continue 
	fi
	
       done

#if [[ $TestName =~ ^[a-zA-Z]+$ ]]
#then 
#break
#else 
#echo "the test name should only contain characters" 
#continue
#fi


while [ $flag3 -eq 0 ]
do
echo
echo -n "Enter the Test Date: "
read TestDate
if [[ $TestDate =~ ^[0-9]{4}-[0-9]{2}$ ]]
then
month=$( echo $TestDate | cut -d'-' -f2 )
if [ $month -ge 1 -a $month -le 12 ]
then
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

while [ $flag4 -eq 0 ]
do
echo
echo -n "Enter the Test value: "
read value
if [[ $value =~ ^[0-9]+(.[0-9]+)$ ]]
then 
TestResult="$value, $newunit"
break
else
echo
echo "write the vlaue as positive floating-point value  e.g. 1.6 "
continue
fi

done


while [ $flag5 -eq 0 ]
do
echo
echo  "Choose the Test Status: "
echo  "1-Pending"
echo  "2-Completed"
echo  "3-Reviewed"
echo
echo -n "option: "
read option
if [ $option -eq 1 ]
then
status=Pending
flag5=1
elif [ $option -eq 2 ]
then
status=Completed
flag5=1
elif [ $option -eq 3 ]
then
status=Reviewed
flag5=1
else
echo
echo "invalid option, make sure to choose between options 1-3"
continue 
fi
done

mTest="${patient_ID}: ${TestName}, ${TestDate}, ${TestResult}, ${status}"
if [ -e medicalRecord ]
then
echo $mTest >> medicalRecord
echo
echo "The medical test is successfully inserted"
else
echo 
echo "create a file called -medicalRecord- first "
fi

exit 



