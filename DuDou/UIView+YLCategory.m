//
//  UIView+YLCategory.m
//  AILottery
//
//  Created by jinyulong on 2017/1/19.
//  Copyright © 2017年 jinyulong. All rights reserved.
//

#import "UIView+YLCategory.h"

@implementation UIView (YLCategory)

- (void)roundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.layer.bounds byRoundingCorners:corners cornerRadii:cornerRadii];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.layer.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (UITapGestureRecognizer *)addTapGestureAction:(ObjBlock)action{
    if (!self.isUserInteractionEnabled) {
        self.userInteractionEnabled = YES;
    }
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        if (action) {
            action(sender);
        }
    }];
    [self addGestureRecognizer:tapGR];
    return tapGR;
}

- (void)setGeneralCornerRadius{
    [self setCornerRadius:3];
}

- (void)setCornerRadius:(float)radius{
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
}

- (void)removeAllGestures{
    NSMutableArray *gestures = [self.gestureRecognizers mutableCopy];
    while (gestures.count > 0) {
        [self removeGestureRecognizer:gestures.lastObject];
        [gestures removeLastObject];
    }
}

- (void)addSubviews:(NSArray *)subViews{
    if (Valid_Array(subViews)) {
        [subViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UIView class]]) {
                [self addSubview:obj];
            }
        }];
    }
}

#pragma mark - progress hud
- (void)postProgressHudWithMessage:(NSString *)message{
    [MBProgressHUD hideHUDForView:self animated:NO];
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeText;
    hud.animationType = MBProgressHUDAnimationZoom;
    hud.label.text = message;
    [hud hideAnimated:YES afterDelay:1.5];
}

- (void)postNetworkNotReachableMessage{
    [self postProgressHudWithMessage:@"网络似乎被给力,请稍后重试"];
}

- (void)hideHud{
    [MBProgressHUD hideHUDForView:self animated:YES];
}

@end
