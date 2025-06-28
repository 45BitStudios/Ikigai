#!/bin/bash

#  ci_post_clone.sh
#  Ikigai
#
#  Xcode Cloud CI Post-Clone Script
#  This script runs after Xcode Cloud clones the repository
#  Use it for setup tasks, dependency installation, and project generation
#
#  Created by Claude Code on 1/29/25.
#

set -e  # Exit on any error
set -u  # Exit on undefined variables

echo "🚀 Starting Xcode Cloud post-clone setup for Ikigai..."

# MARK: - Environment Information

echo "📋 Environment Information:"
echo "  - Xcode Cloud Build: $CI_XCODE_CLOUD"
echo "  - Working Directory: $(pwd)"
echo "  - Xcode Version: $(xcodebuild -version | head -n 1)"
echo "  - Swift Version: $(swift --version | head -n 1)"
echo "  - macOS Version: $(sw_vers -productVersion)"

# MARK: - Homebrew Installation and Dependencies

echo "🍺 Setting up Homebrew and dependencies..."

# Check if Homebrew is installed, install if not
if ! command -v brew &> /dev/null; then
    echo "  Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ $(uname -m) == "arm64" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zshrc
        eval "$(/usr/local/bin/brew shellenv)"
    fi
else
    echo "  Homebrew already installed"
    brew update
fi

# Install XcodeGen if not present
if ! command -v xcodegen &> /dev/null; then
    echo "  Installing XcodeGen..."
    brew install xcodegen
else
    echo "  XcodeGen already installed: $(xcodegen --version)"
fi

# Install SwiftFormat for code formatting (optional)
if ! command -v swiftformat &> /dev/null; then
    echo "  Installing SwiftFormat..."
    brew install swiftformat
else
    echo "  SwiftFormat already installed: $(swiftformat --version)"
fi

# Install SwiftLint for code linting (optional)
if ! command -v swiftlint &> /dev/null; then
    echo "  Installing SwiftLint..."
    brew install swiftlint
else
    echo "  SwiftLint already installed: $(swiftlint version)"
fi

# MARK: - Project Generation

echo "🏗️  Generating Xcode project with XcodeGen..."

# Verify project.yml exists
if [[ ! -f "project.yml" ]]; then
    echo "❌ Error: project.yml not found in repository root"
    exit 1
fi

# Generate the Xcode project
xcodegen generate

# Verify the project was generated
if [[ ! -f "Ikigai.xcodeproj/project.pbxproj" ]]; then
    echo "❌ Error: Failed to generate Ikigai.xcodeproj"
    exit 1
fi

echo "  ✅ Successfully generated Ikigai.xcodeproj"

# MARK: - Swift Package Resolution

echo "📦 Resolving Swift Package dependencies..."

# Resolve Swift Package Manager dependencies
xcodebuild -resolvePackageDependencies -project Ikigai.xcodeproj -scheme IkigaiApp

echo "  ✅ Package dependencies resolved"

# MARK: - Code Quality Checks (Optional)

echo "🔍 Running code quality checks..."

# Run SwiftLint if available and .swiftlint.yml exists
if command -v swiftlint &> /dev/null && [[ -f ".swiftlint.yml" ]]; then
    echo "  Running SwiftLint..."
    swiftlint --strict
    echo "  ✅ SwiftLint passed"
else
    echo "  ⚠️  SwiftLint not configured or not available"
fi

# Run SwiftFormat check if available and .swiftformat exists
if command -v swiftformat &> /dev/null && [[ -f ".swiftformat" ]]; then
    echo "  Checking SwiftFormat..."
    swiftformat --lint .
    echo "  ✅ SwiftFormat check passed"
else
    echo "  ⚠️  SwiftFormat not configured or not available"
fi

# MARK: - Build Validation

echo "🧪 Validating build configuration..."

# Perform a quick build check to ensure everything compiles
echo "  Testing iOS build..."
xcodebuild -project Ikigai.xcodeproj -scheme IkigaiApp -destination 'platform=iOS Simulator,name=iPhone 16' build -quiet

echo "  Testing watchOS build..."
xcodebuild -project Ikigai.xcodeproj -scheme WatchApp -destination 'platform=watchOS Simulator,name=Apple Watch Series 10 (46mm)' build -quiet

echo "  ✅ Build validation successful"

# MARK: - Environment Setup for Tests

echo "🧪 Setting up test environment..."

# Create any required test directories or files
mkdir -p TestResults
mkdir -p Coverage

# Set environment variables for testing if needed
export CI_BUILD=true
export IKIGAI_TEST_MODE=true

echo "  ✅ Test environment configured"

# MARK: - Custom Setup Scripts

echo "⚙️  Running custom setup scripts..."

# Run any additional custom setup scripts if they exist
if [[ -f "scripts/setup.sh" ]]; then
    echo "  Running custom setup script..."
    chmod +x scripts/setup.sh
    ./scripts/setup.sh
else
    echo "  No custom setup script found (scripts/setup.sh)"
fi

# Run platform-specific validation if script exists
if [[ -f "validate-platforms.sh" ]]; then
    echo "  Running platform validation..."
    chmod +x validate-platforms.sh
    ./validate-platforms.sh
else
    echo "  No platform validation script found"
fi

# MARK: - Completion

echo "✅ Xcode Cloud post-clone setup completed successfully!"
echo ""
echo "📊 Setup Summary:"
echo "  - Homebrew: ✅ Installed/Updated"
echo "  - XcodeGen: ✅ Installed and project generated"
echo "  - Package Dependencies: ✅ Resolved"
echo "  - Build Validation: ✅ iOS and watchOS builds successful"
echo "  - Code Quality: ✅ Linting and formatting checks completed"
echo "  - Test Environment: ✅ Configured"
echo ""
echo "🚀 Ready for Xcode Cloud build and test execution!"

# Exit successfully
exit 0