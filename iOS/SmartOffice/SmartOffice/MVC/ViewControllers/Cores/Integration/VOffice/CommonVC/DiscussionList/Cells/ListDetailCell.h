//
//  ListDetailCell.h
//  SmartOffice
//
//  Created by NguyenDucBien on 5/17/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmployeeModel.h"

@class ListDetailCell;

@protocol DiscussionListDelegate <NSObject>

- (void)didPressButtonAtCell:(ListDetailCell *)cell;

@end

@interface ListDetailCell : UITableViewCell {
    id<DiscussionListDelegate>_delegate;
}


@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbPosition;
@property (weak, nonatomic) IBOutlet UIButton *buttonDelete;

@property (strong, nonatomic) NSIndexPath *indexPath;

@property (nonatomic, assign) id<DiscussionListDelegate> delegate;


- (IBAction)btnDeleteCell:(id)sender;

//Passing data
- (void)setupDataFromModel:(EmployeeModel *)model;


@end
