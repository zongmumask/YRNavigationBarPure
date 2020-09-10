//
//  UIView+clone.m
//  Mask
//
//  Created by Daniel on 6/24/20.
//  Copyright © 2020 Mask. All rights reserved.
//

#import "UIView+Snapshot.h"
#import <objc/runtime.h>

@interface UIView ()

@property (nonatomic, assign) CGRect p_visibleFrame;

@end

@implementation UIView (Snapshot)

- (CGRect)p_visibleFrame
{
    return [objc_getAssociatedObject(self, @selector(p_visibleFrame)) CGRectValue];
}

- (void)setP_visibleFrame:(CGRect)p_visibleFrame
{
    objc_setAssociatedObject(self, @selector(p_visibleFrame), [NSValue valueWithCGRect:p_visibleFrame], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGRect)visibleFrame
{
    self.p_visibleFrame = self.frame;
    [self _caculateVisibleBoundry:self];
    return self.p_visibleFrame;
}

- (void)setVisibleFrame:(CGRect)visibleFrame
{
    objc_setAssociatedObject(self, @selector(visibleFrame), [NSValue valueWithCGRect:visibleFrame], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)snapshotImageClipsToBounds:(BOOL)clipsToBounds
{
    if (clipsToBounds) {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return snap;
    } else {
        UIGraphicsBeginImageContextWithOptions(self.visibleFrame.size, self.opaque, 0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        self.p_visibleFrame = self.frame;
        [self _caculateVisibleBoundry:self];
        CGContextTranslateCTM(context, self.frame.origin.x - self.p_visibleFrame.origin.x, self.frame.origin.y - self.p_visibleFrame.origin.y);
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return snap;
    }
}

- (void)_caculateVisibleBoundry:(UIView *)view
{
    if (view.subviews.count == 0) {
        CGRect subRect = [view convertRect:view.bounds toView:self.superview];
        self.p_visibleFrame = CGRectUnion(self.p_visibleFrame, subRect);
    }
    for (UIView *subView in view.subviews) {
        [self _caculateVisibleBoundry:subView];
    }
}

@end
