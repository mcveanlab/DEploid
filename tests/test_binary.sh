#!/bin/bash

function test_dEploid {
  echo -n " dEploid $@ "
  for i in `seq 1 1`; do
    echo -n "."

    # Test using dEploid self-checks
    ./dEploid_dbg $@ -seed $i > /dev/null
    if [ $? -ne 0 ]; then
      echo ""
      echo "Executing \"./dEploid_dbg $@ -seed $i\" failed."
      echo "Debug Call: make -mj2 dEploid_dbg && ./dEploid_dbg $@ -seed $i 2>&1 | less"
      exit 1
    fi

    echo -n "."
    # Test for memory leaks
    valgrind --error-exitcode=1 --leak-check=full -q ./dEploid $@ -seed $i > /dev/null
    if [ $? -ne 0 ]; then
      echo ""
      echo "Valgrind check of \"./dEploid $@ -seed $i\" failed."
      exit 1
    fi

  done
  echo " done."
}

function test_noRepeat {
  echo -n " dEploid $@ "
  # Test using dEploid self-checks
  ./dEploid_dbg $@ > /dev/null
  if [ $? -ne 0 ]; then
    echo ""
    echo "Executing \"./dEploid_dbg $@ -seed $i\" failed."
    echo "Debug Call: make -mj2 dEploid_dbg && ./dEploid_dbg $@ $i 2>&1 | less"
    exit 1
  fi

  # Test for memory leaks
  valgrind --error-exitcode=1 --leak-check=full -q ./dEploid $@ > /dev/null
  if [ $? -ne 0 ]; then
    echo ""
    echo "Valgrind check of \"./dEploid $@ \" failed."
    exit 1
  fi

  echo " done."
}

sameFlags="-exclude data/testData/labStrains.test.exclude.txt -plaf data/testData/labStrains.test.PLAF.txt"

echo "Testing examples"
 test_noRepeat
 test_noRepeat -help
 test_noRepeat -h
 test_noRepeat -v
 test_noRepeat -version
 test_dEploid ${sameFlags} -vcf data/testData/PG0390-C.test.vcf -noPanel -o tmp1 || exit 1
 #test_dEploid ${sameFlags} -vcf data/testData/PG0390-C.test.vcf -panel data/testData/labStrains.test.panel.txt -o tmp1 || exit 1
 #test_dEploid ${sameFlags} -ref data/testData/PG0390-C.test.ref -alt data/testData/PG0390-C.test.alt -noPanel -o tmp1 || exit 1
 #test_dEploid ${sameFlags} -ref data/testData/PG0390-C.test.ref -alt data/testData/PG0390-C.test.alt -panel data/testData/labStrains.test.panel.txt -o tmp1 || exit 1
echo ""
