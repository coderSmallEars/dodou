//
//  Record.h
//  DuDou
//
//  Created by jinyulong on 2017/6/6.
//  Copyright © 2017年 GhostShell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Record : NSObject

@property (nonatomic, copy) NSString *abnormal;
@property (nonatomic, copy) NSString *className;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *deviceId;
@property (nonatomic, copy) NSString *student_id;
@property (nonatomic, copy) NSString *personId;
@property (nonatomic, copy) NSString *personName;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *rfid;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *updateTime;
@property (nonatomic, copy) NSString *type;
/*
 "abnormal": false,
 "className": "AttendanceRecord",
 "createTime": "2017-05-21 17:55:42",
 "deviceId": "116",
 "id": 224,
 "personId": "43",
 "personName": "艳艳",
 "phone": "13723722440",
 "rfid": "0024806028",
 "time": "2017-05-21 17:55:06",
 "type": "in",
 "updateTime": null
 */

@end
