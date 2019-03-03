//
//  CLLoadingHUD.m
//  CLHUD
//
//  Created by 谭春林 on 2019/3/3.
//  Copyright © 2019 alitan2014. All rights reserved.
//

#import "CLLoadingHUD.h"
#define degreesToRadians(x) (M_PI*(x)/180.0)
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
//    self.contetView.layer.cornerRadius = 50;
//    self.contetView.clipsToBounds = YES;
    [self.contetView.layer addSublayer:_backgroundLayer];
    _progressLayer.strokeEnd = 0;
    [self.contetView.layer addSublayer:_progressLayer];
}
- (void)drawRect:(CGRect)rect{
//    [super drawRect:rect];
    
    // 创建一个track shape layer
    _backgroundLayer = [CAShapeLayer layer];
    _backgroundLayer.frame = self.contetView.bounds;
    _backgroundLayer.fillColor = [[UIColor clearColor] CGColor];
    _backgroundLayer.strokeColor = [[UIColor cyanColor]  CGColor];
    [self.contetView.layer addSublayer:_backgroundLayer];
    
    // 指定path的渲染颜色
    _backgroundLayer.opacity = 1; // 背景透明度
    _backgroundLayer.lineCap = kCALineCapRound;// 指定线的边缘是圆的
    _backgroundLayer.lineWidth = 5; // 线的宽度
    
    
    // 上面说明过了用来构建圆形
    
    /*
     center：圆心的坐标
     radius：半径
     startAngle：起始的弧度
     endAngle：圆弧结束的弧度
     clockwise：YES为顺时针，No为逆时针
     方法里面主要是理解startAngle与endAngle
     */
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.contetView.frame.size.width/2, self.contetView.frame.size.height/2)
                                                        radius:self.contetView.frame.size.width/2
                                                    startAngle:degreesToRadians(270)
                                                      endAngle:degreesToRadians(-90) clockwise:NO];
    
    _backgroundLayer.path = [path CGPath]; // 把path传递給layer，然后layer会处理相应的渲染，整个逻辑和CoreGraph是一致的。
    
    
    
    
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.frame = self.contetView.bounds;
    _progressLayer.fillColor = [[UIColor clearColor] CGColor];
    _progressLayer.strokeColor = [[UIColor redColor] CGColor];
    _progressLayer.lineCap = kCALineCapRound;
    _progressLayer.lineWidth = 5;
    _progressLayer.path = [path CGPath];
    _progressLayer.opacity = 1;
    _progressLayer.strokeEnd = 0;
    
    [self.contetView.layer addSublayer:_progressLayer];

    
    
}

-(CAShapeLayer *)createShapeLayer:(UIColor *)color withLineWidth:(CGFloat)lineWidth{
    CAShapeLayer *layer = [[CAShapeLayer alloc]init];
    
//    CGRect rect = CGRectMake(0, 0, 100, 100);
    

//    设置Path
//    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
//    layer.path = path.CGPath;
    layer.frame = self.contetView.bounds;
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
    self.progressLayer.strokeEnd = progress;
   
    [CATransaction commit];
}
@end
