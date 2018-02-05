//
//  VOfficeVC.m
//  SmartOffice
//
//  Created by Kaka on 4/4/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "VOfficeVC.h"
#import "PersonalVC.h"
#import "TaskVC.h"
#import "VOfficeProcessor.h"
#import "SOErrorView.h"
#import "Reachability.h"
#import "SumWorkModel.h"
#import "Common.h"
#import "VOfficeProcessor.h"
#import "SOSessionManager.h"
#import "VOfficeSessionModel.h"
#import "VOffice_MainController.h"
#import "NSException+Custom.h"

@interface VOfficeVC ()<SOErrorViewDelegate, DataNUllDelegate>{
    SOErrorView *_errorView;
    NSInteger _selectedIndex;
}

@property (strong, nonatomic) PersonalVC *personalVC;
@property (strong, nonatomic) TaskVC *taskVC;
@property (strong, nonatomic) VOffice_MainController *mainController;
@end

@implementation VOfficeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _selectedIndex = 0;
    [self createUI];
	//Hidden segmentControlView
	_segmentControl.hidden = YES;
    
	//Load Data
    self.mainController = [[VOffice_MainController alloc] init];
    self.mainController.delegate = self;
	[self loadData];
    [AppDelegateAccessor setupSegment:self.segmentControl];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - CreateUI
- (void)createUI{
	self.view.backgroundColor = AppColor_MainAppBackgroundColor;
	_contentView.backgroundColor = AppColor_MainAppBackgroundColor;
	
    //Add ErrorView
    _errorView = [[SOErrorView alloc] initWithFrame:CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height) inforError:nil];
    _errorView.delegate = self;
    [_contentView addSubview:_errorView];
    //Hide ErrorView Default
    [self showErrorView:NO withError:@""];
	//Disable action when begin loading data
	self.view.userInteractionEnabled = NO;
	
	/*
    //Add Content VC
    if (_personalVC == nil) {
        _personalVC = NEW_VC_FROM_STORYBOARD(@"VOffice", @"PersonalVC");
        [self addChildViewController:_personalVC];
        _personalVC.view.frame = CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height);
        [_contentView addSubview:_personalVC.view];
        [_personalVC didMoveToParentViewController:self];
    }
    
    if (_taskVC == nil) {
        _taskVC = NEW_VC_FROM_STORYBOARD(@"VOffice", @"TaskVC");
        [self addChildViewController:_taskVC];
        _taskVC.view.frame = CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height);
        [_contentView addSubview:_taskVC.view];
        [_taskVC didMoveToParentViewController:self];
    }
	 */
    //Show Content default
    //[self showContentVC:_personalVC withShow:NO];
    //[self showContentVC:_taskVC withShow:NO];
	[self setupLanguage];
}

- (void)setupLanguage{
	//VOffice - VOFF
	[_segmentControl setTitle:LocalizedString(@"KVOFF_TAB_PERSONAL_TITLE") forSegmentAtIndex:0];
	[_segmentControl setTitle:LocalizedString(@"KVOFF_TAB_MISSION_TITLE") forSegmentAtIndex:1];
}

//Add contentView
- (void)addPersonalContentView{
	if (_personalVC == nil) {
		_personalVC = NEW_VC_FROM_STORYBOARD(@"VOffice", @"PersonalVC");
		[self addChildViewController:_personalVC];
		_personalVC.view.frame = CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height);
		[_contentView addSubview:_personalVC.view];
		[_personalVC didMoveToParentViewController:self];
	}
}

- (void)addTaskContentView{
	if (_taskVC == nil) {
		_taskVC = NEW_VC_FROM_STORYBOARD(@"VOffice", @"TaskVC");
		[self addChildViewController:_taskVC];
		_taskVC.view.frame = CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height);
		[_contentView addSubview:_taskVC.view];
		[_taskVC didMoveToParentViewController:self];
	}
}


- (void)displayContentController:(UIViewController *)content {
    [self addChildViewController:content];
    content.view.frame = _contentView.frame;
    [_contentView addSubview:content.view];
    [content didMoveToParentViewController:self];
}

- (void)showContentVC:(UIViewController *)contentVC withShow:(BOOL)isShow{
    if (isShow && contentVC.view.hidden == NO){
        return;
    }
    if (isShow) {
        [contentVC viewWillAppear:YES];
    }
    [contentVC.view setHidden:!isShow];
}

