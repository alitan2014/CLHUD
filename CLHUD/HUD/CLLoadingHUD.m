//
//  CLLoadingHUD.m
//  CLHUD
//
//  Created by 谭春林 on 2019/3/3.
//  Copyright © 2019 alitan2014. All rights reserved.
//

#import "CLLoadingHUD.h"
@interface CLLoadingHUD()

/**
 进度条背景颜色
 */
@property (nonatomic ,strong) CAShapeLayer *backgroundLayer;

/**
 进度条进行时颜色
 */
@property (nonatomic ,strong) CAShapeLayer *progressLayer;

/**
 提示语言
 */
@property (nonatomic ,strong) UILabel *notTip;

/**
 圆的宽度
 */
@property (nonatomic ,assign) CGFloat width;


/**
 进度承载view
 */
@property (nonatomic ,strong) UIView *contetView;

@end

@implementation CLLoadingHUD

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}
-(void)initView{
    self.width = 100;
    self.backgroundLayer = [self createShapeLayer:UIColor.grayColor withLineWidth:5];
    self.progressLayer = [self createShapeLayer:UIColor.orangeColor withLineWidth:5];
    self.contetView = [[UIView alloc ]initWithFrame:CGRectMake(0, 0, 100, 100)];
//    self.contetView.backgroundColor = UIColor.redColor;
    self.contetView.center = self.center;
    [self addSubview:self.contetView];
    self.contetView.layer.cornerRadius = 50;
    self.contetView.clipsToBounds = YES;
    [self.contetView.layer addSublayer:_backgroundLayer];
    _progressLayer.strokeEnd = 0;
    [self.contetView.layer addSublayer:_progressLayer];
}

-(CAShapeLayer *)createShapeLayer:(UIColor *)color withLineWidth:(CGFloat)lineWidth{
    CAShapeLayer *layer = [[CAShapeLayer alloc]init];
    
    CGRect rect = CGRectMake(0, 0, 100, 100);
    

//    设置Path
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
    layer.path = path.CGPath;
    layer.strokeColor = color.CGColor;
    layer.fillColor = UIColor.clearColor.CGColor;
    layer.lineWidth = lineWidth;
    
    layer.lineCap = kCALineCapRound;
    return  layer;
}
-(void)updateProgeressWithProgress:(CGFloat)progress{
    [CATransaction begin];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [CATransaction setAnimationDuration:1];
    self.progressLayer.strokeEnd = progress/100;
    [CATransaction commit];
}
@end
