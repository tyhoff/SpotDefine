export THEOS_DEVICE_IP=192.168.1.149
ARCHS = armv7 arm64

include theos/makefiles/common.mk

TWEAK_NAME = spotdefine
spotdefine_FILES = Tweak.xm
spotdefine_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
