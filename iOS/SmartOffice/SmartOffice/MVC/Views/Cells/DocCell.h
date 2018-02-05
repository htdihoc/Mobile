//
//  DocCell.h
//  SmartOffice
//
//  Created by Kaka on 4/5/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SumDocModel;
@interface DocCell : UITableViewCell{
    
}

@property (weak, nonatomic) IBOutlet UIImageView *imgDocType;
@property (weak, nonatomic) IBOutlet UILabel *lblValue;

- (void)updateValue:(SumDocModel *)model forType:(DocType)type;

@end
