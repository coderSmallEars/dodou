//
//  UIView+YLCategory.h
//  AILottery
//
//  Created by jinyulong on 2017/1/19.
//  Copyright © 2017年 jinyulong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (YLCategory)


#pragma mark - progress hud
- (void)postProgressHudWithMessage:(NSString *)message;

- (void)postNetworkNotReachableMessage;

- (void)hideHud;
//切view指定角的圆角
- (void)roundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii;

- (void)addSeperatorLineInsets:(UIEdgeInsets)insets;

- (UITapGestureRecognizer *)addTapGestureAction:(ObjBlock)action;

- (void)removeAllGestures;

- (void)setGeneralCornerRadius;

- (void)setCornerRadius:(float)radius;

- (void)addSubviews:(NSArray *)subViews;

@end
