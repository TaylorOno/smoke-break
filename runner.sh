#!/bin/bash

USAGE=" Usage: $0 -ls  -- List collections available to test \nUsage: $0 [collection] [HostA] [HostB]\n"

if [[ $# == 1 && $1 == "-ls" ]]; then
  echo "tests:"
  ALL_SERVICES=( $(ls ./tests | sed "s/[.].*//") )
  for SERVICE in "${ALL_SERVICES[@]}"
  do
    echo "- $SERVICE"
  done
  exit 1
fi

if [[ $# -lt 3 ]]; then
  echo -e $USAGE
  exit 1
fi

COLLECTION="$1"
HOST_A="$2"
HOST_B="$3"

echo " "
echo "Collection: $COLLECTION"
echo "Host A: $HOST_A"
echo "Host B: $HOST_B"

tmpHosts=$(mktemp)
echo -e "host\n$HOST_A\n$HOST_B" > "$tmpHosts"

tmpCollection=$(mktemp)
jq '.item[].request.url.host = ["{{host}}"]' "tests/$COLLECTION.postman_collection.json" > "$tmpCollection"

newman run "$tmpCollection" --iteration-data "$tmpHosts" --delay-request