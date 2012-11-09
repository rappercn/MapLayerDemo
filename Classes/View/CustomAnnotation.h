//
//  CustomAnnotation.h
//  MapLayerDemo
//
//  Created by 老王八 :D on 12-10-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface CustomAnnotation : MKPointAnnotation
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) float floatVal;
@property (nonatomic, retain) NSString *stringVal;
@property (nonatomic, assign) BOOL boolVal;
enum {
    anTypeShip = 1,
    anTypeTyphoonPoint = 2
};
-(id)initWithTag:(NSInteger)t;

@end
