#The average calculating option 

#Retriving the number of records 
length=$(cat medicalRecord | wc -l )

#Retrieving the number of tests
tests=$(cat medicalTest | wc -l )
k=1

echo ""
echo "All tests taken = $length"

#a nested loop that finds the average for each record 
while [ $k -le $tests ]
do
  line=$(sed -n ""$k"p" medicalTest)
  test=$(echo $line | cut -d':' -f2 | cut -d'(' -f2 | cut -d')' -f1 )
  name=$(echo $line | cut -d':' -f2 | cut -d';' -f1 )
  echo ""
  echo "-$name :"
     i=1
     eq=0
     sum=0
     
     while [ $i -le $length ] #second loop
     do
       #Rertreiving the tests names and their value
       l=$(sed -n ""$i"p" medicalRecord)
       medt=$(echo $l | cut -d',' -f1 | cut -d' ' -f2)
       mt=$(echo $l | cut -d',' -f3 | cut -d' ' -f2)
       
       if [[ $medt = $test ]]
       then 
       #calulating the sum of the tests values 
          sum=$(echo "$sum+$mt" | bc)
          eq=$(($eq+1))
       fi
       i=$(($i+1))
     done 
     
     #Checking if the sum is zero
     if [ $eq -ne 0 ]
     then
     
     #dividing the sum by the number of those tests 
     avg=$(echo "scale=2; ($sum / $eq)" | bc)
     else
     avg=0
     fi
     #printing the Results as float numbers 
       echo "  Number of Tests Taken = $eq"
     printf "  Average Value = %.2f\n" "$avg"
  k=$(($k+1))
done 

echo ""
