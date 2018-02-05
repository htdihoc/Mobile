//
//  UserModel.h
//  SmartOffice
//
//  Created by Hien Tuong on 4/12/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SOBaseModel.h"

@interface UserModel : SOBaseModel{
    
}
@property (assign, nonatomic) NSInteger userId;
@property (assign, nonatomic) NSString* avatar;
@property (assign, nonatomic) NSString* username;
@property (assign, nonatomic) NSString* fullname;
@property (assign, nonatomic) NSInteger sex;
@property (assign, nonatomic) NSString* position;

@end
