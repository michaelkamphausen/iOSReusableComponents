//
//  AMButton.h
//  appic
//
//  Created by Caro N on 10/16/2012.
//  Copyright (c) 2012 Digital Pioneers N.V. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMLabel.h"

@interface AMButton : UIButton {
    AMLabel* label;
}

- (void) setupDefault;
- (void) setText:(NSString*) text withMargin:(int) margin constantSize:(bool) constant;
- (void) setText:(NSString*) text withMargin:(int) margin constantSize:(bool) constant withHeight:(int) height withFontSize:(int)fontsize;
-(void) setText:(NSString*)text withLeftMargin:(int) leftMargin rightMargin:(int)rightMargin constantSize:(bool) constant withHeight:(int) height withFontSize:(int)fontsize;
- (void) setImage:(UIImage *)image;
- (void) setEnabled:(BOOL)enabled;

@end
