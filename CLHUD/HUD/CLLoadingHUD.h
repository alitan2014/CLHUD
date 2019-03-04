//
//  CLLoadingHUD.h
//  CLHUD
//
//  Created by 谭春林 on 2019/3/3.
//  Copyright © 2019 alitan2014. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLLoadingHUD : UIView

/**
 更新进度条

 @param progress 进度
 */
-(void)updateProgeressWithProgress:(CGFloat)progress;

/**
 设置进度条背景颜色

 @param color 颜色
 */
-(void)setProgressBackgroundColor:(UIColor *)color;

/**
 设置进度条进行时颜色

 @param color 颜色
 */
-(void)setProgressColor:(UIColor*)color;

/**
 设置进度条总长度

 @param length 总长度
 */
-(void)setProgressTotalLength:(CGFloat)length;
@end

NS_ASSUME_NONNULL_END
