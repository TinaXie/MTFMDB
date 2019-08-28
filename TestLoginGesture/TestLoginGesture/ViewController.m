//
//  ViewController.m
//  TestLoginGesture
//
//  Created by xiejc on 2018/12/7.
//  Copyright © 2018 xiejc. All rights reserved.
//

#import "ViewController.h"
#import "GesturePasswordController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    GesturePasswordController *passwordC = [[GesturePasswordController alloc]init];
    passwordC.showMode = mode;
    passwordC.delegate = [LoginTransform instance];
    if (mode == ShowModeSet) {//设置手势
        [rootController.navigationController pushViewController:passwordC animated:NO];
    }else{//验证手势
        [rootController.navigationController pushViewController:passwordC animated:NO];
        [passwordC.navigationController setNavigationBarHidden:YES animated:NO];
    }
}


@end
