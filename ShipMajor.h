//
//  ShipMajor.h
//  MapLayerDemo
//
//  Created by zhengxuan on 10/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ShipMajor : NSManagedObject

@property (nonatomic, retain) NSString * mobileId;
@property (nonatomic, retain) NSString * shipName;
@property (nonatomic, retain) NSString * callSign;
@property (nonatomic, retain) NSString * imo;
@property (nonatomic, retain) NSString * mmsi;

@end
