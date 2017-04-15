# LYJGestureLock
/**开屏手势解锁:
   设置手势密码，然后进行存储；
   登录验证手势密码；
*/
typedef enum{
    GestureViewControllerTypeSetting = 1, // 设置手势密码
    GestureViewControllerTypeLogin        // 登录验证手势密码
}GestureViewControllerType;

How to Use?
    GestureViewController *gestureVc = [[GestureViewController alloc] init]; 
  //[gestureVc setType:GestureViewControllerTypeSetting]; //设置手势（第一步）
    [gestureVc setType:GestureViewControllerTypeLogin];  // 登录验证 （第二步）
    [nav pushViewController:gestureVc animated:YES];
可设置的属性有:
  @property (nonatomic, assign) GestureViewControllerType type;

PhotoShoot:
