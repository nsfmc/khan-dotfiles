install: os-install common-install ;

os-install:
	if [ `uname -s` = Linux ]; then ./linux-setup.sh; fi
	if [ `uname -s` = Darwin ]; then ./mac-setup.sh; fi

common-install:
	./setup.sh

fulltime:
	pushd "scripts"; \
	./package_managers.sh; \
	./dropbox.sh; \
	./auth.sh; \
	./vcs.sh; \
	./clone_repos.sh ${ARGS}; \
	./webapp_config.sh ${ARGS}; \
	./common_dev_apps.sh; \
	popd

intern:
	pushd scripts