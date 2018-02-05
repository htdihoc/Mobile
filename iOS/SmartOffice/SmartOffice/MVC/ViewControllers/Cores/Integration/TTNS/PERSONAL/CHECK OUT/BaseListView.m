//
//  CheckIn.m
//  SmartOffice
//
//  Created by NguyenVanTu on 4/14/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "BaseListView.h"
#import "InfoEmployCheckOut.h"
#import "SOTableViewRowAction.h"
#import "DismissTimeKeeping.h"
@interface BaseListView () <UITableViewDelegate>
@end

@implementation BaseListView

- (void)layoutForTableView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.baseTableView = [[FullWidthSeperatorTableView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) style:UITableViewStylePlain];
    [self.view addSubview:self.baseTableView];
    self.baseTableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.baseTableView.backgroundColor = AppColor_MainAppBackgroundColor;
    self.baseTableView.rowHeight = UITableViewAutomaticDimension;
    self.baseTableView.estimatedRowHeight = 80.0; // set to whatever your "average" cell height is
    NSLayoutConstraint *top= [NSLayoutConstraint
                              constraintWithItem:self.baseTableView
                              attribute:NSLayoutAttributeTop
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeTop
                              multiplier:1.0
                              constant:64];
    NSLayoutConstraint *bottom = [NSLayoutConstraint
                                                 constraintWithItem:self.baseTableView
                                                 attribute:NSLayoutAttributeBottom
                                                 relatedBy:NSLayoutRelationEqual toItem:self.view
                                                 attribute:NSLayoutAttributeBottom multiplier:1.0f
                                                 constant:0];
    
    NSLayoutConstraint *left = [NSLayoutConstraint
                                                 constraintWithItem:self.baseTableView
                                                 attribute:NSLayoutAttributeLeft
                                                 relatedBy:NSLayoutRelationEqual
                                                 toItem:self.view attribute:
                                                 NSLayoutAttributeLeft multiplier:1.0
                                                 constant:0];
    NSLayoutConstraint *right = [NSLayoutConstraint
                                                  constraintWithItem:self.baseTableView
                                                  attribute:NSLayoutAttributeRight
                                                  relatedBy:NSLayoutRelationEqual
                                                  toItem:self.view attribute:
                                                  NSLayoutAttributeRight multiplier:1.0
                                                  constant:0];
    /* 4. Add the constraints to button's superview*/
    [self.view addConstraints:@[top, left, bottom, right]];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self deSelectRow:indexPath];
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

@end
