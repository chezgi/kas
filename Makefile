DNAME=server:5000/kas
build:
	@docker build . -t ${DNAME}
	@docker push ${DNAME}
	
docker: build