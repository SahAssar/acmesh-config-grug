#!/usr/bin/env sh

#
#DNS_LOCAL_FILE_DIRECTORY="/var/acme-challenge/"
#

########  Public functions #####################

#Usage: add  _acme-challenge.www.domain.com   "XKrxpRBosdIKFzxW_CT3KLZNf6q0HG9i01zxXp5CPBs"
dns_local_file_add() {
  fulldomain=$1
  txtvalue=$2

  if [ -z "$DNS_LOCAL_FILE_DIRECTORY" ]; then
    _err "Set DNS_LOCAL_FILE_DIRECTORY to the directory to use for acme challenge records"
    return 1
  fi

  echo "$fulldomain. 20 IN TXT $txtvalue" >> $DNS_LOCAL_FILE_DIRECTORY/$fulldomain

  return 0
}

#fulldomain txtvalue
dns_local_file_rm() {
  fulldomain=$1
  txtvalue=$2

  if [ -z "$DNS_LOCAL_FILE_DIRECTORY" ]; then
    _err "Set DNS_LOCAL_FILE_DIRECTORY to the directory to use for acme challenge records"
    return 1
  fi

  sed -i.bak "/.*$txtvalue.*/d" $DNS_LOCAL_FILE_DIRECTORY/$fulldomain
  rm $DNS_LOCAL_FILE_DIRECTORY/$fulldomain.bak
  # If the file is now empty remove it
  [ -s $DNS_LOCAL_FILE_DIRECTORY/$fulldomain ] || rm $DNS_LOCAL_FILE_DIRECTORY/$fulldomain

  return 0
}
