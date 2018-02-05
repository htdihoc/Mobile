//
//  InfoEmployCheckOut.h
//  SmartOffice
//
//  Created by NguyenVanTu on 4/14/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SOBaseModel.h"
@interface InfoEmployCheckOut : SOBaseModel
@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) UIImage *img;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *time;
-(instancetype)initWithImg:(UIImage *)img
                      name:(NSString *)name
                    content:(NSString *)content
                       time:(NSString *)time;
@end
