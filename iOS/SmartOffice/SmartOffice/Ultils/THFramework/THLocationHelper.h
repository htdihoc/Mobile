//
//  THLocationHelper.h
//  SpeedTest
//
//  Created by Nguyen Thanh Huy on 7/17/16.
//  Copyright © 2016 Nguyen Thanh Huy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MobileCoreServices/MobileCoreServices.h>

//Location
typedef void(^locationBlock)(NSString *oLatitude, NSString *oLongitude, NSString *oAdress, NSString *oArea);
typedef void(^locationError)(NSError *err);

@interface THLocationHelper : NSObject<CLLocationManagerDelegate>

@property (nonatomic, strong) locationBlock _locationBlock;
@property (nonatomic, strong) locationError _locationError;
@property (nonatomic,copy)CLLocationManager *locationManager;
@property (nonatomic)CLLocationCoordinate2D coordinate;
@property (nonatomic,strong) NSString *current_Lat;
@property (nonatomic,strong) NSString *current_Long;

//Location
-(void)GetCurrentLocation_WithBlock:(void(^)(NSString *latitude, NSString *longitude, NSString *adress, NSString *area))block error:(void(^)(NSError *error))errBlock;

@end
