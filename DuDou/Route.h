//
//  Route.h
//  DuDou
//
//  Created by jinyulong on 2017/6/6.
//  Copyright © 2017年 GhostShell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Route : NSObject

@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSNumber *lat;
@property (nonatomic, copy) NSNumber *lng;
@property (nonatomic, copy) NSString *personName;
@property (nonatomic, copy) NSString *logTime;

/*
 className = LocationRecord;
 coordinate = "";
 createTime = "2017-06-06 20:45:42";
 desc = "\U6d59\U6c5f\U7701\U5b81\U6ce2\U5e02\U8c61\U5c71\U53bf\U7235\U6eaa\U8857\U9053\U65b0\U7235\U8def9\U53f7";
 direction = "";
 height = "<null>";
 id = 2652247;
 imei = 864426018060287;
 isSos = 1;
 lat = "29.476467";
 latZone = N;
 lng = "121.95518";
 lngZone = E;
 logTime = "2017-06-06 20:45:42";
 personId = 43;
 personName = " \U76db\U76db";
 phone = "";
 rfid = "";
 safeCardId = 11703;
 simcard = 13723722440;
 speed = "";
 time = "2017-06-06 20:45:45";
 timeZone = E8;
 type = WiFi;
 updateTime = "<null>";
 */

@end
