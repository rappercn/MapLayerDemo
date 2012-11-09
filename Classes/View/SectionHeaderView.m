//
//  mySectionHeadView.m
//  BolingSoft_ChinaaccSubject
//
//  Created by FengGE on 11-8-24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SectionHeaderView.h"
extern  NSInteger heightHeader;
@implementation SectionHeaderView

@synthesize titleLabel, disclosureButton, delegate, section, cells, aTag, heightForHeadView, doubleType;
-(id)initWithFrame:(CGRect)frame title:(NSString*)title section:(NSInteger)sectionNumber  opened:(BOOL)isOpen delegate:(id<SectionHeaderViewDelegate>)aDelegate courseSection:(BOOL)isCourseSection
{
    self = [super initWithFrame:frame];
    if (self) {
		UITapGestureRecognizer *tapGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self 
																			action:@selector(toggleOpen:)] autorelease];
		[self addGestureRecognizer:tapGesture];
		self.userInteractionEnabled = YES;
		section = sectionNumber;
		delegate = aDelegate;
        
		disclosureButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];

        disclosureButton.frame = CGRectMake(0.0, 0.0, 320.0, 42);
		disclosureButton.userInteractionEnabled = YES;
        disclosureButton.tag = isOpen ? 1 : 0;
		if(isOpen) {
			[disclosureButton setBackgroundImage:[UIImage imageNamed:@"sectionHeaderOpen.png"] forState:UIControlStateNormal];
			[disclosureButton setBackgroundImage:[UIImage imageNamed:@"sectionHeaderOpen_on.png"] forState:UIControlStateHighlighted];
		} else {
			[disclosureButton setBackgroundImage:[UIImage imageNamed:@"sectionHeaderClose.png"] forState:UIControlStateNormal];
			[disclosureButton setBackgroundImage:[UIImage imageNamed:@"sectionHeaderClose_on.png"] forState:UIControlStateHighlighted];
        }
        [self addSubview:disclosureButton];
		
		
		CGRect titleLabelFrame = self.bounds;
        //titleLabelFrame.origin.x += 30.0;
        titleLabelFrame.origin.x += 30.0;
//        titleLabelFrame.origin.y -= 3.0;
        titleLabelFrame.origin.y = 0;
        titleLabelFrame.size.width -= 35.0;
        //CGRectInset(titleLabelFrame, 0.0, 30.0);
        titleLabel = [[UILabel alloc] initWithFrame:titleLabelFrame];
        titleLabel.text = title;
        titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.tag = 1;
        titleLabel.frame = CGRectMake(10, 7, 250, 30);
        [self addSubview:titleLabel];

//        UIImageView *sectionMark = [[UIImageView alloc] initWithFrame:CGRectMake(10, 14, 15.0, 15.0)];
//        if (isCourseSection) {
//            sectionMark = [[UIImageView alloc] initWithFrame:CGRectMake(10, 16, 12, 12)];
//            [sectionMark setImage:[UIImage imageNamed:@"dot.png"]];
//        } else {
//            sectionMark = [[UIImageView alloc] initWithFrame:CGRectMake(10, 14, 15.0, 15.0)];
//            [sectionMark setImage:[UIImage imageNamed:@"star.png"]];
//        }
//        [self addSubview:sectionMark];
//        [sectionMark release];
		//self.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Cellforsingle_unfold.png"]];
	}
	return self;
}
-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    for (UIView* view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]] && [view tag] > 0 && view.frame.origin.x > 0) {
            if (CGRectContainsPoint(view.frame, point)) {
                buttonClicked = YES;
                btnTag = [view tag];
                break;
            }
        }
    }
    return [super pointInside:point withEvent:event];
}
-(IBAction)toggleOpen:(id)sender {
    
    [self toggleAction:YES];
}
-(IBAction)toggleAction:(BOOL)userAction {
	
    if (buttonClicked) {
        if ([delegate respondsToSelector:@selector(sectionHeaderView:buttonClicked:buttonTag:)]) {
            [delegate sectionHeaderView:self buttonClicked:section buttonTag:btnTag];
        }
        buttonClicked = NO;
        return;
    }
	disclosureButton.tag = (disclosureButton.tag == 1 ? 0 : 1);

    if (userAction) {
        
        if (!disclosureButton.tag == 1) {
            disclosureButton.frame = CGRectMake(0.0, 0.0, 320.0, 42);
            heightForHeadView = 42;
            self.frame =CGRectMake(0, 0, 320, 42);
            [disclosureButton setBackgroundImage:[UIImage imageNamed:@"sectionHeaderClose.png"] forState:UIControlStateNormal];
            [disclosureButton setBackgroundImage:[UIImage imageNamed:@"sectionHeaderClose_on.png"] forState:UIControlStateHighlighted];
            
            if ([delegate respondsToSelector:@selector(sectionHeaderView:sectionClosed:)]) {
                [delegate sectionHeaderView:self sectionClosed:section];
                
            }
        }
        else {
            heightForHeadView = 66;
            self.frame =CGRectMake(0, 0, 320, 66);
            disclosureButton.frame = CGRectMake(0.0, 0.0, 320.0, 42);
            [disclosureButton setBackgroundImage:[UIImage imageNamed:@"sectionHeaderOpen.png"] forState:UIControlStateNormal];
            [disclosureButton setBackgroundImage:[UIImage imageNamed:@"sectionHeaderOpen_on.png"] forState:UIControlStateHighlighted];
            
            if ([delegate respondsToSelector:@selector(sectionHeaderView:sectionOpened:)]) {
                [delegate sectionHeaderView:self sectionOpened:section];
              
            }
        }
	}
}

- (void)dealloc {
    [super dealloc];
}


@end
