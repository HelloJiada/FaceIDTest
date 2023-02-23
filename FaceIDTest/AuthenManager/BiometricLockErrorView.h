//
//  BiometricLockErrorView.h
//  biozen
//
//  Created by JiaDa on 2022/8/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BiometricLockErrorView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subLabel;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIButton *okBtn;
@property (nonatomic, copy) void(^ClickContinueBlock)(void);
@end

NS_ASSUME_NONNULL_END
