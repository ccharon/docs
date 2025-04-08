# Schnipsel

## switch to cga and back in c++

```cpp
#include <dos.h>

void set_video_mode(unsigned char mode) {
    union REGS regs;
    regs.h.ah = 0x00;  // BIOS function to set video mode
    regs.h.al = mode;  // Video mode
    int86(0x10, &regs, &regs);
}

unsigned char get_video_mode() {
    union REGS regs;
    regs.h.ah = 0x0F;  // BIOS function to get current video mode
    int86(0x10, &regs, &regs);
    return regs.h.al;  // Return current video mode
}

int main() {
    unsigned char initial_mode = get_video_mode();  // Save initial video mode

    set_video_mode(0x04);  // Set CGA 320x200 4 color mode

    // Do something

    set_video_mode(initial_mode);  // Restore initial video mode

    return 0;
}
```
