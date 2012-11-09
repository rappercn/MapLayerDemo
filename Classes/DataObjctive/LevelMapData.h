//
//  LevelMapData.h
//  Scrolling
//
//  Created by 老王八 :D on 12-5-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LevelMapData : NSObject {
    int level;
    int rowCount;
    int colCount;
    int startRow;
    int startCol;
    int minRow;
}

@property (nonatomic, assign) int level;
@property (nonatomic, assign) int rowCount;
@property (nonatomic, assign) int colCount;
@property (nonatomic, assign) int startRow;
@property (nonatomic, assign) int startCol;
@property (nonatomic, assign) int minRow;

@end
