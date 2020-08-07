DOTNET_VERSION = 48
WINE_BRANCH = staging

_IMAGE_PREFIX = shiftinv/wine

# hierarchy:
#       base
#      /    \
#     /      \
#  dotnet     |
#     \      /
#      \    /
#       vnc
#
# names:
#   shiftinv/wine : (<wine_branch>-)?(-vnc)?
#   shiftinv/wine-dotnet : ((<wine_branch>-)?<dotnet_version>-)?(vnc)?


all: build build-vnc build-dotnet build-dotnet-vnc

define _build_internal
	docker build \
		$(addprefix -t $(_IMAGE_PREFIX):, $(_TAGS)) \
		$(addprefix --build-arg , $(_ARGS)) \
		$(_BUILD_CONTEXT)
endef

# shiftinv/wine : (<wine_branch>)?
build: _BUILD_CONTEXT = .
build: _DOCKERFILE = Dockerfile
build: _TAGS = latest $(WINE_BRANCH)
build: _ARGS = WINE_BRANCH=$(WINE_BRANCH)
build:
	$(call _build_internal)

# shiftinv/wine : (<wine_branch>-)?vnc
build-vnc: _BUILD_CONTEXT = vnc
build-vnc: _TAGS = vnc $(WINE_BRANCH)-vnc
build-vnc: _ARGS = BASE_IMAGE=$(_IMAGE_PREFIX):$(WINE_BRANCH)
build-vnc: build
	$(call _build_internal)

# shiftinv/wine-dotnet : ((<wine_branch>-)?<dotnet_version>)?
build-dotnet: _IMAGE_PREFIX := $(_IMAGE_PREFIX)-dotnet
build-dotnet: _BUILD_CONTEXT = dotnet
build-dotnet: _TAGS = latest $(DOTNET_VERSION) $(WINE_BRANCH)-$(DOTNET_VERSION)
build-dotnet: _ARGS = DOTNET_VERSION=$(DOTNET_VERSION) BASE_TAG=$(WINE_BRANCH)
build-dotnet: build
	$(call _build_internal)

# shiftinv/wine-dotnet : ((<wine_branch>-)?<dotnet_version>-)?vnc
build-dotnet-vnc: _IMAGE_PREFIX := $(_IMAGE_PREFIX)-dotnet
build-dotnet-vnc: _BUILD_CONTEXT = vnc
build-dotnet-vnc: _TAGS = vnc $(DOTNET_VERSION)-vnc $(WINE_BRANCH)-$(DOTNET_VERSION)-vnc
build-dotnet-vnc: _ARGS = BASE_IMAGE=$(_IMAGE_PREFIX):$(WINE_BRANCH)-$(DOTNET_VERSION)
build-dotnet-vnc: build-dotnet
	$(call _build_internal)

.PHONY: all build build-vnc build-dotnet build-dotnet-vnc
