
BUILDDIR?=$(PWD)/build
TESTDIR?=$(PWD)/testout

VERSION=1.2.1

TESTDIR=$(PWD)/testout


TARGET_NAMES=$(shell ls cmd)

MOCK_NAMES=\
  check

TARGETS = $(addprefix $(BUILDDIR)/,$(TARGET_NAMES))


clean: build-clean config-clean


build-clean:
	$(info Cleaning build)
	-@rm -rf $(BUILDDIR)/* mocks mockgen
	-@rm -rf $(TESTDIR)


config-clean:
	$(info Cleaning config)
	-@rm -rf deploys
	-@rm -rf testrenders


build: $(TARGETS)

define GOFILES_t
$(BUILDDIR)/$(1): $(shell find cmd/$(1) -type f)
endef
$(foreach prog,$(TARGET_NAMES),$(eval $(call GOFILES_t,$(prog))))


$(TARGETS): $(BUILDDIR)/% : cmd/%/main.go
	CGO_ENABLED=0 go build -a -installsuffix cgo -ldflags "-X 'github.com/bengreen/doozer/config.Version=$(VERSION)' -extldflags '-static'" -o $@ cmd/$*/*.go
