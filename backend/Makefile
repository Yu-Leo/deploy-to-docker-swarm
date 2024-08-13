#################
#| Переменные  |#
#################

GO_DAEMONS_PATH=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
BUILD=$(GO_DAEMONS_PATH)/build
CURRENT_DAEMON_PATH=$(GO_DAEMONS_PATH)/$(DAEMON)

# Переменные, которые используются для генерации версии демона
VERSION_TMP_FILE=$(BUILD)/build_version.tmp
DATE=$(shell date '+%Y%m%d')
GIT_COMMIT=$(shell git rev-parse HEAD | cut -c 1-8)
BUILD_VERSION=$(DATE)_$(GIT_COMMIT)

#################################
#| Правила для сборки проекта  |#
#################################

# Базовая инициализация проекта
start: godeps gotools

# Генерируем версию демона
gen-version:
	mkdir -p build
	touch $(VERSION_TMP_FILE)
	echo $(DATE)_$(GIT_COMMIT) > $(VERSION_TMP_FILE)

# Вывод версии демона
version:
	echo $(BUILD_VERSION)

# Скачиваем все необходимые go-модули
godeps:
	go mod download

# Устанавливаем все вспомогательные утилиты
# make gotools
gotools:
ifeq ("$(wildcard $(GOPATH)/bin/golangci-lint)","")
	go install github.com/golangci/golangci-lint/cmd/golangci-lint@v1.57.2
endif

##############################################
#| Правила для работы с конкретным демоном  |#
##############################################

ALL_DAEMONS=backend # Список демонов

.PHONY: build-all $(ALL_DAEMONS)
build-all: $(ALL_DAEMONS)
$(ALL_DAEMONS):
	$(MAKE) build DAEMON=$@ || exit

# Собираем бинарник демона, кладём в BUILD
# make build DAEMON=<daemon_name>
.PHONY: build
build: gen-version
ifeq ($(DAEMON),all)
	$(MAKE) build-all
else
	CGO_ENABLED=0 go build -ldflags \
	 -o $(BUILD) $(CURRENT_DAEMON_PATH)
endif

# Запускаем unit тесты для демона
# make test DAEMON=<daemon_name>
test:
ifeq ($(DAEMON),all)
	cd $(GO_DAEMONS_PATH) && \
	go test -race -count=1 $(GO_DAEMONS_PATH)/...
else
	cd $(CURRENT_DAEMON_PATH) && \
    go test -count=1 -race \
	$(CURRENT_DAEMON_PATH)/...
endif

# Запускам линтер
# make lint DAEMON=<daemon_name>
lint:
ifeq ($(DAEMON),all)
	cd $(GO_DAEMONS_PATH) && \
	test 0 -eq `$(GOPATH)/bin/golangci-lint run -c $(GO_DAEMONS_PATH)/.golangci.yml --timeout=5m | tee /dev/stderr | wc -l`
else
	cd $(CURRENT_DAEMON_PATH) && \
	test 0 -eq `$(GOPATH)/bin/golangci-lint run -c $(GO_DAEMONS_PATH)/.golangci.yml --timeout=5m | tee /dev/stderr | wc -l`
endif

# Запускаем линтер, билд и тесты для DAEMON
# make build-and-test DAEMON=<daemon_name>
build-lint-test:
	cd $(GO_DAEMONS_PATH) \
	&& $(MAKE) build \
	&& $(MAKE) lint \
	&& $(MAKE) test
