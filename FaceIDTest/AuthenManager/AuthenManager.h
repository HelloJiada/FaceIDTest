//
//  AuthenManager.h
//  biozen
//
//  Created by JiaDa on 2022/7/27.
//

#import <Foundation/Foundation.h>

@interface AuthenManager : NSObject

- (void)authen:(void (^)(void))start complete:(void (^)(BOOL success, NSInteger errorCode))complete;

@end
