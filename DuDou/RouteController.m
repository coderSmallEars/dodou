//
//  RouteController.m
//  DuDou
//
//  Created by jinyulong on 2017/6/5.
//  Copyright © 2017年 GhostShell. All rights reserved.
//

#import "RouteController.h"
#import "NIDropDown.h"
#import "Route.h"


@interface RouteController ()<MAMapViewDelegate,NIDropDownDelegate>
{
    NIDropDown *dropDown;
}
@property (nonatomic ,strong) MAMapView *mapView;
@property (nonatomic, strong) Student *selectedStudent;
@property (nonatomic, strong) NSMutableArray *annotations;
@property (nonatomic, strong) NSString *selectedDay;
@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, copy) NSArray <Route*>*routes;
@property (nonatomic, strong) id overLay;
@property (nonatomic, strong) MAAnimatedAnnotation *annotation;

@end

@implementation RouteController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"轨迹";
    [self.view addSubview:self.mapView];
    self.selectedDate = [NSDate date];
    self.selectedDay = [self nsdateToString:[NSDate date]];
    self.dateLabel.text = self.selectedDay;
    if (DataCengerSingleton.students.count > 0) {
        [self changeStudentBtnTitle:StringNotNull([DataCengerSingleton.students.firstObject name])];
        self.selectedStudent = DataCengerSingleton.students.firstObject;
        [self requestStudentRoute];
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

- (IBAction)lastDayAction:(UIButton *)sender {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.day = -1;
    self.selectedDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self.selectedDate options:0];
    self.selectedDay = [self nsdateToString:self.selectedDate];
    [self requestStudentRoute];
}

- (IBAction)nextDayAction:(id)sender {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.day = +1;
    self.selectedDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self.selectedDate options:0];
    self.selectedDay = [self nsdateToString:self.selectedDate];
    [self requestStudentRoute];
}


- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    self.selectedStudent = sender.student;
    [self rel];
    [self requestStudentRoute];
}

-(void)rel{
    //    [dropDown release];
    dropDown = nil;
}

- (void)changeStudentBtnTitle:(NSString *)title{
    [self.studentBtn setTitle:title forState:UIControlStateNormal];
}

- (void)requestStudentRoute{
    self.dateLabel.text = self.selectedDay;
    NSMutableDictionary *params = [@{} mutableCopy];
    [params setObject:StringNotNull(self.selectedStudent.mobile) forKey:@"mobile"];
    [params setObject:[NSString stringWithFormat:@"%@ 00:00:00",self.selectedDay] forKey:@"startTime"];
     [params setObject:[NSString stringWithFormat:@"%@ 23:59:59",self.selectedDay] forKey:@"endTime"];
    [DataCengerSingleton getDataWithPath:[NSString stringWithFormat:@"%@lbs/locationRecord/list",base] params:params success:^(id obj) {
        if (Valid_Array(obj)) {
            NSMutableArray *tempRoute = [@[] mutableCopy];
            for (NSDictionary *dic in obj) {
                Route *route = [Route modelWithJSON:dic];
                [tempRoute addObject:route];
            }
            self.routes = [tempRoute copy];
            [self drawLines];
        }
    } failure:^(id obj) {
        
    }];
}

- (void)drawLines{
    //构造折线数据对象
    if (!self.routes.count) {
        [self clreanAnnotationInfo];
        [self.view postProgressHudWithMessage:@"无法获取有效的位置信息"];
        return ;
    }
    CLLocationCoordinate2D commonPolylineCoords[self.routes.count];
    for (int i = 0; i < self.routes.count; i++) {
        Route *route = self.routes[i];
        commonPolylineCoords[i].latitude = [NumberNotNull(route.lat) doubleValue];;
        commonPolylineCoords[i].longitude = [NumberNotNull(route.lng) doubleValue];;
    }
    MAPolyline *commonPolyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:self.routes.count];
    [self.mapView addOverlay: commonPolyline];
    self.overLay = commonPolyline;
    
    [self annotationAnimation:commonPolylineCoords];
    Route *route = self.routes.firstObject;
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(NumberNotNull(route.lat).doubleValue, NumberNotNull(route.lng).doubleValue) animated:YES];
}

- (void)clreanAnnotationInfo{
    if (self.overLay) {
        [self.mapView removeOverlay:self.overLay];
    }
    for (MAAnnotationMoveAnimation *animation in [self.annotation allMoveAnimations]) {
        [animation cancel];
    }
    [self.mapView removeAnnotation:self.annotation];
}

- (void)annotationAnimation:(CLLocationCoordinate2D *)commonPolylineCoords{
    self.annotation.coordinate = commonPolylineCoords[0];
    

    [self.annotation addMoveAnimationWithKeyCoordinates:commonPolylineCoords count:self.routes.count withDuration:0.3 * self.routes.count withName:nil completeCallback:^(BOOL isFinished) {
    }];
    [self.mapView addAnnotation:self.annotation];
}

- (void)showPositionOnMap:(NSDictionary *)info{
    CLLocationDegrees lat = [NumberNotNull(info[@"lat"]) doubleValue];
    CLLocationDegrees lng = [NumberNotNull(info[@"lng"]) doubleValue];
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.title = StringNotNull(info[@"personName"]);
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(lat, lng);
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(lat, lng)];
    [self.mapView addAnnotation:pointAnnotation];
//    [self.annotations addObject:pointAnnotation];
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        
        polylineRenderer.lineWidth    = 8.f;
        polylineRenderer.strokeColor  = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.6];
        return polylineRenderer;
    }
    return nil;
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

-(NSString*)nsdateToString:(NSDate *)date
{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString* string=[dateFormat stringFromDate:date];
    return string;
}

- (MAMapView *)mapView{
    if (!_mapView) {
        
        [AMapServices sharedServices].enableHTTPS = YES;
        _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, self.view.top + 100, self.view.width, self.view.bottom - 70)];
        _mapView.delegate = self;
    }
    return _mapView;
}

- (NSMutableArray *)annotations{
    if (!_annotations) {
        _annotations = [@[] mutableCopy];
    }
    return _annotations;
}

- (MAAnimatedAnnotation *)annotation{
    if (!_annotation) {
        _annotation = [[MAAnimatedAnnotation alloc] init];
    }
    return _annotation;
}

@end
