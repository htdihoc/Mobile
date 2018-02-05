//
//  Common.m
//  SpeedTest
//
//  Created by Nguyen Thanh Huy on 7/10/16.
//  Copyright © 2016 Nguyen Thanh Huy. All rights reserved.
//

#import "Common.h"
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "NSDate+Utilities.h"
#import "WorkModel.h"
#import "MissionModel.h"
#import "SO_HUDCustomView.h"
#import "MeetingModel.h"
#import "UserRoleModel.h"
#import "SO_TTNSHUBCustomView.h"
#import "UIImage+Resize.h"
#import "Constants.h"
@interface Common()<MBProgressHUDDelegate>{
	MBProgressHUD *_hud;
	MBProgressHUD *_customHUD;
    
    MBProgressHUD *_ttnsHUD;
    NSInteger _numberOfHub;
}

@end

@implementation Common

+ (Common *)shareInstance{
	static Common *_instance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_instance = [[Common alloc] init];
        _instance.canShowHub = YES;
	});
	
	return _instance;
}
- (id)init {
    self = [super init];
    if (self) {
        [self comInit];
    }
    return self;
}

- (void)comInit {
    //init here
}

#pragma mark - Convert date

+ (BOOL)validateDateString:(NSString *)iStr {
    if (iStr == nil || [iStr length] == 0 ) {
        return NO;
    }
    
    @try {
        NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@" /:-"];
        NSArray *tmpArr = [iStr componentsSeparatedByCharactersInSet:set];
        if ([tmpArr count] >= 3) {
            return YES;
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception parse time string: %@", exception);
    } @finally {
        
    }
    return NO;
}

