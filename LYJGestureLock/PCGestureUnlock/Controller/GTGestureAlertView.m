//
//  GTGestureAlertView.m
//  GTriches
//


#define viewWidth [UIScreen mainScreen].bounds.size.width
#define viewHeight [UIScreen mainScreen].bounds.size.height

#import "GTGestureAlertView.h"

@interface GTGestureAlertView ()

@property(nonatomic,strong)UIImageView *iconIV;
@property(nonatomic,strong)UILabel * messageLaebl;
@property(nonatomic,strong)UIButton * button1;
@property(nonatomic,strong)UIButton * button2;
@property(nonatomic,strong)UIView  * view;
@property(nonatomic,strong)UILabel * line2;
@property(nonatomic, copy) void(^ActionBlock)(int tag,GTGestureAlertView *gestureView);

@end

@implementation GTGestureAlertView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    
    if (self)
    {
        self.frame=[UIScreen mainScreen].bounds;
        self.view=[[UIView alloc]init];
        self.view.bounds=CGRectMake(0, 0, 265, 135);
        self.view.center=CGPointMake(viewWidth/2, viewHeight/2);
        self.view.backgroundColor = [UIColor whiteColor];
        self.view.alpha = 1;
        
        
        _iconIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon-touch"]];
//        NSLog(@"BEGIN_____%@,%@",NSStringFromCGRect(_iconIV.frame),NSStringFromCGPoint(self.view.center));
        CGRect iFrame = _iconIV.frame;
        iFrame.origin.y = 15;
        iFrame.origin.x = self.view.bounds.size.width/2-iFrame.size.width/2;
        _iconIV.frame = iFrame;
        [self.view addSubview:_iconIV];
//        NSLog(@"BEGIN_____%@,%@",NSStringFromCGRect(_iconIV.frame),NSStringFromCGPoint(self.view.center));

        _messageLaebl=[UILabel new];
        _messageLaebl.frame = CGRectMake(0, self.view.frame.size.height/2-10, self.view.bounds.size.width, 22);
        _messageLaebl.textAlignment = NSTextAlignmentCenter;
        _messageLaebl.font = [UIFont systemFontOfSize:15];
        _messageLaebl.textColor = [UIColor blackColor];
        _messageLaebl.text = @"是否启用Touch ID指纹解锁?";
        [self.view addSubview:_messageLaebl];
        
        UILabel *line1 = [UILabel new];
        line1.frame = CGRectMake(0, 90, self.view.frame.size.width, 0.3);
        line1.backgroundColor = [UIColor grayColor];
        [self.view addSubview:line1];
        
        _line2 = [UILabel new];
        _line2.frame = CGRectMake(self.view.frame.size.width / 2, 90.3, 0.3, self.view.bounds.size.height-90.3);
        _line2.backgroundColor = [UIColor grayColor];
        [self.view addSubview:_line2];
        
        _button1=[UIButton buttonWithType:UIButtonTypeSystem];
        _button1.frame=CGRectMake(0 , line1.frame.origin.y + 0.5 , line1.frame.size.width / 2 - 0.3, 40);
        [_button1 setTitle:@"取消" forState:UIControlStateNormal];
        [_button1 addTarget:self action:@selector(clickToAction:) forControlEvents:UIControlEventTouchUpInside];
        _button1.tag = 2001;
        [self.view addSubview:_button1];
        
        _button2=[UIButton buttonWithType:UIButtonTypeSystem];
        _button2.frame=CGRectMake(CGRectGetMaxX(_button1.frame),_button1.frame.origin.y , _button1.frame.size.width, 40);
//        [_button2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal ];
        [_button2 addTarget:self action:@selector(clickToAction:) forControlEvents:UIControlEventTouchUpInside];
        [_button2 setTitle:@"启用" forState:UIControlStateNormal];
        _button2.tag = 2002;
        [self.view addSubview:_button2];
        
        CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        animation.duration = 0.2;
        NSMutableArray *values = [NSMutableArray array];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 0.8)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.1)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
        //        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
        //        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
        animation.values = values;
        [self.view.layer addAnimation:animation forKey:nil];
        self.view.layer.masksToBounds = YES;
        self.view.layer.cornerRadius = 6.0f;
        
        [self addSubview:self.view];
    }
    return self;
    
}

- (void)clickToAction:(UIButton *)sender
{
    if (self.ActionBlock)
    {
        self.ActionBlock((int)(sender.tag),self);
    }
}

- (void)alertWithAction:(void (^)(int,GTGestureAlertView *))ActionBlock
{
    if (ActionBlock) {
        self.ActionBlock = ActionBlock;
    }
}

@end
