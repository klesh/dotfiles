
# Windows

1. Download / install and setup JDK
    1. extract as d:\programs\java\jdk-xxx
    2. set env var JAVA_HOME=d:\programs\java\jdk-xxx
    3. add PATH `%JAVA_HOME\bin%`
2. Download hadoop from https://mirrors.tuna.tsinghua.edu.cn/apache/hadoop/common/hadoop-3.2.1/hadoop-3.2.1.tar.gz
    1. extract as d:\programs\java\hadoop-3.2.1
    2. set env var HADOOP_HOME=d:\programs\java\hadoop-3.2.1
    3. add PATH `%HADOOP_HOME%\bin` and `%HADOOP_HOME%\sbin`
    4. run `hadoop version` see if it's working, if `Could not find or load main class` ocurred because your account name contains space, edit `%HADOOP_HOME%\etc\hadoop\hadoop-env.cmd` file, find line `set HADOOP_IDENT_STRING=%USERNAME%` and change `%USERNAME%` to a fixed string without space
3. Creating hdfs
    1. download windows native files from https://github.com/cdarlint/winutils/tree/master/hadoop-3.2.1/bin extract to `%HADOOP_HOME\BIN`
    2. create folders: 
        ```ps
        mkdir $env:HADOOP_HOME\data\datanode,$env:HADOOP_HOME\data\namenode
        ```
    3. follow guide: https://cwiki.apache.org/confluence/display/HADOOP2/Hadoop2OnWindows
    4. set up hdfs dirs:
        ```xml
        <property>
            <name>dfs.name.dir</name>
            <value>/var/local/hadoop/hdfs/name</value>
            <description>Determines where on the local filesystem the DFS name node
            should store the name table.  If this is a comma-delimited list
            of directories then the name table is replicated in all of the
            directories, for redundancy. </description>
            <final>true</final>
        </property>

        <property>
            <name>dfs.data.dir</name>
            <value>/var/local/hadoop/hdfs/data</value>
            <description>Determines where on the local filesystem an DFS data node
            should store its blocks.  If this is a comma-delimited
            list of directories, then data will be stored in all named
            directories, typically on different devices.
            Directories that do not exist are ignored.
            </description>
            <final>true</final>
        </property>
        ```
    5. fix setPosixPermissions error: https://kontext.tech/column/hadoop/379/fix-for-hadoop-321-namenode-format-issue-on-windows-10

