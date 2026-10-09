ARCHS = arm64 arm64e
TARGET = iphone:clang:16.4:16.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = HomeBarURL
HomeBarURL_FILES = Tweak.xm
HomeBarURL_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk
