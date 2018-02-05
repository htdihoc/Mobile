//
//  SOSessionManager.m
//  SmartOffice
//
//  Created by Kaka on 5/3/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "SOSessionManager.h"
#import "VOfficeSessionModel.h"

//key
static NSString *kSOVOfficeSessionKey   = @"kSOVOfficeSessionKey";
static NSString *kSOTTNSSessionKey      = @"kSOTTNSSessionKey";

@implementation SOSessionManager
	
+ (instancetype)sharedSession{
	static SOSessionManager *_sharedInstance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_sharedInstance = [SOSessionManager new];
	});
	
	return _sharedInstance;
}

- (id)init{
	self = [super init];
	if (self) {
		self.vofficeSession = nil;
        self.ttnsSession    = [TTNSSessionModel new];
	}
	return  self;
}


//voffice session Object
/*
- (VOfficeSessionModel *)vofficeSession {
	if (!_vofficeSession) {
		// Get Current Token
		NSDictionary *comDict = [USER_DEFAULT objectForKey:kSOVOfficeSessionKey];
		if (!comDict && ![comDict isKindOfClass:[NSDictionary class]]) {
			return nil;
		}
		_vofficeSession = [[VOfficeSessionModel alloc] initWithDictionary:comDict error:nil];
		
	}
	return _vofficeSession;
}
*/


#pragma mark - Util Session
- (void)saveData{
	/* No Need use this now
	//Store vOfficeSessionDict to dictionary
	if (_vofficeSession) {
		NSDictionary *vOfficeSessionDict = [self.vofficeSession toDictionary];
		[USER_DEFAULT setObject:vOfficeSessionDict forKey:kSOVOfficeSessionKey];
	}
    
    // Store TTNSSessionDict to dictionary
    if(_ttnsSession){
        NSDictionary *ttnsSessionDict = [self.ttnsSession toDictionary];
        [USER_DEFAULT setObject:ttnsSessionDict forKey:kSOTTNSSessionKey];
    }
	//Syn data
	[USER_DEFAULT synchronize];
	 */
}

- (void)clearData{
	/* No Need use this now
	_vofficeSession = nil;
	[USER_DEFAULT removeObjectForKey:kSOVOfficeSessionKey];
	
    _ttnsSession    = nil;
    [USER_DEFAULT removeObjectForKey:kSOTTNSSessionKey];
    
	//Keep this until logout
	[USER_DEFAULT synchronize];
	 */
}

@end
