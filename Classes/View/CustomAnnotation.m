//
//  CustomAnnotation.m
//  MapLayerDemo
//
//  Created by 老王八 :D on 12-10-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CustomAnnotation.h"

@implementation CustomAnnotation
@synthesize tag;
@synthesize floatVal;
@synthesize stringVal;
@synthesize boolVal;
-(id)initWithTag:(NSInteger)t{
    self = [super init];
    tag = t;
    boolVal = NO;
    return self;
}
@end
