//
//  UIView+CustomAlertView.h
//  CustomAnimation
//
//  Created by JiaDa on 2017/4/17.
//

#import <UIKit/UIKit.h>
#define TagValue  3333
typedef NS_ENUM(NSInteger, JKCustomAnimationMode) {
    JKCustomAnimationModeAlert = 0,//弹出效果
    JKCustomAnimationModeDrop, //由上方掉落
    JKCustomAnimationModeShare,//下方弹出（类似分享效果）
    JKCustomAnimationModeNone,//没有动画
    JKCustomAnimationModeNoneFloatingWindow,//浮窗
};

@interface UIView (CustomAlertView)

/**备注*/
@property (nonatomic,assign)BOOL        retrunRimTaped;

/**
 显示 弹出view 任意view导入头文件之后即可调用
 @param animationMode CustomAnimationMode 三种模式
 @param alpha CGFloat  背景透明度 0-1  默认0.2  传-1即为默认值
 @param isNeed BOOL 是否需要背景模糊效果
 */
-(void)jk_showInWindowWithMode:(JKCustomAnimationMode)animationMode inView:(UIView *)superV bgAlpha:(CGFloat)alpha needEffectView:(BOOL)isNeed;

/**
 显示 弹出view 任意view导入头文件之后即可调用
 @param animationMode CustomAnimationMode 三种模式
 @param alpha CGFloat  背景透明度 0-1  默认0.2  传-1即为默认值
 @param isNeed BOOL 是否需要背景模糊效果
 @param retrunRimTaped BOOL 是否接收周边点击的事件
 */
-(void)jk_showInWindowWithMode:(JKCustomAnimationMode)animationMode inView:(UIView *)superV bgAlpha:(CGFloat)alpha needEffectView:(BOOL)isNeed retrunRimTaped:(BOOL)retrunRimTaped;

/**
 不显示 view
 */
-(void)jk_hideView;
-(void)jk_Next:(BOOL)isNext;

/**
 给view 各个边加 layer.border
 */
- (void)jk_setBorderWithView:(UIView *)view top:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width;

@end

