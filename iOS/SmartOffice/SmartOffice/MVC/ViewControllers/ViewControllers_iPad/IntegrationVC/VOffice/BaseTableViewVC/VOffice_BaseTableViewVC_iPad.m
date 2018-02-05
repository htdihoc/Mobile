//
//  VOfficeBaseTableViewVC.m
//  SmartOffice
//
//  Created by NguyenVanTu on 4/26/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "VOffice_BaseTableViewVC_iPad.h"
#import "UIView+BorderView.h"
@interface VOffice_BaseTableViewVC_iPad ()

@end

@implementation VOffice_BaseTableViewVC_iPad

- (void)layoutForTableView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.baseTableView = [[FullWidthSeperatorTableView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) style:UITableViewStylePlain];
    [self.view addSubview:self.baseTableView];
    self.baseTableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.baseTableView.backgroundColor = [UIColor whiteColor];
    self.baseTableView.rowHeight = UITableViewAutomaticDimension;
    self.baseTableView.estimatedRowHeight = 80.0; // set to whatever your "average" cell height is
    NSLayoutConstraint *top= [NSLayoutConstraint
                              constraintWithItem:self.baseTableView
                              attribute:NSLayoutAttributeTop
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.lblTitle
                              attribute:NSLayoutAttributeBottom
                              multiplier:1.0
                              constant:_spaceTop];
    NSLayoutConstraint *bottom = [NSLayoutConstraint
                                  constraintWithItem:self.baseTableView
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual toItem:self.containerView
                                  attribute:NSLayoutAttributeBottom multiplier:1.0f
                                  constant:-1];
    
    NSLayoutConstraint *left = [NSLayoutConstraint
                                constraintWithItem:self.baseTableView
                                attribute:NSLayoutAttributeLeft
                                relatedBy:NSLayoutRelationEqual
                                toItem:self.containerView attribute:
                                NSLayoutAttributeLeft multiplier:1.0
                                constant:1];
    NSLayoutConstraint *right = [NSLayoutConstraint
                                 constraintWithItem:self.baseTableView
                                 attribute:NSLayoutAttributeRight
                                 relatedBy:NSLayoutRelationEqual
                                 toItem:self.containerView attribute:
                                 NSLayoutAttributeRight multiplier:1.0
                                 constant:-1];
    /* 4. Add the constraints to button's superview*/
    [self.view addConstraints:@[top, left, bottom, right]];
}
- (void)addHeaderView:(UIView *)view
{
    [self.view addSubview:view];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *top= [NSLayoutConstraint
                              constraintWithItem:view
                              attribute:NSLayoutAttributeTop
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.lblTitle
                              attribute:NSLayoutAttributeBottom
                              multiplier:1.0
                              constant:0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint
                                  constraintWithItem:view
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f
                                  constant:_spaceTop];
    
    NSLayoutConstraint *left = [NSLayoutConstraint
                                constraintWithItem:view
                                attribute:NSLayoutAttributeLeft
                                relatedBy:NSLayoutRelationEqual
                                toItem:self.containerView attribute:
                                NSLayoutAttributeLeft multiplier:1.0
                                constant:1];
    NSLayoutConstraint *right = [NSLayoutConstraint
                                 constraintWithItem:view
                                 attribute:NSLayoutAttributeRight
                                 relatedBy:NSLayoutRelationEqual
                                 toItem:self.containerView attribute:
                                 NSLayoutAttributeRight multiplier:1.0
                                 constant:-1];
    /* 4. Add the constraints to button's superview*/
    [self.view addConstraints:@[top, left, bottom, right]];
}
- (void)selectItemsAt:(NSIndexPath *)index
{
    [self.baseTableView selectRowAtIndexPath:index animated:YES  scrollPosition:UITableViewScrollPositionBottom];
}
- (void)selectFirstItem
{
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    [self selectItemsAt:indexPath];
}
- (void)deSelectRow:(NSIndexPath *)indexPath
{
    [self.baseTableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutForTableView];
}

- (void)registerCellWith:(NSString *)identifer
{
    [self.baseTableView registerNib:[UINib nibWithNibName:identifer
                                                   bundle:[NSBundle mainBundle]]
             forCellReuseIdentifier:identifer];
}
#pragma mark UITableViewDelegate

#pragma mark UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemsToShow.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    return cell;
}
@end
