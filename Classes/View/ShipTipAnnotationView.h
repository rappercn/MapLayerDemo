//
//  ShipTipAnnotationView.h
//  MapLayerDemo
//
//  Created by 于 婧 on 12-11-18.
//
//

#import <MapKit/MapKit.h>

@interface ShipTipAnnotationView : MKAnnotationView
- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier;
@end
