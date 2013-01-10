//
//  MapTileOverlay.m
//  MapLayerDemo
//
//  Created by 老王八 :D on 12-11-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MapTileOverlay.h"
#import <CoreLocation/CoreLocation.h>

@implementation MapTileOverlay
@synthesize boundingMapRect; // from <MKOverlay>
@synthesize coordinate;      // from <MKOverlay>
@synthesize defaultAlpha;
//@synthesize tag;
//@synthesize showMap, showShipMap;
-(id) init {
    self = [super init];
    
    defaultAlpha = 1;

    boundingMapRect = MKMapRectWorld;
    boundingMapRect.origin.x += 1048600.0;
    boundingMapRect.origin.y += 1048600.0;
    coordinate = CLLocationCoordinate2DMake(0, 0);
    
    return self;
}

- (NSString *)urlForPointWithX:(NSUInteger)x andY:(NSUInteger)y andZoomLevel:(NSUInteger)zoomLevel {
    
    NSString *mapPath;
    NSString *ret = nil;
    mapPath = [Util getCachePath:[@"map" stringByAppendingFormat:@"/%d", zoomLevel]];
    ret = [mapPath stringByAppendingFormat:@"/%d-%d-%d.jpg", zoomLevel, x, y];
    if (![[NSFileManager defaultManager] fileExistsAtPath:ret]) {
        if (zoomLevel <= 1) {
            ret = [MAP_SERVER_URL stringByAppendingFormat:@"/ChartMap/LN%d/R%08x/C%08x.jpg", zoomLevel, y, x];
        } else {
            ret = [MAP_SERVER_URL stringByAppendingFormat:@"/ChartMap/L%02d/R%08x/C%08x.jpg", zoomLevel - 2, y, x];
        }
    }
    return ret;
}
- (NSString *)imageSavePathWithX:(NSUInteger)x andY:(NSUInteger)y andZoomLevel:(NSUInteger)zoomLevel {
    NSString *mapPath = [Util getCachePath:@"map"];
    mapPath = [Util getCachePath:[@"map" stringByAppendingFormat:@"/%d", zoomLevel]];
    NSString *imgPath = [mapPath stringByAppendingFormat:@"/%d-%d-%d.jpg", zoomLevel, x, y];
    return imgPath;
}
- (BOOL)canDrawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale {
    return YES;
}

@end
