//
//  MapRulerView.h
//  MapLayerDemo
//
//  Created by 老王八 :D on 12-6-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapRulerView : UIView

@property (nonatomic, assign) int rulerWidth;
@property (nonatomic, retain) NSString *mksText;
@property (nonatomic, retain) NSString *briText;

- (id)initWithFrame:(CGRect)frame;
@end
