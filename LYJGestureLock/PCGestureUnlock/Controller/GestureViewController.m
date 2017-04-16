
#import "GestureViewController.h"
#import "PCCircleView.h"
#import "PCCircleViewConst.h"
#import "PCLockLabel.h"
#import "PCCircleInfoView.h"
#import "PCCircle.h"
#import "AppDelegate.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "GTGestureAlertView.h"
//#import "UIImageView+WebCache.h"

@interface GestureViewController ()<CircleViewDelegate,UIAlertViewDelegate>


/**
 *  重设按钮
 */
@property (nonatomic, strong) UIButton *resetBtn;

/**
 *  提示Label
 */
@property (nonatomic, strong) PCLockLabel *msgLabel;

/**
 *  解锁界面
 */
@property (nonatomic, strong) PCCircleView *lockView;

/**
 *  infoView
 */
@property (nonatomic, strong) PCCircleInfoView *infoView;


@property (nonatomic, assign) NSInteger index;

@property(nonatomic,strong) UIView *navgationView;

@property (nonatomic, strong) NSString *touchStateDes;

//当类型为setting的时候，有重绘按钮，重绘按钮在第一次设定后显示
@property (nonatomic, strong) UIButton *resetButton;


@end

@implementation GestureViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"Notify_showPassWordActionView" object:nil];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNeedsStatusBarAppearanceUpdate];

        
    if (self.type == GestureViewControllerTypeLogin) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
        
    }
    
    // 进来先清空存的第一个密码
    [PCCircleViewConst saveGesture:nil Key:gestureOneSaveKey];
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (BOOL)prefersStatusBarHidden
{
    return NO;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //获取用户已经存储的手势密码
    self.index = 4;
    [self.view setBackgroundColor:CircleViewBackgroundColor];
    
    // 1.界面相同部分生成器
    [self setupSameUI];
    
    // 2.界面不同部分生成器
    [self setupDifferentUI];
    //3 添加导航栏
     [self addNavgationView];
}
- (void)addNavgationView{

    if (self.type == GestureViewControllerTypeSetting) {
        self.navgationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,kScreenW,64)];
        UIImageView *nav = [[UIImageView alloc] initWithFrame:self.navgationView.frame];
        nav.image = [UIImage imageNamed:@"Rates_navStatus0"];
        [self.navgationView addSubview:nav];
        UILabel *titlelabel=[[UILabel alloc]init];
        titlelabel.text=@"设置手势密码";
        titlelabel.font=[UIFont fontWithName:@"Arial-BoldItalicMT" size:18];
        titlelabel.frame=CGRectMake(0, 20, self.navgationView.frame.size.width, 40);
//        [titlelabel setTextColor:[GTNCommon getColor:@"666666"]];
        self.navigationItem.titleView=titlelabel;
        titlelabel.textAlignment=NSTextAlignmentCenter;
        [self.navgationView addSubview:titlelabel];
		
        
      
        
        //添加重新绘制按钮
         UIButton *resetButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenW - 56, 32, 40, 19)];
        [resetButton setTitle:@"重绘" forState:UIControlStateNormal];
        [resetButton.titleLabel setFont:[UIFont fontWithName:@"Arial-BoldItalicMT" size:14]];
//        [resetButton setTitleColor:[GTNCommon getColor:@"666666"] forState:UIControlStateNormal];
        [resetButton addTarget:self action:@selector(resetBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.navgationView addSubview:resetButton];
        self.resetButton = resetButton;
        self.resetButton.hidden = YES;
        
        [self.view addSubview:self.navgationView];
        
    }
   

}
- (void)resetBtnClick{
    
    [self infoViewDeselectedSubviews];
    [self.msgLabel showNormalMsg:gestureTextBeforeSet];
    [PCCircleViewConst saveGesture:nil Key:gestureOneSaveKey];

}

