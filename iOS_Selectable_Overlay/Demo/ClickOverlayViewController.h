//
//  ClickOverlayViewController.h
//  officialDemo2D
//
//  Created by yi chen on 14-5-7.
//  Copyright (c) 2014年 AutoNavi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>

@interface ClickOverlayViewController : UIViewController <MAMapViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;

@end
