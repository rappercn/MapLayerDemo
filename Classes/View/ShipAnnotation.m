//
//  ShipAnnotation.m
//  MapLayerDemo
//
//  Created by 老王八 :D on 12-10-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ShipAnnotation.h"

@implementation ShipAnnotation
@synthesize shipdict, annotationType;
-(id)initWithShipDictionary:(NSDictionary *)shipDictionary {
    self = [super init];
    shipdict = [shipDictionary retain];
 //   self.subtitle = [[NSString alloc] initWithFormat:@"呼号:%@, mmsi:%@, imo:%@",
 //                    [shipdict objectForKey:@"callsign"],
 //                    [shipdict objectForKey:@"mmsi"],
 //                    [shipdict objectForKey:@"imo"]];
//    NSString *subtitle = @"定位时间";
    self.subtitle = [@"定位时间:" stringByAppendingString:[shipDictionary objectForKey:@"gpstime"]];
    self.title = [ApplicationDelegate makeShipNameByCnName:[shipDictionary objectForKey:@"shipnamecn"]
                                                   engName:[shipDictionary objectForKey:@"shipname"]
                                                       imo:[shipDictionary objectForKey:@"imo"]];
//    if ([[shipdict objectForKey:@"shipnamecn"] length] > 0) {
//        self.title = [shipdict objectForKey:@"shipnamecn"];
//    } else if([[shipdict objectForKey:@"shipname"] length] > 0) {
//        self.title = [shipdict objectForKey:@"shipname"];
//    }else{
//        self.title = [shipdict objectForKey:@"mmsi"];
//    }
    return self;
}
-(void)dealloc {
    [super dealloc];
    RELEASE_SAFELY(shipdict);
}
@end
