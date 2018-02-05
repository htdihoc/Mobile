//
//  MoreVC.m
//  SmartOffice
//
//  Created by Kaka on 4/3/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "MoreVC.h"
#import "GeneralPersonalInfoVC.h"
#import "SurveyViewController.h"
#import "PMTCViewController.h"
#import "MoreInfoVC.h"
#import "UserNormalInfoCell.h"
#import "FuntionCell.h"
#import "ReminderViewController.h"
#import "PersonalAccountInfoViewController.h"
#import "SurveyProcessor.h"
#import "SVPullToRefresh.h"
#import "TTNS_ApproveTimeKeepingController.h"
#import "Common.h"
#import "TTNSProcessor.h"
@interface MoreVC ()

#define kSetting                @"Setting"
#define kReminder               @"Reminder"
#define kStorage                @"Storage"
#define kSurvey                 @"Survey"
#define kViettelKnowledges      @"Viettel Knowledges"
#define kProject                @"Project"
#define kPMTC                   @"PMTC"
#define kLogout                 @"Logout"

#define iSetting                @"tabbar_setting_icon"
#define iReminder               @"tabbar_reminder_icon"
#define iStorage                @"tabbar_storage_icon"
#define iSurvey                 @"tabbar_survey_icon"
#define iViettelKnowledges      @"tabbar_knowledges_icon"
#define iProject                @"tabbar_bag_icon"
#define iPMTC                   @"pmtc"
#define iLogout                 @"logout"

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) TTNS_EmployeeTimeKeeping *employeeDetail;
@property (strong, nonatomic) NSMutableArray *array_title;
@property (strong, nonatomic) NSMutableArray *array_image;
@property (nonatomic) NSInteger countSurvey;

@end

@implementation MoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:YES];
//    [self.navigationController.interactivePopGestureRecognizer setDelegate:nil];
    [self createUI];
    
    self.array_title = [NSMutableArray arrayWithObjects: kSetting, kReminder, kStorage, kSurvey, kViettelKnowledges, kProject, kPMTC, kLogout, nil];
    self.array_image = [NSMutableArray arrayWithObjects: iSetting, iReminder, iStorage, iSurvey, iViettelKnowledges, iProject, iPMTC, iLogout, nil];
    
    [self countData];
    [self loadEmployeeInfo];
}

- (void) countData {
    NSDictionary *parameter = @{
                                @"username": @"102026",
                                @"password": @"123456a@"
                                };
    [SurveyProcessor getCountDataSurvey:parameter handle:^(id result, NSString *error) {
        self.countSurvey = [result[@"result"] integerValue];
//        self.countSurvey = 20;
        [self.tbMore reloadData];
    } onError:^(NSString *Error) {
        
    } onException:^(NSString *Exception) {
        
    }];
}
- (void)loadEmployeeInfo
{
    [[Common shareInstance] showCustomHudInView:self.view];
    [TTNS_ApproveTimeKeepingController loadDetailEmployee:[[GlobalObj getInstance].ttns_employID stringValue] completion:^(BOOL success, NSDictionary *emloyeeDetail, NSException *exception, BOOL isConnectNetwork, NSDictionary *error) {
        if (success) {
            self.employeeDetail = [[TTNS_EmployeeTimeKeeping alloc] initWithDictionary:emloyeeDetail error:nil];
            [TTNSProcessor getTTNS_PositionName:[[GlobalObj getInstance].ttns_employID stringValue] callBack:^(BOOL success, id resultDict, NSException *exception) {
                if (success && [resultDict isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *entity = [[resultDict valueForKey:@"data"] valueForKey:@"entity"];
                    if ([entity isKindOfClass:[NSDictionary class]]) {
                        self.employeeDetail.positionName = [entity valueForKey:@"positionName"];
                    }
                }
                else
                {
                    [self handleErrorFromResult:resultDict withException:nil inView:self.view];
                }
                [self.tbMore reloadData];
				[[Common shareInstance] dismissCustomHUD];
            }];
        }else
        {
			[[Common shareInstance] dismissCustomHUD];
            [self handleErrorFromResult:error withException:nil inView:self.view];
        }
		
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view setBackgroundColor:[UIColor clearColor]];
    self.navigationController.navigationBar.hidden = NO;
    [AppDelegateAccessor.mainTabbarController.tabBar setHidden:NO];
    self.topView.backgroundColor = AppColor_MainAppTintColor;
}

- (void) viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1+self.array_title.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UserNormalInfoCell *userInfoCell = (UserNormalInfoCell *)[tableView dequeueReusableCellWithIdentifier:@"UserNormalInfoCell"];
        if (userInfoCell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UserNormalInfoCell" owner:self options:nil];
            userInfoCell = [nib objectAtIndex:0];
        }
        userInfoCell.selectionStyle = UIAccessibilityTraitNone;
        if (self.employeeDetail) {
            [userInfoCell setDataForCell:self.employeeDetail];
        }
        return userInfoCell;
    } else {
        FuntionCell *funtionCell = (FuntionCell *)[tableView dequeueReusableCellWithIdentifier:@"funtionCell"];
        if (funtionCell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FuntionCell" owner:self options:nil];
            funtionCell = [nib objectAtIndex:0];
        }
        funtionCell.label_title.text = self.array_title[indexPath.row-1];
        funtionCell.image_option.image = [UIImage imageNamed:self.array_image[indexPath.row-1]];
        funtionCell.image_option.contentMode = UIViewContentModeScaleAspectFit;
        funtionCell.selectionStyle = UIAccessibilityTraitNone;
        
        if (indexPath.row == 4) {
            funtionCell.countLabel.text = [NSString stringWithFormat:@"%ld", (long)self.countSurvey];
            funtionCell.countLabel.layer.cornerRadius = funtionCell.countLabel.frame.size.height/2;
            funtionCell.countLabel.layer.masksToBounds = YES;
        } else {
            funtionCell.countLabel.hidden = YES;
        }
        
        [self.tbMore addPullToRefreshWithActionHandler:^{
            [self.tbMore.pullToRefreshView stopAnimating];
            [self countData];
        }];
        
        return funtionCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            MoreInfoVC *moreInfoVC = NEW_VC_FROM_NIB(MoreInfoVC, @"MoreInfoVC");
            moreInfoVC.employeeDetail = self.employeeDetail;
            [self.navigationController pushViewController:moreInfoVC animated:YES];
        }
            break;
        case 1:
            
            break;
        case 2:
        {
            UIStoryboard *storyboard = New_Storyboard(@"Reminder");
            ReminderViewController *reminder = initViewController(ReminderViewController, @"ReminderViewController");
            [self.navigationController pushViewController:reminder animated:YES];
        }
            break;
        case 3:
            
            break;
        case 4:
        {
            UIStoryboard *storyboard = New_Storyboard(@"Survey");
            SurveyViewController *survey = initViewController(SurveyViewController, @"SurveyViewController");
            survey.countSurvey = self.countSurvey;
            [self.navigationController pushViewController:survey animated:YES];
        }
            break;
        case 5:
        {
            QLTT_MasterVC *qlttVC = NEW_VC_FROM_NIB(QLTT_MasterVC, @"QLTT_MasterVC");
            [self.navigationController pushViewController:qlttVC animated:YES];
        }
            break;
        case 6:
            
            break;
        case 7:
        {
            UIStoryboard *storyboard = New_Storyboard(@"PMTC");
            PMTCViewController *pmtc = initViewController(PMTCViewController, @"PMTCViewController");
            [self.navigationController pushViewController:pmtc animated:YES];
        }
            break;
        case 8:
        {			
			UIAlertController *alert = [UIAlertController alertControllerWithTitle:LocalizedString(@"Logout") message:LocalizedString(@"Are you sure you want to logout?") preferredStyle:UIAlertControllerStyleAlert];
			UIAlertAction *logoutAction = [UIAlertAction actionWithTitle:LocalizedString(@"KLOGIN_ALERT_BTN_OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
				[AppDelegateAccessor startLoginIpad];
			}];
			[alert addAction:logoutAction];
			[self presentViewController:alert animated:YES completion:nil];
        }
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 100;
    } else {
        return 55;
    }
}

- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - CreateUI
- (void)createUI{
    [self.tbMore registerNib:[UINib nibWithNibName:@"UserNormalInfoCell" bundle:nil] forCellReuseIdentifier:@"UserNormalInfoCell"];
    [self.navigationController.navigationBar setBarTintColor:AppColor_MainAppTintColor];
}

@end
