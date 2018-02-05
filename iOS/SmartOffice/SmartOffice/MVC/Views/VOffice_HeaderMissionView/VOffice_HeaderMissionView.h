//
//  VOffice_HeaderMissionView.h
//  SmartOffice
//
//  Created by NguyenVanTu on 6/10/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VOffice_HeaderMissionView : UIView
@property (nonatomic, strong) UIView *view;
@property (weak, nonatomic) IBOutlet UIView *leftColorView;
@property (weak, nonatomic) IBOutlet UIView *rightColorView;
@property (weak, nonatomic) IBOutlet UILabel *leftTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightTitleLabel;

@end
