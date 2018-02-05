//
//  TTNSRoot.m
//  SmartOffice
//
//  Created by NguyenVanTu on 4/14/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "TTNSRoot.h"
#import "InfoHumanVC.h"
#import "UserManagement.h"

#import "Common.h"
#import "TTNSProcessor.h"
#import "SOSessionManager.h"
#import "SOErrorView.h"
#import "Common.h"
#import "NSException+Custom.h"

@interface TTNSRoot ()<SOErrorViewDelegate>
{
    TTNS_Role role;
    TTNS_Role currentRole;
    @protected SOErrorView *_errorView;
}
//default = 48
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cst_Top;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentOutlet;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) InfoHumanVC *infoHumanView;
@property (strong, nonatomic) UserManagement *userManagementView;
@end

@implementation TTNSRoot


- (void)viewDidLoad {
    [super viewDidLoad];
    
    currentRole = TTNS_Person;
    [self setupUI];
    //    [self addInfoHumanView];
    [self getAccessToken];
    
}
- (void)reloadData
{
    if (self.segmentOutlet.selectedSegmentIndex == 0) {
        if (_infoHumanView == nil) {
            [self addInfoHumanView];
        }else
        {
            [_infoHumanView reloadData];
        }
        
    }
    else
    {
        if (_userManagementView == nil) {
            [self addUserManagementView];
        }
        else
        {
            [_userManagementView reloadData];
        }
    }
    
}
- (void)setupUI{
    self.segmentOutlet.backgroundColor = [UIColor whiteColor];
    self.segmentOutlet.clipsToBounds = YES;
    self.segmentOutlet.layer.cornerRadius = 4;
    [[UISegmentedControl appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:AppFont_MainFontWithSize(13), NSFontAttributeName, nil] forState:UIControlStateNormal];
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateSelected];
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor lightGrayColor]} forState:UIControlStateNormal];
    [[UISegmentedControl appearance] setTintColor:AppColor_MainAppTintColor];
    
    self.view.backgroundColor = AppColor_MainAppBackgroundColor;
    // Add Errorview
    
}

- (void)addErrorView:(NSString *)content{
    if (!_errorView) {
        _errorView = [[SOErrorView alloc]initWithFrame:CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height) inforError:nil];
        [_errorView setErrorInfo:content];
        _errorView.backgroundColor = AppColor_MainAppBackgroundColor;
        _errorView.delegate = self;
        [self.contentView addSubview:_errorView];
        self.view.userInteractionEnabled = NO;
    }
    else
    {
        [_errorView setHidden:NO];
        [_errorView setErrorInfo:content];
    }
    
}

- (void) addInfoHumanView
{
    if(_infoHumanView == nil)
    {
        
        _infoHumanView = NEW_VC_FROM_STORYBOARD(@"InfoHuman", @"InfoHumanVC");
        [self addChildViewController:_infoHumanView];
        _infoHumanView.view.frame = CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height);
        [self.contentView addSubview:_infoHumanView.view];
        [_infoHumanView didMoveToParentViewController:self];
        
    }
}

- (void) addUserManagementView
{
    if(_userManagementView == nil)
    {
        _userManagementView = NEW_VC_FROM_NIB(UserManagement, @"UserManagement");
        [self addChildViewController:_userManagementView];
        _userManagementView.view.frame = CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height);
        [self.contentView addSubview:_userManagementView.view];
        [_userManagementView didMoveToParentViewController:self];
    }
}

- (void)switchView
{
    if (role == TTNS_Manager) {
        [self addUserManagementView];
    }
    if(currentRole == TTNS_Person)
    {
        currentRole = TTNS_Manager;
        [_infoHumanView.view setHidden:YES];
        [_userManagementView.view setHidden:NO];
    }
    else
    {
        currentRole = TTNS_Person;
        [_infoHumanView.view setHidden:NO];
        [_userManagementView.view setHidden:YES];
    }
}

-(void)hidenSegment{
    [_segmentOutlet setHidden:YES];
}

- (void)showSegment{
    [_segmentOutlet setHidden:NO];
    
}

- (IBAction)changeType:(id)sender {
    if (![Common checkNetworkAvaiable]) {
        [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
    }
    [self switchView];
}

#pragma mark networking
- (void)calculateManagerID:(NSArray *)managers
{
    self.cst_Top.constant = 0;
    for(NSDictionary *manager in managers)
    {
        if ([manager valueForKey:@"employeeId"] == [GlobalObj getInstance].ttns_employID) {
            role = TTNS_Manager;
            self.cst_Top.constant = 48;
            [GlobalObj getInstance].ttns_managerID = [manager valueForKey:@"employeeId"];
            
        }
    }
    
}
-(void)getAccessToken{
    //[[Common shareInstance]showHUDWithTitle:@"Loading..." inView:self.view];
    if([Common checkNetworkAvaiable]){
        [[Common shareInstance] showCustomTTNSHudInView:self.view];
        
        NSDictionary *params = @{@"username" : [GlobalObj getInstance].ttns_userName, @"password" : [GlobalObj getInstance].ttns_password};
        [TTNSProcessor getSSO_Token:params callBack:^(BOOL success, id resultDict, NSException *exception) {
            if (success) {
                NSString *access_token = [[[resultDict valueForKey:@"data"] valueForKey:@"data"] valueForKey:@"access_token"];
                [SOSessionManager sharedSession].ttnsSession.ssoToken = access_token;
                [TTNSProcessor getListManager:^(BOOL success, id resultDict, NSException *exception) {
                    if (success) {
                        [self calculateManagerID:[[resultDict valueForKey:@"data"] valueForKey:@"entity"]];
                    }else
                    {
                        [self showToastWithMessage:LocalizedString(@"Không kiểm tra được quyền")];
                    }
                }];
            }
        }];
        [TTNSProcessor getAccessTokenTTNSWithComplete:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
            if(success){
                NSString *accessToken = resultDict[@"data"][@"data"][@"access_token"];
                [SOSessionManager sharedSession].ttnsSession.accessToken = accessToken;
                [[SOSessionManager sharedSession] saveData];
                [TTNSProcessor getPrivateTTNSWithComplete:[GlobalObj getInstance].ttns_employID uuid:[GlobalObj getInstance].ttns_uid callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
                    NSString *privateKey = resultDict[@"data"][@"entity"];
                    [SOSessionManager sharedSession].ttnsSession.privateKey = privateKey;
                    [[SOSessionManager sharedSession] saveData];
                    self.view.userInteractionEnabled = YES;
                    [_errorView setHidden:YES];
                    [self addInfoHumanView];
                    [self showSegment];
                    [[Common shareInstance]dismissTTNSCustomHUD];
                }];
            } else {
                [self addErrorView:@"Mất kết nối tới hệ thống"];
                [self hidenSegment];
                self.view.userInteractionEnabled = YES;
                [[Common shareInstance] dismissTTNSCustomHUD];
            }
        }];
    } else{
        [self addErrorView:LocalizedString(@"Mất kết nối mạng")];
        [self hidenSegment];
        self.view.userInteractionEnabled = YES;
    }
	
}

#pragma mark SOErrorViewDelegate
- (void)didRefreshOnErrorView:(SOErrorView *)errorView{
    [self getAccessToken];
}
@end
