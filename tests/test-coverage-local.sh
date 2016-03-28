#!/bin/bash

# Generate gcov output
#make -mj

# Generate html report
lcov --base-directory . --directory . --zerocounters -q
make check -mj
lcov --base-directory . --directory . -c -o libbash_test.info
# --rc lcov_branch_coverage=1 option will turn on branch check
lcov --remove libbash_test.info "/usr*" "src/codeCogs/*" "src/random/*" -o libbash_test.info # remove output for external libraries
rm -rf ./test_coverage
genhtml -o ./test_coverage -t "libbash test coverage" --num-spaces 4 libbash_test.info --legend --function-coverage --demangle-cpp
