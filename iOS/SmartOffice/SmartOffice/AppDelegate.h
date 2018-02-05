//
//  AppDelegate.h
//  SmartOffice
//
//  Created by Nguyen Thanh Huy on 3/28/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "THNavigationVC.h"
#import "SOTabbarController.h"
#import "BaseNavVC.h"
#import "BaseVC.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate> //UITabBarDelegate

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) BaseNavVC *navController;
@property (strong, nonatomic) SOTabbarController *mainTabbarController;

@property (strong, nonatomic) BaseNavVC *navIntegrationVC;
@property (strong, nonatomic) BaseNavVC *navSocial;
@property (strong, nonatomic) BaseNavVC *navConversation;
@property (strong, nonatomic) BaseNavVC *navContact;
@property (strong, nonatomic) BaseNavVC *navMoreVC;
@property (strong, nonatomic) BaseNavVC *navKTTS;
@property (strong, nonatomic) BaseNavVC *navSurvey;
@property (strong, nonatomic) BaseNavVC *navQLTT;
@property (strong, nonatomic) BaseNavVC *navPMTC;


//For iPad
@property (strong, nonatomic) UISplitViewController *splitVC;

+ (AppDelegate*)getInstance;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

//MoreVC frame
//- (void)setMoreVCFrameOrg;
- (void)removeMoreVCFromApp;
//- (void)showModalViewOnScreen:(BaseVC *)viewVC;

//+++ Main Actions
- (void)startMain;
- (void)startMainIpad;
- (void)startLoginIpad;
- (void) setPropertyItalic: (UISearchBar *)searchBar fontsize: (int)size;
- (id)transformedValue:(id)value;
- (void)setupSegment:(UISegmentedControl *)segment;
@end

