//
//  CLProgressHUD.m
//  CLHUD
//
//  Created by 谭春林 on 2019/3/5.
//  Copyright © 2019 alitan2014. All rights reserved.
//

#import "CLProgressHUD.h"
#define ScreenWidth UIScreen.mainScreen.bounds.size.width
#define ScreenHeigth UIScreen.mainScreen.bounds.size.height
#define KWindow UIApplication.sharedApplication.windows.firstObject
@interface CLProgressHUD()

/**
 中间转圈view
 */
@property (nonatomic ,strong) UIView *container;
@property (nonatomic ,strong) UILabel *tipLabel;
/**
 旋转动画
 */
@property (nonatomic ,strong) CABasicAnimation *rotationAnimation;

@end
@implementation CLProgressHUD
+(CLProgressHUD*)shareInstance{
    static dispatch_once_t onceToken;
    static CLProgressHUD *hud = nil;
    dispatch_once(&onceToken, ^{
        hud = [[CLProgressHUD alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeigth)];
        hud.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        hud.userInteractionEnabled = YES;
    });
    return hud;
}

/**
 显示加载框
 */
+ (void)show{
    [[self shareInstance] showWithStatus:@""];
}
+ (void)showTipMessage:(NSString *)msg{
    [[self shareInstance] showTipMessage:msg];
}
/**
 隐藏加载框
 */
+ (void)dismiss{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[CLProgressHUD shareInstance] removeFromSuperview];
    });
    
}
-(CABasicAnimation *)rotationAnimation{
    if (!_rotationAnimation) {
        _rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        
        _rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI*2.0];
        
        _rotationAnimation.duration = 1;
        
        _rotationAnimation.repeatCount = HUGE_VALF;
    }
    return _rotationAnimation;
}
-(CAShapeLayer *)createShapeLayer:(UIColor *)color withLineWidth:(CGFloat)lineWidth{
    CAShapeLayer *layer = [[CAShapeLayer alloc]init];
    
    CGRect rect = CGRectMake(0, 0, 60-lineWidth, 60-lineWidth);
    
    
    //    设置Path
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
    layer.path = path.CGPath;
    layer.frame =self.container.bounds;
    layer.strokeColor = color.CGColor;
    layer.fillColor = UIColor.clearColor.CGColor;
    layer.lineWidth = lineWidth;
    
    
    layer.lineCap = kCALineCapRound;
    return  layer;
}
-(UIView *)container{
    if (!_container) {
        _container = [[UIView alloc]initWithFrame:CGRectMake((ScreenWidth-60)/2, (ScreenHeigth-60)/2, 60, 60)];
//        _container.backgroundColor = UIColor.blueColor;
        CALayer *layer = [CALayer layer];
//        layer.backgroundColor = [UIColor redColor].CGColor; //圆环底色

        CGRect rect =  CGRectMake(2, 2, 56, 56);
        layer.frame = _container.bounds;

        //创建一个圆环
        UIBezierPath *bezierPath =  [UIBezierPath bezierPathWithOvalInRect:rect];

        //圆环遮罩
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        shapeLayer.strokeColor = [UIColor blackColor].CGColor;
        shapeLayer.lineWidth = 2;
        shapeLayer.strokeStart = 0;
        shapeLayer.strokeEnd = 0.95;
//        shapeLayer.lineCap = @"round";
        shapeLayer.lineCap = kCALineCapRound;
//        shapeLayer.lineDashPhase = 0.8;
        shapeLayer.path = bezierPath.CGPath;
        

        //颜色渐变
        NSMutableArray *colors = [NSMutableArray arrayWithObjects:(id)[UIColor blackColor].CGColor,(id)[UIColor whiteColor].CGColor, nil];
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.shadowPath = bezierPath.CGPath;
        gradientLayer.frame = CGRectMake(1, 1, 58, 58);
        gradientLayer.startPoint = CGPointMake(0, 1);
        gradientLayer.endPoint = CGPointMake(1, 0);
        [gradientLayer setColors:[NSArray arrayWithArray:colors]];
        [layer addSublayer:gradientLayer]; //设置颜色渐变
        [layer setMask:shapeLayer]; //设置圆环遮罩
        [_container.layer addSublayer:layer];

        
    }
    return  _container;
}
- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc]initWithFrame:CGRectMake((ScreenWidth-200)/2, (ScreenHeigth-30)/2, 200, 30)];
        _tipLabel.textColor = UIColor.whiteColor;
        _tipLabel.backgroundColor = UIColor.blackColor;
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.font = [UIFont systemFontOfSize:15];
        _tipLabel.layer.cornerRadius = 8;
        _tipLabel.clipsToBounds = YES;
    }
    return _tipLabel;
}

-(void)showWithStatus:(NSString *)status{
    dispatch_async(dispatch_get_main_queue(), ^{
        CLProgressHUD *hud = [CLProgressHUD shareInstance];
        //添加旋转动画
        [self.container.layer addAnimation:self.rotationAnimation forKey:@"rotationAnimation"];
        [hud addSubview:self.container];
        [[self mainWindow] addSubview:hud];
    });
    
    
}
-(void)showTipMessage:(NSString *)message{
    dispatch_async(dispatch_get_main_queue(), ^{
        CLProgressHUD *hud = [CLProgressHUD shareInstance];
        self.tipLabel.text = message;
        CGRect frame = self.tipLabel.frame;
        frame.size.width = [self autoSize:message];
        frame.origin.x = (ScreenWidth -frame.size.width)/2;
        self.tipLabel.frame = frame;
        [hud addSubview:self.tipLabel];
        [[self mainWindow] addSubview:hud];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CLProgressHUD *hud = [CLProgressHUD shareInstance];
        [hud removeFromSuperview];
    });
}

/**
 获取当前window

 @return 返回当前window
 */
- (UIWindow *)mainWindow {
    UIApplication *app = [UIApplication sharedApplication];
    if ([app.delegate respondsToSelector:@selector(window)]){
            return [app.delegate window];
        }
       else{
           return [app keyWindow];
        }
    }


/**
事件透传（loading加载时可响应事件）

 @param point 触摸点
 @param event 事件
 @return 返回
 */
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView == self) {
        return nil;
    }
    return hitView;
}

-(CGFloat)autoSize:(NSString *)text{
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15],};
    
    NSString *str = text;
    
    CGSize textSize = [str boundingRectWithSize:CGSizeMake(ScreenWidth, 30)
                       
                                        options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;;
    
    return textSize.width+15;
}

@end
