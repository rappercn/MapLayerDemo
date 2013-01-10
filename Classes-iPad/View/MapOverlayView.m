//
//  MapOverlayView.m
//  MapLayerDemo
//
//  Created by 老王八 :D on 12-11-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MapOverlayView.h"
#import "TileOverlay.h"
#import "MapTileOverlay.h"
#import <QuartzCore/QuartzCore.h>
#pragma mark Private methods
@interface MapOverlayView()
- (NSUInteger)zoomLevelForMapRect:(MKMapRect)mapRect;
- (NSUInteger)zoomLevelForZoomScale:(MKZoomScale)zoomScale;
- (NSUInteger)worldTileWidthForZoomLevel:(NSUInteger)zoomLevel;
- (CGPoint)mercatorTileOriginForMapRect:(MKMapRect)mapRect;
@end

#pragma mark -
#pragma mark Implementation

@implementation MapOverlayView

#pragma mark Private utility methods

- (NSUInteger)zoomLevelForMapRect:(MKMapRect)mapRect {
    MKCoordinateRegion region = MKCoordinateRegionForMapRect(mapRect);
    CGFloat lon_ratio = region.span.longitudeDelta/360.0;
    NSUInteger z = (NSUInteger)(log(1/lon_ratio)/log(2.0)-1.0);
    
    z += ([[UIScreen mainScreen] scale] - 1.0);
    return z;
}

- (NSUInteger)zoomLevelForZoomScale:(MKZoomScale)zoomScale {
    CGFloat realScale = zoomScale / [[UIScreen mainScreen] scale];
    NSUInteger z = (NSUInteger)(log(realScale)/log(2.0)+20.0);

    z += ([[UIScreen mainScreen] scale] - 1.0);
    return z;
}

- (NSUInteger)worldTileWidthForZoomLevel:(NSUInteger)zoomLevel {
    return (NSUInteger)(pow(2,zoomLevel));
}

- (CGPoint)mercatorTileOriginForMapRect:(MKMapRect)mapRect {
    MKCoordinateRegion region = MKCoordinateRegionForMapRect(mapRect);
    
    // Convert lat/lon to radians
    CGFloat x = (region.center.longitude) * (M_PI/180.0); // Convert lon to radians
    CGFloat y = (region.center.latitude) * (M_PI/180.0); // Convert lat to radians
    y = log(tan(y)+1.0/cos(y));
    
    // X and Y should actually be the top-left of the rect (the values above represent
    // the center of the rect)
    x = (1.0 + (x/M_PI)) / 2.0;
    y = (1.0 - (y/M_PI)) / 2.0;
    
    return CGPointMake(x, y);
}

#pragma mark MKOverlayView methods
- (BOOL)canDrawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale {
    
//    if (downloaded) {
//        return YES;
//    }
    
    if (prevRect.origin.x != mapRect.origin.x || prevRect.origin.y != mapRect.origin.y) {
        prevRect = mapRect;
        counter = 0;
    }
    
    if (counter >= 3) {
        return YES;
    }
    
    NSUInteger zoomLevel = [self zoomLevelForZoomScale:zoomScale];
    CGPoint mercatorPoint = [self mercatorTileOriginForMapRect:mapRect];
    
    // Hook on TileOverlay that allows an overlay to limit the boundaries it attempts to load.
    if ([(id<TileOverlay>)self.overlay canDrawMapRect:mapRect zoomScale:zoomScale] != YES) {
        return NO;
    }
    
    NSUInteger tilex = floor(mercatorPoint.x * [self worldTileWidthForZoomLevel:zoomLevel]);
    NSUInteger tiley = floor(mercatorPoint.y * [self worldTileWidthForZoomLevel:zoomLevel]);
    
//    NSLog(@"step1 %d,%d,%d,---- %.1f,%.1f", zoomLevel, tilex, tiley, mapRect.origin.x,mapRect.origin.y);
    
//    NSLog(@"%@", [Util getCachePath]);
    NSString *url = [(id<TileOverlay>)self.overlay urlForPointWithX:tilex andY:tiley andZoomLevel:zoomLevel];
//    if ([url hasSuffix:@".png"]) {
//        NSLog(@"test png tile");
//    }
    if (![url hasPrefix:@"http"]) {
        return YES;
    }

    NSString *savePath = [(id<TileOverlay>)self.overlay imageSavePathWithX:tilex andY:tiley andZoomLevel:zoomLevel];
    counter++;
    [ApplicationDelegate.imageDownloader
                         downloadMapImageFrom:url
                         toFile:savePath
                         onCompletion:^() {
                             downloaded = YES;
                             [self setNeedsDisplayInMapRect:mapRect zoomScale:zoomScale];
                         } onError:^(NSError *error){
                             downloaded = YES;
                             [self setNeedsDisplayInMapRect:mapRect zoomScale:zoomScale];
                         }];
    drawBg = YES;
    return YES;
}

- (void)drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)context {

    if (drawBg) {
        UIGraphicsPushContext(context);
        [[UIColor lightGrayColor] set];
        UIRectFill([self rectForMapRect:mapRect]);
        drawBg = NO;
        return;
    }
    
    id<TileOverlay> overlay = (id<TileOverlay>)self.overlay;
    
    NSUInteger zoomLevel = [self zoomLevelForZoomScale:zoomScale];
    CGPoint mercatorPoint = [self mercatorTileOriginForMapRect:mapRect];
    
    NSUInteger tilex = floor(mercatorPoint.x * [self worldTileWidthForZoomLevel:zoomLevel]);
    NSUInteger tiley = floor(mercatorPoint.y * [self worldTileWidthForZoomLevel:zoomLevel]);
//    NSLog(@"draw map %d,%d,%d,---- %.1f,%.1f", zoomLevel, tilex, tiley, mapRect.origin.x,mapRect.origin.y);
    UIGraphicsPushContext(context);

    @try {
        NSString *mapPath = [overlay urlForPointWithX:tilex andY:tiley andZoomLevel:zoomLevel];
//        if ([mapPath hasSuffix:@".png"]) {
//            NSLog(@"draw rect png %d,%d",tilex,tiley);
//        } else {
//            NSLog(@"draw map rect jpg %d,%d...",tilex,tiley);
//        }
        UIImage *map = nil;
        if ([[NSFileManager defaultManager] fileExistsAtPath:mapPath]) {
            //        NSLog(@"map exist,draw map normal");
            map = [UIImage imageWithContentsOfFile:mapPath];
            //        NSLog(@"draw map:%@", mapPath);
            //        NSLog(@"draw map for %d,%d,%d", zoomLevel, tilex, tiley);
        } else if ([overlay isKindOfClass:[MapTileOverlay class]]) {
            //        NSLog(@"map not exist,need to draw numm map");
            map = [UIImage imageNamed:@"null.jpg"];
            //        NSLog(@"draw nil map for %d,%d,%d,%@", zoomLevel, tilex, tiley);
        }
        //    map = [UIImage imageNamed:@"null.jpg"];
        if (map != nil) {
            [map drawInRect:[self rectForMapRect:mapRect] blendMode:kCGBlendModeNormal alpha:1.0];
//            if ([mapPath hasSuffix:@".png"]) {
//                
//                NSLog(@"%d,%d,%@",tilex,tiley,mapPath);
//                [[UIImage imageNamed:@"about.png"] drawInRect:[self rectForMapRect:mapRect] blendMode:kCGBlendModeNormal alpha:1.0];
//            }

//        } else {
//            NSLog(@"%@",mapPath);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
    @finally {
        
    }


    UIGraphicsPopContext();
    downloaded = NO;
}
#pragma mark -
#pragma mark Memory management
- (void)dealloc {
    [super dealloc];
}


@end
