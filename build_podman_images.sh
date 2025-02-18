#!/bin/bash

OPENWRT_VERSION=${OPENWRT_VERSION:-23.05.5}
BASE_CONTAINER=${BASE_CONTAINER:-ghcr.io/openwrt/imagebuilder}

targets_all=($(curl -s "https://downloads.openwrt.org/releases/${OPENWRT_VERSION}/.targets.json" | sed 's|.*\"\(.*\)\"\:.*|\1|g' | tail -n +2 | head -n -1 | sort | sed 's|/|-|g'))
skip_targets=($(cat ./excluded_targets | sort | sed 's|/|-|g' ))

targets=()
for i in ${!targets_all[@]}; do 
	if printf '%s\0' "${skip_targets[@]}" | grep -Fxqz -- ${targets_all[$i]}; then echo "skip ${targets_all[$i]}" ; else targets+=(${targets_all[$i]}) ; fi
done

images=$(podman images | grep "imagebuilder-alpine")

for i in ${!targets[@]}; do 
  echo "$(($i+1))/${#targets[@]} - Building ${targets[$i]} "
 
  TARGET=$(echo ${targets[$i]} | cut -d '-' -f 1)
  SUBTARGET=$(echo ${targets[$i]} | cut -d '-' -f 2)

  if $(echo $images | grep -q "${TARGET}-${SUBTARGET}"); then
  	echo 'Done'
  else
	  TARGET="${TARGET}" SUBTARGET="${SUBTARGET}" ./build
  fi
  
done
