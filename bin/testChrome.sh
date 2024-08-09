#!/bin/bash

GECKO_DRIVER_PATH=/opt/bin/geckodriver
CHROME_DRIVER_PATH=/opt/bin/chromedriver

BROWSER=chrome
RETRY=2 # number of retries if a test fails due to timeout errors, etc.
TEST_CASE=$1 # first commandline parameter (leave empty for all warnings plugin tests)
ELASTIC=2 # increase if your machine is slow

error="$(tput setaf 1)$(tput bold)"
warn="$(tput setaf 3)$(tput bold)"
ok="$(tput setaf 2)$(tput bold)"

bold="$(tput bold)"
norm="$(tput setaf 0)$(tput sgr0)"

if [ ! -x ${CHROME_DRIVER_PATH} ]; then
    CHROME_DRIVER_PATH=$(which chromedriver)
fi

if [ ! -x ${CHROME_DRIVER_PATH} ]; then
    echo "${error}Did not find Selenium driver for Chrome ${CHROME_DRIVER_PATH}${norm}"
    exit 1;
fi

if [ -z "$TEST_CASE" ];
then
    TEST_CASE=SmokeTests
fi

mvnOptions="-Dquite -Dsurefire.rerunFailingTestsCount=${RETRY} -Dwebdriver.gecko.driver=${GECKO_DRIVER_PATH} -DElasticTime.factor=${ELASTIC} -Dwebdriver.chrome.driver=${CHROME_DRIVER_PATH}"

echo Running: env LC_NUMERIC="en_US.UTF-8" BROWSER=${BROWSER} mvn -V test -Dtest=${TEST_CASE} ${mvnOptions}

cd warnings-ng-plugin/ui-tests
env LC_NUMERIC="en_US.UTF-8" BROWSER=${BROWSER} mvn -V test -Dtest=${TEST_CASE} ${mvnOptions} -P-no-ui-tests-on-mac
