#!/bin/bash
# Helper functions

# Log messages with different log levels
function log()
{
	local log_args=( $@ )
	local dt=$(date '+%y/%m/%d %H:%M:%S')
	if [[ $(( ${#log_args[@]} )) > 1 ]]; then
		level=$1

		prefix=""
		if [[ $level == 0 ]]; then
			prefix="INFO"
		elif [[ $level == 1 ]]; then
                        prefix="WARN"
		elif [[ $level == 2 ]]; then
                        prefix="ERROR"
		elif [[ $level == 3 ]]; then
                        prefix="FATAL"
		fi

		echo "$dt $prefix $2"
	fi
}

# Variables
master_hostname="master"	# Master Hostname
# ip of this host
this_host_ip="$(ifconfig | grep -A 1 'eth0' | tail -1 | cut -d ':' -f 2 | cut -d ' ' -f 1)"

# Edit xml.templates
sed s/HOSTNAME/$master_hostname/ $HADOOP_PREFIX/etc/hadoop/core-site.xml.template > $HADOOP_PREFIX/etc/hadoop/core-site.xml
sed s/HOSTNAME/$master_hostname/ $HADOOP_PREFIX/etc/hadoop/yarn-site.xml.template > $HADOOP_PREFIX/etc/hadoop/yarn-site.xml
sed s/HOSTNAME/$master_hostname/ $HADOOP_PREFIX/etc/hadoop/mapred-site.xml.template > $HADOOP_PREFIX/etc/hadoop/mapred-site.xml
log 0 "XML templates edited."

# Start ssh
service ssh start
log 0 "SSH started."

# Set master mode
if [[ $(hostname) == $master_hostname ]]; then
	# Formatting namenode, starting namenode and resourcemanager
        $HADOOP_PREFIX/bin/hdfs namenode -format -force
	log 0 "Namenode formatted."
        $HADOOP_PREFIX/sbin/hadoop-daemon.sh start namenode
        log 0 "Namenode started."
        $HADOOP_PREFIX/sbin/yarn-daemon.sh start resourcemanager
	log 0 "Resourcemanager started."
# Set slave mode
else
	# Starting datanode and nodemanager
	$HADOOP_PREFIX/sbin/hadoop-daemon.sh start datanode
        log 0 "Datanode started."
	$HADOOP_PREFIX/sbin/yarn-daemon.sh start nodemanager
	log 0 "Nodemanager started."
fi

# Run container
log 0 "Running container ..."
if [[ $1 == "-d" ]]; then
	while true; do sleep 1000; done
elif [[ $1 == "-bash" ]]; then
	/bin/bash
fi
