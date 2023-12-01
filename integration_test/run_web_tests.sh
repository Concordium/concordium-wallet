#!/bin/bash

# Use HEADER environment variable to run tests with header (as it defaults to running them headerless)
if [[ -z "${HEADER}" ]]; then
    DEVICE=web-server
else
    DEVICE=chrome
fi

find integration_test -type f -name '*_test.dart' | while read -r filename; do
    [ -e "$filename" ] || continue
    flutter drive --driver=integration_test/test_driver.dart --target=$filename -d $DEVICE
done

