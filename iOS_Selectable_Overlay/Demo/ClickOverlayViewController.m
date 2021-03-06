//
//  ClickOverlayViewController.m
//  officialDemo2D
//
//  Created by yi chen on 14-5-7.
//  Copyright (c) 2014年 AutoNavi. All rights reserved.
//

#import "ClickOverlayViewController.h"

#import "SelectableOverlay.h"
#import "Utility.h"

@interface ClickOverlayViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableArray *overlays;

@end


@implementation ClickOverlayViewController

#pragma mark - MAMapViewDelegate

- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    /* 逆序遍历overlay判断单击点是否在overlay响应区域内. */
    [self.mapView.overlays enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id<MAOverlay> overlay, NSUInteger idx, BOOL *stop)
     {
         if ([overlay isKindOfClass:[SelectableOverlay class]])
         {
             SelectableOverlay *selectableOverlay = overlay;
             
             /* 获取overlay对应的renderer. */
             MAOverlayPathRenderer * renderer = (MAOverlayPathRenderer *)[self.mapView rendererForOverlay:selectableOverlay];
             
             /* 把屏幕坐标转换为MAMapPoint坐标. */
             MAMapPoint mapPoint = MAMapPointForCoordinate(coordinate);
             /* overlay的线宽换算到MAMapPoint坐标系的宽度. */
             double mapPointDistance = [self mapPointsPerPointInViewAtCurrentZoomLevel] * renderer.lineWidth;
             
             /* 判断是否选中了overlay. */
             if (isOverlayWithLineWidthContainsPoint(selectableOverlay.overlay, mapPointDistance, mapPoint) )
             {
                 /* 设置选中状态. */
                 selectableOverlay.selected = !selectableOverlay.isSelected;
                 
                 /* 修改view选中颜色. */
                 renderer.fillColor   = selectableOverlay.isSelected? selectableOverlay.selectedColor:selectableOverlay.regularColor;
                 renderer.strokeColor = selectableOverlay.isSelected? selectableOverlay.selectedColor:selectableOverlay.regularColor;
                 
                 /* 修改overlay覆盖的顺序. */
                 [self.mapView exchangeOverlayAtIndex:idx withOverlayAtIndex:self.mapView.overlays.count - 1];
                 
                 [renderer glRender];
                 
                 *stop = YES;
             }
         }
     }];
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[SelectableOverlay class]])
    {
        SelectableOverlay * selectableOverlay = (SelectableOverlay *)overlay;
        id<MAOverlay> actualOverlay = selectableOverlay.overlay;
        if ([actualOverlay isKindOfClass:[MACircle class]])
        {
            MACircleRenderer *circleRenderer = [[MACircleRenderer alloc] initWithCircle:actualOverlay];
            
            circleRenderer.lineWidth    = 4.f;
            circleRenderer.strokeColor  = selectableOverlay.isSelected ? selectableOverlay.selectedColor : selectableOverlay.regularColor;
            circleRenderer.fillColor    = selectableOverlay.isSelected ? selectableOverlay.selectedColor : selectableOverlay.regularColor;
            
            return circleRenderer;
        }
        else if ([actualOverlay isKindOfClass:[MAPolygon class]])
        {
            MAPolygonRenderer *polygonRenderer = [[MAPolygonRenderer alloc] initWithPolygon:actualOverlay];
            polygonRenderer.lineWidth   = 4.f;
            polygonRenderer.strokeColor = selectableOverlay.isSelected ? selectableOverlay.selectedColor : selectableOverlay.regularColor;
            polygonRenderer.fillColor   = selectableOverlay.isSelected ? selectableOverlay.selectedColor : selectableOverlay.regularColor;
            
            return polygonRenderer;
        }
        else if ([actualOverlay isKindOfClass:[MAPolyline class]])
        {
            MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:actualOverlay];
            
            polylineRenderer.lineWidth      = 4.f;
            polylineRenderer.strokeColor    = selectableOverlay.isSelected ? selectableOverlay.selectedColor : selectableOverlay.regularColor;
            
            return polylineRenderer;
        }
    }

    return nil;
}

