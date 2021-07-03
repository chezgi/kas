DNAME=server:5000/kas
docker-build:
	@docker build . -t ${DNAME}

docker-push:
	@docker push ${DNAME}
