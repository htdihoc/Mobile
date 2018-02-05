//
//  THService.m
//  SmartOffice
//
//  Created by Nguyen Thanh Huy on 3/28/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "THService.h"
#import "SOSessionManager.h"

static NSTimeInterval TIME_OUT = 30;

@implementation THService

+ (void)requestGETFromUrl:(NSString *)URL withToken:(NSDictionary *)token parameter:(NSDictionary *)parameters withProgress:(void (^)(float))progressBlock completion:(void (^)(NSDictionary *))completionBlock onError:(void (^)(NSDictionary *))errorBlock onException:(void (^)(NSException *))exceptionBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = TIME_OUT;
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSString *headerCookie = [[NSString alloc] init];
    headerCookie = @"";
    if ([@"userToken" length] > 0) {
        headerCookie = [NSString stringWithFormat:@"{\"currentUser\":\"%@\",\"token\":\"%@\"}", @"UserObj-to-StringJSON", [GlobalObj getInstance].userSession];
    }
    
    [manager.requestSerializer setValue:[headerCookie stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forHTTPHeaderField:@"Cookie"];
    
    //[manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", [GlobalObj getInstance].userSession] forHTTPHeaderField:@"Authorization"];
	[manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", @"sasasaa"] forHTTPHeaderField:@"Authorization"];

    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    if (token) {
        [manager.requestSerializer setValue:token.allValues.firstObject forHTTPHeaderField:token.allKeys.firstObject];
    }
    NSURLSessionTask *taskGet = [manager GET:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        if(progressBlock) {
            progressBlock(downloadProgress.fractionCompleted);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @try {
            NSDictionary *tmpDict = (NSDictionary *)responseObject;
            NSString *errCode = [[responseObject objectForKey:@"resultCode"] description];
            if ([errCode isEqualToString:API_ERR_CODE_SUCCESS]) {
                NSLog(@"Execute GET request success! %@", tmpDict);
                if (completionBlock) {
                    completionBlock(responseObject);
                }
            }
            else {
                NSLog(@"Execute GET request fail! %@", tmpDict);
                if (errorBlock) {
                    errorBlock(tmpDict);
                }
            }
            
        } @catch (NSException *exception) {
            /*NSDictionary *tmpDict = @{@"Exception":exception.description};
             if (errorBlock) {
             errorBlock(tmpDict);
             }*/
            if (exceptionBlock) {
                exceptionBlock(exception);
            }
        } @finally {
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        /*NSDictionary *tmpDict = @{@"Error":error.description};
         if (errorBlock) {
         errorBlock(tmpDict);
         }*/
        NSException *exception = [NSException exceptionWithName:@"requestGET" reason:error.description userInfo:error.userInfo];
        if (exceptionBlock) {
            exceptionBlock(exception);
        }
    }];
    
    [taskGet resume];
}

+ (void)requestGETFromUrl:(NSString *)URL parameter:(NSDictionary *)parameters withProgress:(void (^)(float))progressBlock completion:(void (^)(NSDictionary *))completionBlock onError:(void (^)(NSDictionary *))errorBlock onException:(void (^)(NSException *))exceptionBlock{
    [THService requestGETFromUrl:URL withToken:nil parameter:parameters withProgress:^(float downloadProgress) {
		if (progressBlock) {
			progressBlock(downloadProgress);
		}
    } completion:^(NSDictionary *response) {
        completionBlock(response);
    } onError:^(NSDictionary *error) {
        errorBlock(error);
    } onException:^(NSException *exception) {
        exceptionBlock(exception);
    }];
}

+ (void)requestGETFromUrl:(NSString *)URL withProgress:(void (^)(float progress))progressBlock completion:(void (^)(NSDictionary *response))completionBlock onError:(void (^)(NSDictionary *error))errorBlock onException:(void (^)(NSException *exception))exceptionBlock
{
    [THService requestGETFromUrl:URL withToken:nil parameter:nil withProgress:^(float downloadProgress) {
        if (progressBlock) {
            progressBlock(downloadProgress);
        }
    } completion:^(NSDictionary *response) {
        completionBlock(response);
    } onError:^(NSDictionary *error) {
        errorBlock(error);
    } onException:^(NSException *exception) {
        exceptionBlock(exception);
    }];
}

+ (void)requestPOSTFromUrl:(NSString *)URL withToken:(NSDictionary *)token parameter:(NSDictionary *)parameters withProgress:(void (^)(float))progressBlock completion:(void (^)(NSDictionary *))completionBlock onError:(void (^)(NSDictionary *))errorBlock onException:(void (^)(NSException *))exceptionBlock{
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = TIME_OUT;
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSString *headerCookie = [[NSString alloc] init];
    headerCookie = @"";
    if ([@"userToken" length] > 0) {
        headerCookie = [NSString stringWithFormat:@"{\"currentUser\":\"%@\",\"token\":\"%@\"}", @"UserObj-to-StringJSON", [GlobalObj getInstance].userSession];
    }
    
    [manager.requestSerializer setValue:[headerCookie stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forHTTPHeaderField:@"Cookie"];
    
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", [GlobalObj getInstance].userSession] forHTTPHeaderField:@"Authorization"];
    
    if (token) {
        [manager.requestSerializer setValue:token.allValues.firstObject forHTTPHeaderField:token.allKeys.firstObject];
    }
    
    NSURLSessionTask *taskPost = [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progressBlock) {
            progressBlock(uploadProgress.fractionCompleted);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *tmpDict = (NSDictionary *)responseObject;
        NSInteger resultCode = [tmpDict[@"resultCode"] integerValue];
        if (resultCode == RESP_CODE_SUCCESS || resultCode == RESP_CODE_SUCCESS_VT) {
            if (completionBlock) {
                completionBlock(responseObject);
            }
        }
        else {
            if (errorBlock) {
                errorBlock(tmpDict);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSException *exception = [NSException exceptionWithName:@"requestPOST" reason:error.description userInfo:error.userInfo];
        if (exceptionBlock) {
            exceptionBlock(exception);
        }
    }];
    
    [taskPost resume];
}



+ (void) requestPOSTFromUrl:(NSString *)URL parameter:(NSDictionary *)parameters withProgress:(void (^)(float))progressBlock completion:(void (^)(NSDictionary *))completionBlock onError:(void (^)(NSDictionary *))errorBlock onException:(void (^)(NSException *))exceptionBlock{
    
    [THService requestPOSTFromUrl:URL withToken:nil parameter:parameters withProgress:nil completion:^(NSDictionary *response) {
        completionBlock(response);
    } onError:^(NSDictionary *error) {
        errorBlock(error);
    } onException:^(NSException *exception) {
        exceptionBlock(exception);
    }];
}



#pragma mark - Parse Param to URL
+ (NSString*)urlEscapeString:(NSString *)unencodedString
{
    CFStringRef originalStringRef = (__bridge_retained CFStringRef)unencodedString;
    NSString *s = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,originalStringRef, NULL, NULL,kCFStringEncodingUTF8);
    CFRelease(originalStringRef);
    return s;
}


+ (NSString*)addQueryStringToUrlString:(NSString *)urlString withDictionary:(NSDictionary *)dictionary
{
    NSMutableString *urlWithQuerystring = [[NSMutableString alloc] initWithString:urlString];
    
    for (id key in dictionary) {
        NSString *keyString = [key description];
        NSString *valueString = [[dictionary objectForKey:key] description];
        
        if ([urlWithQuerystring rangeOfString:@"?"].location == NSNotFound) {
            [urlWithQuerystring appendFormat:@"?%@=%@", [self urlEscapeString:keyString], [self urlEscapeString:valueString]];
        } else {
            [urlWithQuerystring appendFormat:@"&%@=%@", [self urlEscapeString:keyString], [self urlEscapeString:valueString]];
        }
    }
    return urlWithQuerystring;
}


@end
