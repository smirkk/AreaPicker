//
//  KJAreaPickerView.m
//  AreaPicker
//
//  Created by kouhanjin on 15/12/28.
//  Copyright © 2015年 khj. All rights reserved.
//

#define kDuration 0.25
#define kColumn 3
#define CitiesKey @"cities"
#define StateKey @"state"
#define CityKey @"city"
#define AreasKey @"areas"

#import "KJAreaPickerView.h"
#import "KJLocation.h"

typedef enum : NSUInteger {
    KJAreaTypeProvinces = 0,
    KJAreaTypeCitys,
    KJAreaTypeAreas
} KJAreaType;

@interface KJAreaPickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
/**
 *  省份
 */
@property (nonatomic, strong) NSArray *provinces;
/**
 *  城市
 */
@property (nonatomic, strong) NSArray *cities;
/**
 *  地区
 */
@property (nonatomic, strong) NSArray *areas;

@end

@implementation KJAreaPickerView

/**
 *  数据的懒加载
 *
 */
- (NSArray *)provinces
{
    if (_provinces == nil) {
        _provinces = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"]];
    }
    
    return _provinces;
}

- (KJLocation *)locate
{
    if (_locate == nil) {
        _locate = [[KJLocation alloc] init];
    }
    
    return _locate;
}

+ (instancetype)areaPickerViewWithDelegate:(id<KJAreaPickerViewDelegate>)delegate
{
    return [[self alloc] initWithDelegate:delegate];
}

- (instancetype)initWithDelegate:(id<KJAreaPickerViewDelegate>)delegate
{
    
    if (self = [super init]) {
        // 从xib中加载视图
        self = [[[NSBundle mainBundle] loadNibNamed:@"KJAreaPickerView" owner:nil options:nil] lastObject];
        self.delegate = delegate;
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        
        // 初始化数据，默认加载第一条
        // 第一级
        self.cities = [self.provinces[0] valueForKey:CitiesKey];
        self.locate.state = [self.provinces[0] valueForKey:StateKey];
        // 第二级
        self.locate.city = [self.cities[0] objectForKey:CityKey];
        self.areas = [self.cities[0] objectForKey:AreasKey];
        // 第三级
        if (self.areas.count > 0) {
            self.locate.district = self.areas[0];
        } else{
            self.locate.district = @"";
        }
        
        for (int i = 0; i < kColumn; i++) {
            [self pickerView:self.pickerView didSelectRow:0 inComponent:i];
        }
       
    }
    
    return self;

}

#pragma mark - 显示AreaPickerView
- (void)showInView:(UIView *)view
{
    self.frame = CGRectMake(0, view.frame.size.height, view.frame.size.width, self.frame.size.height);
    [view addSubview:self];

    // 0.3秒后改变areaPicker的frame
    [UIView animateWithDuration:kDuration animations:^{
        self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    }];
}
#pragma mark - 取消AreaPickerView
- (void)cancelPicker
{
    [UIView animateWithDuration:kDuration animations:^{
        self.frame = CGRectMake(0, self.frame.origin.y + self.frame.size.height, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark -UIPickerViewDataSource数据源方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return kColumn;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case KJAreaTypeProvinces:
            return self.provinces.count;
            break;
        case KJAreaTypeCitys:
            return self.cities.count;
            break;
        case KJAreaTypeAreas:
            return self.areas.count;
            break;
            
        default:
            return 0;
            break;
    }
}
#pragma mark - UIPickerViewDelegate代理方法
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case KJAreaTypeProvinces:
            return [self.provinces[row] objectForKey:StateKey];
            break;
        case KJAreaTypeCitys:
            return [self.cities[row] objectForKey:CityKey];
            break;
        case KJAreaTypeAreas:
            if (self.areas.count > 0) {
                return self.areas[row];
                break;
            }
        default:
            return @"";
            break;
    }
}

/**
 *  选中某列某行
 *
 */
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
        case KJAreaTypeProvinces: // 选中第一列
            // 修改cities数据
            self.cities = [self.provinces[row] objectForKey:CitiesKey];
            // 刷新第二列
            [self.pickerView reloadComponent:1];
            // 默认选中第二列的第一行
            [self.pickerView selectRow:0 inComponent:1 animated:YES];
            
            // 刷新第三列
            [self reloadAreaComponentWithRow:0];
            
            self.locate.state = [[self.provinces objectAtIndex:row] objectForKey:StateKey];
            break;
            
        case KJAreaTypeCitys: // 选中第二列
            [self reloadAreaComponentWithRow:row];
            break;
        case KJAreaTypeAreas: // 选中第三列
            if ([self.areas count] > 0) {
                self.locate.district = [self.areas objectAtIndex:row];
            } else{
                self.locate.district = @"";
            }
            break;
            
        default:
            break;
    }
    // 通知代理
    if ([self.delegate respondsToSelector:@selector(pickerDidChangeStatus:)]) {
        [self.delegate pickerDidChangeStatus:self];
    }
    
}

- (void)reloadAreaComponentWithRow:(NSInteger)row
{
    self.areas = [self.cities[row] objectForKey:AreasKey];
    [self.pickerView reloadComponent:KJAreaTypeAreas];
    [self.pickerView selectRow:0 inComponent:KJAreaTypeAreas animated:YES];
    
    self.locate.city = [[self.cities objectAtIndex:row] objectForKey:CityKey];
    
    if ([self.areas count] > 0) {
        self.locate.district = [self.areas objectAtIndex:0];
    } else{
        self.locate.district = @"";
    }
}
@end
