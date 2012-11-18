//
//  ShipTipAnnotation.m
//  MapLayerDemo
//
//  Created by 于 婧 on 12-11-18.
//
//

#import "ShipTipAnnotation.h"

@implementation ShipTipAnnotation

-(id)initWithShipId:(NSString *)shipid dispName:(NSString *)dispName annoType:(NSInteger)annoType {
    self = [super init];
    self._shipid = shipid;
    self._dispName = dispName;
    self._annoType = annoType;
    return self;
}
@end
