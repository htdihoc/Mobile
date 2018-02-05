//
//  KTTS_ListProperty_iPad.m
//  SmartOffice
//
//  Created by KhacViet Dinh on 5/10/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "KTTS_ListProperty_iPad.h"

@implementation KTTS_ListProperty_iPad


- (void)awakeFromNib
{
    [super awakeFromNib];
    // self.tbl_ListProperty.estimatedRowHeight = 80;
    //  self.tbl_ListProperty.rowHeight = UITableViewAutomaticDimension;
    self.tbl_ListProperty.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    if (CGRectIsEmpty(frame)) {
        self.bounds = self.view.bounds;
    }
    return self;
}

- (void)setup {
    self.view = [[[NSBundle mainBundle] loadNibNamed:@"KTTS_ListProperty_iPad" owner:self options:nil] firstObject];
    self.view.frame = self.bounds;
    [self addSubview:self.view];
    
    self.searchBar.layer.borderWidth                    = 1;
    self.searchBar.layer.borderColor                    = AppColor_BorderForView.CGColor;
    self.counterView.layer.borderWidth                  = 1;
    self.counterView.layer.borderColor                  = AppColor_BorderForView.CGColor;
    self.tbl_ListProperty.layer.borderWidth             = 1;
    self.tbl_ListProperty.layer.borderColor             = AppColor_BorderForView.CGColor;
}

- (void) didselecItem:(NSIndexPath *)indexPath {
    
}

- (IBAction)filter:(UIButton *)sender {
    [self.delegate buttonPressed:sender];
}

- (IBAction)segmentAction:(UISegmentedControl *)sender {
    [self.delegate switchSegment:sender];
}

@end
