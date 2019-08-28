//
//  GesturePasswordView.m
//  GesturePassword
//
//  Created by hb on 14-8-23.
//  Copyright (c) 2014年 黑と白の印记. All rights reserved.
//

#import "GesturePasswordView.h"
#import "GesturePasswordButton.h"
#import "TentacleView.h"

@implementation GesturePasswordView {
//私有实例变量
    NSMutableArray * buttonArray;
    CGPoint lineStartPoint;
    CGPoint lineEndPoint;
}
@synthesize nameLabel;
@synthesize forgetButton;
@synthesize changeButton;

@synthesize tentacleView;
@synthesize state;
@synthesize gesturePasswordDelegate;

//只能编程调用initWithFrame:方法。IB调用的时用的是initWithCoder
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = BackGroundColor;
        // Initialization code
        buttonArray = [[NSMutableArray alloc]initWithCapacity:0];
        //⬇️ 创建一个view，内部只有9个button，并且把这个view添加到当前PasswordView上（subviews[0]）
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width/2-160, frame.size.height/2-80, 320, 320)];
        for (int i=0; i<9; i++) {
            NSInteger row = i/3;
            NSInteger col = i%3;
            // Button Frame
            NSInteger distance = 320/3;
            if (ScreenWidth==320) {
                distance=280/3;
            }
            
            NSInteger size = distance/1.5;
            NSInteger margin = size/4;
            GesturePasswordButton * gesturePasswordButton = [[GesturePasswordButton alloc]initWithFrame:CGRectMake(col*distance+margin, row*distance, size, size)];
            [gesturePasswordButton setTag:i];
            [view addSubview:gesturePasswordButton];
            [buttonArray addObject:gesturePasswordButton];
        }
        frame.origin.y=0;
        view.center=CGPointMake(view.center.x, view.center.y-20);  //view向上移动20pt
        if (ScreenWidth==320) {
            view.center=CGPointMake(view.center.x+20, view.center.y+10);  //view向上移动20pt
        }
        //触手,内部只有9个button，并且把这个tentacleview添加到当前PasswordView上（subviews[1]）,覆盖了上面的九宫格view
        tentacleView = [[TentacleView alloc]initWithFrame:view.frame];
        [tentacleView setButtonArray:buttonArray];
        [tentacleView setTouchBeginDelegate:self];
        [self addSubview:tentacleView];
        view.userInteractionEnabled = NO;
        [self addSubview:view];

        
        nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width/2-100, frame.size.width/2-80-35, 200, 48)];
        nameLabel.text=[Login getUserName];
        nameLabel.textAlignment=NSTextAlignmentCenter;
        nameLabel.font=SystemFontOfSize(20);
        nameLabel.textColor=UIColorFromRGB(0x0A0A0A);
        [self addSubview:nameLabel];
        

        //state标签
        state=[[UILabel alloc]init];
        [state setTextAlignment:NSTextAlignmentCenter];
        [state setFont:SystemFontOfSize(16)];
        state.textColor=UIColorFromRGB(0x6D6D72);
        state.text=@"请验证手势密码";
        [state setFrame:CGRectMake(0, nameLabel.frame.origin.y+[UIScreen mainScreen].bounds.size.height/10, [UIScreen mainScreen].bounds.size.width,32)];
        state.textAlignment = NSTextAlignmentCenter;
        [self addSubview:state];
        
        //设置forgetButton
        forgetButton=[[UIButton alloc]init];
        forgetButton.frame=CGRectMake(ScreenWidth-100-15, ScreenHeight-50, 100, 44);
        [forgetButton.titleLabel setFont:SystemFontOfSize(17)];
        [forgetButton setTitleColor:BlueColor forState:UIControlStateNormal];
        [forgetButton setTitle:@"账号登录" forState:UIControlStateNormal];
        forgetButton.titleLabel.textAlignment=NSTextAlignmentRight;
        [forgetButton addTarget:self action:@selector(forget) forControlEvents:UIControlEventTouchDown];
        [self addSubview:forgetButton];
        //设置changeButton
        changeButton=[[UIButton alloc]init];
        changeButton.frame=CGRectMake(15, ScreenHeight-50, 120, 44);
        [changeButton.titleLabel setFont:SystemFontOfSize(17)];
        [changeButton setTitleColor:BlueColor forState:UIControlStateNormal];
        [changeButton setTitle:@"手势密码设置" forState:UIControlStateNormal];
        changeButton.titleLabel.textAlignment=NSTextAlignmentLeft;
        [changeButton addTarget:self action:@selector(change) forControlEvents:UIControlEventTouchDown];
        [self addSubview:changeButton];
    }
    
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    //CGContextRef context = UIGraphicsGetCurrentContext();
    //
    //CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    //CGFloat colors[] =
    //{
    //    134 / 255.0, 157 / 255.0, 147 / 255.0, 1.00,
    //    3 / 255.0,  3 / 255.0, 37 / 255.0, 1.00,
    //};
    //CGGradientRef gradient = CGGradientCreateWithColorComponents
    //(rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
    //CGColorSpaceRelease(rgb);
    //CGContextDrawLinearGradient(context, gradient,CGPointMake
    //                            (0.0,0.0) ,CGPointMake(0.0,self.frame.size.height),
    //                            kCGGradientDrawsBeforeStartLocation);
    // Drawing code
}

- (void)gestureTouchBegin {
    //[self.state setText:@""];
}

-(void)forget{
    [gesturePasswordDelegate forget];
}

-(void)change{
    [gesturePasswordDelegate change];
}


@end
