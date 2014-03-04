//
//  LCLegendView.m
//  ios-linechart
//
//  Created by Marcel Ruegenberg on 02.08.13.
//  Copyright (c) 2013 Marcel Ruegenberg. All rights reserved.
//

#import "LCLegendView.h"
#import "UIKit+DrawingHelpers.h"
#import <CoreGraphics/CoreGraphics.h>

@implementation LCLegendView
@synthesize titlesFont=_titlesFont;

#define COLORPADDING 15
#define PADDING 5

- (void)drawRect:(CGRect)rect {
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(c, [[UIColor colorWithWhite:0.0 alpha:0.5] CGColor]);
    CGContextFillRoundedRect(c, self.bounds, 4);
    
    
    CGFloat y = 0;
    for(NSString *title in self.titles) {
        UIColor *color = [self.colors objectForKey:title];
        if(color) {
            [color setFill];
            CGContextFillEllipseInRect(c, CGRectMake(PADDING + 2, PADDING + round(y) + self.titlesFont.xHeight / 2 , 8, 8));
        }
        // TODO: replace with new text APIs in iOS 7 only version
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [[UIColor whiteColor] set];
        [title drawAtPoint:CGPointMake(COLORPADDING + PADDING, y + PADDING) withFont:self.titlesFont];
#pragma clang diagnostic pop
        y += [self.titlesFont lineHeight];
    }
}

- (UIFont *)titlesFont {
    if(_titlesFont == nil)
        _titlesFont = [UIFont fontWithName:@"TrebuchetMS-Bold" size:11];
    return _titlesFont;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat h = [self.titlesFont lineHeight] * [self.titles count];
    CGFloat w = 0;
    for(NSString *title in self.titles) {
        // TODO: replace with new text APIs in iOS 7 only version
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CGSize s = [title sizeWithFont:self.titlesFont];
#pragma clang diagnostic pop
        w = MAX(w, s.width);
    }
    return CGSizeMake(COLORPADDING + w + 2 * PADDING, h + 2 * PADDING);
}

@end
