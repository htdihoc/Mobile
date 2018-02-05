//
//  ToolVC.h
//  SmartOffice
//
//  Created by Kaka on 4/3/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "BaseVC.h"
#pragma Doc_Type
typedef enum : NSInteger {
    ViewType_TTNS = 0,
    ViewType_QLTT
} ViewType;
@interface IntegrationVC: BaseVC{
    
}
@property (weak, nonatomic) IBOutlet UIView *topView;

- (IBAction)showListNotification:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *buttonReload;

@end
