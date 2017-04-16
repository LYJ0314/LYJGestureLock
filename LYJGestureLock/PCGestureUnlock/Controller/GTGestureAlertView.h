//
//  GTGestureAlertView.h
//  GTriches
//


#import <UIKit/UIKit.h>

@interface GTGestureAlertView : UIView

- (void)alertWithAction:(void(^)(int,GTGestureAlertView *))ActionBlock;

@end
