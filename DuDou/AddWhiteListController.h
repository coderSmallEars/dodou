//
//  AddWhiteListController.h
//  DuDou
//
//  Created by jinyulong on 2017/6/6.
//  Copyright © 2017年 GhostShell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddWhiteListController : BCViewController

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *phoneNum;

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumField;
@property (copy, nonatomic) void(^dismissBlock)(NSString *name,NSString *number);
@end
