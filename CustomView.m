//
//  CustomView.m
//  AlphaBlender
//
//  Created by Jeff McClintock on 11/10/23.
//

#import "CustomView.h"
#import <QuartzCore/CAMetalLayer.h>
//#import <NSViewBackingLayer.h>

@interface CustomLayer : CALayer

@end

@implementation CustomLayer

- (void)display {
    [super display];
    
 //   [self.delegate displayLayer:self];
    
    if (self.delegate && [self.delegate isKindOfClass:[NSView class]]) {
        NSView *view = (NSView *)self.delegate;
        [view setNeedsDisplay:YES];
    }
    
}

@end


@implementation CustomView

+ (Class)layerClass {
    return [CustomLayer class];
}

- (void)displayLayer:(CALayer *)layer {
    [self setNeedsDisplay:YES];
}

//-(BOOL) wantsLayer {
//    return YES;
//}
- (id)initWithFrame:(NSRect)frame
{
  self = [super initWithFrame:frame];

  if (self) {
    self.wantsLayer                = YES;
 //     [self setWa  .wantsUpdateLayer = TRUE;
 //   self.layerContentsRedrawPolicy = NSViewLayerContentsRedrawOnSetNeedsDisplay;
  }

  return self;
}

- (void)layout {
    [super layout];
    // Update the frame of the custom layer to match the view's bounds
    self.layer.frame = self.bounds;
}

/** If the wantsLayer property is set to YES, this method will be invoked to return a layer instance. */
//-(CALayer*) makeBackingLayer {
//    return [super makeBackingLayer];
    
//    CALayer* layer = [CALayer layer];
//    [layer setDelegate:self];
//    return layer;
//}

