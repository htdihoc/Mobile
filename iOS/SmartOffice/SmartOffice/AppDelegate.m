//
//  AppDelegate.m
//  SmartOffice
//
//  Created by Nguyen Thanh Huy on 3/28/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginVC.h"
#import "BaseNavVC.h"
#import "MoreVC.h"
#import "WYPopoverController.h"
#import "MasterVC.h"
#import "IntegrationVC_iPad.h"
#import "SocialVC_iPad.h"
#import "ConversationVC_iPad.h"
#import "ContactVC_iPad.h"
#import "MoreVC_iPad.h"
#import "MasterViewController.h"
#import "KTTS_PersonalInforVC_iPad.h"
#import "TimePickerVC.h"
#import "KTTS_PersonalInforVC_iPad.h"
#import "SurveyViewController_iPad.h"
#import "QLTT_MainVC_iPad.h"
#import "PMTCViewController_iPad.h"
#import "IQKeyboardManager.h"
#import "MBProgressHUD.h"
#import "KTTSViewController.h"

#define kOriginYMoreView                            264.0
#define FR_MORE_VC_HEIGHT                           320
#define FR_TABBAR_HEIGHT                            44
#define kAnimationTimeMoreView                      0.7

#define kTABBAR_ITEM_WIDTH	70

@interface AppDelegate () <SelectTabDelegate> {
    BaseNavVC *naviMaster;
    UIView *containerView;
    NSMutableArray *viewcontroller;
}

@end

@implementation AppDelegate

static AppDelegate *sharedManager;

#pragma mark - AppDelegate singleton -

+ (AppDelegate*)getInstance {
    if (sharedManager == nil) {
        sharedManager = [[AppDelegate alloc] init];
    }
    
    return sharedManager;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    //Fixed UserSession
    [GlobalObj getInstance].userSession = @"sasaaass";
    // Override point for customization after application launch.
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    //set background for top popOver
    WYPopoverBackgroundView* popoverAppearance = [WYPopoverBackgroundView appearance];
    [popoverAppearance setFillTopColor:[UIColor whiteColor]];
    [popoverAppearance setGlossShadowColor:[UIColor clearColor]];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil] setColor:AppColor_MainAppTintColor];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = AppColor_MainAppBackgroundColor;
    LoginVC *viewController = [[LoginVC alloc] initWithNibName:@"LoginVC" bundle:nil];
    self.navController = [[BaseNavVC alloc] initWithRootViewController:viewController];
    self.window.rootViewController = self.navController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)removeMoreVCFromApp
{
    
}

