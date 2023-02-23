//
//  ViewController.m
//  FaceIDTest
//
//  Created by 陈佳达 on 2023/1/10.
//

#import "ViewController.h"
#import "BiometricLockErrorView.h"
#import "UIView+CustomAlertView.h"

#define UIKeyWindow [[UIApplication sharedApplication] keyWindow]

@interface ViewController ()
@property (nonatomic, strong) UIButton *lockBtn;
@property (nonatomic, strong) UILabel *lockTitle;
@property (nonatomic, strong) AuthenManager *authenManager;
@property (nonatomic, assign) BOOL isPhoneX;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 11.0, *)) {
        UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
        if (window.safeAreaInsets.bottom > 0.0) {
            self.isPhoneX = YES;
        } else {
            self.isPhoneX = NO;
        }
    } else {
        self.isPhoneX = YES;
    }
    
    self.view.backgroundColor = UIColor.whiteColor;
    

    [self initView];
}

- (void)initView {
    [self.view addSubview:self.lockBtn];
    [self.view addSubview:self.lockTitle];
    
    self.lockBtn.frame = CGRectMake(0, 0, 68, 68);
    self.lockBtn.centerY = self.view.centerY;
    self.lockBtn.centerX = self.view.centerX;
    
    self.lockTitle.frame = CGRectMake(0, self.lockBtn.endY + 8, kScreenWidth, 16);
    self.lockTitle.centerX = self.lockBtn.centerX;
}

- (UIButton *)lockBtn {
    if (!_lockBtn) {
        _lockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (@available(iOS 11.0, *)) {
            UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
            if (window.safeAreaInsets.bottom > 0.0) {
                [_lockBtn setImage:kImageName(@"Taptounlockwithfacerecognition") forState:UIControlStateNormal];
            } else {
                [_lockBtn setImage:kImageName(@"Clicktounlockfingerprint") forState:UIControlStateNormal];
            }
        } else {
            [_lockBtn setImage:kImageName(@"Taptounlockwithfacerecognition") forState:UIControlStateNormal];
        }
        [_lockBtn addTarget:self action:@selector(authenClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lockBtn;
}

- (UILabel *)lockTitle {
    if (!_lockTitle) {
        if (@available(iOS 11.0, *)) {
            UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
            if (window.safeAreaInsets.bottom > 0.0) {
                _lockTitle = [self labelWithTitle:@"Face ID" color:RGBA(65, 97, 193, 1) font:[UIFont systemFontOfSize:17] TextAlignment:NSTextAlignmentCenter NumberOfLines:0];
            } else {
                _lockTitle = [self labelWithTitle:@"Touch ID" color:RGBA(65, 97, 193, 1) font:[UIFont systemFontOfSize:17] TextAlignment:NSTextAlignmentCenter NumberOfLines:0];
            }
        } else {
            _lockTitle = [self labelWithTitle:@"Face ID" color:RGBA(65, 97, 193, 1) font:[UIFont systemFontOfSize:17] TextAlignment:NSTextAlignmentCenter NumberOfLines:0];
        }
    }
    return _lockTitle;
}

- (void)authenClick
{

    BOOL isON = [[[NSUserDefaults standardUserDefaults] objectForKey:@"BiometricLockBOOL"] boolValue];
    if (isON==NO) {//没有开启
        
        NSString *str = @"Please go to Menu > Account Settings to turn on the Biometric Lock";
        BiometricLockErrorView *view = [[BiometricLockErrorView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 36*2, 275 + [self zp_calculateRowHeightFontSize:[UIFont systemFontOfSize:16] maxW:kScreenWidth - 36*2 - 32*2 str:str])];
        [view jk_showInWindowWithMode:JKCustomAnimationModeAlert inView:UIKeyWindow bgAlpha:0.4 needEffectView:YES retrunRimTaped:YES];
        [view setClickContinueBlock:^{
            [view jk_hideView];
        }];
    
    }else{
        
        if (self.authenManager == nil) {
            self.authenManager = [[AuthenManager alloc] init];
        }
        
        [self.authenManager authen:^{
        } complete:^(BOOL success, NSInteger errorCode) {
            if (success) {
            } else {
                
                [self alertClick:errorCode];
            }
        }];
    }
}


- (void)alertClick:(NSInteger)errorCode
{
    NSLog(@"errorCode = %ld",(long)errorCode);
    dispatch_main_async_safe((^{
        NSString *res;
        if (errorCode == -5) {//系统设置关闭
            if (self.isPhoneX) {
                res = @"You have not set a unlock passcode. Please go to Settings > Face ID & Passcode to set a passcode";
            }else{
                res = @"You have not set a unlock passcode. Please go to Settings > Touch ID & Passcode to set a passcode";
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:res message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }else if (errorCode == -6) {//App设置关闭
            if (self.isPhoneX) {
                res = @"You need to open Face ID in the system settings";
            }else{
                res = @"You need to open fingerprint in the system settings";
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:res message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Enable",nil];
            [alert show];
        }else if(errorCode == -7){
            if (self.isPhoneX) {
                res = @"You have not set a Face ID. Please go to Settings > Face ID & Passcode to set a Face ID";
            }else{
                res = @"You have not set a Touch ID. Please go to Settings > Touch ID & Passcode to set a Touch ID";
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:res message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }else if (errorCode == -8){
            if (self.isPhoneX) {
                res = @"Face ID";
            }else{
                res = @"Touch ID";
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@ attempts exceeded",res] message:[NSString stringWithFormat:@"Unable to use %@",res] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            [alert show];
        }
    }));
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSString *urlString = @"App-Prefs:biozen.com.heboen";
        NSURL *url = [NSURL URLWithString:urlString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
            }else {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
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

- (CGFloat)zp_calculateRowHeightFontSize:(UIFont *)fontSize maxW:(CGFloat)maxW str:(NSString *)str
{
    
    NSDictionary *dic = @{NSFontAttributeName:fontSize};//指定字号
    CGRect rect = [str boundingRectWithSize:CGSizeMake(maxW, 0) options:NSStringDrawingUsesLineFragmentOrigin |                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.height;/*计算高度要先指定宽度*/
}

@end
