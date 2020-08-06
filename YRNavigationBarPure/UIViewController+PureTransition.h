//
//  UIViewController+PureTransition.h
//  Mask
//
//  Created by Daniel on 4/22/20.
//  Copyright © 2020 Mask. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (PureTransition)

@property (nonatomic, assign) BOOL yr_prefersNavigationBarHidden;
@property (nonatomic, assign) BOOL yr_interactivePopDisabled;

@end

@interface UINavigationController (PureTransition)

@property (nonatomic, assign) BOOL yr_allowFullScreenInteractivePop;

@end

NS_ASSUME_NONNULL_END
