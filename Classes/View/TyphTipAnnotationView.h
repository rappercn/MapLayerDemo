//
//  TyphTipAnnotationView.h
//  MapLayerDemo
//
//  Created by 老王八 :D on 12-10-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


@interface TyphTipAnnotationView : MKAnnotationView
@property (nonatomic, assign) int zoomLevel;
- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier;
@end
