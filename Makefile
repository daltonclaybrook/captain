SWIFT_BUILD_FLAGS=--configuration release
CAPTAIN_EXECUTABLE=$(shell swift build $(SWIFT_BUILD_FLAGS) --show-bin-path)/captain

FRAMEWORKS_FOLDER=/Library/Frameworks
BINARIES_FOLDER=/usr/local/bin

CAPTAIN_PLIST=Sources/captain/Supporting Files/Info.plist
VERSION_STRING=$(shell /usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" "$(CAPTAIN_PLIST)")

all: build

bootstrap:
	git submodule update --init --recursive

clean:
	swift package clean

build:
	swift build $(SWIFT_BUILD_FLAGS)

install: build
	install -d "$(BINARIES_FOLDER)"
	install "$(CAPTAIN_EXECUTABLE)" "$(BINARIES_FOLDER)"

uninstall:
	rm -rf "$(FRAMEWORKS_FOLDER)/CaptainKit.framework"
	rm -f "$(BINARIES_FOLDER)/captain"

get_version:
	@echo $(VERSION_STRING)