#pragma mark - Utility

/*!
 计算当前ZoomLevel下屏幕上一点对应的MapPoints点数
 @return mapPoints点数
 */
- (double)mapPointsPerPointInViewAtCurrentZoomLevel
{
    return [self.mapView metersPerPointForCurrentZoom] * MAMapPointsPerMeterAtLatitude(self.mapView.centerCoordinate.latitude);
}

#pragma mark - Initialization

- (void)initOverlays
{
    self.overlays = [NSMutableArray array];
    
    /* Circle. */
    MACircle *circle = [MACircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(39.981892, 116.338255) radius:2000];
    SelectableOverlay * selectableCircle = [[SelectableOverlay alloc] initWithOverlay:circle];
    [self.overlays addObject:selectableCircle];

    /* Polygon. */
    CLLocationCoordinate2D coordinates[4];
    coordinates[0].latitude = 39.981892;
    coordinates[0].longitude = 116.293413;
    
    coordinates[1].latitude = 39.987600;
    coordinates[1].longitude = 116.391842;
    
    coordinates[2].latitude = 39.933187;
    coordinates[2].longitude = 116.417932;
    
    coordinates[3].latitude = 39.904653;
    coordinates[3].longitude = 116.338255;
    MAPolygon *polygon = [MAPolygon polygonWithCoordinates:coordinates count:4];
    SelectableOverlay * selectablePolygon = [[SelectableOverlay alloc] initWithOverlay:polygon];
    [self.overlays addObject:selectablePolygon];
    
    /* Polyline1. */
    CLLocationCoordinate2D polylineCoords[5];
    polylineCoords[0].latitude = 39.925539;
    polylineCoords[0].longitude = 116.549037;
    
    polylineCoords[1].latitude = 39.855539;
    polylineCoords[1].longitude = 116.549037;

    polylineCoords[2].latitude = 39.855539;
    polylineCoords[2].longitude = 116.430285;
    
    polylineCoords[3].latitude = 39.795479;
    polylineCoords[3].longitude = 116.430859;
    
    polylineCoords[4].latitude = 39.795479;
    polylineCoords[4].longitude = 116.396786;
    MAPolyline *polyline = [MAPolyline polylineWithCoordinates:polylineCoords count:5];
    SelectableOverlay * selectablePolyline = [[SelectableOverlay alloc] initWithOverlay:polyline];
    [self.overlays addObject:selectablePolyline];
    
    /* Polyline2. */
    CLLocationCoordinate2D polylineCoords2[4];
    polylineCoords2[0].latitude = 39.925539;
    polylineCoords2[0].longitude = 116.549037;
    
    polylineCoords2[1].latitude = 39.925539;
    polylineCoords2[1].longitude = 116.460859;
    
    polylineCoords2[2].latitude = 39.795479;
    polylineCoords2[2].longitude = 116.460859;
    
    polylineCoords2[3].latitude = 39.795479;
    polylineCoords2[3].longitude = 116.396786;
    MAPolyline *polyline2 = [MAPolyline polylineWithCoordinates:polylineCoords2 count:4];
    SelectableOverlay * selectablePolyline2 = [[SelectableOverlay alloc] initWithOverlay:polyline2];
    selectablePolyline2.selected = YES;
    [self.overlays addObject:selectablePolyline2];
    
}

- (void)initMapView
{
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    
    self.mapView.delegate = self;
    
    [self.view addSubview:self.mapView];
    
    self.mapView.visibleMapRect = MAMapRectMake(220880104, 101476980, 272496, 466656);
}

#pragma mark - Life Cycle

- (id)init
{
    self = [super init];
    if (self)
    {
        [self initOverlays];
        
        [self setTitle:@"Selectable Overlay"];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initMapView];

    [self.mapView addOverlays:self.overlays];
    
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(39.953076, 116.356767);  //设置一下地图的中心点在多边形overlay的中心，方便UITest
    
}

@end
