//
//  VOffice_HeaderMissionView.m
//  SmartOffice
//
//  Created by NguyenVanTu on 6/10/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "VOffice_HeaderMissionView.h"

@implementation VOffice_HeaderMissionView
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
    if(CGRectIsEmpty(frame)) {
        self.bounds = self.view.bounds;
    }
    return self;
}

- (void)setup {
    self.view = [[[NSBundle mainBundle] loadNibNamed:@"VOffice_HeaderMissionView" owner:self options:nil] firstObject];
    self.view.frame = self.bounds;
    [self addSubview:self.view];
    self.rightTitleLabel.text = LocalizedString(@"VOffice_WorkPlan_iPad_Chưa_thực_hiện");
    self.leftTitleLabel.text = LocalizedString(@"VOffice_WorkPlan_iPad_Chậm_tiến_độ");
}
@end
