# Определяем переменные
GITLEAKS_DOWNLOAD_DIR := $(HOME)/bin/gitleaks-dir
TARGETOS := $(shell uname -s | tr '[:upper:]' '[:lower:]')
TARGETARCH := $(shell uname -m)

ifeq ($(TARGETARCH), x86_64)
    TARGETARCH := "x64"
endif

URL := $(shell curl -sSfL https://api.github.com/repos/zricethezav/gitleaks/releases/latest | grep browser_download_url | cut -d '"' -f 4 | grep ${TARGETOS}"_"${TARGETARCH})

GIT_SUPPORT_PATH := $(HOME)/.git-dir
HOOKS := $(GIT_SUPPORT_PATH)/hooks
PRECOMMIT := $(GIT_SUPPORT_PATH)/hooks/pre-commit
PATTERNS := $(GIT_SUPPORT_PATH)/gitleaks.toml
GITLEAKS := $(HOME)/bin/gitleaks

INSTALL_TARGETS := $(PATTERNS) $(PRECOMMIT) $(GITLEAKS)

# Определяем цели
.PHONY: all install clean global_hooks version detect

all: install

install: $(INSTALL_TARGETS) global_hooks version

clean:
	$(RM) -r $(GIT_SUPPORT_PATH)
	git config --global --unset hooks.gitleaks
	git config --global --unset core.hooksPath
	$(RM) -r $(GITLEAKS)

global_hooks:
	git config --global hooks.gitleaks true
	git config --global core.hooksPath $(GIT_SUPPORT_PATH)/hooks

version:
	@if [ -x "$$(command -v $(GITLEAKS))" ]; then \
		echo "Gitleaks version $$( $(GITLEAKS) version ) OS=$(TARGETOS) ARCH=$(TARGETARCH)"; \
	else \
		echo "Gitleaks not installed"; \
	fi

detect:
	$(GITLEAKS) detect -v

$(PATTERNS): | $(GIT_SUPPORT_PATH)
	curl -sSfL -o $@ https://raw.githubusercontent.com/zricethezav/gitleaks/master/config/gitleaks.toml

$(PRECOMMIT): pre-commit.sh | $(HOOKS)
	install -m 0755 -cv $< $@

$(GIT_SUPPORT_PATH) $(HOOKS):
	mkdir -p $@

$(GITLEAKS): | $(GITLEAKS_DOWNLOAD_DIR)
	curl -sSfL $(URL) | tar -xzf - -C $(GITLEAKS_DOWNLOAD_DIR)
	cp $(GITLEAKS_DOWNLOAD_DIR)/gitleaks $(GITLEAKS)
	$(RM) -r $(GITLEAKS_DOWNLOAD_DIR)
	chmod 755 $@
	@echo "Gitleaks installed to $(GITLEAKS)"

$(GITLEAKS_DOWNLOAD_DIR):
	mkdir -p $@