#!/bin/sh

/vagrant/jmeter/ServerAgent-2.2.1/JRE/bin/java -jar $(dirname $0)/CMDRunner.jar --tool PerfMonAgent "$@"
