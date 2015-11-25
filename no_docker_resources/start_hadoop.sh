#!/bin/bash
# ip of this host
this_hostname="$(hostname -f)"

# Set master mode
if [[ $this_hostname == "ssds111.dbnet.syssoft.uni-trier.de" ]]; then
	# Formatting namenode, starting namenode and resourcemanager
        $HADOOP_PREFIX/bin/hdfs namenode -format -force
        $HADOOP_PREFIX/sbin/hadoop-daemon.sh start namenode
        $HADOOP_PREFIX/sbin/yarn-daemon.sh start resourcemanager
# Set slave mode
else
	# Starting datanode and nodemanager
	$HADOOP_PREFIX/sbin/hadoop-daemon.sh start datanode
	$HADOOP_PREFIX/sbin/yarn-daemon.sh start nodemanager
fi
