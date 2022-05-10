#!/bin/bash

while true
do
        echo "1. Add"
        echo "2. Subtract"
        echo "3. Multiply"
        echo "4. Divide"
        echo "5. Average"
        echo "6. Quit"
        read -p "Enter choice : " choice

        if [ $choice -eq 6 ]
        then
                break

        elif [ $choice -lt 1 ] || [ $choice -gt 6 ]
        then
                continue
        
        else
                read -p "Enter first number : " num1
                read -p "Enter second number : " num2

                case $choice in
                        1) echo "Sum of $num1 and $num2 : $(( $num1 + $num2 ))" ;;
                        2) echo "Difference of $num1 and $num2 : $(( $num1 - $num2 ))" ;;  
                        3) echo "Product of $num1 and $num2 : $(( $num1 * $num2 ))" ;;
                        4) echo "Quotient of $num1 and $num2 : $(( $num1 / $num2 ))" ;;
                        5) echo "Average of $num1 and $num2 : $(( ($num1 + $num2) / 2 ))" ;;
                esac
        fi
done