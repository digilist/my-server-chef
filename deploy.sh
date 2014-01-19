#!/bin/bash

rm -f chef-stacktrace.out

case "$1" in
	"vagrant")
		vagrant ssh -c "cd /vagrant && sudo chef-solo -c solo.rb -j solo.json"
	;;
	"prod")
		cd `dirname $0`
		
		# sync files
		rsync --delete -rltDze 'ssh' --exclude=.git ./ server:/root/my-server-chef -v
		
		# install chef and dependencies if not installed yet
		ssh server "if ! which chef-client > /dev/null; then \
apt-get install -y curl ruby1.9.3 rubygems; \
curl -L https://www.opscode.com/chef/install.sh | bash; \
gem install berkshelf; \
fi"
		
		# deploy configs
		ssh server "cd /root/my-server-chef/ && sudo chef-solo -c solo.rb -j solo-prod.json; rm solo-prod.json"
	;;
	*)
		echo "Usage: $0 {vagrant|prod}"
		exit 1
esac
