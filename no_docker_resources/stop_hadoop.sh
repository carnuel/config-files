#!/bin/bash
# ip of this host
this_hostname="$(hostname -f)"

# Set master mode
if [[ $this_hostname == "ssds111.dbnet.syssoft.uni-trier.de" ]]; then
        # Formatting namenode, starting namenode and resourcemanager
        $HADOOP_PREFIX/sbin/hadoop-daemon.sh stop namenode
        $HADOOP_PREFIX/sbin/yarn-daemon.sh stop resourcemanager
# Set slave mode
else
        # Starting datanode and nodemanager
        $HADOOP_PREFIX/sbin/hadoop-daemon.sh stop datanode
        $HADOOP_PREFIX/sbin/yarn-daemon.sh stop nodemanager
fi

