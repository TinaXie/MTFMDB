//
//  GesturePasswordController.h
//  GesturePassword
//
//  Created by hb on 14-8-23.
//  Copyright (c) 2014年 黑と白の印记. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "TentacleView.h"
#import "GesturePasswordView.h"
#import "AESCrypt.h"
#import "BaseNavViewController.h"

#define ERRCOUNT 5
typedef NS_ENUM(NSInteger, ShowMode) {
    ShowModeSet = 1,//设置
    ShowModeVerify= 2,//验证
};




@class GesturePasswordController;

@protocol GesturePasswordControllerDelegate <NSObject>
-(void)GesturePasswordController:(GesturePasswordController *)passController verifyOK:(id)nilplaceholder;
-(void)GesturePasswordController:(GesturePasswordController *)passController resetOK:(id)nilplaceholder;
-(void)GesturePasswordController:(GesturePasswordController *)passController skipSet:(id)nilplaceholder;//跳过设置手势密码
-(void)GesturePasswordController:(GesturePasswordController *)passController forgetGesturePassword:(id)nilplaceholder;
-(void)GesturePasswordController:(GesturePasswordController *)passController changeGesturePassword:(id)nilplaceholder;
//网络验证出错（指手势验证通过后，发送网络验证账户密码出错）
-(void)GesturePasswordController:(GesturePasswordController *)passController networkWalidationErrorPassword:(id)nilplaceholder;

@end

@interface GesturePasswordController : BaseNavViewController <VerificationDelegate,ResetDelegate,GesturePasswordDelegate>
@property(nonatomic) ShowMode showMode;
- (void)clearGesturePassword;
- (BOOL)exist;

-(NSString *)getDecryptedPassword;
-(void)saveUnEncryptedPassword:(NSString *)pass;
@property (nonatomic,weak) id<GesturePasswordControllerDelegate> delegate;
@end
