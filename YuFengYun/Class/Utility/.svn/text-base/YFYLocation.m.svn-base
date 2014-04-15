//
//  YFYLocation.m
//  JieKuWang
//
//  Created by 董德富 on 13-4-7.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "YFYLocation.h"
#import "AlertUtility.h"
#import "DataCenter.h"
#import "NetworkCenter.h"
#import <CoreLocation/CoreLocation.h>

@interface YFYLocation ()
<
  CLLocationManagerDelegate
>
@property (nonatomic, strong) CLLocationManager *manager;

@property (nonatomic, copy) completeBlock completed;

@end

@implementation YFYLocation


- (void)startLocation:(completeBlock)block {
    if ([CLLocationManager locationServicesEnabled]) {
        self.completed = block;
        
        self.manager = [[CLLocationManager alloc] init];
        self.manager.desiredAccuracy = kCLLocationAccuracyBest;
        self.manager.delegate = self;
        [self.manager startUpdatingLocation];
    }else {
        [AlertUtility showAlertWithTitle:@"定位失败" mess:@"请开启定位服务!"];
    }
}



#pragma mark - location


- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    manager.delegate = nil;
    [manager stopUpdatingLocation];
    
//    [DATA setCoordinate2D:newLocation.coordinate];
    
//    CLLocation *location = [[CLLocation alloc] initWithLatitude:36.7111700000 longitude:119.1691500000];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder  reverseGeocodeLocation:newLocation
                    completionHandler:^(NSArray *placemarks, NSError *error) {
                        if (error) {
                            [AlertUtility showAlertWithMess:@"地理反编码失败!"];
                            DEBUG_LOG_(@"error : %@", [error localizedDescription]);
                        }else {
                            CLPlacemark *placemark = placemarks[0];
                            NSString *city = placemark.locality;
                            DEBUG_LOG(@"location city: %@", city);
                            
                            NSMutableString *address = [NSMutableString string];
                            if (placemark.administrativeArea) [address appendString:placemark.administrativeArea];
                            if (placemark.subAdministrativeArea) [address appendString:placemark.subAdministrativeArea];
                            if (placemark.locality) [address appendString:placemark.locality];
                            if (placemark.subLocality) [address appendString:placemark.subLocality];
                            if (placemark.thoroughfare) [address appendString:placemark.thoroughfare];
                            if (placemark.subThoroughfare) [address appendString:placemark.subThoroughfare];
                            DEBUG_LOG(@"location address: %@", address);
                            
                            if (self.completed) {
                                self.completed(city, address);
                            }
                            
                         NSLog(@"name :%@",                  placemark.name);
                         NSLog(@"country :%@",               placemark.country);
                         NSLog(@"postalCode :%@",            placemark.postalCode);
                         NSLog(@"ISOcountryCode :%@",        placemark.ISOcountryCode);
                         NSLog(@"ocean :%@",                 placemark.ocean);
                         NSLog(@"inlandWater :%@",           placemark.inlandWater);
                         NSLog(@"administrativeArea :%@",    placemark.administrativeArea);
                         NSLog(@"subAdministrativeArea :%@", placemark.subAdministrativeArea);
                         NSLog(@"locality :%@",              placemark.locality);
                         NSLog(@"subLocality :%@",           placemark.subLocality);
                         NSLog(@"thoroughfare :%@",          placemark.thoroughfare);
                         NSLog(@"subThoroughfare :%@",       placemark.subThoroughfare);

                        }
//                         NSLog(@"name :%@",                  placemark.name);
//                         NSLog(@"country :%@",               placemark.country);
//                         NSLog(@"postalCode :%@",            placemark.postalCode);
//                         NSLog(@"ISOcountryCode :%@",        placemark.ISOcountryCode);
//                         NSLog(@"ocean :%@",                 placemark.ocean);
//                         NSLog(@"inlandWater :%@",           placemark.inlandWater);
//                         NSLog(@"administrativeArea :%@",    placemark.administrativeArea);
//                         NSLog(@"subAdministrativeArea :%@", placemark.subAdministrativeArea);
//                         NSLog(@"locality :%@",              placemark.locality);
//                         NSLog(@"subLocality :%@",           placemark.subLocality);
//                         NSLog(@"thoroughfare :%@",          placemark.thoroughfare);
//                         NSLog(@"subThoroughfare :%@",       placemark.subThoroughfare);
                        
//                        name :中国北京市朝阳区建外街道建国路97号
//                        country :中国
//                        postalCode :(null)
//                        ISOcountryCode :CN
//                        ocean :(null)
//                        inlandWater :(null)
//                        administrativeArea :北京市
//                        subAdministrativeArea :(null)
//                        locality :(null)
//                        subLocality :朝阳区
//                        thoroughfare :建国路
//                        subThoroughfare :97号

     }];
}


- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    manager.delegate = nil;
    [manager stopUpdatingLocation];
    [AlertUtility showAlertWithMess:@"定位失败!\n请检查定位设置"];
}

@end
