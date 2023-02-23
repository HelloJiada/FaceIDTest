//
//  ViewController.h
//  FaceIDTest
//
//  Created by 陈佳达 on 2023/1/10.
//

#import <UIKit/UIKit.h>
#import "AuthenManager.h"
#import "UIView+LayoutExtension.h"
#define kImageName(str) [UIImage imageNamed:str]
#ifndef dispatch_main_async_safe
#define dispatch_main_async_safe(block)\
    if (dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL) == dispatch_queue_get_label(dispatch_get_main_queue())) {\
        block();\
    } else {\
        dispatch_async(dispatch_get_main_queue(), block);\
    }
#endif
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height
@interface ViewController : UIViewController


@end

