
#The Record Updating option 

echo ""
l=""
i=1
num=1
ID="$1" 


#Retreiving the files length
length=$(cat medicalRecord | wc -l )


#Printing all the patients' records 
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


#Asking the user to choose which record to operate on
index=1
if [ $num -ne 2 ]
then
  echo ""
  echo -n "Choose which record to update :"
  read index 
 fi 
 
 
#Retrieving that record 
  linenum=0
  num=1
  i=1
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


#dividing the old data 
olddata=$l
type=$(echo $olddata | cut -d' ' -f2 |cut -d',' -f1)
date=$(echo $olddata | cut -d' ' -f3 | cut -d',' -f1)
value=$(echo $olddata | cut -d' ' -f4 | cut -d',' -f1)
unit=$(echo $olddata | cut -d' ' -f5 | cut -d',' -f1)
status=$(echo $olddata | cut -d' ' -f6)

newValue=0
a=1
b=2
c=3
d=-1
e=4
f=5

#The menu update loop
while [ 1 -eq 1 ]
do 

  echo ""
  echo "Choose which aspect to update:"
  if [ $a -gt 0 ]
  then
  echo "  $a.Test Type"
  fi
  if [ $b -gt 0 ]
  then
  echo "  $b.Test Date"
  fi
  if [ $c -gt 0 ]
  then
  echo "  $c.Test value"
  fi
  if [ $d -gt 0 ]
  then
  echo "  $d.Test unit"
  fi
  if [ $e -gt 0 ]
  then
  echo "  $e.Test Status"
  fi
  echo "  $f.Quit updating this record"
  echo -n "option: "
  read aspect
  
  if [ $aspect -lt 0 ]
  then 
  echo "Invalid input, please try again"
  continue
  fi
  
  #updating the test type
  if [ $aspect -eq $a ]
  then 
  name=""
  newtest=""
  newunit=""
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
	
	newtest=$(cat medicalTest |sed -n ""$option"p"|cut -d':' -f2 | cut -d'(' -f2 | cut -d')' -f1 )
	newunit=$(cat medicalTest |sed -n ""$option"p"|cut -d':' -f4|cut -d' ' -f2)
	

	break
	
	else
	echo "invalid option, Please try again"
	continue 
	fi
	
       done
       
       if [ $newtest = $type ]
       then
       echo "This value already exits, No updating occured"
       continue 
       fi
       
       new=$(echo "$olddata"| sed "s|$type|$newtest|")
       nnew=$(echo "$new"| sed "s|$unit|$newunit|")
      
       
       sed -i "${linenum}c\\$nnew" medicalRecord
      
       olddata=$nnew
       
        echo "The Record has been updated successfully"
        
        a=-7
        b=$(($b-1))
        c=$(($c-1))
        d=$(($d-1))
        e=$(($e-1))
        f=$(($f-1))
        
        
    #updating the test Date 
  elif [ $aspect -eq $b ]
  then
      while [ 0 -eq 0 ]
      do
	echo -n "Enter the New Test Date: "
	read TestDate
	
	#Checking its validity 
	if [[ $TestDate =~ ^[0-9]{4}-[0-9]{2}$ ]]
	then
	month=$( echo $TestDate | cut -d'-' -f2 )
	
		if [ $month -ge 1 -a $month -le 12 ]
		then
		break
		else
		echo "make sure you're writng a valid month"
		continue
		fi
	else
	echo "write the date in the following form YYYY-MM e.g. 2024-08" 
	continue
	fi
	
       done
       
       if [ $TestDate = $date ]
       then
       echo "This value already exits, No updating occured"
       continue 
       fi
       
       new=$(echo "$olddata"| sed "s/$date/$TestDate/")
      
       
       sed -i "${linenum}c\\$new" medicalRecord
     
       olddata=$new
  
       
        echo "The Record has been updated successfully"
        
        b=-1
        c=$(($c-1))
        d=$(($d-1))
        e=$(($e-1))
        f=$(($f-1))
    
     #updating the test value
  elif [ $aspect -eq $c ]
  then
      while [ 0 -eq 0 ]
      do
	echo -n "Enter the New Test value: "
	read newValue
	#checking its validity
	if [[ $newValue =~ ^[0-9]+(.[0-9]+)$ ]]
	then 
	break
	else
	echo "write the value as floating-point value  e.g. 1.6 "
	fi
       done
       
       if [ $newValue = $value ]
       then
       echo "This value already exits, No updating occured"
       continue 
       fi
      
       
       nnew=$(echo "$olddata"| cut -d',' -f2,3|sed "s/$value/$newValue/")
       old=$(echo "$olddata"| cut -d',' -f2,3)
       new=$(echo "$olddata"| sed "s/$old/$nnew/")
    
       sed -i "${linenum}c\\$new" medicalRecord
       olddata=$new
      
    
       echo "The Record has been updated successfully"
       
        
        c=-2
        d=$(($d-1))
        e=$(($e-1))
        f=$(($f-1))
      #updating the test unit
  elif [ $aspect -eq $d ]
  then
      while [ 0 -eq 0 ]
      do
	echo -n "Enter the New Unit: "
	read newUnit
	
	#Checking its validity
	if [[ $newUnit =~ ^[a-zA-Z]+/[a-zA-Z]+$ ]]
	then
	break 
	else
	echo "write the unit as string/string  e.g. mg/dl "
	continue 
	fi
	
       done
       
       if [ $newUnit = $unit ]
       then
       echo "This value already exits, No updating occured"
       continue 
       fi
       
       new=$(echo "$olddata"| sed "s|$unit|$newUnit|")
      
       
       sed -i "${linenum}c\\$new" medicalRecord
     
       olddata=$new
  
       
        echo "The Record has been updated successfully"
        
      
        d=-1
        e=$(($e-1))
        f=$(($f-1))
        
    #updating the test status
  elif [ $aspect -eq $e ]
  then
      while [ 0 -eq 0 ]
      do
       
        #printing the status menu
	echo  "Choose a new test Status: "
	echo  "1-Pending"
	echo  "2-Completed"
	echo  "3-Reviewed"
	echo -n "option: "
	read option
	if [ $option -eq 1 ]
	then
	newStatus=Pending
	break
	elif [ $option -eq 2 ]
	then
	
	newStatus=Completed
	break
	
	
	elif [ $option -eq 3 ]
	then
	
	newStatus=Reviewed
	break
	
	else
	echo "invalid option, make sure to choose between options 1-3"
	continue 
	fi
	
       done
       
       if [ $newStatus = $status ]
       then
       echo "This value already exits, No updating occured"
       continue 
       fi
       
       new=$(echo "$olddata"| sed "s|$status|$newStatus|")
       
       sed -i "${linenum}c\\$new" medicalRecord
     
       olddata=$new
        echo "The Record has been updated successfully"
        
      
        e=-5
        f=$(($f-1))
    
    
    elif [ $aspect -eq $f ]
      #Quitting the update operation
	  then
	  
	  echo ""
	  echo "updated record saved succesfully"
	  echo ""
	  f=-6
	  break 2
	  
  else 
  echo "Invalid input, please try again"
  
  fi
  
  echo ""
  echo "$olddata"
  
done 


exit








