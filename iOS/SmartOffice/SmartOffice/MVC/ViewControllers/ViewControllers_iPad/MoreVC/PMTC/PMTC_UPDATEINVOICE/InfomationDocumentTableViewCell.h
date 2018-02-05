//
//  InfomationDocumentTableViewCell.h
//  SmartOffice
//
//  Created by NguyenDucBien on 9/29/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfomationDocumentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *docNumberTittleLabel;
@property (weak, nonatomic) IBOutlet UILabel *docNumberContent;
@property (weak, nonatomic) IBOutlet UILabel *docDateTittleLabel;
@property (weak, nonatomic) IBOutlet UILabel *docDateContent;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentDocument;
@end
