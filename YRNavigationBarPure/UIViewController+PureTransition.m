//
//  UIViewController+PureTransition.m
//  Mask
//
//  Created by Daniel on 4/22/20.
//  Copyright © 2020 Mask. All rights reserved.
//

#import "UIViewController+PureTransition.h"
#import <objc/runtime.h>
#import "UIView+Snapshot.h"

#define kEdgePadding 30

#define ASSOCIATED(propertyName, setter, type, objc_AssociationPolicy) \
- (type)propertyName \
{ \
    return objc_getAssociatedObject(self, _cmd); \
} \
- (void)setter:(type)object \
{ \
    objc_setAssociatedObject(self, @selector(propertyName), object, objc_AssociationPolicy); \
} \

#define ASSOCIATED_BOOL(propertyName, setter, objc_AssociationPolicy) \
- (BOOL)propertyName \
{ \
    return [objc_getAssociatedObject(self, _cmd) boolValue]; \
} \
- (void)setter:(BOOL)object \
{ \
    objc_setAssociatedObject(self, @selector(propertyName), @(object), objc_AssociationPolicy); \
} \

static void YRSwizzleMethod(Class cls, SEL originalSEL, SEL swizzledSEL) {
    Method originalMethod = class_getInstanceMethod(cls, originalSEL);
    Method swizzledMethod = class_getInstanceMethod(cls, swizzledSEL);
    
    BOOL didAddMethod = class_addMethod(cls, originalSEL, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(cls, swizzledSEL, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@interface YRNavigationBarState : NSObject

@property (nonatomic, strong) UIColor *barTintColor;
@property (nonatomic, strong) UIImage *backgroundImage;

@end

@implementation YRNavigationBarState

@end

@interface YRPanGestureRecognizerDelegate : NSObject <UIGestureRecognizerDelegate>

@property (nonatomic, weak) UINavigationController *navigationController;

@end

@implementation YRPanGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint velocity = [gestureRecognizer velocityInView:gestureRecognizer.view];
    if (velocity.x <= 0) {
        return NO;
    }
    if (self.navigationController.viewControllers.count <= 1) {
        return NO;
    }
    
    if ([[self.navigationController valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }
    
    if (self.navigationController.yr_allowFullScreenInteractivePop) {
        return YES;
    }
    
    BOOL isScreenEdge = [gestureRecognizer locationInView:gestureRecognizer.view].x < kEdgePadding;
    if (!isScreenEdge) {
        return NO;
    }
    
    return YES;
}

@end

@interface UIViewController ()

@property (nonatomic, strong) UIImageView *navigationBarSnapshotView;
@property (nonatomic, strong) YRNavigationBarState *navigationBarState;

@end

@interface UINavigationController ()

@property (nonatomic, strong) YRPanGestureRecognizerDelegate *panGestureRecognizerDelegate;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

@end

@implementation UIViewController (PureTransition)

ASSOCIATED_BOOL(yr_prefersNavigationBarHidden, setYr_prefersNavigationBarHidden, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
ASSOCIATED_BOOL(yr_interactivePopDisabled, setYr_interactivePopDisabled, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
ASSOCIATED(navigationBarSnapshotView, setNavigationBarSnapshotView, UIImageView *, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
ASSOCIATED(navigationBarState, setNavigationBarState, YRNavigationBarState *, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        YRSwizzleMethod(self.class, @selector(viewWillAppear:), @selector(yr_viewWillAppear:));
        YRSwizzleMethod(self.class, @selector(viewWillDisappear:), @selector(yr_viewWillDisappear:));
        YRSwizzleMethod(self.class, @selector(viewDidAppear:), @selector(yr_viewDidAppear:));
        YRSwizzleMethod(self.class, @selector(viewWillLayoutSubviews), @selector(yr_viewWillLayoutSubviews));
    });
}

- (void)yr_viewWillAppear:(BOOL)animated
{
    [self yr_viewWillAppear:animated];
    
    if (!self.navigationController) {
        return;
    }
    
    [self savaNavigationBarStateIfNeeded];
    
    if (self.navigationBarSnapshotView && !self.navigationBarSnapshotView.superview) {
        [self.view addSubview:self.navigationBarSnapshotView];
    }
    
    [self.navigationController setNavigationBarHidden:self.yr_prefersNavigationBarHidden animated:NO];
    
    [self.navigationController.view sendSubviewToBack:self.navigationController.navigationBar];
}

- (void)yr_viewWillDisappear:(BOOL)animated
{
    [self yr_viewWillDisappear:animated];
    
    if (!self.navigationController) {
        return;
    }
    
    if (self.navigationBarSnapshotView && !self.navigationBarSnapshotView.superview) {
        [self.view addSubview:self.navigationBarSnapshotView];
    }
}

- (void)yr_viewWillLayoutSubviews
{
    [self yr_viewWillLayoutSubviews];
    
    if (!self.navigationController || self.navigationBarSnapshotView) {
        return;
    }
    
    if (self.navigationController.viewControllers.firstObject != self && [self shouldGenerateNavigationBarImageView]) {
        UIImageView *navigationBarSnapshot = [[UIImageView alloc] initWithFrame:self.navigationController.navigationBar.visibleBoundry];
        navigationBarSnapshot.image = [self.navigationController.navigationBar snapshotImageClipsToBounds:NO];
        self.navigationBarSnapshotView = navigationBarSnapshot;
    }
    
    if (self.navigationBarSnapshotView && !self.navigationBarSnapshotView.superview) {
        [self.view addSubview:self.navigationBarSnapshotView];
    }
}

- (void)yr_viewDidAppear:(BOOL)animated
{
    [self yr_viewDidAppear:animated];
    
    if (!self.navigationController) {
        return;
    }
    
    if ([self shouldGenerateNavigationBarImageView] && !self.navigationBarSnapshotView) {
        UIImageView *navigationBarSnapshot = [[UIImageView alloc] initWithFrame:self.navigationController.navigationBar.visibleBoundry];
        navigationBarSnapshot.image = [self.navigationController.navigationBar snapshotImageClipsToBounds:NO];
        self.navigationBarSnapshotView = navigationBarSnapshot;
    }
    
    [self restoreNavigationBarState];
    
    if (self.navigationBarSnapshotView.superview) {
        [self.navigationBarSnapshotView removeFromSuperview];
    }
    
    self.navigationController.panGestureRecognizer.enabled = !self.yr_interactivePopDisabled;
    
    [self.navigationController.view bringSubviewToFront:self.navigationController.navigationBar];
}

- (void)savaNavigationBarStateIfNeeded
{
    if (self.yr_prefersNavigationBarHidden || self.navigationBarState) {
        return;
    }
    
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    self.navigationBarState = [[YRNavigationBarState alloc] init];
    self.navigationBarState.barTintColor = navigationBar.barTintColor;
    self.navigationBarState.backgroundImage = [navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault];
}

- (void)restoreNavigationBarState
{
    if (self.yr_prefersNavigationBarHidden) {
        return;
    }
    
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    navigationBar.barTintColor = self.navigationBarState.barTintColor;
    [navigationBar setBackgroundImage:self.navigationBarState.backgroundImage forBarMetrics:UIBarMetricsDefault];
}

- (BOOL)shouldGenerateNavigationBarImageView
{
    return (self.navigationController && !self.navigationBarSnapshotView && !self.yr_prefersNavigationBarHidden);
}

@end

@implementation UINavigationController (PureTransition)

ASSOCIATED(panGestureRecognizer, setPanGestureRecognizer, UIPanGestureRecognizer *, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
ASSOCIATED(panGestureRecognizerDelegate, setPanGestureRecognizerDelegate, UIPanGestureRecognizer *, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
ASSOCIATED_BOOL(yr_allowFullScreenInteractivePop, setYr_allowFullScreenInteractivePop, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        YRSwizzleMethod(self.class, @selector(init), @selector(yr_init));
        YRSwizzleMethod(self.class, @selector(initWithCoder:), @selector(yr_initWithCoder:));
        YRSwizzleMethod(self.class, @selector(initWithNibName:bundle:), @selector(yr_initWithNibName:bundle:));
        YRSwizzleMethod(self.class, @selector(initWithRootViewController:), @selector(yr_initWithRootViewController:));
        YRSwizzleMethod(self.class, @selector(initWithNavigationBarClass:toolbarClass:), @selector(yr_initWithNavigationBarClass:toolbarClass:));
    });
}

- (instancetype)yr_init
{
    UINavigationController *instance = [self yr_init];
    [self setupEdgeSwipePanGestureRecognizer];
    return instance;
}

- (instancetype)yr_initWithCoder:(NSCoder *)aDecoder
{
    UINavigationController *instance = [self yr_initWithCoder:aDecoder];
    [self setupEdgeSwipePanGestureRecognizer];
    return instance;
}

- (instancetype)yr_initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    UINavigationController *instance = [self yr_initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    [self setupEdgeSwipePanGestureRecognizer];
    return instance;
}

- (instancetype)yr_initWithRootViewController:(UIViewController *)rootViewController
{
    UINavigationController *instance = [self yr_initWithRootViewController:rootViewController];
    [self setupEdgeSwipePanGestureRecognizer];
    return instance;
}

- (instancetype)yr_initWithNavigationBarClass:(Class)navigationBarClass toolbarClass:(Class)toolbarClass
{
    UINavigationController *instance = [self yr_initWithNavigationBarClass:navigationBarClass toolbarClass:toolbarClass];
    [self setupEdgeSwipePanGestureRecognizer];
    return instance;
}

- (void)setupEdgeSwipePanGestureRecognizer
{
    if (self.panGestureRecognizer) return;
    
    self.interactivePopGestureRecognizer.enabled = NO;

    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] init];
    self.panGestureRecognizer.maximumNumberOfTouches = 1;
    [self.view addGestureRecognizer:self.panGestureRecognizer];
    NSArray *internalTargets = [self.interactivePopGestureRecognizer valueForKey:@"targets"];
    id internalTarget = [internalTargets.firstObject valueForKey:@"target"];
    SEL handler = NSSelectorFromString(@"handleNavigationTransition:");
    [self.panGestureRecognizer addTarget:internalTarget action:handler];
    
    YRPanGestureRecognizerDelegate *gestureDelegate = [YRPanGestureRecognizerDelegate new];
    gestureDelegate.navigationController = self;
    self.panGestureRecognizerDelegate = gestureDelegate;
    self.panGestureRecognizer.delegate = gestureDelegate;
}

@end
