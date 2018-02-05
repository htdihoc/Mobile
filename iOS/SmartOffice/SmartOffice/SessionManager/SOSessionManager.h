//
//  SOSessionManager.h
//  SmartOffice
//
//  Created by Kaka on 5/3/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTNSSessionModel.h"

@class VOfficeSessionModel;

@interface SOSessionManager : NSObject{
	
}
//Model
@property (strong, nonatomic) VOfficeSessionModel *vofficeSession;
@property (strong, nonatomic) TTNSSessionModel *ttnsSession;


//Singleton
+ (instancetype)sharedSession;

- (void)saveData;
- (void)clearData;

@end
