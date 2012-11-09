//
//  shipModelView.h
//  MapLayerDemo
//
//  Created by 老王八 :D on 12-6-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShipModelView : UIView {
//    float currentArc;
    NSDictionary *shipdict;
}
//@property (nonatomic, retain) ;
-(id)initWithShipDictionary:(NSDictionary*)shipDictionary;
//-(void)setShipdict:(NSDictionary *)shipDictionary;
@end
