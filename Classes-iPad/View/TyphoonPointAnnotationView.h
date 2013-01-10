//
//  TyphPtAnnotationView.h
//  MapLayerDemo
//
//  Created by 老王八 :D on 12-10-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface TyphoonPointAnnotationView : MKAnnotationView
//{
//    float typhoonSpeed;
//    NSString *typhoonTime;
//    NSString *typhoonName;
//}
@property (nonatomic, assign) int zoomLevel;
- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier;
//        zoomLevel:(int)level
//        typhoonSpeed:(float)tSpeed
//        typhoonTime:(NSString*)tTime
//        typhoonName:(NSString*)tName;
@end
