#!/usr/bin/env bash

# TODO: exit with non-zero status code when tests fail.


# Clean up.
rm -f *.actual

# Execute the tests.
for testcase in test*.vim; do
  vim -N -u NONE -S $testcase -c 'quit!'
done

# Verify the results.
count_ok=0
count_fail=0

for expected in *.expected; do
  name=${expected%.*}
  actual=$name.actual

  if diff $expected $actual; then
    count_ok=$((count_ok + 1))
    echo "$name ok"
  else
    count_fail=$((count_fail + 1))
    echo "$name failed"
  fi
done

# Clean up.
git reset HEAD fixture.txt > /dev/null
git checkout fixture.txt
rm -f *.actual

# Print results.
echo
echo "$((count_ok + count_fail)) tests"
echo "$count_ok ok"
echo "$count_fail failed"
