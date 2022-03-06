for_loops.sh
 
#!/bin/bash

#variables

my_fav_states=('Georgia' 'Texas' 'Nevada' 'California' 'Hawaii')

for state in ${my_fav_states[@]};
do 
 if [ 'Georgia' == $state ]
 then
  echo "Georgia is the best!"
else
  echo "I'm not fond of $state"
 fi
done

# number variable
numbers=$(echo [0..9])
list=$(ls)
for number in ${numbers[@]};
do
 if [$number=3] || [$number=5] || [$number=7]
 then 
  echo "$number"
 fi
done

for output_list in ${list[@]};
do 
 echo "$output_list"
done



