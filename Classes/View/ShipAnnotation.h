//
//  ShipAnnotation.h
//  MapLayerDemo
//
//  Created by 老王八 :D on 12-10-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//



@interface ShipAnnotation : MKPointAnnotation
enum {
    kCShipTypeNormal = 0,
    kCShipTypeFollowed = 1,
    kCShipTypeMyTeam = 2,
    kCShipTypeFocus = 3
};
@property (nonatomic, retain) NSDictionary *shipdict;
@property (nonatomic, assign) NSInteger annotationType;
@property (nonatomic, assign) BOOL selected;
-(id)initWithShipDictionary:(NSDictionary*)shipDictionary;
@end
