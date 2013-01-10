//
//  ShipDetailViewController.h
//  MapLayerDemo
//
//  Created by 老王八 :D on 12-6-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ShipData;
@interface ShipDetailViewController : UIViewController{
     // NSMutableArray *shipfocused;
     // NSString shipId;
    Boolean isFocused;
}
@property (retain, nonatomic) IBOutlet UIButton *focusButton;
@property (retain,nonatomic) ShipData *baseData;
@property (nonatomic, retain) NSDictionary *shipdict;
-(id) initWithNibName:(NSString *)nibNameOrNil;
- (IBAction)focusButtonPress:(UIButton *)sender;
//@property (nonatomic, retain) NSMutableArray *shipfocused;
@end
