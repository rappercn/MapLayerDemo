//
//  TyphTipAnnotation.h
//  MapLayerDemo
//
//  Created by 老王八 :D on 12-10-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface TyphTipAnnotation : MKPointAnnotation
@property (nonatomic, retain) NSString *timeString;
@property (nonatomic, retain) NSString *typhoonName;

-(id) initWithTyphoonTime:(NSString*)tString typhoonName:(NSString*)tName;
@end
