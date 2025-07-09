bash
#!/bin/bash
# Install XcodeGen if it's not already installed
if ! command -v xcodegen &> /dev/null; then
    echo "XcodeGen not found. Installing..."
    brew install xcodegen
fi
ls .
# Change to the project directory
cd ..
# ALL STEPS AFTER CLONE PROJECT
# Generate the Xcode project using XcodeGen
echo "Generating Xcode project..."
xcodegen generate
echo "Check file on .xcodeproj"
ls *.xcodeproj

echo "Resolving package dependencies..."
xcodebuild -resolvePackageDependencies \
  -project Ikigai.xcodeproj \
  -scheme IkigaiApp \
  -destination 'generic/platform=iOS'

