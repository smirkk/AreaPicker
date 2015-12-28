//
//  ViewController.m
//  1228-AreaPicker
//
//  Created by kouhanjin on 15/12/28.
//  Copyright © 2015年 khj. All rights reserved.
//

#import "ViewController.h"
#import "KJAreaPickerView.h"
#import "KJLocation.h"

@interface ViewController ()<UITextFieldDelegate,KJAreaPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *areaTextFiled;
@property (nonatomic, strong) KJAreaPickerView *areaPickerView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)cancelLocatePicker
{
    [self.areaPickerView cancelPicker];
    self.areaPickerView.delegate = nil;
    self.areaPickerView = nil;
}
#pragma mark - UITextFieldDelegate的代理
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    // 1, 先清空AreaPickerView
    [self cancelLocatePicker];
    // 2，再初始化AreaPickerView
    self.areaPickerView = [KJAreaPickerView areaPickerViewWithDelegate:self];
    // 3，显示
    [self.areaPickerView showInView:self.view];
    return NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    // 取消areaPickerView
    [self cancelLocatePicker];
}

#pragma mark - KJAreaPickerViewDelegate的代理
- (void)pickerDidChangeStatus:(KJAreaPickerView *)picker
{
    self.areaTextFiled.text = [NSString stringWithFormat:@"%@ %@ %@",picker.locate.state,picker.locate.city,picker.locate.district];
    
}
@end
