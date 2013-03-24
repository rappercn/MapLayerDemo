//
//  NameOverlay.h
//  BaoChuanWang
//
//  Created by 于 婧 on 13-3-24.
//
//

#import <Foundation/Foundation.h>

@interface NameOverlay : NSObject <MKOverlay> {
    CGFloat defaultAlpha;
    NSMutableArray *idxArray;
}
@property (readonly) NSMutableArray *rectArray;
@property (nonatomic, assign) int zoomLevel;
-(CGRect)getUseableRectForOverlayView:(MKOverlayView*)view fromPoint:(MKMapPoint)mapPoint andSize:(CGSize)tSize withIndex:(int)idx;
-(CGFloat)getRoadWidth;
@end
