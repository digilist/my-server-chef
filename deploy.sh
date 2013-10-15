#!/bin/bash

rm -f chef-stacktrace.out

case "$1" in
	"vagrant")
		vagrant ssh -c "cd /vagrant && sudo chef-solo -c solo.rb -j solo.json"
	;;
	"prod")
		cd `dirname $0`
		sudo chef-solo -c solo.rb -j solo-prod.json
	;;
esac