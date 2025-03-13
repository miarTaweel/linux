
#The Patient Deleting option 


ID_exists() { # A function to check id the ID exists
  
  if grep -q "$1" medicalRecord
   then
    return 0  # ID exists
  else
    return 1  # ID does not exist
  fi
}


while [ 0 -eq 0 ]
do
echo -n "Enter the Patient ID: "
read searchKey

if [[ $searchKey =~ ^[0-9]{7}$ ]] # checks if the searchKey is a 7 digits variable
then

if ID_exists "$searchKey" 
then
: # choose the test
  echo ""
l=""
i=1
num=1
ID=$searchKey
#retreiving the files' length
length=$(cat medicalRecord | wc -l )


#printing the patient's records
echo "This Patients Records:"
echo ""
while [ $i -le $length ]
     do
       l=$(sed -n ""$i"p" medicalRecord)
       medid=$(echo $l | cut -d':' -f1 )
       if [[ $medid -eq $ID ]]
       then 
       echo "  $num. $l"
       num=$(($num+1))
       fi
       i=$(($i+1))
     done 

index=1

#Asking the user to choose a record 
if [ $num -ne 2 ]
then
  echo ""
  echo -n "Choose which record to delete :"
  read index 
 fi 
 
  num=1
  i=1
  linenum=0
  
  #Retrieving the chosen record 
  while [ $i -le $length ]
     do
       l=$(sed -n ""$i"p" medicalRecord)
       medid=$(echo $l | cut -d':' -f1 )
       if [ $medid -eq $ID ]
       then 
         if [ $num -eq $index ]  
         then 
          linenum=$i 
          break
         fi 
       num=$(($num+1))
       fi
       i=$(($i+1))
     done 

echo ""

#Confirming the deletion operation
 while [ 0 -eq 0 ]
      do
	echo "Proceed to delete?:"
	echo "   1.YES   2.NO"
	echo -n "option: "
	read option
	if [ $option -eq 1 ]
	then
	break
	elif [ $option -eq 2 ]
	then
	echo "Deleting operation eliminated"
	exit
	else 
	echo "Invalid input ,please try again"
	fi
	
	done

olddata=$l
sed -i "${linenum}d" medicalRecord

echo  ""
echo "The Record has been Deleted Successfully"
echo  ""
break
 
else
echo "the ID ${searchKey} does not exist in our records, try again "
fi
1

else # invalid search key
echo "invalid patient ID, make sure that the ID conatains exactly 7 numeric digits "

fi

done
