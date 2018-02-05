//
//  KTTS_ListProperty_iPad.h
//  SmartOffice
//
//  Created by KhacViet Dinh on 5/10/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SOSearchBarView.h"
#import "FullWidthSeperatorTableView.h"

@protocol KTTS_ListPropertyDelegate_iPad <NSObject>

- (void)buttonPressed:(UIButton *)sender;
- (void)switchSegment:(UISegmentedControl *)segment;

@end

@interface KTTS_ListProperty_iPad : UIView 

@property (weak, nonatomic) IBOutlet UITableView *tbl_ListProperty;
@property (weak, nonatomic) IBOutlet SOSearchBarView *searchview;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sgm_WorkType;

@property (weak, nonatomic) IBOutlet UILabel *lbl_Badge;

@property (weak, nonatomic) IBOutlet UILabel *lbl_Message;
@property (weak, nonatomic) IBOutlet UILabel *lbl_PropretyCount;

@property (nonatomic, strong) UIView *view;

@property (weak, nonatomic) IBOutlet UIButton *btn_filter;

@property (weak, nonatomic) IBOutlet UIView *sgmView;

@property (weak, nonatomic) IBOutlet UIView *counterView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) id<KTTS_ListPropertyDelegate_iPad> delegate;


@end
