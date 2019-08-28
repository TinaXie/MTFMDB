//
//  GesturePasswordController.h
//  GesturePassword
//
//  Created by hb on 14-8-23.
//  Copyright (c) 2014年 黑と白の印记. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "TentacleView.h"
#import "ModifyGesturePasswordView.h"
@interface ModifyGesturePasswordController : BaseNavViewController<ResetDelegate>
@property (nonatomic, copy) void (^ModifyGesturePasswordFaildBlock)(void);
@property (nonatomic, copy) void (^ModifyGesturePasswordSuccessBlock)(void);

@end