- (void)startLoginIpad{
    LoginVC *viewController = [[LoginVC alloc] initWithNibName:@"LoginVC" bundle:nil];
    BaseNavVC *_navLogin= [[BaseNavVC alloc] initWithRootViewController:viewController];
    [_navLogin setNavigationBarHidden:YES];
    self.window.rootViewController = _navLogin;
    [self.window makeKeyAndVisible];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "nth.SmartOffice" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"SmartOffice" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"SmartOffice.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


#pragma mark - Main Functions
- (void)startMain{
	//Reset All Nav
	self.mainTabbarController = nil;

    NSMutableArray *localVCArray = [[NSMutableArray alloc] initWithCapacity:5];
    self.navIntegrationVC = NEW_VC_FROM_STORYBOARD(@"Integration", @"navIntegration");
    [localVCArray addObject:self.navIntegrationVC];
    BaseNavVC *navSocial = NEW_VC_FROM_STORYBOARD(@"Social", @"navSocial");
    [localVCArray addObject:navSocial];
    BaseNavVC *navConversation = NEW_VC_FROM_STORYBOARD(@"Conversation", @"navConversation");
    [localVCArray addObject:navConversation];
    BaseNavVC *navContact = NEW_VC_FROM_STORYBOARD(@"Contact", @"navContact");
    [localVCArray addObject:navContact];
    self.navMoreVC = NEW_VC_FROM_STORYBOARD(@"More", @"navMore");
    [localVCArray addObject:self.navMoreVC];
    
    NSMutableArray *titleArray = [NSMutableArray arrayWithObjects:LocalizedString(@"KTABBAR_ITEM_INTEGRATION_TITLE"), LocalizedString(@"KTABBAR_ITEM_SOCIAL_TITLE"), LocalizedString(@"KTABBAR_ITEM_CONVERSATION_TITLE"), LocalizedString(@"KTABBAR_ITEM_CONTACT_TITLE"),LocalizedString(@"KTABBAR_ITEM_MORE_TITLE"), nil];
    NSMutableArray *imageArray = [NSMutableArray arrayWithObjects: @"tabbar_integration_icon", @"tabbar_social_icon", @"tabbar_conversation_icon", @"tabbar_contact_icon", @"tabbar_more_icon", nil];
    if (self.mainTabbarController == nil) {
        self.mainTabbarController = [[SOTabbarController alloc] initWithVCs:localVCArray itemTitles:titleArray itemImages:imageArray];
        //self.mainTabbarController.delegate = self;
    }
    [self.mainTabbarController setSelectedIndex:0];
    self.window.rootViewController = self.mainTabbarController;
    [self.window makeKeyAndVisible];
}

- (void)startMainIpad{
    _splitVC = [[UISplitViewController alloc] init];
    viewcontroller = [NSMutableArray new];
    
    // Integration
    IntegrationVC_iPad *integrationVC = [[IntegrationVC_iPad alloc] initWithNibName:@"IntegrationVC_iPad" bundle:nil];
    self.navIntegrationVC = [[BaseNavVC alloc] initWithRootViewController:integrationVC];
    [self.navIntegrationVC setNavigationBarHidden:YES];
    [viewcontroller addObject:self.navIntegrationVC];
    
    // Social
    SocialVC_iPad *soialVC = [[SocialVC_iPad alloc] initWithNibName:@"SocialVC_iPad" bundle:nil];
    self.navSocial = [[BaseNavVC alloc] initWithRootViewController:soialVC];
    [self.navSocial setNavigationBarHidden:YES];
    [viewcontroller addObject:self.navSocial];
    
    // Conversation
    ConversationVC_iPad *conversationVC = [[ConversationVC_iPad alloc] initWithNibName:@"ConversationVC_iPad" bundle:nil];
    self.navConversation = [[BaseNavVC alloc] initWithRootViewController:conversationVC];
    [self.navConversation setNavigationBarHidden:YES];
    [viewcontroller addObject:self.navConversation];
    
    // Contact
    ContactVC_iPad *contactVC = [[ContactVC_iPad alloc] initWithNibName:@"ContactVC_iPad" bundle:nil];
    self.navContact = [[BaseNavVC alloc] initWithRootViewController:contactVC];
    [self.navContact setNavigationBarHidden:YES];
    [viewcontroller addObject:self.navContact];
    
    // More
    MoreVC_iPad *moreVC_iPad = [[MoreVC_iPad alloc] initWithNibName:@"MoreVC_iPad" bundle:nil];
    self.navMoreVC = [[BaseNavVC alloc] initWithRootViewController:moreVC_iPad];;
    [self.navMoreVC setNavigationBarHidden:YES];
    [viewcontroller addObject:self.navMoreVC];
    
    // KTTS
//    KTTS_PersonalInforVC_iPad *ktts_VC_iPad = [[KTTS_PersonalInforVC_iPad alloc] initWithNibName:@"KTTS_PersonalInforVC_iPad" bundle:nil];
//    self.navKTTS = [[BaseNavVC alloc] initWithRootViewController:ktts_VC_iPad];;
//    [self.navKTTS setNavigationBarHidden:YES];
//    [viewcontroller addObject:self.navKTTS];
    
    // KTTS New
    UIStoryboard *storyboard_ktts = [UIStoryboard storyboardWithName:@"KTTS" bundle:nil];
    KTTSViewController *kttsViewController = (KTTSViewController *)[storyboard_ktts instantiateViewControllerWithIdentifier:@"KTTSViewController"];
    self.navKTTS = [[BaseNavVC alloc] initWithRootViewController:kttsViewController];
    [self.navKTTS setNavigationBarHidden:YES];
    [viewcontroller addObject:self.navKTTS];
    
    // Survey
    UIStoryboard *storyboard_survey = [UIStoryboard storyboardWithName:@"SurveyViewController_iPad" bundle:nil];
    SurveyViewController_iPad *survey_VC_iPad = (SurveyViewController_iPad *)[storyboard_survey instantiateViewControllerWithIdentifier:@"SurveyViewController_iPad"];
    self.navSurvey = [[BaseNavVC alloc] initWithRootViewController:survey_VC_iPad];;
    [self.navSurvey setNavigationBarHidden:YES];
    [viewcontroller addObject:self.navSurvey];
    
    // QLTT
    QLTT_MainVC_iPad *qltt_iPad = [[QLTT_MainVC_iPad alloc] initWithNibName:@"QLTT_MainVC_iPad" bundle:nil];
    self.navQLTT = [[BaseNavVC alloc] initWithRootViewController:qltt_iPad];;
    [self.navQLTT setNavigationBarHidden:YES];
    [viewcontroller addObject:self.navQLTT];
    
    // PMTC
    UIStoryboard *storyboard_pmtc = [UIStoryboard storyboardWithName:@"PMTC_iPad" bundle:nil];
    PMTCViewController_iPad *pmtc_iPad = (PMTCViewController_iPad *)[storyboard_pmtc instantiateViewControllerWithIdentifier:@"PMTCViewController_iPad"];
    self.navPMTC = [[BaseNavVC alloc] initWithRootViewController:pmtc_iPad];;
    [self.navPMTC setNavigationBarHidden:YES];
    [viewcontroller addObject:self.navPMTC];
    
    // Master
    MasterViewController *master = [[MasterViewController alloc] initWithNibName:@"MasterViewController" bundle:nil controllers:viewcontroller];
    master.delegate = self;
    naviMaster = [[BaseNavVC alloc] initWithRootViewController:master];
    [naviMaster setNavigationBarHidden:YES];
    [_splitVC setValue:@0.0 forKey:@"gutterWidth"];
    _splitVC.viewControllers = @[naviMaster, self.navIntegrationVC];
    _splitVC.maximumPrimaryColumnWidth = kTABBAR_ITEM_WIDTH;
    _splitVC.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
    self.window.rootViewController = _splitVC;
    [self.window makeKeyAndVisible];
}

- (void)selectFuntioninTab:(NSInteger)indexPath {
    switch (indexPath) {
        case 0:
        {
            [self selectViewController:self.navIntegrationVC];
        }
            break;
        case 1:
        {
            [self selectViewController:self.navSocial];
        }
            break;
        case 2:
        {
            [self selectViewController:self.navConversation];
        }
            break;
        case 3:
        {
            [self selectViewController:self.navContact];
        }
            break;
        case 4:
        {
            [self selectViewController:self.navContact];
        }
            break;
        case 5:
        {
            [self selectViewController:self.navContact];
        }
            break;
        case 6:
        {
            [self selectViewController:self.navKTTS];
        }
            break;
        case 7:
        {
            [self selectViewController:self.navSurvey];
        }
            break;
        case 8:
        {
            [self selectViewController:self.navPMTC];
        }
            break;
        case 9:
        {
            [self selectViewController:self.navQLTT];
        }
            break;
        case 10:
        {
            [AppDelegateAccessor startLoginIpad];
        }
            break;
        default:
            break;
    }
}

- (void) selectViewController:(UINavigationController *)navi {
    _splitVC.viewControllers = @[naviMaster, navi];
}

- (void)removeContainerMoreVC {
    if (containerView != nil) {
        [containerView removeFromSuperview];
    }
}

- (void) setPropertyItalic: (UISearchBar *)searchBar fontsize: (int)size {
    [[UITextField appearanceWhenContainedIn: [UISearchBar class], nil] setFont: [UIFont fontWithName:@"HelveticaNeue-Italic" size: size]];
}

- (id)transformedValue:(id)value
{
    
    double convertedValue = [value doubleValue];
    int multiplyFactor = 0;
    
    NSArray *tokens = @[@"bytes",@"KB",@"MB",@"GB",@"TB",@"PB", @"EB", @"ZB", @"YB"];
    
    while (convertedValue > 1024) {
        convertedValue /= 1024;
        multiplyFactor++;
    }
    
    return [NSString stringWithFormat:@"%4.2f%@",convertedValue, tokens[multiplyFactor]];
}

- (void)setupSegment:(UISegmentedControl *)segment {
    for (int i=0; i<[segment.subviews count]; i++)
    {
        if ([[segment.subviews objectAtIndex:i] respondsToSelector:@selector(isSelected)] && [[segment.subviews objectAtIndex:i] isSelected])
        {
            [segment.subviews objectAtIndex:i].tintColor = AppColor_MainAppTintColor;
        } else {
            [segment.subviews objectAtIndex:i].backgroundColor = [UIColor whiteColor];
        }
    }
}

@end
