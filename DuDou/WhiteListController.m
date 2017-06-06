//
//  WhiteListController.m
//  DuDou
//
//  Created by jinyulong on 2017/6/5.
//  Copyright © 2017年 GhostShell. All rights reserved.
//

#import "WhiteListController.h"
#import "AddWhiteListController.h"

#import "CommonTableViewCell.h"
#import "NIDropDown.h"
#import "Relative.h"

@interface WhiteListController ()<NIDropDownDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NIDropDown *dropDown;
}

@property (nonatomic, strong) Student *selectedStudent;
@property (nonatomic, copy) NSArray <Relative*>*relatives;
@property (weak, nonatomic) IBOutlet UITableView *listTableView;

@end

@implementation WhiteListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"白名单";
    [self.listTableView registerNib:[UINib nibWithNibName:@"CommonTableViewCell" bundle:nil] forCellReuseIdentifier:@"relativeCell"];
    self.listTableView.tableFooterView = [UIView new];
    if (DataCengerSingleton.students.count > 0) {
        [self changeStudentBtnTitle:StringNotNull([DataCengerSingleton.students.firstObject name])];
        self.selectedStudent = DataCengerSingleton.students.firstObject;
        [self requestStudentRelative];
    }
}

- (IBAction)changeStudentAction:(UIButton *)sender {
    NSMutableArray *names = [@[] mutableCopy];
    for (Student *student in DataCengerSingleton.students) {
        [names addObject:StringNotNull(student.name)];
    }
    if(dropDown == nil) {
        CGFloat f = DataCengerSingleton.students.count * 40;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :DataCengerSingleton.students :nil :@"down"];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        [self rel];
    }
}

- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    self.selectedStudent = sender.student;
    [self rel];
    [self requestStudentRelative];
}

-(void)rel{
    //    [dropDown release];
    dropDown = nil;
}

- (void)changeStudentBtnTitle:(NSString *)title{
    [self.studentBtn setTitle:title forState:UIControlStateNormal];
}

- (void)requestStudentRelative{
    [DataCengerSingleton getDataWithPath:[NSString stringWithFormat:@"%@jxt/safeCard/listWhiteList",base] params:@{@"mobile":StringNotNull(self.selectedStudent.mobile)} success:^(id obj) {
        NSMutableArray *tempRelatives = [@[] mutableCopy];
        if (Valid_Array(obj)) {
            for (NSDictionary *dic in obj) {
                [tempRelatives addObject:[Relative modelWithJSON:dic]];
            }
            self.relatives = [tempRelatives copy];
            [self.listTableView reloadData];
        }
    } failure:^(id obj) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.relatives.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"relativeCell"];
    Relative *relative = nil;
    if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section] -1) {
        cell.pushNum.text = @"未定义";
        [cell.editBtn setTitle:@"添加" forState:UIControlStateNormal];
    }else{
        [cell.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        relative = self.relatives[indexPath.row];
        cell.pushNum.text = [NSString stringWithFormat:@"%@",relative.name];
        cell.phoneNum.text = [NSString stringWithFormat:@"电话号码：%@",relative.number];
    }
    cell.indexPath = indexPath;
    [cell.editBtn removeAllTargets];
    [cell.editBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        NSLog(@"%@",indexPath);
        [self showEditCtrlWithRelative:relative];
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)showEditCtrlWithRelative:(Relative *)relative{
    AddWhiteListController *whiteListCtrl = [[AddWhiteListController alloc] initWithNibName:@"AddWhiteListController" bundle:nil];
    self.definesPresentationContext = YES;
    whiteListCtrl.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    whiteListCtrl.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    @weakify(self)
    whiteListCtrl.dismissBlock = ^(NSString *name, NSString *number) {
        @strongify(self)
        if (relative) {
            relative.name = name;
            relative.number = @(number.integerValue);
        }else{
            Relative *new = [Relative new];
            new.name = name;
            new.number = @(number.integerValue);
            self.relatives = [self.relatives arrayByAddingObject:new];
        }
        [self.listTableView reloadData];
    };

    [self presentViewController:whiteListCtrl animated:YES completion:nil];
    if (relative) {
        whiteListCtrl.name = relative.name;
        whiteListCtrl.phoneNum = [NSString stringWithFormat:@"%@",relative.number];
    }
}

- (NSArray<Relative *> *)relatives{
    if (!_relatives) {
        _relatives = [@[] copy];
    }
    return _relatives;
}

@end
