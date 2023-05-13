DNAME=reg.am.net/soodar/index/kas:3
build:
	@docker build . -t ${DNAME}
	@docker push ${DNAME}
	
docker: build