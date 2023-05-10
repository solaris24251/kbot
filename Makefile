APP=$(shell basename $(shell git remote get-url origin))
REGISTRY=gcr.io/k3s-demo-363719
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
#TARGETOS=linux #linux darwin windows
#TARGETARCH=arm64 #amd64 arm64
IMAGE_TAG=${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v

get:
	go get

# Перевірка параметрів командного рядка
ifeq ($(TARGETOS),)
    TARGETOS=linux
endif

ifeq ($(TARGETARCH),)
    TARGETARCH=amd64
endif


# Збірка для Linux
ifeq ($(TARGETOS),linux)
    ifeq ($(TARGETARCH),amd64)
        build: build-linux-amd64
    else ifeq ($(TARGETARCH),arm64)
        build: build-linux-arm64
    else
        $(error Unsupported architecture $(TARGETARCH) for target $(TARGETOS))
    endif
endif


# Збірка для macOS
ifeq ($(TARGETOS),darwin)
    ifeq ($(TARGETARCH),amd64)
        build: build-darwin-amd64
    else ifeq ($(TARGETARCH),arm64)
        build: build-darwin-arm64
    else
        $(error Unsupported architecture $(TARGETARCH) for target $(TARGETOS))
    endif
endif

# Збірка для Windows
ifeq ($(TARGETOS),windows)
    ifeq ($(TARGETARCH),amd64)
        build: build-windows-amd64
    else ifeq ($(TARGETARCH),arm64)
        build: build-windows-arm64
    else
        $(error Unsupported architecture $(TARGETARCH) for target $(TARGETOS))
    endif
endif


build-darwin-amd64: format get
	CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 go build -v -o kbot -ldflags "-X="github.com/den-vasyliev/kbot/cmd.appVersion=${VERSION}
build-darwin-arm64: format get
	CGO_ENABLED=0 GOOS=darwin GOARCH=arm64 go build -v -o kbot -ldflags "-X="github.com/den-vasyliev/kbot/cmd.appVersion=${VERSION}

build-windows-amd64: format get
	CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build -v -o kbot.exe -ldflags "-X="github.com/den-vasyliev/kbot/cmd.appVersion=${VERSION}
build-windows-arm64: format get
	CGO_ENABLED=0 GOOS=windows GOARCH=arm64 go build -v -o kbot.exe -ldflags "-X="github.com/den-vasyliev/kbot/cmd.appVersion=${VERSION}

build-linux-amd64: format get
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -v -o kbot -ldflags "-X="github.com/den-vasyliev/kbot/cmd.appVersion=${VERSION}
build-linux-arm64: format get
	CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -v -o kbot -ldflags "-X="github.com/den-vasyliev/kbot/cmd.appVersion=${VERSION}


image:
	docker build --build-arg TARGETOS=${TARGETOS} --build-arg TARGETARCH=${TARGETARCH} . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

clean:
	rm -rf kbot kbot.exe
	docker rmi ${IMAGE_TAG}