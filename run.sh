#!/bin/bash
mkdir -p out
mkdir -p report
cd ./tests
prefix="t" ;
dirlist=(`ls ${prefix}*.in`) ;
OUTPUT_DIRECTORY="out/"
TEST_DIRECTORY="tests/"
REPORT_DIRECTORY="report/"
NUMBER_OF_PASSED=0
NUMBER_OF_FAILED=0
cd ../

checkeq() {
    python3 comp.py -a $1 -b $2 -o $3
    if [[ $? = 0 ]]; then
        ((NUMBER_OF_PASSED++))
        echo "++++ test passed"
    else
        ((NUMBER_OF_FAILED++))
        echo "---- test failed !"
    fi
    echo
}

for filelist in ${dirlist[*]}
do  
    filename=`echo $filelist | cut -d'.' -f1`;
    output_filename="$filename.out"
    program_input="$filename.in"
    report_filename="$filename.report.txt"
 
    echo "Running Test $filename -------------------------------------"
    echo "$filelist"
    java -jar Mars.jar quicksort.asm < "$TEST_DIRECTORY$program_input" | tail -n +2  > "$OUTPUT_DIRECTORY$output_filename"
    if [[ $? -eq 0 ]]; then
        echo "Code Executed Successfuly!"
        checkeq "$OUTPUT_DIRECTORY$output_filename" "$TEST_DIRECTORY$output_filename" "$REPORT_DIRECTORY$report_filename"
    else
        echo "Code did not execute successfuly!"
        ((NUMBER_OF_FAILED++))
    fi
done

echo "Passed : $NUMBER_OF_PASSED"
echo "Failed : $NUMBER_OF_FAILED"
score=$(echo "scale=4 ; $NUMBER_OF_PASSED / $(($NUMBER_OF_PASSED + $NUMBER_OF_FAILED)) * 100" | bc | sed 's/.....$//')
echo "Score : $score"
