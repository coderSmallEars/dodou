//
//  DataCenter.m
//  DuDou
//
//  Created by jinyulong on 2017/6/5.
//  Copyright © 2017年 GhostShell. All rights reserved.
//

#import "DataCenter.h"
#import "Student.h"

@interface DataCenter ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong) AFHTTPRequestSerializer *httpRequestSerializer;
@property (nonatomic, strong) AFJSONRequestSerializer *jsonRequestSerializer;

@end

@implementation DataCenter

+ (instancetype)singleton{
    static DataCenter *dataCenter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataCenter = [DataCenter new];
    });
    return dataCenter;
}

- (void)getDataWithPath:(NSString *)path params:(NSDictionary *)params success:(ObjBlock)success failure:(ObjBlock)failure{
    NSURLRequest *request = [self generateGETRequestWithPath:path requestParams:params];
    [self dataWithRequest:request success:success failure:failure];
}

- (void)postDataWithPath:(NSString *)path params:(NSDictionary *)params success:(ObjBlock)success failure:(ObjBlock)failure{
    NSURLRequest *request = [self generatePOSTRequestWithPath:path requestParams:params];
    [self dataWithRequest:request success:success failure:failure];
}

- (void)dataWithRequest:(NSURLRequest *)request success:(ObjBlock)success failure:(ObjBlock)failure{
    NSLog(@"%@",request.URL.absoluteString);
    [[self.manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            if (failure) {
                failure(error.description);
                return ;
            }
        }else{
            if (!Valid_Dictionary(responseObject)) {
                if (failure) {
                    failure(error.description);
                    return ;
                }
            }
            if (NumberNotNull([responseObject objectForKey:@"success"]).boolValue) {
                if (success) {
                    success(responseObject[@"result"]);
                }
                return ;
            }
            if (failure) {
                failure(error.description);
                return;
            }
        }
    }] resume];
}

- (NSURLRequest *)generateGETRequestWithPath:(NSString *)path requestParams:(NSDictionary *)requestParams{
    NSMutableURLRequest *request = [self.jsonRequestSerializer requestWithMethod:@"GET" URLString:StringNotNull(path) parameters:requestParams error:NULL];
    request.timeoutInterval = 20;
    return request;
}

- (NSURLRequest *)generatePOSTRequestWithPath:(NSString *)path requestParams:(NSDictionary *)requestParams{
    self.httpRequestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
    NSMutableURLRequest *request = [self.jsonRequestSerializer requestWithMethod:@"POST" URLString:StringNotNull(path)  parameters:requestParams error:NULL];
    request.timeoutInterval = 20;
    return request;
}


- (AFHTTPSessionManager *)manager{
    if (!_manager) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
        AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
        _manager.responseSerializer = responseSerializer;
    }
    return _manager;
}

- (AFHTTPRequestSerializer *)httpRequestSerializer
{
    if (_httpRequestSerializer == nil) {
        _httpRequestSerializer = [AFHTTPRequestSerializer serializer];
        _httpRequestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
        _httpRequestSerializer.timeoutInterval = 20;
        [_httpRequestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }
    return _httpRequestSerializer;
}

- (AFJSONRequestSerializer *)jsonRequestSerializer{
    if (!_jsonRequestSerializer) {
        _jsonRequestSerializer = [AFJSONRequestSerializer serializer];
        _jsonRequestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
        _jsonRequestSerializer.timeoutInterval = 20;
        [_jsonRequestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }
    return _jsonRequestSerializer;
}

- (NSArray<Student *> *)students{
    if (!_students) {
        _students = [@[] copy];
    }
    return  _students;
}
@end