- (void)showErrorView:(BOOL)isShow withError:(NSString *)error{
    _errorView.hidden = !isShow;
	[_errorView setErrorInfo:error];
	if (isShow) {
		[_segmentControl setUserInteractionEnabled:NO];
		
	}else{
		[_segmentControl setUserInteractionEnabled:YES];
	}
}

#pragma mark - Actions
- (void)loadCurrentSegment
{
	if (!_errorView.hidden) {
		//Reload on Supper view- Check server, exception
		[self loadData];
	}else{
		//Load On try view
		
		if (_selectedIndex == 0) {
			[_personalVC loadData];
		}
		else
		{
			if (_taskVC) {
				[_taskVC loadData];
			}
			else
			{
				[self addTaskContentView];
			}
		}
	}
	
}
- (void)loadDataWhenTapSegment:(NSInteger)index
{
    if (index == 0) {
        DLog(@"Personal");
        [self showContentVC:_personalVC withShow:YES];
        [self showContentVC:_taskVC withShow:NO];
    }else{
        if (!_taskVC) {
            [self addTaskContentView];
        }
        DLog(@"Task");
        [self showContentVC:_personalVC withShow:NO];
        [self showContentVC:_taskVC withShow:YES];
    }
}
- (IBAction)onSegmentedControlClicked:(UISegmentedControl *)sender {
    _selectedIndex = sender.selectedSegmentIndex;
    [AppDelegateAccessor setupSegment:sender];
    [self loadDataWhenTapSegment:_selectedIndex];
}

- (void)setEnableSegmentedControl:(BOOL)enable atIndex:(NSInteger)index{
	[_segmentControl setEnabled:enable forSegmentAtIndex:index];
	if (enable == NO) {
		for (int i=0; i<[_segmentControl.subviews count]; i++)
		{
			if (i == index -1) {
				[_segmentControl.subviews[i] setTintColor:RGBA(170, 170, 170, 0.3)];
				//[_segmentControl.subviews[i] setHidden:YES];
			}
		}
	}
}

- (void)hiddenSegmentView{
	[self setEnableSegmentedControl:NO atIndex:1];
	_segmentViewConstrainHeight.constant = 0.0;
	[self.view layoutIfNeeded];
}
- (void)showSegmentView{
	//[self setEnableSegmentedControl:NO atIndex:1];
	_segmentViewConstrainHeight.constant = 35.0;
	[self.view layoutIfNeeded];
}
#pragma mark - SOErrorViewDelegate
- (void)didRefreshOnErrorView:(SOErrorView *)errorView{
    DLog(@"Refresh here");
	/*
	if ([Common checkNetworkAvaiable]) {
		if (!_personalVC) {
			[self addPersonalContentView];
		}
		//Show Personal Default
		[self showContentVC:_personalVC withShow:YES];
		[self showErrorView:NO];
	}else{
		[self showErrorView:YES];
	}
	 */
	if (_errorView.hidden) {
		//Refresh data on Personal VC here
		if (_personalVC) {
			[_personalVC loadData];
		}
		return;
	}
	[self loadData];
}

#pragma mark - Get VOffice AccessToken
- (void)loadData{
	[[Common shareInstance] showCustomHudInView:self.view];
    [self.mainController loadData:^(BOOL network, BOOL success, NSException *exception, NSDictionary *error) {
		self.view.userInteractionEnabled = YES;
        if(!network)
        {
            //ALERT
            //"Mất kết nối tới hệ thống" = "Mất kết nối tới hệ thống";
            //"Mất kết nối mạng"		   = "Mất kết nối mạng";
            [self showErrorView:YES withError:LocalizedString(@"Mất kết nối mạng")];
        }
        else
        {
			if (success) {
			
				//Show Full UI
				_segmentControl.hidden = NO;
				[self addPersonalContentView];
				[self showContentVC:_personalVC withShow:YES];
				[self showErrorView:NO withError:nil];
				//Detech User Role
				if (![Common isHasManagedRoleFromRoles:[SOSessionManager sharedSession].vofficeSession.userRolesArr]) {
					//Disable Mission Menu + Hidden Segment View
					[self hiddenSegmentView];
				}
			}else{
				if (error != nil) {
					 [self showErrorView:YES withError:LocalizedString(@"Không có dữ liệu")];
				}else{
					 [self showErrorView:YES withError:LocalizedString(@"Mất kết nối tới hệ thống")];
				}
			}
        }
		[[Common shareInstance] dismissCustomHUD];
    }];
}

- (void)dataNULL {
    [self showErrorView:YES withError:@"Không có kết quả"];
}

@end
