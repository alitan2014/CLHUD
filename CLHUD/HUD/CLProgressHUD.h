//
//  CLProgressHUD.h
//  CLHUD
//
//  Created by 谭春林 on 2019/3/5.
//  Copyright © 2019 alitan2014. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLProgressHUD : UIView

/**
 展示加载框
 */
+(void)show;

/**
 隐藏加载框
 */
+(void)dismiss;

/**
 显示提示语

 @param msg 需要提示的语言
 */
+(void)showTipMessage:(NSString *)msg;
@end

NS_ASSUME_NONNULL_END