#pragma mark - Detect Network
+ (BOOL)checkNetworkAvaiable{
	Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
	NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
	if (networkStatus == NotReachable) {
		return NO;
	}
	return YES;
}
#pragma mark - Util Image
//Convert Image to Base 64 data
+ (NSString *)base64EncodeImage:(UIImage *)originalImage {
    NSData *imagedata = UIImagePNGRepresentation(originalImage);
    // Resize the image if it exceeds the 2MB API limit
    if ([imagedata length] > LIMIT_SIZE_IMAGE_TO_RESIZE) {
        UIImage *newImage = [UIImage resizeImageByWidth:originalImage scaledToWidth:100];
        imagedata = UIImagePNGRepresentation(newImage);
    }
    NSString *base64String = [imagedata base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
    return base64String;
}

#pragma mark - HUD
+ (MBProgressHUD *)instanceCustomHUDInView:(UIView *)view{
	MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
	// Set the custom view mode to show any view.
	hud.mode = MBProgressHUDModeCustomView;
	SO_HUDCustomView *animateView = [[SO_HUDCustomView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
	animateView.backgroundColor = [UIColor clearColor];
	hud.customView = animateView;
	hud.customView.backgroundColor = [UIColor clearColor];
	
	//Remove color on square
	hud.bezelView.color = [UIColor clearColor];
	hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
	hud.square = YES;
	return hud;
}

- (void)didFinish
{
    [Common shareInstance].canShowHub = YES;
}
- (void)showCustomTTNSHudInView:(UIView *)view{
    _numberOfHub++;
    if (!_ttnsHUD) {
        //use this to show new hud
        _ttnsHUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
        // Set the custom view mode to show any view.
        _ttnsHUD.mode = MBProgressHUDModeCustomView;
        // Set an image view with a checkmark.
        //UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        SO_HUDCustomView *animateView = [[SO_HUDCustomView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        animateView.stop = false;
        animateView.backgroundColor = [UIColor clearColor];
        _ttnsHUD.customView = animateView;
        _ttnsHUD.customView.backgroundColor = [UIColor clearColor];
        
        //Remove color on square
        _ttnsHUD.bezelView.color = [UIColor clearColor];
        _ttnsHUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        
        //Clear color
        //_hud.backgroundView.backgroundColor = [UIColor clearColor];
        //_hud.contentColor = [UIColor clearColor];
        
        // Looks a bit nicer if we make it square.
        _ttnsHUD.square = YES;
    }
    else
    {
        [_ttnsHUD showAnimated:YES];
    }
    
}
- (void)showCustomHudInView:(UIView *)view{
	if (_customHUD) {
		[_customHUD hideAnimated:NO];
	}
	//use this to show new hud
	_customHUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
	// Set the custom view mode to show any view.
	_customHUD.mode = MBProgressHUDModeCustomView;
	// Set an image view with a checkmark.
	//UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	SO_HUDCustomView *animateView = [[SO_HUDCustomView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
	animateView.backgroundColor = [UIColor clearColor];
	_customHUD.customView = animateView;
	_customHUD.customView.backgroundColor = [UIColor clearColor];
	
	//Remove color on square
	_customHUD.bezelView.color = [UIColor clearColor];
	_customHUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
	
	//Clear color
	//_hud.backgroundView.backgroundColor = [UIColor clearColor];
	//_hud.contentColor = [UIColor clearColor];
	
	// Looks a bit nicer if we make it square.
	_customHUD.square = YES;
}
- (void)showHUDWithTitle:(NSString *)title inView:(UIView *)view{
	if (_hud) {
		[_hud hideAnimated:NO];
	}
	_hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
	_hud.contentColor = AppColor_MainAppTintColor;
	//_hud.contentColor = kHUDBorderColor;
	
	// Set the label text.
	if (title) {
		_hud.label.text = title;
	}
	// Change the background view style and color.
	_hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
	_hud.square = YES;
}

- (void)showSuccessHUDWithTitle:(NSString *)title inView:(UIView *)view{
	dispatch_async(dispatch_get_main_queue(), ^{
		if (_hud) {
			[_hud hideAnimated:NO];
		}
		_hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
		//_hud.contentColor = [UIColor redColor];
		// Set the custom view mode to show any view.
		_hud.mode = MBProgressHUDModeCustomView;
		if (title) {
			_hud.label.text = title;
		}
		_hud.tintColor = [UIColor redColor];
		// Set an image view with a checkmark.
		UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		_hud.customView = [[UIImageView alloc] initWithImage:image];
		// Looks a bit nicer if we make it square.
		_hud.square = YES;
		[_hud hideAnimated:YES afterDelay:2.0f];
	});
}

- (void)showErrorHUDWithMessage:(NSString *)message inView:(UIView *)view{
	dispatch_async(dispatch_get_main_queue(), ^{
		if (![Common shareInstance].canShowHub) {
			return;
		}
		if (_hud) {
			[_hud hideAnimated:NO];
		}
		
	 _hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
		_hud.delegate = self;
		
		// Set the custom view mode to show any view.
		/*
		 hud.mode = MBProgressHUDModeCustomView;
		 if (message) {
		 hud.label.text = message;
		 }
		 // Set an image view with a checkmark.
		 UIImage *image = [[UIImage imageNamed:@"warning_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		 hud.customView = [[UIImageView alloc] initWithImage:image];
		 // Looks a bit nicer if we make it square.
		 hud.square = YES;
		 [hud hideAnimated:YES afterDelay:2.0f];
		 */
		// Set the text mode to show only text.
		_hud.mode = MBProgressHUDModeText;
		_hud.animationType = MBProgressHUDAnimationZoomIn;
		_hud.contentColor = AppColor_MainAppTintColor;
		if (message) {
			_hud.label.numberOfLines = 0;
			_hud.label.text = message;
		}
		// Move to bottm center.
		//hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
		[_hud hideAnimated:YES afterDelay:2.5];
	});
}

- (void)dismissHUD{
	if (_hud) {
		[_hud hideAnimated:YES];
		_hud = nil;
	}
}

- (void)dismissCustomHUD{
	if (_customHUD) {
		[_customHUD hideAnimated:YES];
        ((SO_HUDCustomView *)_customHUD.customView).stop = true;
        [_customHUD removeFromSuperview];
        _customHUD.removeFromSuperViewOnHide = YES;
        _customHUD = nil;
	}
}
- (void)dismissTTNSCustomHUD{
    _numberOfHub--;
    if (_numberOfHub < 1) {
        [self dismissAllTTNSCustomHUB];
    }
    
}
- (void)dismissAllTTNSCustomHUB
{
    _numberOfHub = 0;
    if (_ttnsHUD) {
        [_ttnsHUD hideAnimated:YES];
        ((SO_TTNSHUBCustomView *)_ttnsHUD.customView).stop = true;
        [_ttnsHUD removeFromSuperview];
        _ttnsHUD.removeFromSuperViewOnHide = YES;
        _ttnsHUD = nil;
    }
}
#pragma mark - Parse jSon to Dictionary
+ (id)dictFromJSONString:(NSString *)jSon{
	NSDictionary *dict = @{}.copy;
	NSError *jsonError;
	NSData *objectData = [jSon dataUsingEncoding:NSUTF8StringEncoding];
	id json = [NSJSONSerialization JSONObjectWithData:objectData
														 options:NSJSONReadingMutableContainers
														   error:&jsonError];
	if (jsonError != nil) {
		DLog(@"Error parse json file: %@", jsonError.description);
		return dict;
	}
	return json;
}

+ (NSString *)readDataFromPlistSampleFileWithKey:(NSString *)key{
	NSDictionary *rootDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SOSampleData" ofType:@"plist"]];
	NSString *dictData = rootDict[key];
	return dictData;
}


#pragma mark - Util Date
- (NSDate *)dateFromString:(NSString *)strDate withFormat:(NSString *)format{
	NSDateFormatter *formater = [[NSDateFormatter alloc] init];
	[formater setDateFormat:format];
	//NSLocale *local = [NSLocale localeWithLocaleIdentifier:@"vi"];;

	//format.locale = local;
	//[formater setLocale:[[NSLocale alloc] initWithLocaleIdentifier:NSLocaleIdentifier]];
	//[formater setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
	NSLocale *local = [NSLocale currentLocale];
	formater.locale = local;
	NSDate *date = [formater dateFromString:strDate];
	return date;
}

- (NSString *)stringWithCheckCompareFromDateString:(NSString *)strDate{
	NSDate *date = [self dateFromString:strDate withFormat:kServerFormatDate];
	if ([date isToday]) {
		return [NSString stringWithFormat:@"%@ (%@)",LocalizedString(@"Hôm nay"), [[Common separateStringBySpaceCharacter:strDate] firstObject]];
	}
	if ([date isTomorrow]) {
		return [NSString stringWithFormat:@"%@ (%@)",LocalizedString(@"Ngày mai"), [[Common separateStringBySpaceCharacter:strDate] firstObject]];
	}
	return [date stringWithFormat:kAppFullFormatDate];
}
- (NSString *)fullNormalStringDateFromServerDate:(NSString *)serverDate serverFormatDate:(NSString *)format{
	//@"dd/MM/yyyy HH:mm:ss"
	NSDate *date = [self dateFromString:serverDate withFormat:format];
	return [date stringWithFormat:kFullFormatClientDate];
}

- (NSString *)normalDateFromServerDate:(NSString *)serverDate serverFormatDate:(NSString *)serFormat toClientFormat:(NSString *)clientFormat{
    //@"dd/MM/yyyy HH:mm:ss"
    NSDate *date = [self dateFromString:serverDate withFormat:serFormat];
    return [date stringWithFormat:clientFormat];
}

- (NSString *)convertToServerDateFromClientDate:(NSDate *)clientDate{
	if (clientDate == nil) {
		return @"";
	}
	return [clientDate stringWithFormat:kAppNormalFormatDate];
}

#pragma mark - Util Image
//Convert Image to Base 64 data


#pragma mark Date Time

- (NSString*)getCurrentTime{
    NSDateFormatter *dateFM = [[NSDateFormatter alloc]init];
    [dateFM setDateFormat:@"HH:mm - dd/MM/yyyy"];
    DLog(@"%@", [dateFM stringFromDate:[NSDate date]]);
    
    return [dateFM stringFromDate:[NSDate date]];
}

#pragma mark - Check Role User
+ (BOOL)isHasManagedRoleFromRoles:(NSArray *)roles{
	BOOL roleManager = NO;
	for(UserRoleModel *model in roles){
		if ([self isManagerUserById:model.sysRoleId] == YES) {
			roleManager = YES;
			break;
		}
	}
	return roleManager;
}

+ (BOOL)isManagerUserById:(NSString *)userID{
	NSInteger _id = [userID integerValue];
	if (_id == UserRoleID_Manager1 || _id == UserRoleID_Manager2) {
		return YES;
	}
	return NO;
}

#pragma mark - UTILS VOFFICE
+ (NSString *)missionNameiConFromCommandType:(NSInteger)type{
	NSString *name = @"";
	switch (type) {
		case MissionType_Combined:
			name = @"mission_combined_icon";
			break;
		case 0: //Nhiệm vụ BGĐ giao
			name = @"mission_registed_icon";
			break;
			//Add another type below...
		case MissionType_Registered: //Nhiệm vụ đăng ký
			name = @"mission_director_assigned_icon";
			break;
		default:
			name = @"unknown_icon"; //
			break;
	}
	return name;
}
//MissionType_Combined = 3,				//Nhiệm vụ kết hợp
//MissionType_DirectorateAssigned = 4,	//Nhiệm vụ BGĐ giao
//MissionType_Registered = 6				//Nhiệm vụ đăng ký

#pragma mark - Util String
+ (NSArray *)separateStringBySpaceCharacter:(NSString *)curStr{
	return [curStr componentsSeparatedByString:@" "];
}

#pragma mark - Detech delay work / Mission
+ (BOOL)isDelayWork:(WorkModel *)model{
	if (!model) {
		return NO;
	}
	if (model.commandType == 3) {
		return NO;
	}
	if (model.commandType == 4 && model.isCompleted) {
		return NO;
	}
	if (model.endTime) {
		NSDate *completeDate = [[Common shareInstance] dateFromString:model.endTime withFormat:@"dd/MM/yyyy HH:mm"];
		if ([completeDate isEarlierThan:[NSDate date]]) {
			return YES;
		}
	}
	return NO;
}

// Check worktype for Image use
+ (NSString *)iconTypeWorkFromCommandType:(NSInteger)commandType{
	NSString *iconName = @"";
	if (commandType == 2) {
		//Personal
		iconName = @"work_perform_icon";
	}else if (commandType == 4){
		//Combined
		iconName = @"work_combinated_icon";
	}else{
		//Other - Được giao
		iconName = @"work_other_icon";
	}
	return iconName;
}

+ (NSInteger)numberRowsOfCommandTypeWork:(NSInteger)commandType{
	if (commandType == 2) {
		return 7;
	}
	return 8;
}


#pragma mark - Util Mission
+ (NSString *)statusStringFromType:(MissionStatus)status{
	NSString *value = @"";
	switch (status) {
		case MissionStatus_DelayProgress:
			value = LocalizedString(@"MISSION_STATUS_DELAY_PROGRESS_LABEL");
			break;
		case MissionStatus_UnInprogress:
			value = LocalizedString(@"MISSION_STATUS_UN_INPROGRESS_LABEL");
			break;
		case MissionStatus_Inprogress:
			value = LocalizedString(@"Đang thực hiện");
			break;
		case MissionStatus_Completed:
			value = LocalizedString(@"Đã hoàn thành");
			break;
		case MissionStatus_Ended:
			value = LocalizedString(@"Đã kết thúc");
			break;
		case MissionStatus_RequestClose:
			value = LocalizedString(@"Yêu cầu đóng");
			break;
		case MissionStatus_Closed:
			value = LocalizedString(@"Đã đóng");
			break;
		case MissionStatus_RequestExtend:
			value = LocalizedString(@"Yêu cầu gia hạn");
			break;
		case MissionStatus_NotClose:
			value = LocalizedString(@"Chưa đóng");
			break;
		case MissionStatus_Moved:
			value = LocalizedString(@"Đã chuyển");
			break;
		default:
			break;
	}
	return value;
}

+ (BOOL)isDelayMission:(MissionModel *)model{
	//Check delay time or not
	//Check delay time or not
	if (model.dateComplete) {
		NSDate *completeDate = [[Common shareInstance] dateFromString:model.dateComplete withFormat:kServerFormatDate];
		if ([completeDate isEarlierThan:[NSDate date]]) {
			return YES;
		}
	}
	return NO;
}
#pragma mark - Util Status Sign
+ (NSString *)getStatusSignFrom:(SignStatus)status{
	NSString *result = @"";
	switch (status) {
		case SignStatus_Noprocess:
			result = LocalizedString(@"SignStatus_Chưa_xử_lý");
			break;
		case SignStatus_LetterRefusesToApprove:
			result = LocalizedString(@"SignStatus_Văn_thư_từ_chối_duyệt");
			break;
		case SignStatus_RefusalToApprove:
			result = LocalizedString(@"SignStatus_Từ_chối_duyệt");
			break;
		case SignStatus_Signed:
			result = LocalizedString(@"SignStatus_Đã_ký_duyệt");
			break;
		case SignStatus_Noprocess2:
			result = LocalizedString(@"SignStatus_Chưa_xử_lý");
			break;
		case SignStatus_LetterSigned:
			result = LocalizedString(@"SignStatus_Văn_thư_đã_ký_duyệt");
			break;
		case SignStatus_SignedBlink:
			result = LocalizedString(@"SignStatus_Đã_ký_nháy");
			break;
		default:
			result = LocalizedString(@"SignStatus_Chưa_xử_lý");
			break;
	}
	return result;
}

+ (UIColor *)colorForStatusSign:(SignStatus)status{
	//Từ chối
	if (status == SignStatus_LetterRefusesToApprove || status == SignStatus_RefusalToApprove) {
		return [UIColor redColor];
	}
	//Đã duyệt
	if (status == SignStatus_LetterSigned || status == SignStatus_SignedBlink || status == SignStatus_Signed){
		return AppColor_MainAppTintColor;
	}
	//Chưa xử lý
	return [UIColor lightGrayColor];
}
#pragma mark - Util DOC
+ (NSString *)getPriorityDoc:(NSInteger)priorityId{
	//1 - bình thường; 2 - khẩn; 3 - hỏa tốc; 4 - thượng khẩn
	NSString *value = LocalizedString(@"");
	switch (priorityId) {
		case 1:
			value = LocalizedString(@"Bình thường");
			break;
		case 2:
			value = LocalizedString(@"Khẩn");
			break;
		case 3:
			value = LocalizedString(@"Hoả tốc");
			break;
		case 4:
			value = LocalizedString(@"Thượng khẩn");
			break;
		default:
			break;
	}
	return value;
}
#pragma mark - Meeting Util

+ (BOOL)checkValid:(NSInteger)value
{
    if (value == 1) {
        return YES;
    }
    return NO;
}

+ (NSString *)getRoleFromMeetingModel:(NSInteger)isPresident isParticipate:(NSInteger)isParticipate isPrepare:(NSInteger)isPrepare{
    if ([self checkValid:isPresident]) {
		return LocalizedString(@"VOffice_PersonJoinCell_iPad_Chủ_trì");
	}
	if ([self checkValid:isPrepare]) {
		return LocalizedString(@"VOffice_PersonJoinCell_iPad_Chuẩn_bị");
	}
	return LocalizedString(@"VOffice_PersonJoinCell_iPad_Tham_gia");
}
#pragma mark - Detect iS TextEdit Control
+ (BOOL)isTextEditControll:(UIView *)view{
	if ([view isKindOfClass:[UITextField class]] || [view isKindOfClass:[UITextView class]] || [view isKindOfClass:[UISearchBar class]]){
		return YES;
	}
	return NO;
}
@end
