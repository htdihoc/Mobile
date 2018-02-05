//
//  ListNotificationVC.m
//  SmartOffice
//
//  Created by Hien Tuong on 4/17/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "ListNotificationVC.h"
#import "ReminderViewController.h"
#import "NotificationCell.h"
#import "SOTableViewRowAction.h"

@interface ListNotificationVC ()<UITableViewDataSource, UITableViewDelegate>{
@protected BOOL isEditting;
@protected BOOL isShowBottomView;
@protected BOOL isSelectAll;
}

@end

@implementation ListNotificationVC

#pragma mark LifeCycler

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(IS_PAD){
        _bottomContraint.constant = 0;
    } else{
        _bottomContraint.constant = 56;
    }
    
    [self setupUI];
    [AppDelegateAccessor.mainTabbarController.tabBar setHidden:YES];
     _topConstraint.constant = 44;
    [self.tableView reloadData];
}

#pragma mark UI

- (void)setupUI{
    isEditting = NO;
    self.backTitle = LocalizedString(@"KNOTIFICATION_REPORT");
    self.rightTitle = LocalizedString(@"KNOTIFICATION_DELETE");
    [self.selectAllButton setTitle:LocalizedString(@"KNOTIFICATION_SELECTALL") forState:UIControlStateNormal];
    [self.deleteButton setTitle:LocalizedString(@"KNOTIFICATION_DELETE") forState:UIControlStateNormal];
    [self.bottomView setHidden:YES];
    isShowBottomView = NO;
    isSelectAll      = NO;
}

#pragma mark Action

- (void)didTapRightButton{
    if(!isShowBottomView){
        [self.bottomView setHidden:NO];
        self.rightTitle = LocalizedString(@"KNOTIFICATION_CLOSE");
        
    } else {
        [self.bottomView setHidden:YES];
        self.rightTitle = LocalizedString(@"KNOTIFICATION_DELETE");
    }
    isShowBottomView = !isShowBottomView;
    
    [self.tableView reloadData];
}

#pragma mark UITABLEVIEWDATASOURCE

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* Identifier         = @"NotificationCell";
    
    NotificationCell *cell              = [tableView dequeueReusableCellWithIdentifier:Identifier];
    
    if(cell == nil){
        [tableView registerNib:[UINib nibWithNibName:Identifier bundle:nil] forCellReuseIdentifier:Identifier];
        cell                            = [tableView dequeueReusableCellWithIdentifier:Identifier];
        cell.selectionStyle             = UITableViewCellSelectionStyleNone;
    }
    
    if(isShowBottomView){
        [cell.btnCheck setHidden:NO];
        
        if(isSelectAll){
            [cell.btnCheck setSelected:YES];
        } else {
            [cell.btnCheck setSelected:NO];
        }
        
    } else {
        [cell.btnCheck setHidden:YES];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    SOTableViewRowAction *delete = [SOTableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                                      title:@"Reminder"
                                                                       icon:[UIImage imageNamed:@"icon_reminder"]
                                                                      color:[UIColor orangeColor]
                                                                    handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
                                                                        DLog(@"%ld",(long)indexPath.row);
                                                                        ReminderViewController *rm = NEW_VC_FROM_STORYBOARD(@"Reminder", @"ReminderViewController");
                                                                        [AppDelegateAccessor.navIntegrationVC pushViewController:rm animated:YES];
                                                                        
                                                                    }];
    
    delete.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    return @[delete];
}

#pragma mark IBAction

- (IBAction)selectAllAction:(id)sender {
    isSelectAll = !isSelectAll;
    [self.tableView reloadData];
}

- (IBAction)deleteAction:(id)sender {
}
@end
