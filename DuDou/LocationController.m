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
        }else{
            NSLog(@"获取位置信息失败");
        }
    } failure:^(id obj) {
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
        _mapView.delegate = self;
//        ///把地图添加至view
//        _mapView.showsUserLocation = YES;
//        _mapView.userTrackingMode = MAUserTrackingModeFollow;
//        MAUserLocationRepresentation *r = [[MAUserLocationRepresentation alloc] init];
//        r.showsAccuracyRing = NO;///精度圈是否显示，默认YES
//        r.showsHeadingIndicator = NO;///是否显示方向指示(MAUserTrackingModeFollowWithHeading模式开启)。默认为YES
//        r.fillColor = [UIColor redColor];///精度圈 填充颜色, 默认 kAccuracyCircleDefaultColor
//        r.strokeColor = [UIColor blueColor];///精度圈 边线颜色, 默认 kAccuracyCircleDefaultColor
//        r.lineWidth = 2;///精度圈 边线宽度，默认0
//        
//        r.image = [UIImage imageNamed:@"你的图片"]; ///定位图标, 与蓝色原点互斥
//        [_mapView updateUserLocationRepresentation:r];
    }
    return _mapView;
}

- (NSMutableArray *)annotations{
    if (!_annotations) {
        _annotations = [@[] mutableCopy];
    }
    return _annotations;
}

@end
