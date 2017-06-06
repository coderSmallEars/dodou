//
//  RecordController.m
//  DuDou
//
//  Created by jinyulong on 2017/6/5.
//  Copyright © 2017年 GhostShell. All rights reserved.
//

#import "RecordController.h"
#import "MyCalendarItem.h"
#import "Record.h"
#import "RecordCell.h"

@interface RecordController ()<NIDropDownDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NIDropDown *dropDown;
}
@property (nonatomic, copy) NSArray <Record *>*records;
@property (nonatomic, strong) Student *selectedStudent;
@property (nonatomic, strong) NSMutableArray *annotations;
@property (nonatomic, strong) MyCalendarItem *calendarView;

@property (weak, nonatomic) IBOutlet UIButton *studentBtn;
@property (weak, nonatomic) IBOutlet UIView *calenderBgView;

@property (nonatomic, strong) NSString *selectDay;

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (nonatomic, strong) UILabel *footLabel;
@end

@implementation RecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"考勤";
    self.listTableView.tableFooterView = self.footLabel;
    [self.listTableView registerNib:[UINib nibWithNibName:@"RecordCell" bundle:nil] forCellReuseIdentifier:@"recordCell"];
    [self.calenderBgView addSubview:self.calendarView];
    self.selectDay= [self nsdateToString:[NSDate date]];
    
    if (DataCengerSingleton.students.count > 0) {
        [self changeStudentBtnTitle:StringNotNull([DataCengerSingleton.students.firstObject name])];
        self.selectedStudent = DataCengerSingleton.students.firstObject;
        [self requestStudentRecord];
    }
}
- (IBAction)dataChanged:(UIDatePicker *)sender {
    [self requestStudentRecord];
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
    [self requestStudentRecord];
}

-(void)rel{
    dropDown = nil;
}

- (void)changeStudentBtnTitle:(NSString *)title{
    [self.studentBtn setTitle:title forState:UIControlStateNormal];
}

- (void)requestStudentRecord{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSLog(@"%@",self.selectDay);
    NSMutableDictionary *params = [@{} mutableCopy];
    [params setObject:StringNotNull(self.selectedStudent.mobile) forKey:@"mobile"];
    [params setObject:[NSString stringWithFormat:@"%@ 00:00:00",self.selectDay] forKey:@"startTime"];
    [params setObject:[NSString stringWithFormat:@"%@ 23:59:59",self.selectDay] forKey:@"endTime"];
    [DataCengerSingleton getDataWithPath:[NSString stringWithFormat:@"%@lbs/attendance/listByMobile",base] params:params success:^(id obj) {
        if (Valid_Array(obj)) {
            NSMutableArray *mutableRecords = [@[] mutableCopy];
            for (NSDictionary *dic in obj) {
                Record *record = [Record modelWithJSON:dic];
                [mutableRecords addObject:record];
            }
            self.records = [mutableRecords copy];
        }
        [self.listTableView reloadData];
        self.footLabel.text = self.records.count ? @"":@"没有找到考勤信息";
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(id obj) {
        [self.listTableView reloadData];
        self.footLabel.text = self.records.count ? @"":@"没有找到考勤信息";
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.records.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recordCell"];
    Record *record = self.records[indexPath.row];
    if ([StringNotNull(record.type) isEqualToString:@"in"]) {
        cell.indicateLabel.text = @"入";
        cell.indicateLabel.backgroundColor = [UIColor blueColor];
        cell.contentLabel.text = [NSString stringWithFormat:@"%@ 进入学校",record.time];
    }else{
        cell.indicateLabel.text = @"出";
        cell.indicateLabel.backgroundColor = [UIColor redColor];
        cell.contentLabel.text = [NSString stringWithFormat:@"%@ 离开学校",record.time];
    }
    return cell;
}


- (NSArray<Record *> *)records{
    if (!_records) {
        _records = [@[] copy];
    }
    return _records;
}

- (MyCalendarItem *)calendarView{
    if (!_calendarView) {
        _calendarView = [[MyCalendarItem alloc] init];
        _calendarView.frame = CGRectMake(0, 0, kScreenWidth, 218);
        _calendarView.date = [NSDate date];
        @weakify(self)
        _calendarView.calendarBlock =  ^(NSInteger day, NSInteger month, NSInteger year){
            @strongify(self)
            self.selectDay = [NSString stringWithFormat:@"%li-%02li-%02li", year,month,day];
            [self requestStudentRecord];
        };
    }
    return _calendarView;
}

-(NSString*)nsdateToString:(NSDate *)date
{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString* string=[dateFormat stringFromDate:date];
    return string;
}

- (UILabel *)footLabel{
    if (!_footLabel) {
        _footLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];;
    }
    return _footLabel;
}


@end
