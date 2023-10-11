//
//  CustomView.m
//  AlphaBlender
//
//  Created by Jeff McClintock on 11/10/23.
//

#import "CustomView.h"

@implementation CustomView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
//    NSImage* image = [[NSImage alloc] initWithSize:NSMakeSize(800, 400)];
    
    NSBitmapImageRep* imagerep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL
       pixelsWide:800
       pixelsHigh:400
       bitsPerSample:16 //8     // 1, 2, 4, 8, 12, or 16.
       samplesPerPixel:3
       hasAlpha:NO
       isPlanar:NO
       colorSpaceName:NSCalibratedRGBColorSpace
       bitmapFormat:0 //NSFloatingPointSamplesBitmapFormat //NSAlphaFirstBitmapFormat
       bytesPerRow:0    // 0 = don't care  800 * 4
       bitsPerPixel:64 ];
 
    
    /* valid
      8, 3, 0 , 32
     16, 3, 0 , 64
     16, 3, NSFloatingPointSamplesBitmapFormat, 64
     */
    
//    [imagerep lockFocus];
    NSGraphicsContext *g = [NSGraphicsContext graphicsContextWithBitmapImageRep:imagerep];
    [NSGraphicsContext saveGraphicsState];
    [NSGraphicsContext setCurrentContext:g];
    
    // erase the background
    [[NSColor colorWithCalibratedRed:0.1 green:0.2 blue:0.3 alpha:1.0] set];
    [NSBezierPath fillRect:dirtyRect];
    
    [[NSColor whiteColor] set];
    [NSBezierPath fillRect:NSMakeRect(-60, 20, 360, 60)];
    
    [[NSColor blackColor] set];
    [NSBezierPath fillRect:NSMakeRect(0, 20, 60, 60)];

    [NSBezierPath fillRect:NSMakeRect(180, 20, 60, 60)];

    // checkerboard
    bool fill = false;
    for(double x = 0 ; x < 60 ; x += 1.0)
    {
        for(double y = 0 ; y < 60 ; y += 1.0)
        {
            if(fill)
            {
                [NSBezierPath fillRect:NSMakeRect(60 + x, 20 + y, 1, 1)];
            }
            
            fill = !fill;
        }
        fill = !fill;
    }

    // 50% gray
    [[NSColor colorWithCalibratedRed:0.5 green:0.5 blue:0.5 alpha:1.0] set];
    [NSBezierPath fillRect:NSMakeRect(120, 20, 60, 60)];

    // 50% white over 100% black
    [[NSColor colorWithCalibratedRed:1.0 green:1.0 blue:1.0 alpha:0.5] set];
    [NSBezierPath fillRect:NSMakeRect(180, 20, 60, 60)];

    // 50% black over 100% white
    [[NSColor colorWithCalibratedRed:0.0 green:0.0 blue:0.0 alpha:0.5] set];
    [NSBezierPath fillRect:NSMakeRect(240, 20, 60, 60)];
    
    [NSGraphicsContext restoreGraphicsState];
    
//    [image unlockFocus];
 //   [image drawAtPoint:NSMakePoint(0, 0) fromRect:NSMakeRect(0, 0, 400, 800) operation:NSCompositingOperationCopy fraction:1.0 ];
    
    [imagerep drawAtPoint:NSMakePoint(0, 0)];
}

@end
