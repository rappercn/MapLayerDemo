//
//  TyphoonPointAnnotation.h
//  MapLayerDemo
//
//  Created by 老王八 :D on 12-10-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


@interface TyphoonPointAnnotation : MKPointAnnotation
@property (nonatomic, assign) float typhoonSpeed;
-(id) initWithTitle:(NSString*)ttl subTitle:(NSString*)subTtl;
//-(id) initWithTyphoonTime:(NSString*)tString typhoonName:(NSString*)tName typhoonSpeed:(float)tSpeed;
@end
