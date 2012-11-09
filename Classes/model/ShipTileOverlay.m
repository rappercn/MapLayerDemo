//
//  ShipTileOverlay.m
//  MapLayerDemo
//
//  Created by 老王八 :D on 12-11-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ShipTileOverlay.h"
#import <CoreLocation/CoreLocation.h>

@implementation ShipTileOverlay
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
    NSString *shipMapPath = [[Util getCachePath] stringByAppendingFormat:@"/shipmap/%d/%d-%d-%d.png",zoomLevel, zoomLevel, x, y];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:shipMapPath]) {
        NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:shipMapPath error:nil];
        NSDate *cDate = [attrs objectForKey:NSFileCreationDate];
        NSInteger interval = [[NSDate date] timeIntervalSinceDate:cDate];
        if (interval > 3600) {
            if (zoomLevel > 6) {
                int lvl = pow(2, zoomLevel - 5);
                int row = y / lvl;
                int col = x / lvl;
                shipMapPath = [@"http://map.ctrack.com.cn/CustomMap/mctShipGps" stringByAppendingFormat:@"/%d/R%d/C%d/%d-%d-%d.png", zoomLevel, row, col, zoomLevel, x, y];
            } else {
                shipMapPath = [@"http://map.ctrack.com.cn/CustomMap/mctShipGps" stringByAppendingFormat:@"/%d/%d-%d-%d.png", zoomLevel, zoomLevel, x, y];
            }
        }
    } else {
        if (zoomLevel > 6) {
            int lvl = pow(2, zoomLevel - 5);
            int row = y / lvl;
            int col = x / lvl;
            shipMapPath = [@"http://map.ctrack.com.cn/CustomMap/mctShipGps" stringByAppendingFormat:@"/%d/R%d/C%d/%d-%d-%d.png", zoomLevel, row, col, zoomLevel, x, y];
        } else {
            shipMapPath = [@"http://map.ctrack.com.cn/CustomMap/mctShipGps" stringByAppendingFormat:@"/%d/%d-%d-%d.png", zoomLevel, zoomLevel, x, y];
        }
    }
    return shipMapPath;
}
- (BOOL)canDrawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale {
    return YES;
}
@end
