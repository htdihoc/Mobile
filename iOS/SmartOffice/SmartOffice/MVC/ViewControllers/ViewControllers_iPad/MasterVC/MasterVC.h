//
//  MasterVC.h
//  SmartOffice
//
//  Created by Kaka on 4/21/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IntegrationVC_iPad;
@class SOTabbarItemView;

@interface MasterVC : UIViewController{
	
}
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) IntegrationVC_iPad *contentVC;
//Outlets
@property (weak, nonatomic) IBOutlet SOTabbarItemView *integrationTabbar;
@property (weak, nonatomic) IBOutlet SOTabbarItemView *socialTabbar;
@property (weak, nonatomic) IBOutlet SOTabbarItemView *conversationTabbar;
@property (weak, nonatomic) IBOutlet SOTabbarItemView *contactTabbar;
@property (weak, nonatomic) IBOutlet SOTabbarItemView *moreTabbar;

@property (strong, nonatomic) NSMutableArray *listControllers;
@property (assign, nonatomic) TabbarItemType selectedTabbar;


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil controllers:(NSMutableArray *)controllers selectedAtIndex:(TabbarItemType)selectedTabbar;

@end
