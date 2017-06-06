//
//  RelativeController.m
//  DuDou
//
//  Created by jinyulong on 2017/6/5.
//  Copyright © 2017年 GhostShell. All rights reserved.
//

#import "RelativeController.h"

#import "CommonTableViewCell.h"
#import "NIDropDown.h"
#import "Relative.h"

@interface RelativeController ()<NIDropDownDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NIDropDown *dropDown;
}

@property (nonatomic, strong) Student *selectedStudent;
@property (nonatomic, copy) NSArray <Relative*>*relatives;
@property (weak, nonatomic) IBOutlet UITableView *listTableView;

@end

@implementation RelativeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"亲情号";
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
    [DataCengerSingleton getDataWithPath:[NSString stringWithFormat:@"%@jxt/safeCard/listFamily",base] params:@{@"mobile":StringNotNull(self.selectedStudent.mobile)} success:^(id obj) {
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
    return self.relatives.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"relativeCell"];
    cell.editBtn.hidden = YES;
    Relative *relative = self.relatives[indexPath.row];
    cell.pushNum.text = [NSString stringWithFormat:@"( 按键 %@）",relative.key];
    cell.phoneNum.text = [NSString stringWithFormat:@"亲情号码：%@",relative.number];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (NSArray<Relative *> *)relatives{
    if (!_relatives) {
        _relatives = [@[] copy];
    }
    return _relatives;
}
@end
