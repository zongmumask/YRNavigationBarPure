//
//  UIView+Snapshot.h
//  Mask
//
//  Created by Daniel on 6/24/20.
//  Copyright © 2020 Mask. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ext)

@property (nonatomic, assign) CGRect visibleBoundry;

- (UIImage *)snapshotImageClipsToBounds:(BOOL)clipsToBounds;

@end

NS_ASSUME_NONNULL_END
