//
//  TTNS_BaseSwipeView.m
//  SmartOffice
//
//  Created by NguyenVanTu on 4/21/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "TTNS_BaseSwipeView.h"
#import "DismissTimeKeeping.h"
#import "Common.h"

@interface TTNS_BaseSwipeView () <DismissTimeKeepingDelegate>{

@protected BOOL _isEmpty;
}

@end

@implementation TTNS_BaseSwipeView

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
     NSLog(@"canEditRowAtIndexPath");
    return YES;
}
- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath
{
    
    NSLog(@"commitEditingStyle");
    // All tasks are handled by blocks defined in editActionsForRowAtIndexPath, however iOS8 requires this method to enable editing
}
//Swipe Cell
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UIImage *rejectIcon = [UIImage imageNamed:@"rejectSwipe"];
    UIImage *accpetIcon = [UIImage imageNamed:@"acceptSwipe"];
    SOTableViewRowAction *reject = [SOTableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                                      title:LocalizedString(@"TTNS_SwipeCell_Từ_chối")
                                                                       icon:rejectIcon
                                                                      color:CommonColor_Red
                                                                    handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
                                                                        [self reject:indexPath];
                                                                    }];
    
    SOTableViewRowAction *accpet = [SOTableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                                      title:LocalizedString(@"TTNS_SwipeCell_Phê_duyệt")
                                                                       icon:accpetIcon
                                                                      color:CommonColor_DarkBlue
                                                                    handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
                                                                        [self accpet:indexPath];
                                                                    }];
    
    return @[accpet, reject];
}

-(void)reject
{
    
}

-(void)accpet
{
}

-(void)isEmpty:(BOOL)isEmpty
{
    _isEmpty  = isEmpty;
}

- (void)showDismissTimeKeeping:(void (^)(void))rightAction andLeftAction:(void (^)(void))leftAction
{
    _content = [[DismissTimeKeeping alloc] initWithNibName:@"DismissTimeKeeping" bundle:nil];
    _content.delegate = self;
    [self showAlert:_content title:LocalizedString(@"TTNS_TTNSBaseSwipeView_Từ_chối_phê_duyệt") leftButtonTitle: LocalizedString(@"Huỷ") rightButtonTitle:LocalizedString(@"TTNS_CheckOut_Từ_chối") leftHander:leftAction rightHander:rightAction];
}

@end
