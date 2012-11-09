//
//  ShipAnnotation.m
//  MapLayerDemo
//
//  Created by 老王八 :D on 12-10-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ShipAnnotation.h"

@implementation ShipAnnotation
@synthesize shipdict, retainFlag, annotationType;
-(id)initWithShipDictionary:(NSDictionary *)shipDictionary {
    self = [super init];
    shipdict = [shipDictionary retain];
    self.subtitle = [[NSString alloc] initWithFormat:@"呼号:%@, mmsi:%@, imo:%@", 
                     [shipdict objectForKey:@"callsign"], 
                     [shipdict objectForKey:@"mmsi"], 
                     [shipdict objectForKey:@"imo"]];
    if ([[shipdict objectForKey:@"shipnamecn"] length] > 0) {
        self.title = [shipdict objectForKey:@"shipnamecn"];
    } else {
        self.title = [shipdict objectForKey:@"shipname"];
    }
    return self;
}
-(void)dealloc {
    [super dealloc];
    [shipdict release];
    shipdict = nil;
}
@end
