//
//  GesturePasswordController.m
//  GesturePassword
//
//  Created by hb on 14-8-23.
//  Copyright (c) 2014年 黑と白の印记. All rights reserved.
//

#import <Security/Security.h>
#import <CoreFoundation/CoreFoundation.h>
#import "ModifyGesturePasswordController.h"

#define BLog(formatString, ...) NSLog((@">Blog:%s " formatString), __PRETTY_FUNCTION__, ##__VA_ARGS__);

//VC控制器有两个方法，clear、exist。还有3个私有实例变量 gesturePasswordView、previousString、password
@interface ModifyGesturePasswordController ()

@property (nonatomic,strong) ModifyGesturePasswordView * gesturePasswordView;

@end
@implementation ModifyGesturePasswordController {
    NSString * previousString;
    NSString * password;
    NSInteger passwordErrorCount;
}
@synthesize gesturePasswordView;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.popGestureEnable = NO;
    self.navigationItem.title = @"修改手势密码";
    self.view.backgroundColor=BackGroundColor;
    previousString = [NSString string];
    passwordErrorCount=0;
    CGRect rect = [[UIApplication sharedApplication] statusBarFrame];
    CGRect frame = [[UIScreen mainScreen] bounds];
    gesturePasswordView = [[ModifyGesturePasswordView alloc]initWithFrame:CGRectMake(0,0, rect.size.width, frame.size.height)];
    [gesturePasswordView.tentacleView setResetDelegate:self];
    [gesturePasswordView.tentacleView setStyle:2];
    [gesturePasswordView.state setFrame:CGRectMake(0, 70, rect.size.width,rect.size.height)];
    gesturePasswordView.state.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:gesturePasswordView];//这时才刚显示了界面，此界面没有两个按钮，所以只能输入手势
    [gesturePasswordView.state setTextColor:[UIColor greenColor]];
    [gesturePasswordView.state setText:@"请绘制新的手势密码"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backPopViewcontroller:(id) sender {
    if (self.ModifyGesturePasswordFaildBlock) {
        self.ModifyGesturePasswordFaildBlock();
    }
    [super backPopViewcontroller:sender];
}

#pragma mark - tentacle中定义协议resetPassword
//TouchEnd时、切tentacle.style为2时 调用此函数，用来重设密码
- (BOOL)resetPassword:(NSString *)result{
    if (result.length<4) {
        [gesturePasswordView.state setTextColor:[UIColor redColor]];
        [gesturePasswordView.state setText:@"手势密码长度必须大于4个"];
        return NO;
    }
    if ([previousString isEqualToString:@""]) { //previousString为空，第一次输入手势
        previousString=result;//将第一次手势保存到一个previousString 它与password完全不是一个东西
        [gesturePasswordView.tentacleView enterArgin];//再让用户输入一次手势密码，然后就到下面的else部分了
        [gesturePasswordView.state setTextColor:[UIColor greenColor]];
        [gesturePasswordView.state setText:@"请再次绘制手势密码"];
        return YES;
    }
    else { //第二次输入手势
        if ([result isEqualToString:previousString]) {
            //第二次与第一次相同，可以保存了
            [self saveUnEncryptedPassword:result];
            [Login setLoginMode:LoginModeGesturePassword];
            if (self.ModifyGesturePasswordSuccessBlock) {
                self.ModifyGesturePasswordSuccessBlock();
            }
            [self.navigationController popViewControllerAnimated:YES];
            return YES;
        }
        else{
            //两次输入不相同
            previousString =@"";
            [gesturePasswordView.state setTextColor:[UIColor redColor]];
            [gesturePasswordView.state setText:@"两次密码不一致，请重新输入"];
            return NO;
        }
    }
}


-(void)saveUnEncryptedPassword:(NSString *)pass{
    [Login setGesturePassword:pass];
}



@end
