//
//  DLAPIClient.m
//  Dualens
//
//  Created by kede on 2017/2/13.
//  Copyright © 2017年 JK. All rights reserved.
//

#import "DLAPIClient.h"


@implementation DLAPIClient

+ (instancetype)sharedClient {
    static DLAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[DLAPIClient alloc] init];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        _sharedClient.requestSerializer = [AFHTTPRequestSerializer serializer];

        [_sharedClient.requestSerializer setValue:@"iOS" forHTTPHeaderField:@"DevicePlatform"];
        
        //how to use query string in POST method
        _sharedClient.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithArray:@[@"POST", @"GET", @"HEAD",@"DELETE"]];//此方法会把body中的内容自动拼接到URL中
    });
    
    //AFNetWorking默认超时为60s，暂不修改
    //    [_sharedClient.requestSerializer setTimeoutInterval: 5.0];
    _sharedClient.baseURL = [NSURL URLWithString:kLINK_HOST];
    return _sharedClient;
}


+ (NSString*) getAbsoluteURLWithRelative:(NSString*) url {
    if(!url)
        return nil;
    return [NSString stringWithFormat:@"%@%@", kLINK_HOST, url];
}

#pragma mark --- afnetworking 旧方法弃用, 重写方法 调用 新方法
- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    return [self POST:URLString parameters:parameters progress:nil success:success failure:failure];
}


- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{

    return [self GET:URLString parameters:parameters progress:nil success:success failure:failure];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(nullable id)parameters
     constructingBodyWithBlock:(nullable void (^)(id<AFMultipartFormData> _Nonnull))block
                       success:(nullable void (^)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject))success
                       failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure 
{
    return [self POST:URLString parameters:parameters constructingBodyWithBlock:block progress:nil success:success failure:failure];
}

@end
