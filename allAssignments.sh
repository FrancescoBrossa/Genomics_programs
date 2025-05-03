

# this program will read from a file that will contains the couple foldernumber and GENE TYPE in each row
# for all the 10 cases
# the file needs a text file named ourcases.txt


while IFS= read -r line; do
	#fields=($(echo "$line" | cut -d ";" -f 1) $(echo "$line" | cut -d ";" -f 2))
	field1=$(echo "$line" | cut -d ";" -f 1)
    	field2=$(echo "$line" | cut -d ";" -f 2)
	./allCommands.sh "$field1" "$field2"
done < ourcases.txt
