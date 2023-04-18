#!/bin/bash

modify_names=/home/ignacy/EOPSY/modify.sh;

# ------- CREATING DIRECTORY FOR TESTING------

function make_test_dir() {

    mkdir "test_directory";
    echo test > "test_directory/file.txt";
    echo test > "test_directory/AbC.txt";
    echo test > "test_directory/aab.txt";
    echo test > "test_directory/space is here .txt";
    echo test > "test_directory/.special.txt";
    echo test > "test_directory/space is here .txt";

    cd test_directory;

    for i in  {1..4}
    do
        mkdir "test_subdirectory_$i";
        echo test > "test_subdirectory_$i/abb${i}.txt";
        echo test > "test_subdirectory_$i/space is here ${i}.txt";
        echo test > "test_subdirectory_$i/.special${i}.txt";
    done
}

function make_test_dir1() {

    mkdir "test_directory1";
    echo test > "test_directory1/FILE.txt";
    echo test > "test_directory1/ABC.txt";
    echo test > "test_directory1/AAB.txt";
    echo test > "test_directory1/SPACE IS HERE .txt";
    echo test > "test_directory1/.SPECIAL.txt";
    echo test > "test_directory1/SPACE IS HERE .txt";

    cd test_directory1;

    for i in  {1..4}
    do
        mkdir "test_subdirectory1_$i";
        echo test > "test_subdirectory1_$i/ABB${i}.txt";
        echo test > "test_subdirectory1_$i/SPACE IS HERE ${i}.txt";
        echo test > "test_subdirectory1_$i/.SPECIAL${i}.txt";
    done
}

#PROPER CALLING OF THE SCRIPT

test1='./modify.sh -h';
test2='./modify.sh -l ./test_directory1';
test3='./modify.sh -l ./test_directory1/file.txt';
test4='./modify.sh -u ./test_directory';
test5='./modify.sh -u ./test_directory/file.txt';
test6='./modify.sh -r -l ./test_directory1';
test7='./modify.sh -r -l ./test_directory1/file.txt';
test8='./modify.sh -r -u ./test_directory';
test9='./modify.sh -r -u ./test_directory/file.txt';
test10='./modify.sh -u ./test_directory/.special.txt';
test11='./modify.sh -u ./test_directory/space is here .txt';
test12='./modify.sh s/a/A/ ./test_directory';
test13='./modify.sh s/a/A/ ./test_directory/file.txt';

#INPROPER CALLING OF THE SCRIPT

test14='./modify.sh s/a/A/'; #no directory passed
test15='./modify.sh -u'; #no directory passed
test16='./modify.sh -l'; #no directory passed
test17='./modify.sh'; #no parameter passed
test18='./modify.sh -p'; #wrong parameter
test19='./modify.sh -l -p'; #proper parameter and wrong parameter
test20='./modify.sh -l -u'; #double options
test21='./modify.sh -r -l -u'; #all options
test22='./modify.sh -l -u ./test_directory'; #double options with path
test23='./modify.sh -l s/a/A/'; #option with sed
test24='./modify.sh s/a/A/ s/a/A/'; #double sed
test25='./modify.sh ./test_directory'; #only path
test26='./modify.sh ./test_directory ./test_directory'; #double path

# ------- MAIN -------

[ $# -eq 0 ] && echo "No test number passed" && exit;

[ $1 -gt 26 ] && echo "Test $1 does not exist" && exit;
[ $1 -lt 1 ] && echo "Test $1 does not exist" && exit;

rm -r test_directory
rm -r test_directory1;
make_test_dir;
cd ..;
make_test_dir1;
cd ..;

echo "Calling test$1";
echo "-----------------------";

call_test=test$1;
eval ${!call_test};

echo "Is it correct? (y/n)";
read answer;

if [ $answer == "y" ]; then
    echo "Test $1 passed";
else
    echo "Test $1 failed";
fi
