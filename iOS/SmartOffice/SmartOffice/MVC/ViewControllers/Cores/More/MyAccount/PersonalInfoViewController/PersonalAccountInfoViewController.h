//
//  PersonalInfoViewController.h
//  SmartOffice
//
//  Created by Vu Van Tiep on 4/25/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "TTNS_BaseVC.h"
#import "Common.h"
#import "SOSearchBarView.h"

@interface PersonalAccountInfoViewController : TTNS_BaseVC

@property (weak, nonatomic) IBOutlet UIView *contentview;
@property (weak, nonatomic) IBOutlet SOSearchBarView *searchview;
@property (weak, nonatomic) IBOutlet UILabel *label_Badge;
@property (weak, nonatomic) IBOutlet UILabel *noResultLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
