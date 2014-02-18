ARCHS = armv7 armv7s arm64

include theos/makefiles/common.mk

BUNDLE_NAME = SpotDefinePrefs
SpotDefinePrefs_CFLAGS = -fobjc-arc
SpotDefinePrefs_FILES = SpotDefinePrefsListController.m
SpotDefinePrefs_INSTALL_PATH = /Library/PreferenceBundles
SpotDefinePrefs_FRAMEWORKS = Foundation UIKit
SpotDefinePrefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/SpotDefinePrefs.plist$(ECHO_END)
