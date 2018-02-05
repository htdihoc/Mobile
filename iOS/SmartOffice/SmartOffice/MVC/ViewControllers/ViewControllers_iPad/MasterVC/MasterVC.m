//
//  MasterVC.m
//  SmartOffice
//
//  Created by Kaka on 4/21/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "MasterVC.h"
#import "IntegrationVC_iPad.h"
#import "SocialVC_iPad.h"
#import "ConversationVC_iPad.h"
#import "ContactVC_iPad.h"
#import "MoreVC_iPad.h"
#import "SOTabbarItemView.h"

static NSString *HIGHTLIGHT = @"hightlight";

static NSString *TABBAR_ITEM_INTEGRATION	= @"ipad_tabbar_integration";
static NSString *TABBAR_ITEM_SOCIAL			= @"ipad_tabbar_social";
static NSString *TABBAR_ITEM_CONVERSATION	= @"ipad_tabbar_conversation";
static NSString *TABBAR_ITEM_CONTACT		= @"ipad_tabbar_contact";
static NSString *TABBAR_ITEM_MORE			= @"ipad_tabbar_more";
static NSString *TABBAR_ITEM_LOGOUT			= @"ipad_tabbar_logout";

#define Defatul_tabbar_item_title_color		RGB(164, 163, 163)


@interface MasterVC (){
	NSMutableArray *_listTabbar;
}
@property (weak, nonatomic) IBOutlet UIView *topView;


@end

@implementation MasterVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil controllers:(NSMutableArray *)controllers selectedAtIndex:(TabbarItemType)selectedTabbar{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		self.listControllers = controllers;
		self.selectedTabbar = selectedTabbar;
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[self initialDefault];
	[self createUI];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CreateUI
- (void)createUI{
	//Setup Default tabbar
	[self refreshTabbars:_selectedTabbar];
}
- (void)initialDefault{
    self.topView.backgroundColor = AppColor_MainAppTintColor;
	_listTabbar = @[_integrationTabbar, _socialTabbar, _conversationTabbar, _contactTabbar, _moreTabbar].mutableCopy;
}

//Refresh Tabbar
- (void)refreshTabbars:(TabbarItemType)selectedTabbar{
	[_listTabbar enumerateObjectsUsingBlock:^(SOTabbarItemView  *tabbar, NSUInteger idx, BOOL * _Nonnull stop) {
		if (tabbar.tag == selectedTabbar) {
			[self setupTabbarItem:tabbar isSelected:YES];
		}else{
			[self setupTabbarItem:tabbar isSelected:NO];
		}
	}];
}

- (void)setupTabbarItem:(SOTabbarItemView *)tabar isSelected:(BOOL)selected{
	UILabel *titleLabel;
	UIImageView *imgIcon;

	for (id view in tabar.subviews) {
		if ([view isKindOfClass:[UIImageView class]]) {
			imgIcon = view;
		}
		if ([view isKindOfClass:[UILabel class]]) {
			titleLabel = view;
		}
	}
	
	UIColor *titleColor;
	UIImage *image;
	NSString *title;
	switch (tabar.tag) {
		case TabbarItemType_Integration:{
			title = LocalizedString(@"KTABBAR_ITEM_INTEGRATION_TITLE");
			if (selected) {
				titleColor = AppColor_MainAppTintColor;
				image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_%@", TABBAR_ITEM_INTEGRATION, HIGHTLIGHT]];
				
			}else{
				titleColor = Defatul_tabbar_item_title_color;
				image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", TABBAR_ITEM_INTEGRATION]];
			}
		}
			break;
			
		case TabbarItemType_Social:{
			title = LocalizedString(@"KTABBAR_ITEM_SOCIAL_TITLE");
			if (selected) {
				titleColor = AppColor_MainAppTintColor;
				image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_%@", TABBAR_ITEM_SOCIAL, HIGHTLIGHT]];
				
			}else{
				titleColor = Defatul_tabbar_item_title_color;
				image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", TABBAR_ITEM_SOCIAL]];
			}
		}
			break;
		case TabbarItemType_Conversation:{
			title = LocalizedString(@"KTABBAR_ITEM_CONVERSATION_TITLE");
			if (selected) {
				titleColor = AppColor_MainAppTintColor;
				image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_%@", TABBAR_ITEM_CONVERSATION, HIGHTLIGHT]];
				
			}else{
				titleColor = Defatul_tabbar_item_title_color;
				image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", TABBAR_ITEM_CONVERSATION]];
			}

		}
			break;
		case TabbarItemType_Contact:{
			title = LocalizedString(@"KTABBAR_ITEM_CONTACT_TITLE");
			if (selected) {
				titleColor = AppColor_MainAppTintColor;
				image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_%@", TABBAR_ITEM_CONTACT, HIGHTLIGHT]];
				
			}else{
				titleColor = Defatul_tabbar_item_title_color;
				image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", TABBAR_ITEM_CONTACT]];
			}
		}
			break;
		
		case TabbarItemType_More:{
			title = LocalizedString(@"KTABBAR_ITEM_MORE_TITLE");
			if (selected) {
				titleColor = AppColor_MainAppTintColor;
				image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_%@", TABBAR_ITEM_MORE, HIGHTLIGHT]];
				
			}else{
				titleColor = Defatul_tabbar_item_title_color;
				image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", TABBAR_ITEM_MORE]];
			}
		}
			break;
			
		case TabbarItemType_Logout:{
			title = LocalizedString(@"KTABBAR_ITEM_LOGOUT_TITLE");
			if (selected) {
				titleColor = AppColor_MainAppTintColor;
				image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_%@", TABBAR_ITEM_LOGOUT, HIGHTLIGHT]];
				
			}else{
				titleColor = Defatul_tabbar_item_title_color;
				image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", TABBAR_ITEM_LOGOUT]];
			}
		}
			break;
		default:
			break;
	}
	titleLabel.textColor = titleColor;
	titleLabel.text = title;
	imgIcon.image = image;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - Actions

- (IBAction)didTapOnTabbarItem:(UIButton *)sender {
	if (sender.tag != TabbarItemType_Logout) {
		BaseNavVC *navContent = _listControllers[sender.tag];
		if (_selectedTabbar == sender.tag) {
			[navContent popToRootViewControllerAnimated:NO];
		}else{
			//Refresh layout
			_selectedTabbar = sender.tag;
			[self refreshTabbars:_selectedTabbar];
			[navContent setNavigationBarHidden:YES];
			[[navContent.viewControllers.firstObject view] setBackgroundColor:AppColor_MainAppBackgroundColor];
			NSArray *newVCs = [NSArray arrayWithObjects:[self.splitViewController.viewControllers objectAtIndex:0], navContent, nil];
			self.splitViewController.viewControllers = newVCs;
			[self.splitViewController.view setNeedsDisplay];
		}
	}else{
		DLog(@"Logout");
		[AppDelegateAccessor startLoginIpad];
	}
	[self.view setNeedsLayout];
}


@end
