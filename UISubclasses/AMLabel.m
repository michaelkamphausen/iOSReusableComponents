//
//  AMLabel.m
//  appic
//
//  Created by Caro N on 10/11/2012.
//  Copyright (c) 2012 Digital Pioneers N.V. All rights reserved.
//

#import "AMLabel.h"
#import "UIColor+CustomColors.h"

@implementation AMLabel

-(void)drawTextInRect:(CGRect)rect{
    UIFont* font;
    if (!_fontSize) {
        font =[UIFont fontWithName: @"GROBOLD" size:18];
    } else {
        font =[UIFont fontWithName: @"GROBOLD" size:_fontSize];
    }
    UIColor* fillColor;
    UIColor* strokeColor;
    
    if (self.enabled) {
        fillColor = [UIColor whiteColor];
        strokeColor = [UIColor blackColor];
    } else {
        fillColor = [UIColor backgroundColor];
        strokeColor = [UIColor borderColor];
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    //position the label in the Center
    CGSize size = [[self text] sizeWithFont:font];
    int width = (rect.size.width-size.width)*0.5;;
    if(_leftMargin >width ){
        width = _leftMargin;
    }
    int height = (rect.size.height-size.height)*0.5;
    CGPoint point = CGPointMake(width,height);
    
    // Draw outlined text.
    CGContextSetTextDrawingMode(context, kCGTextStroke);
    // Make the thickness of the outline a function of the font size in use.
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [strokeColor CGColor]);
    [[self text] drawAtPoint:point withFont:font];
    
    // Draw filled text with black shadow. This will make sure it's clearly readable, while leaving some outline behind it.
    CGPoint shadow = CGPointMake(point.x, point.y+3);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetFillColorWithColor(context, [strokeColor CGColor]);
    [[self text] drawAtPoint:shadow withFont:font];
    
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetFillColorWithColor(context, [fillColor CGColor]);
    [[self text] drawAtPoint:point withFont:font];
}

@end
