//
//  VerificationCodeView.h
//  DuDou
//
//  Created by jinyulong on 2017/6/5.
//  Copyright © 2017年 GhostShell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerificationCodeView : UIControl

@property (nonatomic, copy, readonly) NSString *changeString;

- (void)changeCode;

@end
