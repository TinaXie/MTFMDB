//
//  GesturePasswordButton.m
//  GesturePassword
//
//  Created by hb on 14-8-23.
//  Copyright (c) 2014年 黑と白の印记. All rights reserved.
//

#import "GesturePasswordButton.h"

#define bounds self.bounds

@implementation GesturePasswordButton
@synthesize selected;
@synthesize success;

//这个Button的骨架
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        success=YES;
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//系统调用，绘图
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor *greencolor = [UIColor greenColor];//[CommonTools colorWithHexString:@"#oo7aff"];
    UIColor *redColor = [UIColor redColor];// [CommonTools colorWithHexString:@"#ff00000"];
    UIColor *grayColor = [UIColor colorWithRed:187.0f/255.0f green:187.0f/255.0f blue:192.0f/255.0f alpha:1];;
    
    UIColor *greenFillColor = GestureLightGreenColor;
    UIColor *redFillColor = [UIColor colorWithRed:255/255.f green:190/255.f blue:194/255.f alpha:1];
    if (selected) {
        if (success) {
            CGContextSetStrokeColorWithColor(context, greencolor.CGColor);
        }
        else
        {
            CGContextSetStrokeColorWithColor(context, redColor.CGColor);
        }
    }
    else
    {
        CGContextSetStrokeColorWithColor(context, grayColor.CGColor);
    }
    CGContextSetLineWidth(context,2);
    CGRect frame = CGRectMake(3, 3, bounds.size.width-6, bounds.size.height-6);
   

    if (success) {
//        CGContextSetRGBFillColor(context,30/255.f, 175/255.f, 235/255.f,0.3);
        CGContextSetFillColorWithColor(context, greenFillColor.CGColor);

    }
    else {
        
//        CGContextSetRGBFillColor(context,208/255.f, 36/255.f, 36/255.f,0.3);
        CGContextSetFillColorWithColor(context, redFillColor.CGColor);

    }
    CGContextAddEllipseInRect(context,frame);
    if (selected) {
        CGContextFillPath(context);
    }
    CGContextAddEllipseInRect(context,frame);
    CGContextStrokePath(context);
    

    
    
    if (selected) {
        if (success) {
            //            CGContextSetRGBStrokeColor(context, 2/255.f, 174/255.f, 240/255.f,1);//线条颜色
            //            CGContextSetRGBFillColor(context,2/255.f, 174/255.f, 240/255.f,1);
            CGContextSetStrokeColorWithColor(context, greencolor.CGColor);
            CGContextSetFillColorWithColor(context, greencolor.CGColor);
        }
        else {
            //            CGContextSetRGBStrokeColor(context, 208/255.f, 36/255.f, 36/255.f,1);//线条颜色
            //            CGContextSetRGBFillColor(context,208/255.f, 36/255.f, 36/255.f,1);
            CGContextSetStrokeColorWithColor(context, redColor.CGColor);
            CGContextSetFillColorWithColor(context, redColor.CGColor);
        }
        CGRect frame = CGRectMake(bounds.size.width/2-bounds.size.width/8+1, bounds.size.height/2-bounds.size.height/8, bounds.size.width/4, bounds.size.height/4);
        
        CGContextAddEllipseInRect(context,frame);
        CGContextFillPath(context);
    }
    else{
        //        CGContextSetRGBStrokeColor(context, 30/255.f, 40/255.f, 70/255.f,0.5);//线条颜色
        CGContextSetStrokeColorWithColor(context, greencolor.CGColor);
        
    }
    
}


@end
