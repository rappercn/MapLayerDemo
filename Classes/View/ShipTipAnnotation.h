//
//  ShipTipAnnotation.h
//  MapLayerDemo
//
//  Created by 于 婧 on 12-11-18.
//
//

@interface ShipTipAnnotation : MKPointAnnotation
@property (nonatomic, retain) NSString *_shipid;
@property (nonatomic, retain) NSString *_dispName;
@property (nonatomic, assign) NSInteger _annoType;
-(id)initWithShipId:(NSString*)shipid dispName:(NSString*)dispName annoType:(NSInteger)annoType;
@end
