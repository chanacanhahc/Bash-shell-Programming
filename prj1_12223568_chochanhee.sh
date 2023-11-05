#! /bin/bash
echo --------------------------
echo User name: chochanhee
echo Student Number: 12223568
echo [ Menu ]
echo 1. Get the data of the movie identified by a specific \'movie id\' from \'u.item\'
echo 2. Get the data of action genre movies from \'u.item\'
echo 3. Get the average \'rating\' of the movie idenfied by specific \'movie id\' from \'u.data\'
echo 4. Delete the \'IMDb URL\' from \'u.item\'
echo 5. Get the data about users from \'u.user\'
echo 6. Modify the format of \'release data\' in \'u.item\'
echo 7. Get the data of movies rated by a specific \'user id\' from \'u.data\'
echo 8. Get the average \'rating\' of movies rated by users with \'age\' between 20 and 29 and \'occupation\' as \'programmer\'
echo 9. Exit
echo ---------------------------
read -p "Enter your choice [1-9] " choice
while true;
do
 if (($choice == 1)); then
  echo
  read -p "Please enter 'movie id'(1~1682):" id
  echo 
  cat u.item| awk -F\| -v a=${id} '$1==a{print $0}'
  echo 
 elif (($choice == 2)); then
  echo
  read -p "Do you want to get the data of 'action' genre moives from 'u.item'?(y/n):" res
  echo
  if [ $res = "y" ]
  then
   cat u.item| awk -F\|  '$7==1{print $1, $2}'| awk 'NR<=10 {print $0}'
   echo
  fi
 elif (($choice == 3)); then
  echo
  read -p "Please enter the 'movie id'(1~1682):" id
  echo
  cat u.data| awk -v a=${id} '$2==a{print $0}'| awk -v a=${id}  '{sum+=$3} END {printf("average rating of %d: %.5f\n", a,sum/NR)}'
  echo
 elif (($choice == 4)); then
  echo
  read -p "Do you want to delete the 'IMDb URL' from 'u.item'?(y/n):" res
  echo
  if [ $res = "y" ]
  then
   sed 's/http.*)//g' u.item | awk 'NR<=10 {print $0}'
   echo
  fi
 elif (($choice == 5)); then
  echo
  read -p "Do you want to get the data about users from 'u.user'?(y/n):" res
  echo
  if [ $res = "y" ]
  then
   cat u.user | awk -F\| 'NR<=10 {print "user",$1,"is",$2,"years old",$3,$4}'| sed -E 's/M/male/g'| sed -E 's/F/female/g'
   echo 
  fi
 elif (($choice == 6)); then
  echo
  read -p "Do you want to Modify the format of 'release data' in 'u.item'?(y/n):" res
  echo
  if [ $res = "y" ]
  then
   sed -E  's/([0-9]{2})-([A-Z][a-z]{2})-([0-9]{4})/\3\2\1/g' u.item | awk 'NR>=1673'| sed -E 's/([0-9]{4})(Jan)([0-9]{2})/\101\3/g'| sed -E 's/([0-9]{4})(Feb)([0-9]{2})/\102\3/g'| sed -E 's/([0-9]{4})(Mar)([0-9]{2})/\103\3/g'| sed -E 's/([0-9]{4})(Sep)([0-9]{2})/\109\3/g'| sed -E 's/([0-9]{4})(Oct)([0-9]{2})/\110\3/g' 
   echo
  fi
 elif (($choice == 7)); then
  echo
  read -p "Please enter the 'user id'(1~943):" id
  echo
  cat u.data | awk -v a=${id} '$1==a{print $2}'| sort -n| awk  '{printf $0"|"}'| sed 's/|$//'
  echo
  echo
  val=$(cat u.data | awk -v a=${id} '$1==a{print $2}'| sort -n | awk 'NR<=10 {print $0}')
  for v in $val
  do
   cat u.item| awk -F\| -v a=$v '$1==a{print $1"|"$2}'
  done
  echo
 elif (($choice == 8)); then
  echo
  read -p "Do you want to get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'?(y/n):" res
  if [ $res = "y" ]
  then
   id=$(cat u.user| awk -F\| '$2>=20 && $2<=29 && $4=="programmer"{print $1}')
   data=""
   for i in $id
   do
    d=$(cat u.data| awk -v a=$i  '$1==a {print $2, $3"\n"}'| sort -n)
    data+="$d"
   done
   movie_id="" 
   a=0 
   for i in $(echo "$data"| sort -n| awk '{print $1}')
   do
    if [ $i != $a ]; then
     movie_id+="$i
"
     a=$i
    fi
   done
   res=""
   for i in $movie_id
   do
    sum=0
    rates=$(echo "$data"| sort -n|awk -v a=$i 'a==$1{print $2}')
    for j in $rates
    do
     ((sum+=j))
     ((cnt++))
    done
    res+="$i $(awk -v sum=$sum -v cnt=$cnt 'BEGIN {print sum / cnt}')
"
    cnt=0
   done
  echo "$res"
  else
   echo
  fi
 elif (($choice == 9)); then
  echo "Bye!"
  break
 fi
read -p "Enter your choice [1-9] " choice
done
