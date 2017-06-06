//
//  CommonTableViewCell.h
//  DuDou
//
//  Created by jinyulong on 2017/6/6.
//  Copyright © 2017年 GhostShell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *pushNum;
@property (weak, nonatomic) IBOutlet UILabel *phoneNum;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end
