//
//  CustomView.m
//  AlphaBlender
//
//  Created by Jeff McClintock on 11/10/23.
//

#import "CustomView.h"
#import <QuartzCore/CAMetalLayer.h>

@implementation CustomView

- (id)initWithFrame:(NSRect)frame
{
  self = [super initWithFrame:frame];

  if (self) {
    self.wantsLayer = YES;
  }

  return self;
}

- (CALayer *)makeBackingLayer {
    CALayer* layer = [super makeBackingLayer];
    layer.contentsFormat = kCAContentsFormatRGBA16Float; // deep but not linear
    return layer;
}

- (void)drawRect:(NSRect)dirtyRect {
    NSSize logicalsize = self.frame.size;
    NSSize pysicalsize = [self convertRectToBacking:[self bounds]].size;
    
#if 0
#if 1
    // 16 bits per component
    NSBitmapImageRep* imagerep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL
       pixelsWide:pysicalsize.width
       pixelsHigh:pysicalsize.height
       bitsPerSample:16 //8     // 1, 2, 4, 8, 12, or 16.
       samplesPerPixel:3
       hasAlpha:NO
       isPlanar:NO
       colorSpaceName: NSCalibratedRGBColorSpace
       bitmapFormat: NSBitmapFormatFloatingPointSamples //NSAlphaFirstBitmapFormat
       bytesPerRow:0    // 0 = don't care  800 * 4
       bitsPerPixel:64 ];
#else
    // 10 bits per component
    NSBitmapImageRep* imagerep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL
       pixelsWide:800
       pixelsHigh:400
       bitsPerSample:10 //8     // 1, 2, 4, 8, 12, or 16.
       samplesPerPixel:3
       hasAlpha:NO
       isPlanar:NO
       colorSpaceName:NSCalibratedRGBColorSpace
       bitmapFormat: 0 //NSBitmapFormatFloatingPointSamples //NSAlphaFirstBitmapFormat
       bytesPerRow:0    // 0 = don't care  800 * 4
       bitsPerPixel:32 ];
#endif
    
#else
#if 0
    // Set the number of components per pixel
    size_t numComponents = 4; // RGBA

    // Set the number of bytes per component
    size_t bytesPerComponent = 2; // 16 bits

    // Calculate the bytes per row
    size_t bytesPerRow = logicalsize.width * numComponents * bytesPerComponent;

    // Allocate memory for the bitmap
    uint16_t *data = (uint16_t *)calloc(logicalsize.width * logicalsize.height * numComponents, bytesPerComponent);

    // Create the color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGBLinear);//kCGColorSpaceExtendedLinearDisplayP3);

    // Create the bitmap context with 16-bit per pixel values
    CGContextRef context = CGBitmapContextCreate(data, logicalsize.width, logicalsize.height, bytesPerComponent * 8, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder16Host |kCGBitmapFloatComponents);

    // Create a CGImageRef from the bitmap context
    CGImageRef cgImage = CGBitmapContextCreateImage(context);

    // Convert the CGImageRef to an NSBitmapImageRep
    NSBitmapImageRep *imagerep = [[NSBitmapImageRep alloc] initWithCGImage:cgImage];

//    [imagerep setColorSpaceName:    ];
    // Convert the CGColorSpaceRef to an NSColorSpace
    NSColorSpace *linearRGBColorSpace = [[NSColorSpace alloc] initWithCGColorSpace:colorSpace];
#endif
    // Create the color space
    // kCGColorSpaceGenericRGBLinear - middle gray is darker, blend seems correct.
    // kCGColorSpaceExtendedLinearSRGB, kCGColorSpaceLinearDisplayP3 - same
    // kCGColorSpaceGenericRGB - actually sRGB
    
    // kCGColorSpaceExtendedLinearSRGB might be best since float color values should match SE's linear RGB
    CGColorSpaceRef colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceExtendedLinearSRGB);
    
    NSColorSpace *linearRGBColorSpace = [[NSColorSpace alloc] initWithCGColorSpace:colorSpace];

    NSBitmapImageRep* imagerep1 = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL
       pixelsWide:pysicalsize.width
       pixelsHigh:pysicalsize.height
       bitsPerSample:16 //8     // 1, 2, 4, 8, 12, or 16.
       samplesPerPixel:3
       hasAlpha:NO
       isPlanar:NO
       colorSpaceName: NSCalibratedRGBColorSpace // makes no difference if we retag it later anyhow.
       bitmapFormat: NSBitmapFormatFloatingPointSamples //NSAlphaFirstBitmapFormat
       bytesPerRow:0    // 0 = don't care  800 * 4
       bitsPerPixel:64 ];
    
    NSBitmapImageRep* imagerep = [imagerep1 bitmapImageRepByRetaggingWithColorSpace:linearRGBColorSpace];
    
    // Release the resources
//    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
//    CGImageRelease(cgImage);
#endif
    
    [imagerep setSize: logicalsize]; // Communicates DPI
    
    /* valid
      8, 3, 0 , 32
     16, 3, 0 , 64
     16, 3, NSFloatingPointSamplesBitmapFormat, 64
     */
    
    [NSGraphicsContext saveGraphicsState];
    NSGraphicsContext *g = [NSGraphicsContext graphicsContextWithBitmapImageRep:imagerep];
    [NSGraphicsContext setCurrentContext:g];

    
    // erase the background
    [[NSColor colorWithCalibratedRed:0.1 green:0.2 blue:0.3 alpha:1.0] set];
    [NSBezierPath fillRect:dirtyRect];

    [[NSColor whiteColor] set];
    [NSBezierPath fillRect:NSMakeRect(-60, 20, 300, 60)];
    
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
    // colorWithCalibratedRed can't do extend-range
    // colorWithRed expects extended sRGB
    double midGrey = 0.737;
    [[NSColor colorWithRed:midGrey green:midGrey blue:midGrey alpha:1.0] set];
    [NSBezierPath fillRect:NSMakeRect(120, 20, 60, 60)];

    // 50% white over 100% black
    [[NSColor colorWithCalibratedRed:1.0 green:1.0 blue:1.0 alpha:0.5] set];
    [NSBezierPath fillRect:NSMakeRect(180, 20, 60, 60)];
   
    // HDR?
    [[NSColor colorWithCalibratedRed:0.0 green:1.0 blue:0.0 alpha:1.0] set];
    [NSBezierPath fillRect:NSMakeRect(40, 40, 32, 32)];

    [[NSColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0] set];
    [NSBezierPath fillRect:NSMakeRect(40, 40, 16, 16)];
    
    [NSGraphicsContext restoreGraphicsState];
    
//    [imagerep drawAtPoint:NSMakePoint(0, 0)];
    [imagerep drawInRect:[self bounds]]; // copes with DPI
}

@end
