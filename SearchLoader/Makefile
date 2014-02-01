export ARCHS = armv7 arm64

include theos/makefiles/common.mk

TARGET =: clang

BUNDLE_NAME = DictionarySearch
DictionarySearch_FILES = Dictionary.m
DictionarySearch_INSTALL_PATH = /Library/SearchLoader/SearchBundles
DictionarySearch_BUNDLE_EXTENSION = searchBundle
DictionarySearch_LDFLAGS = -lspotlight -fobjc-arc
DictionarySearch_FRAMEWORKS = UIKit
DictionarySearch_PRIVATE_FRAMEWORKS = Search

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	mkdir -p $(THEOS_STAGING_DIR)/Library/SearchLoader/Applications
	cp -r InfoBundle/ $(THEOS_STAGING_DIR)/Library/SearchLoader/Applications/Dictionary.bundle

after-install::
	install.exec "killall -9 backboardd searchd AppIndexer &>/dev/null"