#pragma mark - 创建UIBarButtonItem
- (UIBarButtonItem *)itemWithTitle:(NSString *)title target:(id)target action:(SEL)action tag:(NSInteger)tag
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.frame = (CGRect){CGPointZero, {100, 20}};
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    button.tag = tag;
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [button setHidden:YES];
    self.resetBtn = button;
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

#pragma mark - 界面不同部分生成器
- (void)setupDifferentUI
{
    switch (self.type) {
        case GestureViewControllerTypeSetting:
            [self setupSubViewsSettingVc];
            break;
        case GestureViewControllerTypeLogin:
            [self setupSubViewsLoginVc];
            break;
        default:
            break;
    }
}

#pragma mark - 界面相同部分生成器
- (void)setupSameUI
{
    // 创建导航栏右边按钮
    self.navigationItem.rightBarButtonItem = [self itemWithTitle:@"重设" target:self action:@selector(didClickBtn:) tag:buttonTagReset];
    
    // 解锁界面
    PCCircleView *lockView = [[PCCircleView alloc] init];
    lockView.delegate = self;
    self.lockView = lockView;
    [self.view addSubview:lockView];
    
    PCLockLabel *msgLabel = [[PCLockLabel alloc] init];
    msgLabel.frame = CGRectMake(0, 10, kScreenW, 14);
    msgLabel.center = CGPointMake(kScreenW/2, CGRectGetMinY(lockView.frame) - 15);
    self.msgLabel = msgLabel;
    [self.view addSubview:msgLabel];
}

- (void)didClickBtn:(id)send{
	
}

#pragma mark - 设置手势密码界面
- (void)setupSubViewsSettingVc
{
    [self.lockView setType:CircleViewTypeSetting];
    
    self.title = @"设置手势密码";
    
    [self.msgLabel showNormalMsg:gestureTextBeforeSet];
    
    PCCircleInfoView *infoView = [[PCCircleInfoView alloc] init];
    infoView.frame = CGRectMake(0, 0, CircleRadius * 2 * 0.6, CircleRadius * 2 * 0.6);
    infoView.center = CGPointMake(kScreenW/2, CGRectGetMinY(self.msgLabel.frame) - CGRectGetHeight(infoView.frame)/2 - 10);
    self.infoView = infoView;
    [self.view addSubview:infoView];
}

#pragma mark - 登陆手势密码界面
- (void)setupSubViewsLoginVc
{
    [self.lockView setType:CircleViewTypeLogin];
     [self.msgLabel showNormalMsg:@"请输入手势密码"];
    // 头像
    UIImageView  *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 0, 65, 65);
    imageView.center = CGPointMake(kScreenW/2, kScreenH/5);
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = imageView.bounds.size.height/2;
    imageView.image = [UIImage  imageNamed:@"徽商银行"];
    [self.view addSubview:imageView];
    
    // 忘记手势密码
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat x = (kScreenW- (kScreenW/2))/2;
    [self creatButton:leftBtn frame:CGRectMake(x, kScreenH - 60, kScreenW/2, 20) title:@"忘记手势密码" alignment:UIControlContentHorizontalAlignmentCenter tag:buttonTagManager];
	[leftBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
}


- (void)dismissGestureViewaa
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)leftbtnClick{
    
    UIAlertView *alertVeiw = [[UIAlertView alloc] initWithTitle:nil
    message:@"忘记手势密码，需要重新登录"
    delegate:self
    cancelButtonTitle:nil
    otherButtonTitles:@"取消",@"确定", nil];
    alertVeiw.tag = 909;

    [alertVeiw show];


}


