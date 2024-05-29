let

  tom = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJMERALdLOOYZP5ENpa+VXzYSM7ABn9POZL6hJDoxt4s tom@zeus"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFl4GaQ0liA4sCgQeabUzYiZbvr5VqqSmSxaL4YpZapc tom@tom-laptop2"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKdnwVGpMaBv5Bx2XuIvuBI+b4HNaPYcuPoGSzZi/Z5R ffrn@tom v1"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKYkU9Fla4gbEqj0nW2vSHQ8aVQM7RtB7E2ynAMU/rb7 ffda@tom v1"
  ];

  gw-test01 = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDtR8TRk8ZSnNjDTADNqFDLyYseZHJN0JuoZ7oFQ5CeG" ];
  gw-test02 = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGSor4Kbpm2//WZXOk5qnCWlyI45SEBhBtXeoEdiniss" ];
  www1 = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG4i5fBF0dk57Sl2pgrpBoONof3m0lr8yeogF+OPxfBl" ];

  admins = tom;
  all_servers = gw-test01 ++ gw-test02 ++ www1;
in
{
  "gw-test01/fastd.age".publicKeys = admins ++ gw-test01;
  "gw-test01/acme.age".publicKeys = admins ++ gw-test01;

  "gw-test02/fastd.age".publicKeys = admins ++ gw-test02;
  "gw-test03/fastd.age".publicKeys = admins;
  "gw-test04/fastd.age".publicKeys = admins;

  "www1/acme.age".publicKeys = admins ++ www1;
  "www1/influxdb-basicAuth.age".publicKeys = admins ++ www1;
  "www1/influxdb-basicAuth-secret.age".publicKeys = admins;
}