- (CALayer *)makeBackingLayer {
//    return [super makeBackingLayer];
#if 1
 //   CALayer* layer = [super makeBackingLayer];
    
    CALayer* layer = [[CustomLayer alloc] init]; //[CustomLayer layer];
    [layer setDelegate:self];
 
    // Set the layer frame
    layer.frame = self.bounds;
    
// ?   CGSize viewScale = [self convertSizeToBacking: CGSizeMake(2.0, 2.0)];
 //   layer.contentsScale = MIN(viewScale.width, viewScale.height);

 //   layer.contentsFormat = kCAContentsFormatRGBA16Float; // deep but not linear
    CGSize imageSize = CGSizeMake(self.bounds.size.width,self.bounds.size.height);
    
#if 0
    auto provider = CGDataProviderCreateWithData(NULL, pixels, width*height*8, NULL);
    
    CGImageRef cgImage = CGImageCreate(
        width,
        height,
        16,
        64,
        8 * width,
        CGColorSpaceCreateWithName(kCGColorSpaceLinearSRGB),
        kCGImageAlphaNone | kCGBitmapFloatComponents,
        provider, NULL, true,
        kCGRenderingIntentDefault
      );
    
    CFRelease(provider);
#else

    // https://developer.apple.com/library/archive/documentation/GraphicsImaging/Conceptual/drawingwithquartz2d/dq_context/dq_context.html#//apple_ref/doc/uid/TP30001066-CH203-BCIBHHBB
    // can be 16 bbpp int or 32 float
    int bpp = 16;
    uint32_t options = kCGImageAlphaNoneSkipLast;
    if(false)
    {
        bpp = 32;
        options = kCGBitmapFloatComponents|kCGImageAlphaNoneSkipLast;
    }

    CGContextRef context;
#if 0
     context = CGBitmapContextCreate(
         NULL,
         imageSize.width,
         imageSize.height,
        bpp,
         0,
         CGColorSpaceCreateWithName(kCGColorSpaceGenericRGBLinear),
        options // or kCGImageAlphaPremultipliedLast (for transparency)
         );
#endif
    // Set the number of components per pixel
    size_t numComponents = 4; // RGBA

    // Set the number of bytes per component
    size_t bytesPerComponent = 2; // 16 bits

    // Calculate the bytes per row
    size_t bytesPerRow = imageSize.width * numComponents * bytesPerComponent;

    // Allocate memory for the bitmap
    uint16_t *data = (uint16_t *)calloc(imageSize.width * imageSize.height * numComponents, bytesPerComponent);

    for(int i = 0 ; i < 2000; ++i)
        data[i] = rand();
    
    // Create the color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGBLinear); //CGColorSpaceCreateDeviceRGB();

    // Create the bitmap context with 16-bit per pixel values
    context = CGBitmapContextCreate(data, imageSize.width, imageSize.height, 16, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder16Host |kCGBitmapFloatComponents);

    
    
    if (context != NULL) {
        // Clear the context with a transparent color
//        CGContextClearRect(context, CGRectMake(0, 0, imageSize.width, imageSize.height));
        CGContextSetRGBFillColor (context, 1, 0 , 0, 1);
        CGContextFillRect (context, CGRectMake(10,10,50,50));
        
        // Create a CGImage from the context
        CGImageRef image = CGBitmapContextCreateImage(context);
        

        [layer setContents: (__bridge id) image];
        
        // Set the layer frame
        layer.frame = CGRectMake(0, 0, imageSize.width, imageSize.height);

        if (image != NULL) {
            // You now have a blank CGImage
            // You can use this image as needed
            
            // Don't forget to release the image when you're done with it
//            CFRelease(image);
        }
        // Release the context, as it's no longer needed
        CGContextRelease(context);
   }
#endif
    
#else
    CALayer* layer = [NSViewBackingLayer layer];
    layer.backgroundColor = [NSColor blueColor].CGColor;
[layer setDelegate:self];
 //   [layer setFrame:[self bounds]];
    
    [self needsDisplay];
#endif
    layer.backgroundColor = [NSColor blueColor].CGColor;
    layer.opaque = YES;
    
    
//    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(data);
    
    return layer;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
 
    // never called.
    // Your drawing code here
    CGContextRef ctx = NSGraphicsContext.currentContext.CGContext;
    // Perform drawing using Core Graphics
    CGContextSetRGBFillColor(ctx, 1.0, 1.0, 0.0, 1.0); // Red color
    CGContextFillRect(ctx, dirtyRect);
    
    return;
    
#if 0
//    NSImage* image = [[NSImage alloc] initWithSize:NSMakeSize(800, 400)];
    // metal support 16 bit floating point componenets well
#if 1
    NSBitmapImageRep* imagerep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL
       pixelsWide:800
       pixelsHigh:400
       bitsPerSample:16 //8     // 1, 2, 4, 8, 12, or 16.
       samplesPerPixel:3
       hasAlpha:NO
       isPlanar:NO
       colorSpaceName:NSCalibratedRGBColorSpace
       bitmapFormat: NSBitmapFormatFloatingPointSamples //NSAlphaFirstBitmapFormat
       bytesPerRow:0    // 0 = don't care  800 * 4
       bitsPerPixel:64 ];
#else
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
    
    /* valid
      8, 3, 0 , 32
     16, 3, 0 , 64
     16, 3, NSFloatingPointSamplesBitmapFormat, 64
     */
    
//    [imagerep lockFocus];
    NSGraphicsContext *g = [NSGraphicsContext graphicsContextWithBitmapImageRep:imagerep];
    [NSGraphicsContext saveGraphicsState];
    [NSGraphicsContext setCurrentContext:g];
#else
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
    
    // HDR?
    [[NSColor colorWithCalibratedRed:0.0 green:1.0 blue:0.0 alpha:1.0] set];
    [NSBezierPath fillRect:NSMakeRect(40, 40, 32, 32)];

    [[NSColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0] set];
    [NSBezierPath fillRect:NSMakeRect(40, 40, 16, 16)];

#endif
    
#if 0
    [NSGraphicsContext restoreGraphicsState];
    
//    [image unlockFocus];
 //   [image drawAtPoint:NSMakePoint(0, 0) fromRect:NSMakeRect(0, 0, 400, 800) operation:NSCompositingOperationCopy fraction:1.0 ];
    
    [imagerep drawAtPoint:NSMakePoint(0, 0)];
#endif
}

@end
