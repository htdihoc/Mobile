//
//  ReminderViewController.m
//  SmartOffice
//
//  Created by Vu Van Tiep on 4/17/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "ReminderViewController.h"
#import "CreateRemiderViewController.h"
#import "ReminderCell.h"

@interface ReminderViewController () <UITableViewDelegate, UITableViewDataSource, TTNS_BaseNavViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *remiderTableView;

@end

@implementation ReminderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.backTitle = LocalizedString(@"KMORE_REMINDER");
    self.rightTitle = LocalizedString(@"KMORE_CREATE");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

// btn create reminder action
- (void) didTapRightButton {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CreateRemider" bundle:nil];
    
    CreateRemiderViewController *createRemider = (CreateRemiderViewController *)[storyboard instantiateViewControllerWithIdentifier:@"CreateRemiderViewController"];
    [self.navigationController pushViewController:createRemider animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"reminderCell";
    ReminderCell *reminderCell = (ReminderCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    reminderCell.selectionStyle = UIAccessibilityTraitNone;
    return reminderCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (void)didTapBackButton {
    [self popToMoreRoot];
    [self popToIntegrationRoot];
}

@end
