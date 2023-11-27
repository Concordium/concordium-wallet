#!/bin/bash

# Use HEADER environment variable to run tests with header (as it defaults to running them headerless)
if [[ -z "${HEADER}" ]]; then
    DEVICE=web-server
else
    DEVICE=chrome
fi

for filename in integration_test/*_test.dart integration_test/**/*_test.dart; do
    [ -e "$filename" ] || continue
    flutter drive --driver=integration_test/test_driver.dart --target=$filename   -d $DEVICE
done

