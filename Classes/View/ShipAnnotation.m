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
    shipdict = [shipDictionary copy];
    static NSString *subtitle = @"定位时间:" ;
    self.subtitle = [subtitle stringByAppendingString:[shipdict objectForKey:@"gpstime"]];
    NSString *title = [ApplicationDelegate makeShipNameByCnName:[shipdict objectForKey:@"shipnamecn"]
                                                        engName:[shipdict objectForKey:@"shipname"]
                                                            imo:[shipdict objectForKey:@"imo"]];
    self.title = title;
    return self;
}
-(void)dealloc {
    [super dealloc];
    RELEASE_SAFELY(shipdict);
}
@end
