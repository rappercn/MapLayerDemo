//
//  CustomAnnotationView.h
//  MapLayerDemo
//
//  Created by 老王八 :D on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


@interface ShipAnnotationView : MKAnnotationView

@property (nonatomic, assign) int arrayIndex;
- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier;
@end
