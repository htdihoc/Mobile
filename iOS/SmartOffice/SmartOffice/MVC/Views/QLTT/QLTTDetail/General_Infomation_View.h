//
//  General_Infomation_View.h
//  SmartOffice
//
//  Created by Vu Van Tiep on 7/17/29 H.
//  Copyright © 29 Heisei ITSOL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSubView.h"
@interface General_Infomation_View : BaseSubView

@property (weak, nonatomic) IBOutlet UILabel *title_author;
@property (weak, nonatomic) IBOutlet UILabel *value_author;

@property (weak, nonatomic) IBOutlet UILabel *title_language;
@property (weak, nonatomic) IBOutlet UILabel *value_language;

@property (weak, nonatomic) IBOutlet UILabel *title_approver;
@property (weak, nonatomic) IBOutlet UILabel *value_approver;

@property (weak, nonatomic) IBOutlet UILabel *title_numberofpage;
@property (weak, nonatomic) IBOutlet UILabel *value_numberofpage;

@property (weak, nonatomic) IBOutlet UILabel *title_creator;
@property (weak, nonatomic) IBOutlet UILabel *value_creator;

- (void) loadDataWith:(QLTTMasterDocumentModel *)model;
@end
