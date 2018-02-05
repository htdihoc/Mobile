//
//  PersonalInfoVC.m
//  SmartOffice
//
//  Created by Hien Tuong on 4/17/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "MoreInfoVC.h"

#import "PersonalInfoCell.h"
#import "MenuCell.h"
#import "PersonalInfoVC.h"
#import "PersonalAccountInfoViewController.h"
#import "AttachDocVC.h"
#import "PositionVC.h"
#import "AttachDocVC.h"
#import "UserInfoCell.h"
@interface MoreInfoVC ()<UITableViewDataSource, UITableViewDelegate, TTNS_BaseNavViewDelegate>

@property (strong, nonatomic) NSMutableArray *menuArray;
@property (strong, nonatomic) NSMutableArray *imageArray;

@end

@implementation MoreInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.backTitle = @"Thông tin chung";
    self.menuArray = [NSMutableArray arrayWithObjects:
                      LocalizedString(@"KGENERALINFO_SCR_PERSIONAL_INFO"),
                      LocalizedString(@"KGENERALINFO_SCR_PERSIONAL_ASSEST"),
                      LocalizedString(@"KGENERALINFO_SCR_TRAINING_PROCESS"),
                      LocalizedString(@"KGENERALINFO_SCR_SALARY"),
                      LocalizedString(@"KGENERALINFO_SCR_INSTRUMENT"),
                      LocalizedString(@"KGENERALINFO_SCR_BONUS"),
                      LocalizedString(@"KGENERALINFO_SCR_SOCIAL_INST"),
                      LocalizedString(@"KGENERALINFO_SCR_PER_TYPE"),
                      LocalizedString(@"KGENERALINFO_SCR_AWARD"),
                      LocalizedString(@"KGENERALINFO_SCR_TAX"),
                      LocalizedString(@"KGENERALINFO_SCR_FILES"),
                      LocalizedString(@"KGENERALINFO_SCR_RELATIONSHIP"), nil];
    
    self.imageArray = [NSMutableArray arrayWithObjects:@"thongtincanhan", @"thongtintaisancanhan", @"quatrinhdaotaovanghiencuu", @"dienbienluongchucdanh", @"dienbienluongbaohiem", @"dienbienluongphucap", @"quatrinhthamgiabhxh", @"quatrinhloaicanbo", @"khenthuongvakyluat", @"thuevagiamtrugiacanh", @"hosokemtheo", @"quanhegiadinh", nil];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 2;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if(section == 0){
//        return 1;
//    } else {
        return self.menuArray.count + 1;
//    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    static NSString* IdentifierCell1                = @"PersonalInfoCell";
    static NSString* IdentifierCell2                = @"MenuCell";
    if (indexPath.row == 0) {
        UserInfoCell *userInfoCell = (UserInfoCell *)[tableView dequeueReusableCellWithIdentifier:@"userInfoCell"];
        if (userInfoCell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UserInfoCell" owner:self options:nil];
            userInfoCell = [nib objectAtIndex:0];
        }
        userInfoCell.selectionStyle = UIAccessibilityTraitNone;
        if (self.employeeDetail) {
            [userInfoCell setDataForCell:self.employeeDetail];
        }
        return userInfoCell;
    }else
    {
        MenuCell *menuCell = [tableView dequeueReusableCellWithIdentifier:IdentifierCell2];
        if(menuCell == nil){
            [tableView registerNib:[UINib nibWithNibName:IdentifierCell2 bundle:nil] forCellReuseIdentifier:IdentifierCell2];
            menuCell = [tableView dequeueReusableCellWithIdentifier:IdentifierCell2];
        }
        menuCell.lb_menu_option.text = [self.menuArray objectAtIndex:indexPath.row-1];
        menuCell.img_option.image = [UIImage imageNamed:[self.imageArray objectAtIndex:indexPath.row-1]];
        menuCell.img_option.contentMode = UIViewContentModeScaleAspectFit;
        //menuCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return menuCell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 90;
    }
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == 0) {
//        
//    } else {
//        NSLog(@"%li", (long)indexPath.row);
        switch (indexPath.row) {
            case 1:
            {
                PersonalInfoVC *vc = [[PersonalInfoVC alloc] initWithNibName:@"PersonalInfoVC" bundle:nil];
                vc.employeeDetail = self.employeeDetail;
                [self.navigationController pushViewController:vc animated:YES];
                
            }
                break;
            case 2:
            {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PersonalAccountInfo" bundle:nil];
                PersonalAccountInfoViewController *personalInfoVC = (PersonalAccountInfoViewController *)[storyboard instantiateViewControllerWithIdentifier:@"PersonalAccountInfoViewController"];
                [self.navigationController pushViewController:personalInfoVC animated:YES];
            }
                break;
            case 3:
            {

                
                
            }
                break;
            case 4:
            {
                // KGENERALINFO_SCR_SALARY
                
                PositionVC *vc = [[PositionVC alloc] initWithNibName:@"PositionVC" bundle:nil];
                
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 5:
            {
                
            }
                break;
            case 6:
            {
                
            }
                break;
            case 7:
            {
                
            }
                break;
            case 8:
            {
                
            }
                break;
            case 9:
            {
                
            }
                break;
            case 10:
            {
                
            }
                break;
            case 11:
            {
                AttachDocVC *vc = [[AttachDocVC alloc] initWithNibName:@"AttachDocVC" bundle:nil];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 12:
            {
            
            }
                break;
            default:
                break;
        }
//    }
}

- (void)didTapBackButton {
    [self popToMoreRoot];
}

@end
