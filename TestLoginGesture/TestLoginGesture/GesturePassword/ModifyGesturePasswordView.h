//
//  ModifyGesturePasswordView.h
//  BitAutoCRM
//
//  Created by Mac on 15/2/10.
//  Copyright (c) 2015年 crm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TentacleView.h"

@interface ModifyGesturePasswordView : UIView<TouchBeginDelegate>

@property (nonatomic,strong) TentacleView * tentacleView;

@property (nonatomic,strong) UILabel * state;

@property (nonatomic,strong) UIImageView * imgView;

@end
