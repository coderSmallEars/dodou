//
//  CommonTableViewCell.m
//  DuDou
//
//  Created by jinyulong on 2017/6/6.
//  Copyright © 2017年 GhostShell. All rights reserved.
//

#import "CommonTableViewCell.h"

@implementation CommonTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.imgView.layer.cornerRadius = 2;
    self.imgView.layer.masksToBounds = YES;
    self.editBtn.layer.cornerRadius = 2;
    self.editBtn.layer.masksToBounds = YES;
    self.editBtn.layer.borderColor = [UIColor orangeColor].CGColor;
    self.editBtn.layer.borderWidth = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
