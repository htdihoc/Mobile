//
//  SOSearchBarView.h
//  SmartOffice
//
//  Created by NguyenVanTu on 7/31/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSubView.h"
#import "SOSearchBarTextField.h"
@protocol SOSearchBarViewDelegate<NSObject>
@optional
- (void)textField:(UITextField *)textField textDidChange:(NSString *)searchText;
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
- (void)textFieldDidBeginEditing:(UITextField *)textField;
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField;
- (void)textFieldDidEndEditing:(UITextField *)textField;
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
-(BOOL)textFieldShouldClear:(UITextField *)textField;
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
@end

@interface SOSearchBarView : BaseSubView
@property (weak, nonatomic) IBOutlet SOSearchBarTextField *searchBar;
@property (weak, nonatomic) id<SOSearchBarViewDelegate> delegate;
@property (strong, nonatomic) NSString* placeholder;
@property (strong, nonatomic) NSString* text;
@property (assign) BOOL isCommentVC;

- (void)dismissKeyboard;

@end
