//
//  THLocationHelper.m
//  SpeedTest
//
//  Created by Nguyen Thanh Huy on 7/17/16.
//  Copyright © 2016 Nguyen Thanh Huy. All rights reserved.
//

#import "THLocationHelper.h"

@implementation THLocationHelper

#pragma mark - CLLocationManager
-(void)GetCurrentLocation_WithBlock:(void(^)(NSString *latitude, NSString *longitude, NSString *adress, NSString *area))block error:(void (^)(NSError *))errBlock {
    self._locationBlock = block;
    self._locationError = errBlock;
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager setDelegate:self];
    [_locationManager setDistanceFilter:kCLDistanceFilterNone];
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    //if (IS_OS_8_OR_LATER) {
        NSUInteger code = [CLLocationManager authorizationStatus];
        if (code == kCLAuthorizationStatusNotDetermined && [_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [_locationManager requestWhenInUseAuthorization];
            //[_locationManager requestAlwaysAuthorization];
        }
    //}
    [_locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    @try {
        CLLocation *currentLoc=[locations objectAtIndex:0];
        _coordinate=currentLoc.coordinate;
        _current_Lat = [NSString stringWithFormat:@"%f",currentLoc.coordinate.latitude];
        _current_Long = [NSString stringWithFormat:@"%f",currentLoc.coordinate.longitude];
        NSLog(@"here lat %@ and here long %@",_current_Lat,_current_Long);
        
        CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
        [geocoder reverseGeocodeLocation:currentLoc completionHandler:^(NSArray *placemarks, NSError *error)
         {
             if (!(error))
             {
                 CLPlacemark *placemark = [placemarks objectAtIndex:0];
                 //NSLog(@"\nCurrent Location Detected\n");
                 //NSLog(@"placemark %@",placemark);
                 NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
                 NSString *Address = @"";
                 if (locatedAt != nil) {
                     Address = locatedAt;
                 }
                 NSString *Area = @"";
                 if (placemark.locality != nil) {
                     Area = placemark.locality;
                 }
                 NSString *countryIOS = @"";
                 if (placemark.ISOcountryCode != nil) {
                     countryIOS = placemark.ISOcountryCode;
                 }
                 
                 //NSString *Country = [[NSString alloc]initWithString:placemark.country];
                 NSString *CountryArea = [NSString stringWithFormat:@"%@, %@", Area, countryIOS];
                 //NSLog(@"CountryArea: %@", CountryArea);
                 //NSLog(@"FormattedAddress: %@ - Address: %@", locatedAt, Address);
                 self._locationBlock(_current_Lat, _current_Long, Address, CountryArea);
             }
             else
             {
                 NSLog(@"Geocode failed with error %@", error);
                 NSLog(@"\nCurrent Location Not Detected\n");
                 self._locationBlock(_current_Lat, _current_Long, @"", @"");
             }
             /*---- For more results
              placemark.region);
              placemark.country);
              placemark.locality);
              placemark.name);
              placemark.ocean);
              placemark.postalCode);
              placemark.subLocality);
              placemark.location);
              ------*/
             
             [_locationManager stopUpdatingLocation];
             _locationManager = nil;
         }];
        
        //[_locationManager stopUpdatingLocation];
        //_locationManager = nil;
    } @catch (NSException *exception) {
        NSLog(@"UpdateLocations exception: %@", exception);
    } @finally {
        NSLog(@"");
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    self._locationError(error);
}

@end
