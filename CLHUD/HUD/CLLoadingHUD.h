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
-(void)updateProgeressWithProgress:(CGFloat)progress;
@end

NS_ASSUME_NONNULL_END
