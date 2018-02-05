//
//  ViewController.h
//  autolayout
//
//  Created by Admin on 4/10/17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface InComeDetail : UIViewController{
    NSArray *_payInfoItems;
}


- (void)setDataForView:(double)totalOtherIncome totalSXKD:(double)totalSXKD totalPeriod:(double)totalPeriod;
@end
