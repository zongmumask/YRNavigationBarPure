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

@property (nonatomic, assign) CGRect p_visibleBoundry;

@end

@implementation UIView (ext)

- (CGRect)p_visibleBoundry
{
    return [objc_getAssociatedObject(self, @selector(p_visibleBoundry)) CGRectValue];
}

- (void)setP_visibleBoundry:(CGRect)p_visibleBoundry
{
    objc_setAssociatedObject(self, @selector(p_visibleBoundry), [NSValue valueWithCGRect:p_visibleBoundry], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGRect)visibleBoundry
{
    self.p_visibleBoundry = self.frame;
    [self _caculateVisibleBoundry:self];
    return self.p_visibleBoundry;
}

- (void)setVisibleBoundry:(CGRect)visibleBoundry
{
    objc_setAssociatedObject(self, @selector(visibleBoundry), [NSValue valueWithCGRect:visibleBoundry], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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
        UIGraphicsBeginImageContextWithOptions(self.visibleBoundry.size, self.opaque, 0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        self.p_visibleBoundry = self.frame;
        [self _caculateVisibleBoundry:self];
        CGContextTranslateCTM(context, self.frame.origin.x - self.p_visibleBoundry.origin.x, self.frame.origin.y - self.p_visibleBoundry.origin.y);
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return snap;
    }
}

- (void)_caculateVisibleBoundry:(UIView *)view
{
    if (view.subviews.count == 0) {
        CGRect subRect = [self.superview convertRect:view.bounds fromView:view];
        self.p_visibleBoundry = CGRectUnion(self.p_visibleBoundry, subRect);
    }
    for (UIView *subView in view.subviews) {
        [self _caculateVisibleBoundry:subView];
    }
}

@end
