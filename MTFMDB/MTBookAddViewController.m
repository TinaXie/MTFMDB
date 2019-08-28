//
//  MTBookAddViewController.m
//  MTFMDB_Example
//
//  Created by xiejc on 2018/12/17.
//  Copyright © 2018 xiejc. All rights reserved.
//

#import "MTBookAddViewController.h"
#import "MTFMDBManager.h"

@interface MTBookAddViewController ()
<UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *nameLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *typePicker;
@property (nonatomic, assign) NSInteger type;


@end

@implementation MTBookAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)hideKeyBoard {
    [self.view endEditing:YES];
}

- (IBAction)saveBook:(id)sender {
    NSString *name = self.nameLabel.text;
    if (name == nil) {
        return;
    }
    NSString *sql = [NSString stringWithFormat:@"insert into Book(name,type) values('%@', %ld)", name, (long)self.type];
    BOOL isSuccess = [[MTFMDBManager instance] executeUpdateWithString:sql];
    if (isSuccess) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        NSLog(@"插入书本失败:%@", sql);
    }
}

#pragma mark - UIPickerViewDelegate

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 2;
}

- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 1;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (row == 0) {
        return @"txt";
    }
    return @"epub";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.type = row;
}


@end
