SHELL=/bin/sh

IMAGE_NAME=sendmail

SENDMAIL_VERSION=8.14.4

DOCKERHUB=ffffuuu

.PHONY: build clean docker run tag

docker: build tag

build:
	docker build . -t $(IMAGE_NAME):latest

tag:
	docker tag $(IMAGE_NAME):latest $(DOCKERHUB)/$(IMAGE_NAME):latest
	docker tag $(IMAGE_NAME):latest $(DOCKERHUB)/$(IMAGE_NAME):$(SENDMAIL_VERSION)
	docker push $(DOCKERHUB)/$(IMAGE_NAME):latest
	docker push $(DOCKERHUB)/$(IMAGE_NAME):$(SENDMAIL_VERSION)
run:
	docker run -it --name sendmail --rm  -p 2525:25/tcp $(IMAGE_NAME):latest

clean:
	-docker ps -a | awk '/$(IMAGE_NAME)/{print $$1};' | xargs -n1 docker rm
	-docker images | awk '/^<none>/ {print $$3};' | xargs -n1 docker rmi -f
	-docker rmi -f $(IMAGE_NAME):latest
