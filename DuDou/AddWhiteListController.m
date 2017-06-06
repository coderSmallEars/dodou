//
//  AddWhiteListController.m
//  DuDou
//
//  Created by jinyulong on 2017/6/6.
//  Copyright © 2017年 GhostShell. All rights reserved.
//

#import "AddWhiteListController.h"

@interface AddWhiteListController ()

@end

@implementation AddWhiteListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
}

- (IBAction)saveAction:(id)sender {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        if (![self.nameField.text isEqualToString:self.name] || ![self.phoneNumField.text isEqualToString:self.phoneNum]) {
            if (self.dismissBlock) {
                self.dismissBlock(self.nameField.text, self.phoneNumField.text);
            }
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    for (UITouch *touch in touches) {
        if ([touch.view isEqual:self.view]) {
            if ([self.nameField isFirstResponder] || [self.phoneNumField isFirstResponder]) {
                [self.view endEditing:YES];
            }else{
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
    }
}

- (void)setName:(NSString *)name{
    _name = name;
    self.nameField.text = name;
}

- (void)setPhoneNum:(NSString *)phoneNum{
    _phoneNum = phoneNum;
    self.phoneNumField.text = phoneNum;
}
@end
