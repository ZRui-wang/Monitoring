//
//  DLAPIClient.h
//  Dualens
//
//  Created by kede on 2017/2/13.
//  Copyright © 2017年 JK. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface DLAPIClient : AFHTTPSessionManager

+ (instancetype)sharedClient;
+ (NSString*) getAbsoluteURLWithRelative:(NSString*) url;

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;


- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(nullable id)parameters
     constructingBodyWithBlock:(nullable void (^)(id<AFMultipartFormData> _Nonnull))block
                       success:(nullable void (^)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject))success
                       failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure;

@end
