//
//  NotificationView.m
//  PPTopMostController
//
//  Created by Marian Paul on 24/05/13.
//  Copyright (c) 2013 iPuP. All rights reserved.
//

#import "NotificationView.h"
#import "UIViewController+PPTopMostController.h"

static const int viewHeight = 20.0;
static const int shadowHeight = 6.0;

void drawLinearGradientWithPoints(CGContextRef context, CGRect rect, CGPoint startPoint, CGPoint endPoint, CGColorRef startColor, CGColorRef endColor) {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = [NSArray arrayWithObjects:(__bridge id)startColor, (__bridge id)endColor, nil];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors, locations);
    
    CGContextSaveGState(context);
    CGContextAddRect(context, rect);
    CGContextClip(context);
    
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor) {
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    drawLinearGradientWithPoints(context, rect, startPoint, endPoint, startColor, endColor);
}

@interface NotificationView ()
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIColor *color;
@end

@implementation NotificationView

- (id)initWithFrame:(CGRect)frame {
    frame.size = CGSizeMake(CGRectGetWidth([[UIScreen mainScreen] bounds]), viewHeight + shadowHeight);
    self = [super initWithFrame:frame];
    if (self) {
        self.label = [[UILabel alloc] initWithFrame:CGRectZero];
        self.label.font = [UIFont fontWithName:@"Helvetica" size:12.0];
        self.label.textColor = [UIColor whiteColor];
        self.label.backgroundColor = [UIColor clearColor];
        [self addSubview:self.label];
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect newFrame = _label.frame;
    newFrame.origin = CGPointMake((CGRectGetWidth(self.frame) - CGRectGetWidth(_label.frame)) / 2.0, (viewHeight - CGRectGetHeight(_label.frame)) / 2.0);
    _label.frame = newFrame;
}

+ (NotificationView *)showWithText:(NSString *)text color:(UIColor *)color andHideAfterDelay:(NSTimeInterval)delay {
    NotificationView *n = [[NotificationView alloc] initWithFrame:CGRectZero];
    n.color = color;
    [n.label setText:text];
    [n.label sizeToFit];
    
    [n showAnimated:YES];
    
    [n performSelector:@selector(hide) withObject:nil afterDelay:delay];
    
    return n;
}

#pragma mark - Private

- (void)_addToCurrentController {
    // Add to navigation controller view if not available. That way, it won't move when we push the views
    // Get the top most controller view
    UIViewController *c = [UIViewController topMostController];
    
    UIView *superView = nil;
    UIView *belowView = nil;
    
    if (c.navigationController) {
        superView = c.navigationController.view;
        belowView = c.navigationController.navigationBar;
    } else {
        superView = c.view;
    }
    
    if (self.superview != superView) {
        [self removeFromSuperview];
        if (belowView) [superView insertSubview:self belowSubview:belowView];
        else [superView addSubview:self];
    }
}

- (CGFloat)_getFinalOrigin {
    UIViewController *c = [UIViewController topMostController];
    CGFloat finalOrigin = c.navigationController ? 44.0 /*Toolbar height*/ + (c.revealSideViewController ? 0.0/* "bug" with full screen status bar and PPReveal*/ : 20.0) /*Status bar height*/ : 0.0;
    return finalOrigin;
}

- (void)showAnimated:(BOOL)animated {
    [self _addToCurrentController];
    [self showWithFinalOrigin:[self _getFinalOrigin] animated:animated];
}

- (void)show {
    [self showAnimated:YES];
}

- (void)showWithFinalOrigin:(CGFloat)finalOrigin animated:(BOOL)animated {
    void (^ animation)(void) = ^{
        CGRect newFrame = self.frame;
        newFrame.origin.y = finalOrigin;
        self.frame = newFrame;
    };
    
    if (animated) {
        CGRect newFrame = self.frame;
        newFrame.origin.y = -viewHeight - shadowHeight;
        self.frame = newFrame;
        
        NSTimeInterval showAnimationTime = 0.4;
        [UIView animateWithDuration:showAnimationTime
                         animations:animation];
    } else {
        animation();
    }
}

- (void)hide {
    NSTimeInterval showAnimationTime = 0.4;
    [UIView animateWithDuration:showAnimationTime
                     animations:^{
                         CGRect newFrame = self.frame;
                         newFrame.origin.y = -CGRectGetHeight(self.frame);
                         self.frame = newFrame;
                     }
     
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, self.color.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, CGRectGetWidth(rect), viewHeight));
    
    drawLinearGradient(context,
                       CGRectMake(0.0, viewHeight, CGRectGetWidth(rect), shadowHeight),
                       [UIColor colorWithWhite:0.0 alpha:0.7].CGColor,
                       [UIColor colorWithWhite:0.0 alpha:0.0].CGColor);
}

@end
