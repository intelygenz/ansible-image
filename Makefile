OWNER=intelygenz
IMAGE_NAME=ansible
IMAGE_VERSION=$(TRAVIS_TAG)
QNAME=$(OWNER)/$(IMAGE_NAME)

TEST_TAG=$(QNAME):test
BUILD_TAG=$(QNAME):$(IMAGE_VERSION)
LATEST_TAG=$(QNAME):latest

build:
	docker build \
		--build-arg ANSIBLE_VERSION=$(IMAGE_VERSION) \
		-t $(TEST_TAG) .

test:
	docker run --rm $(TEST_TAG) ansible --version | grep $(IMAGE_VERSION)

lint:
	docker run -it --rm -v "$(PWD)/Dockerfile:/Dockerfile:ro" redcoolbeans/dockerlint

tag:
	docker tag $(TEST_TAG) $(BUILD_TAG)
	docker tag $(TEST_TAG) $(LATEST_TAG)

login:
	@docker login -u "$(DOCKER_USER)" -p "$(DOCKER_PASS)"

push: login
	docker push $(BUILD_TAG)
	docker push $(LATEST_TAG)

readme:
	docker run --rm -v $(PWD)/README.md:/data/README.md -e DOCKERHUB_USERNAME=$(DOCKER_USER) -e DOCKERHUB_PASSWORD=$(DOCKER_PASS) -e DOCKERHUB_REPO_PREFIX=intelygenz -e DOCKERHUB_REPO_NAME=ansible readme-to-hub