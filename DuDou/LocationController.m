//
//  LocationController.m
//  DuDou
//
//  Created by jinyulong on 2017/6/5.
//  Copyright © 2017年 GhostShell. All rights reserved.
//

#import "LocationController.h"
#import "NIDropDown.h"

@interface LocationController ()<MAMapViewDelegate,NIDropDownDelegate>
{
    NIDropDown *dropDown;
}
@property (nonatomic ,strong) MAMapView *mapView;
@property (nonatomic, strong) Student *selectedStudent;
@property (nonatomic, strong) NSMutableArray *annotations;

@property (weak, nonatomic) IBOutlet UILabel *hintView;
@property (nonatomic, strong) UILabel *hintLabel;

@end

@implementation LocationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"定位";
    [self.view addSubview:self.mapView];    
    [self requestStudents];
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
    [self requestStudentLocation];
}

-(void)rel{
    //    [dropDown release];
    dropDown = nil;
}

- (void)changeStudentBtnTitle:(NSString *)title{
    [self.studentBtn setTitle:title forState:UIControlStateNormal];
}

- (void)requestStudents{
    [DataCengerSingleton getDataWithPath:[NSString stringWithFormat:@"%@listMyChildren",ctx] params:nil success:^(id obj) {
        if (!Valid_Array(obj)) {
        }
        NSMutableArray *mutibleStudents = [@[] mutableCopy];
        for (NSDictionary *dic in obj) {
            if (!Valid_Dictionary(dic)) {
                continue;
            }
            Student *student = [Student modelWithJSON:dic];
            [mutibleStudents addObject:student];
        }
        DataCengerSingleton.students = [mutibleStudents copy];
        if (mutibleStudents.count > 0) {
            [self changeStudentBtnTitle:StringNotNull([mutibleStudents.firstObject name])];
            self.selectedStudent = mutibleStudents.firstObject;
            [self requestStudentLocation];
        }
    } failure:^(id obj) {
        NSLog(@"获取学生信息失败");
    }];
}

- (void)requestStudentLocation{
    [DataCengerSingleton getDataWithPath:[NSString stringWithFormat:@"%@lbs/locationRecord/last",base] params:@{@"mobile":StringNotNull(self.selectedStudent.mobile)} success:^(id obj) {
        if (Valid_Dictionary(obj)) {
            [self showPositionOnMap:obj];
            [self setHintView:obj];
        }else{
            NSLog(@"获取位置信息失败");
            [self setHintView:nil];
        }
    } failure:^(id obj) {
        [self setHintView:nil];
        NSLog(@"获取位置信息失败");
    }];
}

- (void)showPositionOnMap:(NSDictionary *)info{
    if (self.annotations.count > 0) {
        [self.mapView removeAnnotations:self.annotations];
        [self.annotations removeAllObjects];
    }
    CLLocationDegrees lat = [NumberNotNull(info[@"lat"]) doubleValue];
    CLLocationDegrees lng = [NumberNotNull(info[@"lng"]) doubleValue];
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.title = StringNotNull(info[@"personName"]);
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(lat, lng);
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(lat, lng)];
    [self.mapView addAnnotation:pointAnnotation];
    [self.annotations addObject:pointAnnotation];
}

- (void)setHintView:(NSDictionary *)info{
    if (!Valid_Dictionary(info)) {
        self.hintView.text = nil;
        return;
    }
    NSString *time =[NSString stringWithFormat:@"时间：%@",info[@"time"]];
    NSString *desc = [NSString stringWithFormat:@"%@",info[@"desc"]];
    NSString *location = [NSString stringWithFormat:@"经纬度：[%f,%f]。",[NumberNotNull(info[@"lat"]) doubleValue],[NumberNotNull(info[@"lng"]) doubleValue]];
    NSString *content = [NSString stringWithFormat:@"%@\n%@\n%@\n提示：10分钟后刷新",time,desc,location];
    self.hintView.text = content;
    NSLog(@"%@", content);
    self.hintLabel.text = content;
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorPurple;
        return annotationView;
    }
    return nil;
}

- (MAMapView *)mapView{
    if (!_mapView) {
        
        [AMapServices sharedServices].enableHTTPS = YES;
        _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, self.view.top + 70, self.view.width, self.view.bottom - 70)];
        _mapView.delegate = self;    }
    return _mapView;
}

- (NSMutableArray *)annotations{
    if (!_annotations) {
        _annotations = [@[] mutableCopy];
    }
    return _annotations;
}

- (UILabel *)hintLabel{
    if (!_hintLabel) {
        _hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bottom - 84, 0, kScreenWidth, 84)];
        _hintLabel.numberOfLines = 4;
    }
    return _hintLabel;
}

@end
