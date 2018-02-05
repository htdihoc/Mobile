//
//  KTTS_DetailPropertyView_iPad.m
//  SmartOffice
//
//  Created by KhacViet Dinh on 5/10/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "KTTS_DetailPropertyView_iPad.h"
#import "KTTS_ConfirmProperty_iPad.h"
#import "WYPopoverController.h"

@interface KTTS_DetailPropertyView_iPad () <WYPopoverControllerDelegate> {
@protected WYPopoverController *popOverController;
}

@end

@implementation KTTS_DetailPropertyView_iPad

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.lbl_title.text = @"Chi tiết tài sản";
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
    self.view = [[[NSBundle mainBundle] loadNibNamed:@"KTTS_DetailPropertyView_iPad" owner:self options:nil] firstObject];
    self.view.frame = self.bounds;
    [self addSubview:self.view];
}

- (IBAction)action_Confirm:(id)sender {
    [self.delegate buttonShowConfirmVC:sender];
}

@end
