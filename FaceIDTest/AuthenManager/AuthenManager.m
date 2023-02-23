//
//  AuthenManager.m
//  biozen
//
//  Created by JiaDa on 2022/7/27.
//

#import "AuthenManager.h"

// 指纹解锁必须的头文件
#import <LocalAuthentication/LocalAuthentication.h>

@interface AuthenManager ()

@property (nonatomic, strong) LAContext *context;

@end

@implementation AuthenManager

- (void)authen:(void (^)(void))start complete:(void (^)(BOOL success, NSInteger errorCode))complete
{
    // 开始回调
    if (start) {
        start();
    }
    
    // 判断设备是否支持指纹识别
    NSError *error = nil;
    BOOL isValidTouch = [self.context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
    if (isValidTouch)
    {
        NSLog(@"支持指纹识别");
        [self.context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"请按home键指纹解锁" reply:^(BOOL success, NSError * _Nullable error) {
            if (success)
            {
                NSLog(@"验证成功 刷新主界面");
            }
            else
            {
                NSLog(@"%@", error.localizedDescription);
                switch (error.code)
                {
                    case LAErrorSystemCancel:
                    {
                        NSLog(@"系统取消授权，如其他APP切入");
                        break;
                    }
                    case LAErrorUserCancel:
                    {
                        NSLog(@"用户取消验证Touch ID");
                        break;
                    }
                    case LAErrorAuthenticationFailed:
                    {
                        NSLog(@"授权失败");
                        break;
                    }
                    case LAErrorPasscodeNotSet:
                    {
                        NSLog(@"系统未设置密码");
                        break;
                    }
                    case LAErrorTouchIDNotAvailable:
                    {
                        NSLog(@"设备Touch ID不可用，例如未打开");
                        break;
                    }
                    case LAErrorTouchIDNotEnrolled:
                    {
                        NSLog(@"设备Touch ID不可用，用户未录入");
                        break;
                    }
                    case LAErrorUserFallback:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            NSLog(@"用户选择输入密码，切换主线程处理");
                        }];
                        break;
                    }
                    default:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            NSLog(@"其他情况，切换主线程处理");
                        }];
                        break;
                    }
                }
            }
            
            // 成功回调
            if (complete) {
                complete(success, error.code);
            }
        }];
    }
    else
    {
        NSLog(@"不支持指纹识别");
        switch (error.code)
        {
            case LAErrorTouchIDNotEnrolled:
            {
                NSLog(@"TouchID is not enrolled");
                break;
            }
            case LAErrorPasscodeNotSet:
            {
                NSLog(@"A passcode has not been set");
                break;
            }
            default:
            {
                NSLog(@"TouchID not available");
                break;
            }
        }
        NSLog(@"%@", error.localizedDescription);
        
        // 失败回调
        if (complete) {
            complete(NO, error.code);
        }
    }
}

- (LAContext *)context
{
    if (_context == nil) {
        // 创建LAContext
        _context = [LAContext new];
        // 这个设置的使用密码的字体，当text=@""时，按钮将被隐藏，也设置指纹输入失败之后的弹出框的选项
        _context.localizedFallbackTitle = @"";
        // 这个设置的取消按钮的字体
//        _context.localizedCancelTitle = Local(@"Cancel");
    }
    return _context;
}

@end
