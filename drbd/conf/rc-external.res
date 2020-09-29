resource r0 {
    protocol C;
    device	/dev/drbd0;
    disk	/dev/sdb1;
    meta-disk	/dev/sdb2[0];

  on master {
    address	192.168.31.31:7789;
  }

  on node2 {
    address	192.168.31.127:7789;
  }

}
