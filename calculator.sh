!/bin/bash

while true
do
        echo "1. Add"
        echo "2. Subtract"
        echo "3. Multiply"
        echo "4. Divide"
        echo "5. Quit"
        read -p "Enter choice : " choice

        if [ $choice -eq 5 ]
        then
                break

        elif [ $choice -lt 1 ] || [ $choice -gt 5 ]
        then
                continue
        
        else
                read -p "Enter first number : " num1
                read -p "Enter second number : " num2

                if [ $choice -eq 1 ]
                then

                        echo "Sum of $num1 and $num2 : $(( $num1 + $num2 ))"
                
                elif [ $choice -eq 2 ]
                then
                        echo "Subtraction of $num1 and $num2 : $(( $num1 - $num2 ))"


                elif [ $choice -eq 3 ]
                then
                        echo "Multiplication of $num1 and $num2 : $(( $num1 * $num2 ))"

                elif [ $choice -eq 4 ]
                then
                        echo "Division of $num1 and $num2 : $(( $num1 / $num2 ))"
                fi
        fi
done