DOTNET_VERSION ?= 48
WINE_BRANCH ?= staging

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


# arg #1: image tags
# arg #2: build args
# arg #3: build context
# arg #4: image prefix (optional)
define _build_internal
	docker build \
		$(addprefix -t $(if $(4), $(4), $(_IMAGE_PREFIX)):, $(1)) \
		$(addprefix --build-arg , $(2)) \
		$(3)
endef

# shiftinv/wine : (<wine_branch>)?
build:
	$(call _build_internal, \
		latest $(WINE_BRANCH), \
		WINE_BRANCH=$(WINE_BRANCH), \
		.)

# shiftinv/wine : (<wine_branch>-)?vnc
build-vnc: build
	$(call _build_internal, \
		vnc $(WINE_BRANCH)-vnc, \
		BASE_IMAGE=$(_IMAGE_PREFIX):$(WINE_BRANCH), \
		./vnc)

# shiftinv/wine-dotnet : ((<wine_branch>-)?<dotnet_version>)?
build-dotnet: build
	$(call _build_internal, \
		latest $(DOTNET_VERSION) $(WINE_BRANCH)-$(DOTNET_VERSION), \
		DOTNET_VERSION=$(DOTNET_VERSION) BASE_TAG=$(WINE_BRANCH), \
		./dotnet, \
		$(_IMAGE_PREFIX)-dotnet)

# shiftinv/wine-dotnet : ((<wine_branch>-)?<dotnet_version>-)?vnc
build-dotnet-vnc: build-dotnet
	$(call _build_internal, \
		vnc $(DOTNET_VERSION)-vnc $(WINE_BRANCH)-$(DOTNET_VERSION)-vnc, \
		BASE_IMAGE=$(_IMAGE_PREFIX)-dotnet:$(WINE_BRANCH)-$(DOTNET_VERSION), \
		./vnc, \
		$(_IMAGE_PREFIX)-dotnet)

.PHONY: all build build-vnc build-dotnet build-dotnet-vnc
