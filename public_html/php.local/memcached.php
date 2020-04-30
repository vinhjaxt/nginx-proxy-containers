<?php
$memcached = new Memcached();
$memcached->addServer('/var/run/memcached/unix.sock', 0);
var_dump($memcached->getStats());
var_dump($memcached->getVersion());
var_dump($memcached->getServerList());

$memcached->set("hello", "world");
echo $memcached->get("hello");
