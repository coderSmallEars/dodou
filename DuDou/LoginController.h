//
//  LoginController.h
//  DuDou
//
//  Created by jinyulong on 2017/6/5.
//  Copyright © 2017年 GhostShell. All rights reserved.
//

#import "BCViewController.h"

@interface LoginController : BCViewController

@property (weak, nonatomic) IBOutlet UITextField *phoneNumField;

@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (weak, nonatomic) IBOutlet UITextField *verifyCodeField;

@property (nonatomic, copy) void(^loginBlock)(void);

@end
