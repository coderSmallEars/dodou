//
//  BCTabBarController.m
//  QKPlayer
//
//  Created by jinyulong on 2017/6/4.
//  Copyright © 2017年 ak. All rights reserved.
//

#import "BCTabBarController.h"

@interface BCTabBarController ()

@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation BCTabBarController

- (instancetype)init{
    if (self = [super init]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.tabBar.translucent = NO;
    }
    return self;
}

- (void)loadView{
//    [super loadView];
//    AILMatchViewController *matchListVC = [AILMatchViewController new];
//    AILNavigationController *matchListNC = [[AILNavigationController alloc] initWithRootViewController:matchListVC];
//    UITabBarItem *matchItem = [self creatTabBarItemWithTitle:@"比赛" imageName:@"tab_icon_match_normal" selectedImageName:@"tab_icon_match_pre"];
//    matchListNC.tabBarItem = matchItem;
//    
//    AILNewsViewController *newsListVC = [AILNewsViewController new];
//    AILNavigationController *newsListNC = [[AILNavigationController alloc] initWithRootViewController:newsListVC];
//    UITabBarItem *newsItem = [self creatTabBarItemWithTitle:@"彩讯" imageName:@"tab_icon_news_normal" selectedImageName:@"tab_icon_news_pre"];
//    newsListNC.tabBarItem = newsItem;
//    
//    AILStoreViewController *storeVC = [AILStoreViewController new];
//    AILNavigationController *storeNC = [[AILNavigationController alloc] initWithRootViewController:storeVC];
//    UITabBarItem *storeItem = [self creatTabBarItemWithTitle:@"商城" imageName:@"tab_icon_shop_normal" selectedImageName:@"tab_icon_shop_pre"];
//    storeNC.tabBarItem = storeItem;
//    
//    AILPersonalViewController *personalVC = [AILPersonalViewController new];
//    AILNavigationController *personalNC = [[AILNavigationController alloc] initWithRootViewController:personalVC];
//    UITabBarItem *personalItem = [self creatTabBarItemWithTitle:@"我的" imageName:@"tab_icon_user_normal" selectedImageName:@"tab_icon_user_pre"];
//    personalNC.tabBarItem = personalItem;
//    self.viewControllers = @[matchListNC, newsListNC, storeNC, personalNC];
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageFromColor:AILColorNavigationBar Width:10 Height:10] forBarMetrics:UIBarMetricsDefault];
//    
//    self.tabBar.backgroundColor = AILColorFFFFFF;
//    self.selectedIndex = 0;
//    self.delegate = self;
//    
//    [self.tabBar setShadowImage:[UIImage imageWithColor:AILColor_BG size:CGSizeMake(kScreenWidth, 0.5)]];
//    [self.tabBar setBackgroundImage:[[UIImage alloc]init]];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endTabbarRefresh) name:kTabBarEndRefreshNotification object:nil];
}

- (void)dealloc{
//    [self removeNotificationObserver];
}

#pragma mark - CreatTabBarItem
- (UITabBarItem *)creatTabBarItemWithTitle:(NSString*)title imageName:(NSString*)imgName selectedImageName:(NSString*)selectedImgName{
    UIImage *image = [[UIImage imageNamed:imgName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectedImage = [[UIImage imageNamed:selectedImgName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:title image:image selectedImage:selectedImage];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],}  forState:UIControlStateHighlighted];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateNormal];
//    [item setTitleTextAttributes:@{NSForegroundColorAttributeName : AILColorNavigationBar} forState:UIControlStateSelected];
    
    item.imageInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    item.titlePositionAdjustment =  UIOffsetMake(0, -3);
    return item;
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    NSInteger index = [tabBar.items indexOfObject:item];
    
    NSLog(@"Tabbar Selected Index >>>>>%zd",index);
    self.currentIndex = index;
}

#pragma mark - UIViewControllerRotation
- (BOOL)shouldAutorotate
{
    return self.selectedViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return self.selectedViewController.supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [self.selectedViewController preferredInterfaceOrientationForPresentation];
}

@end

@implementation UITabBarController (HideTabBar)

- (void)setHideTabBar:(BOOL)hide {
    UIViewController *selectedViewController = self.selectedViewController;
    /**
     * If the selectedViewController is a UINavigationController, get the visibleViewController.
     * - setEdgesForExtendedLayout won't work with the UINavigationBarController itself.
     * - setExtendedLayoutIncludesOpaqueBars won't work with the UINavigationBarController itself.
     */
    if ([selectedViewController isKindOfClass:[UINavigationController class]])
    {
        selectedViewController = ((UINavigationController *)selectedViewController).visibleViewController;
        
        self.tabBar.hidden = hide;
        if (hide) {
            selectedViewController.edgesForExtendedLayout = UIRectEdgeAll;
        }else{
            selectedViewController.edgesForExtendedLayout = UIRectEdgeNone;
        }
        [selectedViewController setExtendedLayoutIncludesOpaqueBars:hide];
        
        /**
         * Just in case we have a navigationController, call layoutSubviews in order to resize the selectedViewController
         */
        [selectedViewController.navigationController.view layoutSubviews];
    };
}

@end
