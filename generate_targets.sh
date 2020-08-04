#!/bin/sh

gen_targets_sdk() {
	perl ./scripts/dump-target-info.pl architectures | while read -r LINE; do
		ARCH=$(echo "$LINE" | cut -d ' ' -f 1)
		TARGETS=$(echo "$LINE" | cut -d ' ' -f 2-)
		echo "
deploy-sdk_$ARCH:
  extends: .deploy-sdk
  variables:
    TARGETS: $TARGETS"
	done
}

gen_targets_imagebuilder() {
	perl ./scripts/dump-target-info.pl targets | while read -r LINE; do
		TARGET=$(echo "$LINE" | cut -d ' ' -f 1 | tr '/' '-')
		echo "
deploy-imagebuilder_$TARGET:
  extends: .deploy-imagebuilder"
	done
}

echo "include:
  - local: .gitlab/ci/deploy.yml
" > ../targets.yml
gen_targets_sdk >> ../targets.yml
gen_targets_imagebuilder >> ../targets.yml
cat ../targets.yml
