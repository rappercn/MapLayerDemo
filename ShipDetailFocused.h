//
//  ShipDetailFocused.h
//  MapLayerDemo
//
//  Created by zhengxuan on 10/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ShipDetailFocused : NSManagedObject

@property (nonatomic, retain) NSNumber * averageSpeed;
@property (nonatomic, retain) NSString * callSign;
@property (nonatomic, retain) NSNumber * direction;
@property (nonatomic, retain) NSNumber * distanceMoved;
@property (nonatomic, retain) NSNumber * draft;
@property (nonatomic, retain) NSString * gpsTime;
@property (nonatomic, retain) NSString * gpsTimeEx;
@property (nonatomic, retain) NSString * imo;
@property (nonatomic, retain) NSNumber * lat;
@property (nonatomic, retain) NSNumber * latEx;
@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSNumber * lon;
@property (nonatomic, retain) NSNumber * lonEx;
@property (nonatomic, retain) NSString * longitude;
@property (nonatomic, retain) NSString * mmsi;
@property (nonatomic, retain) NSString * mobileId;
@property (nonatomic, retain) NSString * shipFlag;
@property (nonatomic, retain) NSNumber * shipLength;
@property (nonatomic, retain) NSString * shipName;
@property (nonatomic, retain) NSString * shipType;
@property (nonatomic, retain) NSNumber * shipWidth;
@property (nonatomic, retain) NSNumber * speed;

@end
