SUBPROJECTS = SearchLoader SpotDefinePrefs

TARGET =: clang

# 32bit and 64bit, but only advised if keeping 7.0+ compatibility
export ARCHS = armv7 arm64


include theos/makefiles/common.mk
include $(THEOS_MAKE_PATH)/aggregate.mk

TWEAK_NAME = SpotDefine
SpotDefine_FILES = Tweak.xm
SpotDefine_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard backboardd searchd AppIndexer &>/dev/null"
