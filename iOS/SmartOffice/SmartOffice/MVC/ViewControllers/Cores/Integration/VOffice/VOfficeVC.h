//
//  VOfficeVC.h
//  SmartOffice
//
//  Created by Kaka on 4/4/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "BaseVC.h"

@interface VOfficeVC : BaseVC{
    
}

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *segmentViewConstrainHeight;

- (void)loadData;
- (void)loadCurrentSegment;
@end
