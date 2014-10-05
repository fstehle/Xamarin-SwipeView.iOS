BTOUCH=/Developer/MonoTouch/usr/bin/btouch
SMCS=/Developer/MonoTouch/usr/bin/smcs
MONOXBUILD=/Library/Frameworks/Mono.framework/Commands/xbuild
XBUILD=/Applications/Xcode.app/Contents/Developer/usr/bin/xcodebuild

PROJECT_NAME=SwipeView

PROJECT_ROOT=$(PROJECT_NAME)
PROJECT=$(PROJECT_ROOT)/$(PROJECT_NAME).csproj
LIB_NAME=$(PROJECT_ROOT)/lib$(PROJECT_NAME).a
LIB_NAME_I386=$(PROJECT_ROOT)/lib$(PROJECT_NAME)-i386.a
LIB_NAME_ARMV7=$(PROJECT_ROOT)/lib$(PROJECT_NAME)-armv7.a
LIB_NAME_ARMV7S=$(PROJECT_ROOT)/lib$(PROJECT_NAME)-armv7s.a
DLL_NAME=$(PROJECT_NAME).dll

POD_NAME=$(PROJECT_NAME)
PODS_PROJECT_ROOT=$(PROJECT_ROOT)/Pods
PODS_PROJECT=$(PODS_PROJECT_ROOT)/Pods.xcodeproj
PODS_TARGET=Pods-$(POD_NAME)

all: $(DLL_NAME)
	
package: $(DLL_NAME)
	nuget pack Package.nuspec

$(PODS_PROJECT):
	cd $(PROJECT_ROOT) && pod install --no-integrate

$(LIB_NAME_I386): $(PODS_PROJECT)
	$(XBUILD) -project $(PODS_PROJECT) -target $(PODS_TARGET) -sdk iphonesimulator -configuration Release clean build
	-mv $(PODS_PROJECT_ROOT)/build/Release-iphonesimulator/lib$(PODS_TARGET).a $@

$(LIB_NAME_ARMV7): $(PODS_PROJECT)
	$(XBUILD) -project $(PODS_PROJECT) -target $(PODS_TARGET) -sdk iphoneos -arch armv7 -configuration Release clean build
	-mv $(PODS_PROJECT_ROOT)/build/Release-iphoneos/lib$(PODS_TARGET).a $@
	
$(LIB_NAME_ARMV7S): $(PODS_PROJECT)
	$(XBUILD) -project $(PODS_PROJECT) -target $(PODS_TARGET) -sdk iphoneos -arch armv7s -configuration Release clean build
	-mv $(PODS_PROJECT_ROOT)/build/Release-iphoneos/lib$(PODS_TARGET).a $@

$(LIB_NAME): $(LIB_NAME_I386) $(LIB_NAME_ARMV7) $(LIB_NAME_ARMV7S)
	lipo -create -output $@ $^

$(DLL_NAME): $(LIB_NAME)
	$(MONOXBUILD) /p:Configuration=Release $(PROJECT)
	cp $(PROJECT_ROOT)/bin/Release/$(DLL_NAME) $(DLL_NAME)

clean:
	-cd $(PROJECT_ROOT) && rm -rf bin obj *.a *.dll
	cd $(PROJECT_ROOT) && rm -rf Pods
	rm -rf *.dll *.nupkg