//
//  CustomView.h
//  AlphaBlender
//
//  Created by Jeff McClintock on 11/10/23.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomView : NSView<CALayerDelegate>
- (void)drawRect:(NSRect)dirtyRect;
@end

NS_ASSUME_NONNULL_END
