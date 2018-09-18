//
//  KJAreaPickerView.h
//  AreaPicker
//
//  Created by kouhanjin on 15/12/28.
//  Copyright © 2015年 khj. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KJLocation, KJAreaPickerView;

@protocol KJAreaPickerViewDelegate <NSObject>
@optional
- (void)pickerDidChangeStatus:(KJAreaPickerView *)picker;
@end

@interface KJAreaPickerView : UIView

@property (nonatomic, weak) id<KJAreaPickerViewDelegate> delegate;
@property (nonatomic, strong) KJLocation *locate;

+ (instancetype)areaPickerViewWithDelegate:(id<KJAreaPickerViewDelegate>)delegate;

/**
 *  显示
 *
 */
- (void)showInView:(UIView *)view;
/**
 *  隐藏
 */
- (void)cancelPicker;
@end
