IMAGE_NAME := takesxisximada/docker-gaurun
USER := ng
GROUP := ng

SRC_DIR := $(CURDIR)/gaurun
BUILD_DIR := $(CURDIR)/build

GAURUN_EXE := $(BUILD_DIR)/gaurun
GAURUN_RECOVER_EXE := $(BUILD_DIR)/gaurun_recover

$(GAURUN_EXE):
	mkdir -p $(BUILD_DIR)
	cd $(SRC_DIR) && GOOS=linux GOARCH=amd64 go build -o $(GAURUN_EXE) cmd/gaurun/gaurun.go

$(GAURUN_RECOVER_EXE):
	mkdir -p $(BUILD_DIR)
	cd $(SRC_DIR) && GOOS=linux GOARCH=amd64 go build -o $(GAURUN_RECOVER_EXE) cmd/gaurun_recover/gaurun_recover.go

.PHONY: build
build: $(GAURUN_EXE) $(GAURUN_RECOVER_EXE)
	docker build . --build-arg USER=$(USER) --build-arg GROUP=$(GROUP) --tag $(IMAGE_NAME)

.PHONY: debug
debug:
	@## make debug vault=CONTAINER_ID token=TOKEN
	docker run --link $(vault):vault.internal -e VAULT_TOKEN=$(token) -it $(IMAGE_NAME) sh

.PHONY: dummy-crt
dummy-crt:
	mkdir -p secret
	openssl genrsa 2048 > secret/server.key
	openssl req -new -key secret/server.key > secret/server.csr
	openssl x509 -days 3650 -req -signkey secret/server.key < secret/server.csr > secret/server.crt
