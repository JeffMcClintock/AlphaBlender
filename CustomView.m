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
    
    // erase the background
    [[NSColor colorWithCalibratedRed:0.1 green:0.2 blue:0.3 alpha:1.0] set];
    [NSBezierPath fillRect:dirtyRect];
    
    [[NSColor whiteColor] set];
    [NSBezierPath fillRect:NSMakeRect(0, 20, 300, 60)];
    
    [[NSColor blackColor] set];
    [NSBezierPath fillRect:NSMakeRect(60, 20, 60, 60)];
    [NSBezierPath fillRect:NSMakeRect(180, 20, 60, 60)];

    // checkerboard
    bool fill = false;
    for(double x = 0 ; x < 60 ; x += 1.0)
    {
        for(double y = 0 ; y < 60 ; y += 1.0)
        {
            if(fill)
            {
                [NSBezierPath fillRect:NSMakeRect(120 + x, 20 + y, 1, 1)];
            }
            
            fill = !fill;
        }
        fill = !fill;
    }
    
    // 50% white over 100% black
    [[NSColor colorWithCalibratedRed:1.0 green:1.0 blue:1.0 alpha:0.5] set];
    [NSBezierPath fillRect:NSMakeRect(180, 20, 60, 60)];

    // 50% black over 100% white
    [[NSColor colorWithCalibratedRed:0.0 green:0.0 blue:0.0 alpha:0.5] set];
    [NSBezierPath fillRect:NSMakeRect(240, 20, 60, 60)];

}

@end
