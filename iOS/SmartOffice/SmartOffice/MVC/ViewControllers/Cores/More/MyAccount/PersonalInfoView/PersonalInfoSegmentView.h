//
//  PersonalInfoSegmentView.h
//  SmartOffice
//
//  Created by Nguyen Thanh Huy on 4/17/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "BaseVC.h"

@interface PersonalInfoSegmentView : BaseVC

@property (weak, nonatomic) IBOutlet UISegmentedControl *segAssetView;
@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@property (strong, nonatomic) UIViewController *currentVC;


@end
