//
//  LoginVC.h
//  SmartOffice
//
//  Created by Nguyen Thanh Huy on 3/28/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginVC : UIViewController {
    
}
@property (weak, nonatomic) IBOutlet UITextField *text_username;
@property (weak, nonatomic) IBOutlet UITextField *text_password;


- (IBAction)btnLoginPressed:(id)sender;

@end
