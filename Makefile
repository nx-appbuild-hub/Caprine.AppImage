
# Copyright 2020 Alex Woroschilow (alex.woroschilow@gmail.com)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
PWD:=$(shell pwd)


all: clean
	mkdir --parents $(PWD)/build/Boilerplate.AppDir/caprine
	apprepo --destination=$(PWD)/build appdir boilerplate libatk1.0-0 libatk-bridge2.0-0 libgtk-3-0
	echo '' 																		>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '' 																		>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo 'LD_LIBRARY_PATH=$${LD_LIBRARY_PATH}:$${APPDIR}/caprine' 					>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo 'export LD_LIBRARY_PATH=$${LD_LIBRARY_PATH}' 								>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '' 																		>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '' 																		>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo 'UUC_VALUE=`cat /proc/sys/kernel/unprivileged_userns_clone 2> /dev/null`' 	>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '' 																		>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '' 																		>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '' 																		>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo 'if [ -z "$${UUC_VALUE}" ]' 												>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '    then' 																>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '        exec $${APPDIR}/caprine/caprine --no-sandbox "$${@}"' 			>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '    else' 																>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '        exec $${APPDIR}/caprine/caprine "$${@}"' 							>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '    fi' 																	>> $(PWD)/build/Boilerplate.AppDir/AppRun

	wget --output-document=$(PWD)/build/Caprine.AppImage https://github.com/sindresorhus/caprine/releases/download/v2.51.1/Caprine-2.51.1.AppImage
	chmod +x $(PWD)/build/Caprine.AppImage

	cd $(PWD)/build && $(PWD)/build/Caprine.AppImage --appimage-extract

	
	wget --output-document=$(PWD)/build/build.rpm http://mirror.centos.org/centos/8/BaseOS/x86_64/os/Packages/libffi-3.1-22.el8.x86_64.rpm
	cd $(PWD)/build && rpm2cpio $(PWD)/build/build.rpm | cpio -idmv && cd ..
	
	cp --force --recursive $(PWD)/build/usr/lib/* 			$(PWD)/build/Boilerplate.AppDir/lib64 	| true
	cp --force --recursive $(PWD)/build/usr/lib64/* 		$(PWD)/build/Boilerplate.AppDir/lib64 	| true
	cp --force --recursive $(PWD)/build/squashfs-root/usr/share/* 	$(PWD)/build/Boilerplate.AppDir/share 	| true
	cp --force --recursive $(PWD)/build/squashfs-root/usr/lib/* 	$(PWD)/build/Boilerplate.AppDir/lib64 	| true
	cp --force --recursive $(PWD)/build/squashfs-root/* 		$(PWD)/build/Boilerplate.AppDir/caprine


	rm -rf $(PWD)/build/Boilerplate.AppDir/caprine/usr
	rm -rf $(PWD)/build/Boilerplate.AppDir/caprine/AppRun 		| true	
	rm -rf $(PWD)/build/Boilerplate.AppDir/caprine/*.desktop 	| true	
	rm -rf $(PWD)/build/Boilerplate.AppDir/caprine/*.svg 		| true	
	rm -rf $(PWD)/build/Boilerplate.AppDir/caprine/*.png 		| true		
	rm -rf $(PWD)/build/Boilerplate.AppDir/*.svg 				| true
	rm -rf $(PWD)/build/Boilerplate.AppDir/*.desktop 			| true		
	rm -rf $(PWD)/build/Boilerplate.AppDir/*.png 				| true

	cp --force --recursive $(PWD)/AppDir/*.svg 		$(PWD)/build/Boilerplate.AppDir | true
	cp --force --recursive $(PWD)/AppDir/*.desktop 	$(PWD)/build/Boilerplate.AppDir | true
	cp --force --recursive $(PWD)/AppDir/*.png 		$(PWD)/build/Boilerplate.AppDir | true

	export ARCH=x86_64 && $(PWD)/bin/appimagetool.AppImage $(PWD)/build/Boilerplate.AppDir $(PWD)/Caprine.AppImage
	chmod +x $(PWD)/Caprine.AppImage

clean:
	rm -rf $(PWD)/build
