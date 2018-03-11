#!/bin/bash

# system memory size: MemTotal (kB)
mem_size_kB=$(head -1 /proc/meminfo | awk '{print $2}')
innodb_buffer_pool_size=`echo $mem_size_kB | awk '{printf("%d", $1 * 0.75)}'`
innodb_log_file_size=`echo $innodb_buffer_pool_size | awk '{printf("%d", $1 * 0.2)}'`
log_path='/var/log/mysql/mysql-slow.log'

my_cnf_text=`cat << EOS
[mysqld]
\ncharacter-set-server=utf8mb4
\nslow_query_log-file=$log_path
\nlong_query_time=0.2
\nlog_queries_not_using_indexes=OFF
\nslow_query_log=ON
# \nskip_innodb_doublewrite
\n
\ninnodb_buffer_pool_size=${innodb_buffer_pool_size}K
\ninnodb_log_file_size=${innodb_log_file_size}K
\n
\n[client]
\ndefault-character-set=utf8mb4
EOS
`
echo $my_cnf_text


