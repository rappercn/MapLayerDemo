//
//  mySectionHeadView.h
//  BolingSoft_ChinaaccSubject
//
//  Created by FengGE on 11-8-24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SectionHeaderViewDelegate;

@interface SectionHeaderView : UIView {
	UILabel*                titleLabel;
	UIButton*               disclosureButton;
	NSInteger               section;
	NSMutableArray*         cells;
    BOOL                    flag;
    BOOL                    buttonClicked;
    NSInteger               heightForHeadView;
    NSInteger               btnTag;
    BOOL                    doubleType;
}
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIButton *disclosureButton;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, assign) NSInteger heightForHeadView;
@property (nonatomic, retain) NSMutableArray* cells;
@property (nonatomic)         BOOL aTag;
@property (nonatomic, assign) BOOL doubleType;
@property (nonatomic, assign) id  <SectionHeaderViewDelegate> delegate;
-(id)initWithFrame:(CGRect)frame title:(NSString*)title section:(NSInteger)sectionNumber  opened:(BOOL)isOpen delegate:(id<SectionHeaderViewDelegate>)aDelegate courseSection:(BOOL)isCourseSection;
-(IBAction)toggleAction:(BOOL)userAction;
-(IBAction)toggleOpen:(id)sender;
@end

@protocol SectionHeaderViewDelegate <NSObject> 

@optional
-(void)sectionHeaderView:(SectionHeaderView*)sectionHeaderView sectionClosed:(NSInteger)section;

-(void)sectionHeaderView:(SectionHeaderView*)sectionHeaderView sectionOpened:(NSInteger)section;

-(void)sectionHeaderView:(SectionHeaderView*)sectionHeaderView buttonClicked:(NSInteger)section buttonTag:(NSInteger)tag;
@end