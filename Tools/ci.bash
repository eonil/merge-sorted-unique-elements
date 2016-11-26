export MODULE="EonilMergeSortedUniqueElements"
export TOOL="xcodebuild"
export PROJ="$MODULE.xcodeproj"
xcrun swiftc --version
#$TOOL -project      $PROJ -scheme $MODULE -sdk iphonesimulator ONLY_ACTIVE_ARCH=NO
#$TOOL test -project $PROJ -scheme $MODULE -sdk iphonesimulator ONLY_ACTIVE_ARCH=NO
$TOOL -project      $PROJ -scheme $MODULE -sdk macosx ONLY_ACTIVE_ARCH=NO
$TOOL test -project $PROJ -scheme $MODULE -sdk macosx ONLY_ACTIVE_ARCH=NO
swift build
swift test
