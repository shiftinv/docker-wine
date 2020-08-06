DOTNET_VERSION = 48

all: build build-dotnet

build:
	docker build -t shiftinv/wine-vnc:latest .

build-dotnet: build
	docker build \
	-f Dockerfile.dotnet \
	-t shiftinv/wine-vnc:dotnet \
	-t shiftinv/wine-vnc:dotnet-$(DOTNET_VERSION) \
	--build-arg DOTNET_VERSION=$(DOTNET_VERSION) \
	.

.PHONY: all build build-dotnet
