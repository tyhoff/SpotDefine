export ARCHS = armv7 arm64

include theos/makefiles/common.mk

TARGET =: clang

BUNDLE_NAME = SpotDefineSearch
SpotDefineSearch_FILES = Dictionary.m
SpotDefineSearch_INSTALL_PATH = /Library/SearchLoader/SearchBundles
SpotDefineSearch_BUNDLE_EXTENSION = searchBundle
SpotDefineSearch_LDFLAGS = -lspotlight -fobjc-arc
SpotDefineSearch_FRAMEWORKS = UIKit
SpotDefineSearch_PRIVATE_FRAMEWORKS = Search

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	mkdir -p $(THEOS_STAGING_DIR)/Library/SearchLoader/Applications
	cp -r InfoBundle/ $(THEOS_STAGING_DIR)/Library/SearchLoader/Applications/Dictionary.bundle

	mkdir -p $(THEOS_STAGING_DIR)/Library/SearchLoader/Preferences
	cp Dictionary.plist $(THEOS_STAGING_DIR)/Library/SearchLoader/Preferences/SpotDefineSearch.plist

after-install::
	install.exec "killall -9 backboardd searchd AppIndexer &>/dev/null"
