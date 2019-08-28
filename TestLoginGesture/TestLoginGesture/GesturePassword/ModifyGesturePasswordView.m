//
//  ModifyGesturePasswordView.m
//  BitAutoCRM
//
//  Created by Mac on 15/2/10.
//  Copyright (c) 2015年 crm. All rights reserved.
//

#import "ModifyGesturePasswordView.h"
#import "GesturePasswordButton.h"
#import "TentacleView.h"

@implementation ModifyGesturePasswordView {
    //私有实例变量
    NSMutableArray * buttonArray;
    CGPoint lineStartPoint;
    CGPoint lineEndPoint;
}
@synthesize imgView;
@synthesize tentacleView;
@synthesize state;


//只能编程调用initWithFrame:方法。IB调用的时用的是initWithCoder
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
        buttonArray = [[NSMutableArray alloc]initWithCapacity:0];
        //⬇️ 创建一个view，内部只有9个button，并且把这个view添加到当前PasswordView上（subviews[0]）
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width/2-160, frame.size.height/2-100, 320, 320)];
        for (int i=0; i<9; i++) {
            NSInteger row = i/3;
            NSInteger col = i%3;
            // Button Frame
            
            NSInteger distance = 320/3;
            NSInteger size = distance/1.5;
            NSInteger margin = size/4;
            GesturePasswordButton * gesturePasswordButton = [[GesturePasswordButton alloc]initWithFrame:CGRectMake(col*distance+margin, row*distance, size, size)];
            [gesturePasswordButton setTag:i];
            [view addSubview:gesturePasswordButton];
            [buttonArray addObject:gesturePasswordButton];
        }
        frame.origin.y=0;
        view.center=CGPointMake(view.center.x, view.center.y-20);  //view向上移动20pt
        [self addSubview:view];
        //⬇️触手,内部只有9个button，并且把这个tentacleview添加到当前PasswordView上（subviews[1]）,覆盖了上面的九宫格view
        tentacleView = [[TentacleView alloc]initWithFrame:view.frame];
        [tentacleView setButtonArray:buttonArray];
        [tentacleView setTouchBeginDelegate:self];
        [self addSubview:tentacleView];
        //⬇️ state是一个宽280高30的标签，居中对齐，字体14pt。一个方块的左边点坐标=方块中心点坐标-0.5宽，所以state的center为(屏幕中心x，屏幕中心y-105)。y不如直接改为60。或者直接先创建然后设置center位置
        //state = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width/2-140, frame.size.height/2-105-15, 280, 30)];//作者代码
        //state = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width/2-140, 60, 280, 30)];//第二种
        state=[[UILabel alloc]init];//第三种
        state.center=CGPointMake(frame.size.width/2, 125);//第三种
        state.bounds=CGRectMake(0, 0, 280, 30);//第三种
        [state setTextAlignment:NSTextAlignmentCenter];
        [state setFont:SystemFontOfSize(14)];
        [self addSubview:state];
        
        //⬇️imgView是头像
        UILabel* nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, ScreenWidth, 70)];
        nameLabel.text=[Login getUserName];
        nameLabel.font=SystemFontOfSize(17);
        nameLabel.textAlignment=NSTextAlignmentCenter;
        [self addSubview:nameLabel];
    }
    self.backgroundColor=BackGroundColor;
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect
{
    // Drawing code
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
//    CGFloat colors[] =
//    {
//        0.85, 0.85, 0.85, 1,
//        0.85, 0.85, 0.85, 1,
//    };
//    CGGradientRef gradient = CGGradientCreateWithColorComponents
//    (rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
//    CGColorSpaceRelease(rgb);
//    CGContextDrawLinearGradient(context, gradient,CGPointMake
//                                (0.0,0.0) ,CGPointMake(0.0,self.frame.size.height),
//                                kCGGradientDrawsBeforeStartLocation);
}

- (void)gestureTouchBegin {
    [self.state setText:@""];
}




@end
