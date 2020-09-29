resource r0 {
    protocol C;
    device	/dev/drbd0;
    disk	/dev/sdb;
    meta-disk  internal;	

  on master {
    address	192.168.31.31:7789;
  }

  on node2 {
    address	192.168.31.127:7789;
  }

}
