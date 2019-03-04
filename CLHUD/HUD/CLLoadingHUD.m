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
 提示语
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

/**
 总长度
 */
@property (nonatomic ,assign) CGFloat totalLength;


/**
 百分比进度
 */
@property (nonatomic ,strong) UILabel *progressTip;


/**
 设置圆形宽度
 */
@property (nonatomic ,assign) CGFloat lineWidth;
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
- (void)setProgressColor:(UIColor *)color{
    if (_progressLayer!=nil) {
        _progressLayer.strokeColor = color.CGColor;
    }
}
- (void)setProgressBackgroundColor:(UIColor *)color{
    if (_backgroundLayer!=nil) {
        _backgroundLayer.strokeColor = color.CGColor;
    }
}
- (void)setProgressTotalLength:(CGFloat)length{
        _totalLength  = length;
    
}
-(void)initView{
    self.lineWidth = 5;
//    比较宽高，设置width为短的
    if (CGRectGetWidth(self.frame)>CGRectGetHeight(self.frame)) {
        self.width = CGRectGetHeight(self.frame);
    }else{
        self.width = CGRectGetWidth(self.frame);
    }
    //创建圆形Layer
    self.backgroundLayer = [self createShapeLayer:UIColor.grayColor withLineWidth:_lineWidth];
    self.progressLayer = [self createShapeLayer:UIColor.orangeColor withLineWidth:_lineWidth];
    
    //创建layer承载view
    self.contetView = [[UIView alloc ]initWithFrame:CGRectMake((CGRectGetWidth(self.frame)-self.width+self.lineWidth)/2, (CGRectGetHeight(self.frame)-self.width-self.lineWidth)/2, self.width-_lineWidth, self.width-_lineWidth)];
    //逆时针旋转90度
    self.contetView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    //设置中心点
    [self addSubview:self.contetView];
    [self.contetView.layer addSublayer:_backgroundLayer];
    _progressLayer.strokeEnd = 0;
    [self.contetView.layer addSublayer:_progressLayer];
    
    
    
    
    //创建提示view
    _notTip = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_contetView.frame), CGRectGetMaxY(_contetView.frame)+10, self.width, 20)];
    _notTip.text = @"上传中";
    _notTip.textAlignment = NSTextAlignmentCenter;
    _notTip.font = [UIFont systemFontOfSize:15];
    [self addSubview:_notTip];
    
    
    
    //创建百分比进度条
    
    _progressTip = [[[UILabel alloc]init]initWithFrame:CGRectMake(0, 0, self.width-20, 20)];
    _progressTip.frame = _contetView.frame;
    _progressTip.font = [UIFont systemFontOfSize:15];
    _progressTip.textAlignment = NSTextAlignmentCenter;
    _progressTip.text = @"%0";
    [self addSubview:_progressTip];
    
    
    
}

-(CAShapeLayer *)createShapeLayer:(UIColor *)color withLineWidth:(CGFloat)lineWidth{
    CAShapeLayer *layer = [[CAShapeLayer alloc]init];
    
    CGRect rect = CGRectMake(0, 0, self.width-lineWidth, self.width-lineWidth);
    

//    设置Path
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
    layer.path = path.CGPath;
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
    self.progressLayer.strokeEnd = progress/_totalLength;
    
    _progressTip.text = [NSString stringWithFormat:@"%%%.0f",(progress/_totalLength)*100];
//    [_contetView bringSubviewToFront:_progressTip];
   
    [CATransaction commit];
}
@end
