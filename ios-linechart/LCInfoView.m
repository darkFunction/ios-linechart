//
//  LCInfoView.m
//  Classes
//
//  Created by Marcel Ruegenberg on 19.11.09.
//  Copyright 2009 Dustlab. All rights reserved.
//

#import "LCInfoView.h"
#import "UIKit+DrawingHelpers.h"

@interface LCInfoView ()
- (void)recalculateFrame;

@end


@implementation LCInfoView

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {		
        UIFont *fatFont = [UIFont fontWithName:@"TrebuchetMS-Bold" size:13.f];
        self.color = [UIColor darkGrayColor];
        self.infoLabel = [[UILabel alloc] init];
        self.infoLabel.font = fatFont;
        self.infoLabel.backgroundColor = [UIColor clearColor];
        self.infoLabel.textColor = [UIColor whiteColor];
        self.infoLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        self.infoLabel.shadowColor = [UIColor clearColor];
        self.infoLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.infoLabel];
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)init {
	if((self = [self initWithFrame:CGRectZero])) {
		;
	}
	return self;
}

#define TOP_BOTTOM_MARGIN 5
#define LEFT_RIGHT_MARGIN 15
#define SHADOWSIZE 3
#define SHADOWBLUR 5
#define HOOK_SIZE 8

void CGContextAddRoundedRectWithHookSimple(CGContextRef c, CGRect rect, CGFloat radius) {
	//eventRect must be relative to rect.
	CGFloat hookSize = HOOK_SIZE;
	CGContextAddArc(c, rect.origin.x + radius, rect.origin.y + radius, radius, M_PI, M_PI * 1.5, 0); //upper left corner
	CGContextAddArc(c, rect.origin.x + rect.size.width - radius, rect.origin.y + radius, radius, M_PI * 1.5, M_PI * 2, 0); //upper right corner
	CGContextAddArc(c, rect.origin.x + rect.size.width - radius, rect.origin.y + rect.size.height - radius, radius, M_PI * 2, M_PI * 0.5, 0);
    {
		CGContextAddLineToPoint(c, rect.origin.x + rect.size.width / 2 + hookSize, rect.origin.y + rect.size.height);
		CGContextAddLineToPoint(c, rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height + hookSize);
		CGContextAddLineToPoint(c, rect.origin.x + rect.size.width / 2 - hookSize, rect.origin.y + rect.size.height);
	}
	CGContextAddArc(c, rect.origin.x + radius, rect.origin.y + rect.size.height - radius, radius, M_PI * 0.5, M_PI, 0);
	CGContextAddLineToPoint(c, rect.origin.x, rect.origin.y + radius);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self sizeToFit];
    
    [self recalculateFrame];
    
    [self.infoLabel sizeToFit];
    self.infoLabel.frame = CGRectMake(self.bounds.origin.x + 7, self.bounds.origin.y + 3, self.infoLabel.frame.size.width, self.infoLabel.frame.size.height);
}

- (CGSize)sizeThatFits:(CGSize)size {
    // TODO: replace with new text APIs in iOS 7 only version
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    CGSize s = [self.infoLabel.text sizeWithFont:self.infoLabel.font];
#pragma clang diagnostic pop
    s.height += 20;
    s.width += 14;
    
    return s;
}

- (void)drawRect:(CGRect)rect {
	CGContextRef c = UIGraphicsGetCurrentContext();

	CGRect theRect = self.bounds;
	//passe x oder y Position sowie Hoehe oder Breite an, je nachdem, wo der Hook sitzt.
	theRect.size.height -= 13;
	theRect.origin.x += 2;
	theRect.size.width -= 4;
	
    [self.color set];

	CGContextSaveGState(c);
	
	CGContextBeginPath(c);
    CGContextAddRoundedRectWithHookSimple(c, theRect, 3);
	CGContextFillPath(c);
}



#define MAX_WIDTH 400
// calculate own frame to fit within parent frame and be large enough to hold the event.
- (void)recalculateFrame {
    CGRect theFrame = self.frame;
    theFrame.size.width = MIN(MAX_WIDTH, theFrame.size.width);
    
    CGRect theRect = self.frame; theRect.origin = CGPointZero;

    {
        theFrame.origin.y = self.tapPoint.y - theFrame.size.height + 2 * SHADOWSIZE + 1;
        theFrame.origin.x = round(self.tapPoint.x - ((theFrame.size.width - 2 * SHADOWSIZE)) / 2.0);
    }
    self.frame = theFrame;
}

@end
