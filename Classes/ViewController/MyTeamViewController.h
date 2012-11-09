//
//  mycompSecondViewController.h
//  Chuanbao
//
//  Created by 老王八 :D on 12-6-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectionHeaderView.h"
@interface MyTeamViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, SectionHeaderViewDelegate> {
    IBOutlet UITableView* shipListTableView;
//    NSMutableArray* myFav;
    int openSectionIndex;
    BOOL flag[100];
    SectionHeaderView* sectionArray[100];
    NSArray* favArray;
    NSMutableArray* teamArray;
}

@property (nonatomic, retain) IBOutlet UITableView* shipListTableView;
//@property (nonatomic, retain) NSMutableArray* myFav;
@property (nonatomic, assign) int openSectionIndex;

@end
