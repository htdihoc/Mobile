//
//  SOTabbarController.m
//  SmartOffice
//
//  Created by Kaka on 4/3/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "SOTabbarController.h"

@interface SOTabbarController ()

@end

@implementation SOTabbarController

#pragma mark - Overide initial Tabbar
/*
    iemTitles: String array of name item title
    itemImages: String array of name image from assets
 */
- (id)initWithVCs:(NSArray *)viewControllers itemTitles:(NSArray *)itemTitles itemImages:(NSArray *)itemImages{
    self = [super init];
    if (self) {
        self.viewControllers = viewControllers;
        for (UIViewController *itemVC in self.viewControllers)
        {
            itemVC.tabBarItem.title = [itemTitles objectAtIndex: [self.viewControllers indexOfObject: itemVC]];
            UIImage *imgItem = [[UIImage imageNamed:itemImages[[self.viewControllers indexOfObject:itemVC]]]
                                imageWithRenderingMode:UIImageRenderingModeAutomatic];
            
            
            itemVC.tabBarItem.image = imgItem;
        }

    }
    return self;
}

#pragma mark - Main

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tabBar.tintColor = kMainAppTintColor;
    [UITabBarItem.appearance setTitleTextAttributes: @{
                                                       //NSForegroundColorAttributeName : [UIColor colorWithRed:214.0/255 green:69.0/255 blue:65.0/255 alpha:1.0],
                                                       NSFontAttributeName :kMainFontWithSize(11)
                                                       } forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor blackColor] }
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor blackColor] }
                                             forState:UIControlStateSelected];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
