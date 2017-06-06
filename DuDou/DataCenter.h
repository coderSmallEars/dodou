//
//  DataCenter.h
//  DuDou
//
//  Created by jinyulong on 2017/6/5.
//  Copyright © 2017年 GhostShell. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Student;

static NSString *const base = @"http://www.jytechjxt.com.cn:8080/";
static NSString *const ctx = @"http://www.jytechjxt.com.cn:8080/jxt/mobile/";

#define DataCengerSingleton [DataCenter singleton]

@interface DataCenter : NSObject

+ (instancetype)singleton;
@property (nonatomic, copy) NSArray <Student *>*students;

- (void)getDataWithPath:(NSString *)path params:(NSDictionary *)params success:(ObjBlock)success failure:(ObjBlock)failure;

- (void)postDataWithPath:(NSString *)path params:(NSDictionary *)params success:(ObjBlock)success failure:(ObjBlock)failure;

@end
