//
//  RecordCell.m
//  DuDou
//
//  Created by jinyulong on 2017/6/6.
//  Copyright © 2017年 GhostShell. All rights reserved.
//

#import "RecordCell.h"

@implementation RecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.indicateLabel.layer.cornerRadius = 15;
    [self.contentLabel setAdjustsFontSizeToFitWidth:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
