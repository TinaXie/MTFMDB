//
//  GesturePasswordController.m
//  GesturePassword
//
//  Created by hb on 14-8-23.
//  Copyright (c) 2014年 黑と白の印记. All rights reserved.
//

#import <Security/Security.h>
#import <CoreFoundation/CoreFoundation.h>
#import "GesturePasswordController.h"
#import "LoginServer.h"
#import "MBProgressHUD.h"
#define BLog(formatString, ...) NSLog((@">Blog:%s " formatString), __PRETTY_FUNCTION__, ##__VA_ARGS__);

//VC控制器有两个方法，clear、exist。还有3个私有实例变量 gesturePasswordView、previousString、password
@interface GesturePasswordController ()

@property (nonatomic,strong) GesturePasswordView * gesturePasswordView;

@end

@implementation GesturePasswordController {
    NSString * previousString;
    NSString * password;
    NSInteger passwordErrorCount;
}

@synthesize gesturePasswordView;

//无返回按钮
- (UIBarButtonItem *)leftMenuBarButtonItem {
    return nil;
}

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
    // Do any additional setup after loading the view.
//    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0x0288d1)];
//    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0x0288d1);
    self.navigationController.navigationBar.translucent = NO;
    previousString = [NSString string];
    passwordErrorCount=0;
    self.view.backgroundColor=BackGroundColor;
    if (_showMode==ShowModeSet) {
        self.title=@"设置手势密码";
        UIBarButtonItem*rightBtn = [[UIBarButtonItem alloc]
                                    initWithTitle:@"跳过"
                                    style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(SkipSet)];
        self.navigationItem.rightBarButtonItem = rightBtn;
        [self reset];
    }
    else { // 验证。
        password=[Login getGesturePassword];
        [self verify];
    }
}
//跳过设置手势
-(void)SkipSet{
   [self.delegate GesturePasswordController:self skipSet:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_showMode!=ShowModeSet) {
        [self.navigationController setNavigationBarHidden:YES];
   
    }
    [self.navigationItem setHidesBackButton:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationItem setHidesBackButton:NO animated:NO];
    
}


#pragma mark - 验证手势密码，显示passwordview让用户触摸
- (void)verify{
    gesturePasswordView = [[GesturePasswordView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [gesturePasswordView.tentacleView setVerificationDelegate:self];
    [gesturePasswordView.tentacleView setStyle:1];
    [gesturePasswordView setGesturePasswordDelegate:self];//GesturePasswordDelegate要实现forget和change两个方法
    [self.view addSubview:gesturePasswordView];
}

#pragma mark - 重置手势密码，显示passwordview，隐藏两个按钮
- (void)reset{
    gesturePasswordView = [[GesturePasswordView alloc]initWithFrame:CGRectMake(0, (ScreenHeight==480?0:10), ScreenWidth, ScreenHeight-(ScreenHeight==480?0:10))];
//    CGRect frame=gesturePasswordView.frame;
//    frame.origin.y=-44;
//    gesturePasswordView.frame=frame;
    [gesturePasswordView.tentacleView setResetDelegate:self];
    [gesturePasswordView.tentacleView setStyle:2];
//    [gesturePasswordView.imgView setHidden:YES];
    [gesturePasswordView.forgetButton setHidden:YES];
    [gesturePasswordView.changeButton setHidden:YES];
    [self.view addSubview:gesturePasswordView];//这时才刚显示了界面，此界面没有两个按钮，所以只能输入手势
    [gesturePasswordView.state setTextColor:[UIColor greenColor]];
    [gesturePasswordView.state setText:@"请绘制新的手势密码"];
}

#pragma mark - 判断是否已存在手势密码
- (BOOL)exist{
    password = [self getDecryptedPassword];
    if ([password isEqualToString:@""])
        return NO;
    return YES;
}

#pragma mark - 清空记录
- (void)clearGesturePassword{
    [Login clearGesturePassword];
}
#pragma mark - 按钮事件改变手势密码
//修改手势
- (void)change{
    [self clearGesturePassword];
    [self.delegate GesturePasswordController:self changeGesturePassword:nil];
}

#pragma mark - 按钮事件忘记手势密码
//帐号密码登录
- (void)forget{
    [self.delegate GesturePasswordController:self forgetGesturePassword:nil];
}
#pragma mark - tentacle触角是否正确
- (BOOL)verification:(NSString *)result{
    if ([result isEqualToString:password]) {
        [YCMBProgressHUD showHUDAddedTo:self.view animated:YES];
        [LoginServer loginWithName:[Login getUserCode] Password:[Login getPassword]  success:^(void){
            [YCMBProgressHUD hideAllHUDsForView :self.view animated:YES];
            [self.delegate GesturePasswordController:self verifyOK:nil];
        } failure:^(NSString* errStr){
            [YCMBProgressHUD hideAllHUDsForView :self.view animated:YES];
            [CommonTools showAlertDismissWithContent:errStr];
            [self.delegate GesturePasswordController:self networkWalidationErrorPassword:nil];
        }];
        return YES;
    }
    [gesturePasswordView.state setTextColor:[UIColor redColor]];
    passwordErrorCount++;
    NSString* str=[NSString stringWithFormat:@"密码错误,您还可尝试次数%ld",ERRCOUNT-passwordErrorCount];
    [gesturePasswordView.state setText:str];
    if (passwordErrorCount>=ERRCOUNT) {
        [self forget];
    }
    
    return NO;
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
            [self dismissViewControllerAnimated:YES completion:nil];
            [self.delegate GesturePasswordController:self resetOK:nil];
            
            return YES;
        }
        else{
            //两次输入不相同
            previousString =@"";
            [gesturePasswordView.state setTextColor:[UIColor redColor]];
            [gesturePasswordView.state setText:@"两次密码不一致，请重新输入"];
            return YES;
        }
    }
}

-(NSString *)getDecryptedPassword{
    return [Login getGesturePassword];
}
-(void)saveUnEncryptedPassword:(NSString *)pass{
    [Login setGesturePassword:pass];
}



@end
