testOPT=0
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
	
	
	break
	
	else
	echo "invalid option, Please try again"
	continue 
	fi
	
       done

echo
echo "the normal ${TestName} tests: " 
echo

chmod 755 searchByID.sh
./searchByID.sh 2 $TestName
exit
