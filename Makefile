export THEOS_DEVICE_IP=192.168.1.149
ARCHS = armv7 arm64

TARGET =: clang

include theos/makefiles/common.mk

TWEAK_NAME = SpotDefine
SpotDefine_FILES = Tweak.xm
SpotDefine_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/mine.mk

after-install::
	install.exec "killall -9 SpringBoard"
