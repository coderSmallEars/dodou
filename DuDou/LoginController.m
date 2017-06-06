//
//  LoginController.m
//  DuDou
//
//  Created by jinyulong on 2017/6/5.
//  Copyright © 2017年 GhostShell. All rights reserved.
//

#import "LoginController.h"

@interface LoginController ()

@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)loginAction:(UIButton *)sender {
    NSString *username = @"13631585649"; StringNotNull(self.phoneNumField.text);
    NSString *password = @"111111"; StringNotNull(self.passwordField.text);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [DataCengerSingleton postDataWithPath:[NSString stringWithFormat:@"%@login",ctx] params:@{@"userName":username,@"password":password} success:^(id obj) {
        [self updateRootViewController];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(id obj) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"用户名或密码错误，请重试";
        [hud hideAnimated:YES afterDelay:1.5];
    }];
}

- (void)updateRootViewController{
    LocationController *locationCtrl = [LocationController new];
//    UINavigationController * accout =[[UINavigationController alloc] initWithRootViewController:[LocationController alloc]];
    locationCtrl.tabBarItem = [self creatTabBarItemWithTitle:@"定位" imageName:@"n1" selectedImageName:@"n1_h"];
    locationCtrl.title = @"定位";
    
    RouteController *routeCtrl = [RouteController new];
//    UINavigationController * active =[[UINavigationController alloc] initWithRootViewController:[RouteController alloc]];
    routeCtrl.tabBarItem = [self creatTabBarItemWithTitle:@"轨迹" imageName:@"n2" selectedImageName:@"n2_h"];
    routeCtrl.title = @"轨迹";
    
    RecordController *recordCtrl = [RecordController new];
//    UINavigationController * registe =[[UINavigationController alloc] initWithRootViewController:[RecordController alloc]];
    recordCtrl.tabBarItem = [self creatTabBarItemWithTitle:@"考勤" imageName:@"n3" selectedImageName:@"n3_h"];
    recordCtrl.title = @"考勤";
    
    RelativeController *relativeCtrl = [RelativeController new];
//    UINavigationController * comment =[[UINavigationController alloc] initWithRootViewController:[RelativeController alloc]];
    relativeCtrl.tabBarItem = [self creatTabBarItemWithTitle:@"亲情号" imageName:@"n4" selectedImageName:@"n4_h"];
    relativeCtrl.title = @"亲情号";
    
    WhiteListController *whiteCtrl = [WhiteListController new];
//    UINavigationController * white =[[UINavigationController alloc] initWithRootViewController:[WhiteListController alloc]];
    whiteCtrl.tabBarItem = [self creatTabBarItemWithTitle:@"白名单" imageName:@"n5" selectedImageName:@"n5_h"];
    whiteCtrl.title = @"白名单";
    
    UITabBarController * tabController = [[UITabBarController alloc] init];
    NSArray * viewConrollerArray = [NSArray arrayWithObjects: locationCtrl, routeCtrl,recordCtrl, relativeCtrl,whiteCtrl, nil];
    tabController.viewControllers = viewConrollerArray;
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = tabController;
    [window makeKeyAndVisible];
}
- (UITabBarItem *)creatTabBarItemWithTitle:(NSString*)title imageName:(NSString*)imgName selectedImageName:(NSString*)selectedImgName{
    UIImage *image = [[UIImage imageNamed:imgName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectedImage = [[UIImage imageNamed:selectedImgName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:title image:image selectedImage:selectedImage];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],}  forState:UIControlStateHighlighted];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:60 green:220 blue:220 alpha:1]} forState:UIControlStateSelected];
    
    item.imageInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    item.titlePositionAdjustment =  UIOffsetMake(0, -3);
    return item;
}

@end
