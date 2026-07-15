#include <stdio.h>
#include <stdbool.h>
#include <IOKit/IOKitLib.h>
#include <IOKit/hidsystem/IOHIDLib.h>
#include <IOKit/hidsystem/IOHIDParameter.h>
#include <CoreGraphics/CoreGraphics.h>

int main() {
    kern_return_t kr;
    io_connect_t ioc = 0;
    
    // Connect to macOS HID system (using 0 to remain compatible across all macOS versions)
    io_service_t ios = IOServiceGetMatchingService(0, IOServiceMatching(kIOHIDSystemClass));
    if (!ios) {
        fprintf(stderr, "Failed to get HID service.\n");
        return 1;
    }
    
    kr = IOServiceOpen(ios, mach_task_self(), kIOHIDParamConnectType, &ioc);
    IOObjectRelease(ios);
    if (kr != KERN_SUCCESS) {
        fprintf(stderr, "Failed to open HID service: %x\n", kr);
        return (int) kr;
    }
    
    // Query the REAL current state of Caps Lock using CoreGraphics
    // This successfully bypasses the buggy IOHIDGetModifierLockState API
    CGEventFlags flags = CGEventSourceFlagsState(kCGEventSourceStateCombinedSessionState);
    bool isCapsOn = (flags & kCGEventFlagMaskAlphaShift) != 0;
    
    // Toggle state to the exact opposite of the actual current state
    bool newState = !isCapsOn;
    kr = IOHIDSetModifierLockState(ioc, kIOHIDCapsLockState, newState);
    if (kr != KERN_SUCCESS) {
        IOServiceClose(ioc);
        fprintf(stderr, "Failed to set Caps Lock state: %x\n", kr);
        return (int) kr;
    }
    
    IOServiceClose(ioc);
    return 0;
}
