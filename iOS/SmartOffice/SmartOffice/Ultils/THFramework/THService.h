//
//  THService.h
//  SmartOffice
//
//  Created by Nguyen Thanh Huy on 3/28/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "Config.h"
#import "GlobalObj.h"
#import "Common.h"
#import "Constants.h"

@interface THService : NSObject

// get with param
+ (void)requestGETFromUrl:(NSString *)URL parameter:(NSDictionary *)parameters withProgress:(void (^)(float progress))progressBlock completion:(void (^)(NSDictionary *response))completionBlock onError:(void (^)(NSDictionary *error))errorBlock onException:(void (^)(NSException *exception))exceptionBlock;


+ (void)requestGETFromUrl:(NSString *)URL withProgress:(void (^)(float progress))progressBlock completion:(void (^)(NSDictionary *response))completionBlock onError:(void (^)(NSDictionary *error))errorBlock onException:(void (^)(NSException *exception))exceptionBlock;

+ (void)requestGETFromUrl:(NSString *)URL withToken:(NSDictionary *)token parameter:(NSDictionary *)parameters withProgress:(void (^)(float))progressBlock completion:(void (^)(NSDictionary *))completionBlock onError:(void (^)(NSDictionary *))errorBlock onException:(void (^)(NSException *))exceptionBlock;

+ (void) requestPOSTFromUrl: (NSString *)URL parameter:(NSDictionary *)parameters withProgress:(void (^)(float progress))progressBlock completion:(void (^)(NSDictionary *response))completionBlock onError:(void (^)(NSDictionary *error))errorBlock onException:(void (^)(NSException *exception))exceptionBlock;

+ (void) requestPOSTFromUrl: (NSString *)URL withToken:(NSDictionary*)token parameter:(NSDictionary *)parameters withProgress:(void (^)(float progress))progressBlock completion:(void (^)(NSDictionary *response))completionBlock onError:(void (^)(NSDictionary *error))errorBlock onException:(void (^)(NSException *exception))exceptionBlock;

@end
