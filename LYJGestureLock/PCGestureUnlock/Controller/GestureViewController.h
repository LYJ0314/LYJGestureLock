
#import <UIKit/UIKit.h>
//#import "GTPushModel.h"

typedef enum{
    GestureViewControllerTypeSetting = 1,
    GestureViewControllerTypeLogin
}GestureViewControllerType;

typedef enum{
    buttonTagReset = 1,
    buttonTagManager,
    buttonTagForget
    
}buttonTag;

@interface GestureViewController : UIViewController

@property (nonatomic, assign) GestureViewControllerType type;

@end
