ID_exists() {
  
  if grep -q "$1" medicalRecord
   then
    return 0  # ID exists
  else
    return 1  # ID does not exist
  fi
}

systemStatus=1  # to set the system to on or off
echo
echo "Welcome To our Medical System"
echo
while [ $systemStatus -eq 1 ]  # the main loop 1 = on
do

if [ ! -e medicalRecord ]
then
echo "the file that contains all the medical records does not exist "
echo
echo "do you want to create one?"
echo "press 1 to proceed, or 0 to exit"
echo -n "option: "
read decision
if [ $decision -eq 1 ]
then 
touch medicalRecord
echo "medicalRecord file is successfully created, fill it with data then you can use the program" 
break
else
break
fi

elif [ ! -e medicalTest ]
then
echo "the file that contains all the medical tests information does not exist "
echo
echo "do you want to create one?"
echo "press 1 to proceed, or 0 to exit"
echo -n "option: "
read decision2
if [ $decision2 -eq 1 ]
then 
touch medicalTest
echo "medicalRecord file is successfully created, fill it with data then you can use the program" 
break
else
break
fi

elif [ ! -s medicalRecord ]
then
echo "the medical records file is empty! , fill it with proper data then try again to use our program with no errors"
echo
break

elif [ ! -s medicalTest ]
then
echo "the medical tests information file is empty! , fill it with proper data then try again to use our program with no errors"
echo
break

else

echo
echo
echo "choose an option to proceed"
echo "1- Insert a new Medical Test "
echo "2- Search for a Test by Patient_ID "
echo "3- Search for up normal tests "
echo "4- Average test value "
echo "5- Update an existing test result "
echo "6- Delete an existing test result "
echo "7- Exit "
echo
echo -n "option: "
read option  


if [ $option -ge 1 -a $option -le 7 ] # check if the option is valid  [1 <= option <= 7]
then

if [ $option -eq 1 ]
then
chmod 755 InsertValidation.sh
./InsertValidation.sh
# echo "The chosen option : Insert a new Medical Test "
#echo -n "Enter the Patient ID: "
#read patient_ID
#echo -n "Enter the Test Name: "
#read TestName
#echo -n "Enter the Test Date: "
#read TestDate
#echo -n "Enter the Test Result: "
#read TestResult
#echo -n "Enter the Test Status: "
#read TestStatus
#mTest="${patient_ID}: ${TestName}, ${TestDate}, ${TestResult}, ${TestStatus}"
#echo $mTest
#echo "The medical test is successfully inserted"
#continue




elif [ $option -eq 2 ]
then

echo "The chosen option : Search for a Test by Patient_ID "
echo
while [ $option -eq 2 ]
do

echo
echo -n "Enter the Patient ID: "
read searchKey

if [[ $searchKey =~ ^[0-9]{7}$ ]] # checks if the searchKey is a 7 digits variable
then

if ID_exists "$searchKey" 
then
while ID_exists "$searchKey"
do
echo
echo
echo "what do you want to search for?"
echo "1- all patient tests"
echo "2- all up normal patient tests"
echo "3- all patient tests in a given specific period"
echo "4- all patient tests based on test status"
echo "5- exit from the search option"
echo
echo -n "option: "
read selection
echo
if [ $selection -ge 1 -a $selection -le 5 ]
then

if [ $selection -eq 1 ]
then 
echo
echo "all patient tests: "
echo
chmod 755 searchByID.sh
./searchByID.sh 1 $searchKey
elif [ $selection -eq 2 ]
then
echo
echo "all up normal patient tests: "
echo
chmod 755 searchByID.sh
./searchByID.sh 2 $searchKey
elif [ $selection -eq 3 ]
then
chmod 755 searchByID.sh
./searchByID.sh 3 $searchKey

elif [ $selection -eq 4 ]
then
while [ $selection -eq 4 ]
do
echo
echo "Enter the status of test that you are looking for: "
echo "1- Pending"
echo "2- Completed"
echo "3- Reviewed"
echo
echo -n "option: "
read statusOPT
echo
if [ $statusOPT -eq 1 ]
then 
status=Pending
break
elif [ $statusOPT -eq 2 ]
then
status=Completed
break
elif [ $statusOPT -eq 3 ]
then
status=Reviewed
break
else
echo
echo "invalid option"
continue
fi
done
chmod 755 searchByID.sh
./searchByID.sh 4 $searchKey $status

#echo "all the tests with the ${status} status: " 
elif [ $selection -eq 5 ]
then 
break 2
fi



else 
echo
echo "Invalid Option! try again with a value between 1 and 5 "
continue
fi

done

else
echo
echo "the ID ${searchKey} does not exist in our records, try again "
continue
fi


else # invalid search key
echo
echo "invalid patient ID, make sure that the ID conatains exactly 7 numeric digits "
continue
fi

done

elif [ $option -eq 3 ]
then
echo
echo "The chosen option : all up normal tests: "
echo
chmod 755 normalTests.sh
./normalTests.sh


elif [ $option -eq 4 ]
then
echo
echo "The chosen option : Average test value: "
echo
chmod 755 avg.sh 
./avg.sh

elif [ $option -eq 5 ]
then
echo
echo "The chosen option : Update an existing test result "
echo
while [ $option -eq 5 ]
do

echo
echo -n "Enter the Patient ID: "
read searchKey
echo
if [[ $searchKey =~ ^[0-9]{7}$ ]] # checks if the searchKey is a 7 digits variable
then

if ID_exists "$searchKey" 
then
: # choose the test
chmod 755 update.sh
./update.sh $searchKey
break
else
echo
echo "the ID ${searchKey} does not exist in our records, try again "
continue
fi


else # invalid search key
echo
echo "invalid patient ID, make sure that the ID conatains exactly 7 numeric digits "
continue
fi

done


elif [ $option -eq 6 ]
then
echo
echo "The chosen option : Delete a test: "
echo

chmod 755 delete.sh
./delete.sh
 
elif [ $option -eq 7 ] #exit 
then
echo
echo "GoodBye"
break
fi




else
echo
echo "Invalid Option! try again with a value between 1 and 7"
continue
fi

fi
done

exit
