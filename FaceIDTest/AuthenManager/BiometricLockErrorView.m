//
//  BiometricLockErrorView.m
//  biozen
//
//  Created by JiaDa on 2022/8/1.
//

#import "BiometricLockErrorView.h"
#import "Masonry.h"
@implementation BiometricLockErrorView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.layer.cornerRadius = 8;
        self.layer.masksToBounds = YES;
        self.backgroundColor = UIColor.whiteColor;
        
        [self addSubview:self.titleLabel];
        
        [self addSubview:self.imgView];
        
        [self addSubview:self.subLabel];
        
        [self addSubview:self.okBtn];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(32);
            make.right.mas_equalTo(self.mas_right).offset(-32);
            make.top.mas_equalTo(self.mas_top).offset(24);
        }];
        
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(18);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(68, 68));
        }];
        
        [self.subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(32);
            make.right.mas_equalTo(self.mas_right).offset(-32);
            make.top.mas_equalTo(self.imgView.mas_bottom).offset(18);
        }];
        
        [self.okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(self.frame.size.width, 54));
            make.bottom.mas_equalTo(self.mas_bottom).offset(-15);
        }];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        if (@available(iOS 11.0, *)) {
            UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
            if (window.safeAreaInsets.bottom > 0.0) {
                _titleLabel = [self labelWithTitle:@"Your Face ID is not set up" color:UIColor.blackColor font:[UIFont systemFontOfSize:20] TextAlignment:NSTextAlignmentCenter NumberOfLines:0];
            } else {
                _titleLabel = [self labelWithTitle:@"Your Touch ID is not set up" color:UIColor.blackColor font:[UIFont systemFontOfSize:20] TextAlignment:NSTextAlignmentCenter NumberOfLines:0];
            }
        } else {
            _titleLabel = [self labelWithTitle:@"Your Face ID is not set up" color:UIColor.blackColor font:[UIFont systemFontOfSize:20] TextAlignment:NSTextAlignmentCenter NumberOfLines:0];
        }
    }
    return _titleLabel;
}

- (UILabel *)subLabel { 
    if (!_subLabel) {
        _subLabel = [self labelWithTitle:@"Please go to Menu > Account Settings to turn on the Biometric Lock" color:UIColor.blackColor font:[UIFont systemFontOfSize:16] TextAlignment:NSTextAlignmentCenter NumberOfLines:0];
    }
    return _subLabel;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        if (@available(iOS 11.0, *)) {
            UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
            if (window.safeAreaInsets.bottom > 0.0) {
                [_imgView setImage:[UIImage imageNamed:@"Taptounlockwithfacerecognition"]];
            } else {
                [_imgView setImage:[UIImage imageNamed:@"Taptounlockwithfacerecognition"]];
            }
        } else {
            [_imgView setImage:[UIImage imageNamed:@"Clicktounlockfingerprint"]];
        }
    }
    return _imgView;
}

- (UIButton *)okBtn {
    if (!_okBtn) {
        _okBtn = [self allocButtonWithType:UIButtonTypeCustom buttonNormalStr:@"OK" buttonSelectedStr:@"OK" buttonNormalColor:UIColor.redColor buttonSelectedColor:UIColor.redColor buttonBackgroundColor:UIColor.whiteColor buttonFont:[UIFont systemFontOfSize:16] cornerRadius:0];
        [_okBtn addTarget:self action:@selector(clickContinueBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _okBtn;
}

- (void)clickContinueBtn {
    
    if (self.ClickContinueBlock) {
        self.ClickContinueBlock();
    }
}

- (UILabel *)labelWithTitle:(NSString *)title color:(UIColor *)color font:(UIFont *)font TextAlignment:(NSTextAlignment)textAlignment NumberOfLines:(NSInteger)numberOfLines{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = color;
    label.text = title;
    label.font = font;
    label.numberOfLines = numberOfLines;
    label.textAlignment = textAlignment;
    return label;
}

- (UIButton *)allocButtonWithType:(UIButtonType)buttonType buttonNormalStr:(NSString *)buttonNormalStr buttonSelectedStr:(NSString *)buttonSelectedStr buttonNormalColor:(UIColor *)buttonNormalColor buttonSelectedColor:(UIColor *)buttonSelectedColor buttonBackgroundColor:(UIColor *)buttonBackgroundColor buttonFont:(UIFont *)buttonFont cornerRadius:(NSInteger)cornerRadius {
    UIButton *button = [UIButton buttonWithType:buttonType];
    button.adjustsImageWhenHighlighted = NO;
    [button setTitle:buttonNormalStr forState:UIControlStateNormal];
    [button setTitle:buttonSelectedStr forState:UIControlStateSelected];
    [button setTitleColor:buttonNormalColor forState:UIControlStateNormal];
    [button setTitleColor:buttonSelectedColor forState:UIControlStateSelected];
    button.backgroundColor = buttonBackgroundColor;
    button.titleLabel.font = buttonFont;
    if (cornerRadius > 0) {
        button.layer.cornerRadius = cornerRadius;
        button.layer.masksToBounds = YES;
    }
    return button;
}

@end
