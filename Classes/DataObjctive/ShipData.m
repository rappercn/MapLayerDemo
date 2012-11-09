//
//  ShipData.m
//  Chuanbao
//
//  Created by 老王八 :D on 12-6-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ShipData.h"
@implementation ShipData

@synthesize shipName, mobileId, mmsi, imo, callSign, latitude, longitude;
@synthesize latEx, lonEx, gpsTime, averageSpeed, distanceMoved, direction;
@synthesize speed, gpsTimeEx, lat, lon, fLat, fLon, coor;
@synthesize shipFlag,shipType,shipLength,shipWidth,draft;

-(ShipData *)transferFromShipDetailFocusedToShipData:(ShipDetailFocused *)shipDetail {
self.shipName = shipDetail.shipName;
self.mobileId = shipDetail.mobileId;
self.mmsi = shipDetail.mmsi;
self.imo = shipDetail.imo;
self.callSign = shipDetail.callSign;
self.longitude = shipDetail.longitude;
NSNumberFormatter *formatter = [[[NSNumberFormatter alloc] init] autorelease];
self.latEx = [formatter stringFromNumber: shipDetail.latEx];
self.lonEx = [formatter stringFromNumber:shipDetail.lonEx ];
self.gpsTime = shipDetail.gpsTime;
self.averageSpeed = [shipDetail.averageSpeed floatValue];
self.distanceMoved = [shipDetail.distanceMoved floatValue ];
self.direction = [shipDetail.direction floatValue ];
self.speed = [shipDetail.speed floatValue ];
self.gpsTimeEx = shipDetail.gpsTimeEx;
self.lat = [shipDetail.lat floatValue ];
self.lon = [shipDetail.lon floatValue ];
//self.fLat = [shipDetail.fLat floatValue];
//self.fLon = [shipDetail.fLon floatValue];
self.latitude = shipDetail.latitude;
self.shipFlag = shipDetail.shipFlag;
self.shipType = shipDetail.shipType;
self.shipLength = [shipDetail.shipLength floatValue];
self.shipWidth = [shipDetail.shipWidth floatValue];
self.draft = [shipDetail.draft floatValue];
   // self.coor.latitude = self.lat;
    
return self;
}

-(ShipDetailFocused *)transferFromShipDataToShipDetailFocused:(ShipData *)shipDetail{
    ShipDetailFocused *focus = [[[ShipDetailFocused alloc] init ] autorelease];
    
    focus.shipName = shipDetail.shipName;
    focus.mobileId = shipDetail.mobileId;
    focus.mmsi = shipDetail.mmsi;
    focus.imo = shipDetail.imo;
    focus.callSign = shipDetail.callSign;
    focus.longitude = shipDetail.longitude;
    NSNumberFormatter *formatter = [[[NSNumberFormatter alloc] init] autorelease];
    focus.latEx = [formatter numberFromString: shipDetail.latEx];
    focus.lonEx = [formatter numberFromString:shipDetail.lonEx ];
    focus.gpsTime = shipDetail.gpsTime;
    focus.averageSpeed = [NSNumber numberWithFloat:shipDetail.averageSpeed];
    focus.distanceMoved =[NSNumber numberWithFloat:shipDetail.distanceMoved];
    focus.direction = [NSNumber numberWithFloat:shipDetail.direction  ];
    focus.speed = [NSNumber numberWithFloat:shipDetail.speed  ];
    focus.gpsTimeEx = shipDetail.gpsTimeEx;
    focus.lat = [NSNumber numberWithFloat:shipDetail.lat  ];
    focus.lon = [NSNumber numberWithFloat:shipDetail.lon  ];
    //self.fLat = [shipDetail.fLat floatValue];
    //self.fLon = [shipDetail.fLon floatValue];
    focus.latitude = shipDetail.latitude;
    focus.shipFlag = shipDetail.shipFlag;
    focus.shipType = shipDetail.shipType;
    focus.shipLength = [NSNumber numberWithFloat:shipDetail.shipLength ];
    focus.shipWidth = [NSNumber numberWithFloat:shipDetail.shipWidth ];
    focus.draft = [NSNumber numberWithFloat:shipDetail.draft];
    return focus;
}

-(ShipData *)transferFromDictionaryToShipData:(NSDictionary *)returnDictionary{
    self.shipName = [returnDictionary objectForKey:@"shipname"];
    self.mobileId = [returnDictionary objectForKey:@"shipid"];
    self.callSign = [returnDictionary objectForKey:@"callsign"];
    self.imo = [returnDictionary objectForKey:@"imo"];
    self.latEx = [returnDictionary objectForKey:@"latpre" ];  
    self.latitude = [returnDictionary objectForKey:@"latitude"];
    self.lonEx = [returnDictionary objectForKey:@"lonpre"];
    self.longitude = [returnDictionary objectForKey:@"longitude"];
    self.mmsi = [returnDictionary objectForKey:@"mmsi"];
    self.averageSpeed = [[returnDictionary objectForKey:@"averageSpeed"] floatValue];
    self.direction = [[returnDictionary objectForKey:@"direction"] floatValue];
    self.distanceMoved = [[returnDictionary objectForKey:@"distanceMoved"] floatValue];
    self.lat = [[returnDictionary objectForKey:@"lat"] floatValue];
    self.lon = [[returnDictionary objectForKey:@"lon"] floatValue];
    self.shipFlag = [returnDictionary objectForKey:@"shipflag"];
    self.shipType = [returnDictionary objectForKey:@"shiptype"];
    self.shipLength = [[returnDictionary objectForKey:@"shiplength"] floatValue];
    self.shipWidth = [[returnDictionary objectForKey:@"shipwidth"] floatValue];
    self.draft = [[returnDictionary objectForKey:@"draft"] floatValue];
    self.speed = [[returnDictionary objectForKey:@"speed"] floatValue];
    self.gpsTimeEx = [returnDictionary objectForKey:@"gpstimepre"];
    self.gpsTime = [returnDictionary objectForKey:@"gpstime"];
    return self;
}

@end
