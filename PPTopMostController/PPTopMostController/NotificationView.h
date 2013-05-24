//
//  NotificationView.h
//  PPTopMostController
//
//  Created by Marian Paul on 24/05/13.
//  Copyright (c) 2013 iPuP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationView : UIView
+ (NotificationView *)showWithText:(NSString *)text color:(UIColor *)color andHideAfterDelay:(NSTimeInterval)delay;
@end