#pragma mark - 创建UIButton
- (void)creatButton:(UIButton *)btn frame:(CGRect)frame title:(NSString *)title alignment:(UIControlContentHorizontalAlignment)alignment tag:(NSInteger)tag
{
    btn.frame = frame;
    btn.tag = tag;
    [btn setTitle:title forState:UIControlStateNormal];
//    [btn setTitleColor:[GTNCommon getColor:@"666666"] forState:UIControlStateNormal];
    [btn setContentHorizontalAlignment:alignment];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [btn addTarget:self action:@selector(leftbtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}



#pragma mark - circleView - delegate
#pragma mark - circleView - delegate - setting
- (void)circleView:(PCCircleView *)view type:(CircleViewType)type connectCirclesLessThanNeedWithGesture:(NSString *)gesture
{
    NSString *gestureOne = [PCCircleViewConst getGestureWithKey:gestureOneSaveKey];

    // 看是否存在第一个密码
    if ([gestureOne length]) {
        
        [self.resetBtn setHidden:NO];
        [self.msgLabel showWarnMsgAndShake:gestureTextDrawAgainError];
    } else {
        NSLog(@"密码长度不合法%@", gesture);
        [self.msgLabel showWarnMsgAndShake:gestureTextConnectLess];
    }
}

- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteSetFirstGesture:(NSString *)gesture
{
    NSLog(@"获得第一个手势密码%@", gesture);
    [self.msgLabel showWarnMsg:gestureTextDrawAgain];
    if (self.resetButton)
    {
        self.resetButton.hidden = NO;
    }
    
    // infoView展示对应选中的圆
    [self infoViewSelectedSubviewsSameAsCircleView:view];
}

- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteSetSecondGesture:(NSString *)gesture result:(BOOL)equal
{
    NSLog(@"获得第二个手势密码%@",gesture);
    
    if (equal) {
        
        [self.msgLabel showWarnMsg:gestureTextSetSuccess];
        NSLog(@"手势密码设置成功");
        [self hidenLoginView];

    } else {
        NSLog(@"两次手势不匹配！");
        
        [self.msgLabel showWarnMsgAndShake:gestureTextDrawAgainError];
        [self.resetBtn setHidden:NO];
    }
}

#pragma mark - circleView - delegate - login or verify gesture
- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteLoginGesture:(NSString *)gesture result:(BOOL)equal
{
    // 此时的type有两种情况 Login or verify
    if (type == CircleViewTypeLogin) {
        
        if (equal) {
            NSLog(@"登陆成功！");
//            [self hidenLoginView];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
        else {
            NSLog(@"密码错误！");
            if (self.index > 0) {
               
                NSString *errorM = [NSString stringWithFormat:@"密码错误,还可绘制%ld次", (long)self.index];
                self.index--;

                [self.msgLabel showWarnMsgAndShake:errorM];
            }
         
        }
    } else if (type == CircleViewTypeVerify) {
        
        if (equal) {
            NSLog(@"验证成功，跳转到设置手势界面");
            
        } else {
            NSLog(@"原手势密码输入错误！");
            
        }
    }
    
}

- (void)hidenLoginView
{
   [self dismissViewControllerAnimated:NO completion:nil];
    GestureViewController *gestureVc = [[GestureViewController alloc] init];
    gestureVc.type = GestureViewControllerTypeSetting;
    [self presentViewController:gestureVc animated:YES completion:nil];
    NSLog(@"手势页面消失");
}

#pragma mark - infoView展示方法
#pragma mark - 让infoView对应按钮选中
- (void)infoViewSelectedSubviewsSameAsCircleView:(PCCircleView *)circleView
{
    for (PCCircle *circle in circleView.subviews) {
        
        if (circle.gestState == CircleStateSelected || circle.gestState == CircleStateLastOneSelected) {
            
            for (PCCircle *infoCircle in self.infoView.subviews) {
                if (infoCircle.tag == circle.tag) {
                    [infoCircle setGestState:CircleStateSelected];
                }
            }
        }
    }
}

#pragma mark - 让infoView对应按钮取消选中
- (void)infoViewDeselectedSubviews
{
    [self.infoView.subviews enumerateObjectsUsingBlock:^(PCCircle *obj, NSUInteger idx, BOOL *stop) {
        [obj setGestState:CircleStateNormal];
    }];
}

@end
