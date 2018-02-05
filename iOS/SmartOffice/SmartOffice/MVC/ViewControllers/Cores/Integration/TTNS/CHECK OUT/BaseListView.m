//
//  CheckIn.m
//  SmartOffice
//
//  Created by NguyenVanTu on 4/14/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "BaseListView.h"
#import "InfoEmployDetailCell.h"
#import "InfoEmployCheckOut.h"
#import "SOTableViewRowAction.h"
#import "DismissTimeKeeping.h"
@interface BaseListView ()
@end

@implementation BaseListView

- (void)layoutForTableView
{
    self.baseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) style:UITableViewStylePlain];
    [self.view addSubview:self.baseTableView];
    self.baseTableView.translatesAutoresizingMaskIntoConstraints = NO;
    /* Top space to superview Y*/
    NSLayoutConstraint *leftButtonYConstraint = [NSLayoutConstraint
                                                 constraintWithItem:self.baseTableView
                                                 attribute:NSLayoutAttributeBottom
                                                 relatedBy:NSLayoutRelationEqual toItem:self.view
                                                 attribute:NSLayoutAttributeBottom multiplier:1.0f
                                                 constant:0];
    
    /* Leading space to superview */
    NSLayoutConstraint *leftButtonXConstraint = [NSLayoutConstraint
                                                 constraintWithItem:self.baseTableView
                                                 attribute:NSLayoutAttributeLeft
                                                 relatedBy:NSLayoutRelationEqual
                                                 toItem:self.view attribute:
                                                 NSLayoutAttributeLeft multiplier:1.0
                                                 constant:0];
    NSLayoutConstraint *rightButtonXConstraint = [NSLayoutConstraint
                                                  constraintWithItem:self.baseTableView
                                                  attribute:NSLayoutAttributeRight
                                                  relatedBy:NSLayoutRelationEqual
                                                  toItem:self.view attribute:
                                                  NSLayoutAttributeRight multiplier:1.0
                                                  constant:0];
    
    /* Fixed Height */
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint
                                            constraintWithItem:self.baseTableView
                                            attribute:NSLayoutAttributeTop
                                            relatedBy:NSLayoutRelationEqual
                                            toItem:self.view
                                            attribute:NSLayoutAttributeTop
                                            multiplier:1.0
                                            constant:64];
    /* 4. Add the constraints to button's superview*/
    [self.view addConstraints:@[leftButtonXConstraint, leftButtonYConstraint, heightConstraint, rightButtonXConstraint]];
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
