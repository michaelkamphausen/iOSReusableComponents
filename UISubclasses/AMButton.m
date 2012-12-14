//
//  AMButton.m
//  appic
//
//  Created by Caro N on 10/16/2012.
//  Copyright (c) 2012 Digital Pioneers N.V. All rights reserved.
//

#import "AMButton.h"
#import "AMLabel.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+CustomColors.h"

@implementation AMButton

- (void) setupDefault
{
    [self setText:nil withMargin:20 constantSize:NO withHeight:41 withFontSize:18];
    [self setImage:[UIImage imageNamed:@"button_bg_rot.png"]];
}

- (void) setText:(NSString*) text withMargin:(int) margin constantSize:(bool) constant
{
    [self setText:text withMargin:margin constantSize:constant withHeight:41 withFontSize:18];
}

-(void) setText:(NSString*) text withMargin:(int)margin constantSize:(bool) constant withHeight:(int)height withFontSize:(int)fontsize
{
    [self setText:text withLeftMargin:margin rightMargin:margin constantSize:constant withHeight:height withFontSize:fontsize];
}

-(void) setText:(NSString*) text  withLeftMargin:(int) leftMargin rightMargin:(int)rightMargin constantSize:(bool) constant withHeight:(int) height withFontSize:(int)fontsize
{
    if (!text) {
        text = [self titleForState:UIControlStateNormal];
    }
    [self setTitle:@"" forState:UIControlStateNormal];
    
    if (!label) {
        label = [[AMLabel alloc] init];
        [self addSubview:label];
    }
    [label setFontSize:fontsize];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setText:text];
    
    UIFont* font =[UIFont fontWithName: @"GROBOLD" size:fontsize];
    CGSize titleSize = [text sizeWithFont:font];
    NSLayoutConstraint *myConstraint;
    if (!constant) {
        [label setLeftMargin:leftMargin];
        [label setFrame:CGRectMake(0,0,titleSize.width+leftMargin+rightMargin,height)];
        [self removeConstraints:[self constraints]];
        myConstraint = [NSLayoutConstraint
                        constraintWithItem:self
                        attribute:NSLayoutAttributeWidth
                        relatedBy:NSLayoutRelationEqual
                        toItem:label
                        attribute:NSLayoutAttributeWidth
                        multiplier:1
                       constant:0];
        [self addConstraint: myConstraint];
        myConstraint = [NSLayoutConstraint
                       constraintWithItem:self
                       attribute:NSLayoutAttributeHeight
                       relatedBy:NSLayoutRelationEqual
                       toItem:label
                       attribute:NSLayoutAttributeHeight
                       multiplier:1
                       constant:0];
        [self addConstraint: myConstraint];
    } else {
        label.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraints:@[
            [self labelToButtonConstraintForAttribute:NSLayoutAttributeCenterX],
            [self labelToButtonConstraintForAttribute:NSLayoutAttributeCenterY],
            [self labelToButtonConstraintForAttribute:NSLayoutAttributeWidth],
            [self labelToButtonConstraintForAttribute:NSLayoutAttributeHeight]
        ]];
    }
}

- (NSLayoutConstraint*) labelToButtonConstraintForAttribute:(NSLayoutAttribute)attribute
{
    return [NSLayoutConstraint
            constraintWithItem:label
            attribute:attribute
            relatedBy:NSLayoutRelationEqual
            toItem:self
            attribute:attribute
            multiplier:1
            constant:0];
}

-(void) setImage:(UIImage *)image
{
    UIImage* img = [image  resizableImageWithCapInsets:UIEdgeInsetsMake(0, 19, 19, 19)];
    [self setBackgroundImage:img forState:UIControlStateNormal];
    [self setBackgroundImage:[[UIImage alloc] init] forState:UIControlStateDisabled];
}

- (void) setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    [label setEnabled:enabled];
    if (enabled) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = 0.0f;
        self.layer.masksToBounds = NO;
        self.layer.borderColor = [UIColor clearColor].CGColor;
        self.layer.borderWidth = 0.0f;
    } else {
        self.backgroundColor = [UIColor backgroundColor];
        self.layer.cornerRadius = 10.0f;
        self.layer.masksToBounds = YES;
        self.layer.borderColor = [UIColor borderColor].CGColor;
        self.layer.borderWidth = 3.0f;
    }
}

@end
