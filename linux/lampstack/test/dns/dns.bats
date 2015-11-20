#! /usr/bin/env bats
#
# Acceptance test for the DNS server for linuxlab.lan

sut_ip=192.168.56.10
domain=testdomein.lan

#{{{ Helper functions

# Usage: assert_forward_lookup NAME IP
# Exits with status 0 if NAME.DOMAIN resolves to IP, a nonzero
# status otherwise
assert_forward_lookup() {
  local name="$1"
  local ip="$2"

  [ "$ip" = "$(dig @${sut_ip} ${name}.${domain} +short)" ]
}

# Usage: assert_reverse_lookup NAME IP
# Exits with status 0 if a reverse lookup on IP resolves to NAME,
# a nonzero status otherwise
assert_reverse_lookup() {
  local name="$1"
  local ip="$2"

  [ "${name}.${domain}." = "$(dig @${sut_ip} -x ${ip} +short)" ]
}

# Usage: assert_alias_lookup ALIAS NAME IP
# Exits with status 0 if a forward lookup on NAME resolves to the
# host name NAME.DOMAIN and to IP, a nonzero status otherwise
assert_alias_lookup() {
  local alias="$1"
  local name="$2"
  local ip="$3"
  local result="$(dig @${sut_ip} ${alias}.${domain} +short)"

  echo ${result} | grep "${name}\.${domain}\."
  echo ${result} | grep "${ip}"
}

# Usage: assert_ns_lookup NS_NAME...
# Exits with status 0 if all specified host names occur in the list of
# name servers for the domain.
assert_ns_lookup() {
  local result="$(dig @${sut_ip} ${domain} NS +short)"

  [ -n "${result}" ] # the list of name servers should not be empty
  while (( "$#" )); do
    echo "${result}" | grep "$1\.${domain}\."
    shift
  done
}

# Usage: assert_mx_lookup PREF1 NAME1 PREF2 NAME2...
#   e.g. assert_mx_lookup 10 mailsrv1 20 mailsrv2
# Exits with status 0 if all specified host names occur in the list of
# mail servers for the domain.
assert_mx_lookup() {
  local result="$(dig @${sut_ip} ${domain} MX +short)"

  [ -n "${result}" ] # the list of name servers should not be empty
  while (( "$#" )); do
    echo "${result}" | grep "$1 $2\.${domain}\."
    shift
    shift
  done
}

#}}}

@test 'The `dig` command should be installed' {
  which dig
}

@test 'The main config file should be syntactically correct' {
  named-checkconf /etc/named.conf
}

@test 'The forward zone file should be syntactically correct' {
  # It is assumed that the name of the zone file is the name of the zone
  # itself (without extra extension)
  named-checkzone ${domain} /var/named/${domain}
}

@test 'The reverse zone files should be syntactically correct' {
  # It is assumed that the name of the zone file is the name of the zone
  # itself (without extra extension)
  for zone_file in /var/named/*.in-addr.arpa; do
    reverse_zone=${zone_file##*/}
    named-checkzone ${reverse_zone} ${zone_file}
  done
}

@test 'The service should be running' {
  systemctl status named
}

@test 'Forward lookups' {
  #                     host name  IP
  assert_forward_lookup monitoring      192.168.56.70
  assert_forward_lookup lampstack      192.168.56.77
  assert_forward_lookup lempstack      192.168.56.66
}


@test 'Reverse lookups' {
  #                     host name  IP
  assert_reverse_lookup monitoring      192.168.56.70
  assert_reverse_lookup lampstack      192.168.56.77
  assert_reverse_lookup lempstack      192.168.56.66
}


@test 'Alias lookups' {
  #                   alias      hostname  IP
  assert_alias_lookup mon        monitoring      192.168.56.70
  assert_alias_lookup ls        lampstack      192.168.56.77
  assert_alias_lookup lemp       lempstack      192.168.56.66
}

@test 'NS record lookup' {
  assert_ns_lookup dns
}
