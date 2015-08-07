#import <UIKit/UIKit.h>
typedef void (^CHTumblrMenuViewSelectedBlock)(void);


@interface CHTumblrMenuView : UIView<UIGestureRecognizerDelegate>
- (void)addMenuItemWithTitle:(NSString*)title andIcon:(UIImage*)icon andSelectedBlock:(CHTumblrMenuViewSelectedBlock)block;
- (void)show;
@end
