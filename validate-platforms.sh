#!/bin/bash

# Multi-Platform Build Validation Script
# Tests compilation across all supported Apple platforms to ensure cross-platform compatibility

set -e

echo "🚀 Starting Multi-Platform Build Validation"
echo "=========================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Track results
PASSED_BUILDS=()
FAILED_BUILDS=()

# Function to log with colors
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
    PASSED_BUILDS+=("$1")
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
    FAILED_BUILDS+=("$1")
}

# Function to build for a specific platform
build_platform() {
    local scheme="$1"
    local destination="$2"
    local platform_name="$3"
    
    log_info "Building $scheme for $platform_name..."
    
    if xcodebuild -scheme "$scheme" -destination "$destination" build > /dev/null 2>&1; then
        log_success "$scheme ($platform_name)"
    else
        log_error "$scheme ($platform_name) - Build failed"
        return 1
    fi
}

# Generate Xcode project first
log_info "Generating Xcode project with XcodeGen..."
if command -v xcodegen >/dev/null 2>&1; then
    xcodegen generate
    log_success "Project generated successfully"
else
    log_error "XcodeGen not found. Please install: brew install xcodegen"
    exit 1
fi

echo ""
log_info "Testing Core Swift Package compilation across platforms..."

# Test Swift Package compilation for different platforms
SWIFT_PACKAGE_PLATFORMS=(
    "iOS;-destination 'platform=iOS Simulator,name=iPhone 16'"
    "macOS;-destination 'platform=macOS'"
    "watchOS;-destination 'platform=watchOS Simulator,name=Apple Watch SE (40mm) (2nd generation)'"
    "tvOS;-destination 'platform=tvOS Simulator,name=Apple TV'"
    "visionOS;-destination 'platform=visionOS Simulator,name=Apple Vision Pro'"
)

for platform_config in "${SWIFT_PACKAGE_PLATFORMS[@]}"; do
    IFS=';' read -r platform_name destination <<< "$platform_config"
    
    log_info "Testing Swift Package for $platform_name..."
    
    # Use xcodebuild instead of swift build for platform testing
    if xcodebuild -scheme YourProjectPackage $destination build > /dev/null 2>&1; then
        log_success "Swift Package ($platform_name)"
    else
        log_error "Swift Package ($platform_name) - Build failed"
    fi
done

echo ""
log_info "Testing main app targets..."

# Test main iOS app
build_platform "YourProjectName" "platform=iOS Simulator,name=iPhone 16" "iOS"

# Test watchOS app  
build_platform "WatchApp" "platform=watchOS Simulator,name=Apple Watch SE (40mm) (2nd generation)" "watchOS"

echo ""
log_info "Testing app extensions..."

# Test extensions that support multiple platforms
EXTENSION_CONFIGS=(
    "ActionExtension;platform=iOS Simulator,name=iPhone 16;iOS"
    "ActionExtension;platform=macOS;macOS"
    "ShareExtension;platform=iOS Simulator,name=iPhone 16;iOS"
    "ShareExtension;platform=macOS;macOS"
    "NotificationExtension;platform=iOS Simulator,name=iPhone 16;iOS"
    "NotificationExtension;platform=macOS;macOS"
    "WidgetExtension;platform=iOS Simulator,name=iPhone 16;iOS"
    "WidgetExtension;platform=macOS;macOS"
)

for config in "${EXTENSION_CONFIGS[@]}"; do
    IFS=';' read -r scheme destination platform <<< "$config"
    build_platform "$scheme" "$destination" "$platform"
done

# Test iOS-only extensions
build_platform "MessageExtension" "platform=iOS Simulator,name=iPhone 16" "iOS (Messages)"
build_platform "AppClips" "platform=iOS Simulator,name=iPhone 16" "iOS (App Clips)"

echo ""
echo "=========================================="
log_info "Build Validation Summary"
echo "=========================================="

if [ ${#PASSED_BUILDS[@]} -gt 0 ]; then
    echo -e "${GREEN}✅ Passed Builds (${#PASSED_BUILDS[@]}):${NC}"
    for build in "${PASSED_BUILDS[@]}"; do
        echo "   • $build"
    done
fi

if [ ${#FAILED_BUILDS[@]} -gt 0 ]; then
    echo ""
    echo -e "${RED}❌ Failed Builds (${#FAILED_BUILDS[@]}):${NC}"
    for build in "${FAILED_BUILDS[@]}"; do
        echo "   • $build"
    done
    echo ""
    log_error "Some builds failed. Please check platform-specific code and dependencies."
    exit 1
else
    echo ""
    log_success "All builds passed! 🎉"
    log_info "Your code is compatible across all supported Apple platforms."
fi

echo ""
log_info "Validation complete. Total builds tested: $((${#PASSED_BUILDS[@]} + ${#FAILED_BUILDS[@]}))"