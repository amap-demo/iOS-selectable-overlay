//
//  ViewController.swift
//  iOS_Selectable_Overlay-swift
//
//  Created by hanxiaoming on 16/12/13.
//  Copyright © 2016年 AutoNavi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, MAMapViewDelegate {
    
    var mapView: MAMapView!
    var overlays: Array<MAOverlay>!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initMapView()
        initOverlays()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        mapView.addOverlays(overlays)
        mapView.visibleMapRect = MAMapRectMake(220880104, 101476980, 272496, 466656)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func initMapView() {
        mapView = MAMapView(frame: self.view.bounds)
        mapView.delegate = self
        self.view.addSubview(mapView)
    }
    
    func initOverlays() {
        overlays = Array()
        
        // circle
        let circle: MACircle = MACircle(center: CLLocationCoordinate2D(latitude: 39.981892, longitude: 116.338255), radius: 2000)
        let selectableCircle: SelectableOverlay = SelectableOverlay(overlay: circle);
        overlays.append(selectableCircle)
        
        // polyline1
        var lineCoordinates: [CLLocationCoordinate2D] = [
            CLLocationCoordinate2D(latitude: 39.925539, longitude: 116.549037),
            CLLocationCoordinate2D(latitude: 39.855539, longitude: 116.549037),
            CLLocationCoordinate2D(latitude: 39.855539, longitude: 116.430285),
            CLLocationCoordinate2D(latitude: 39.795479, longitude: 116.430859),
            CLLocationCoordinate2D(latitude: 39.795479, longitude: 116.396786)]
        
        let polyline: MAPolyline = MAPolyline(coordinates: &lineCoordinates, count: UInt(lineCoordinates.count))
        
        let selectablePolyline: SelectableOverlay = SelectableOverlay(overlay: polyline);
        overlays.append(selectablePolyline)
        
        // polyline2
        var lineCoordinates2: [CLLocationCoordinate2D] = [
            CLLocationCoordinate2D(latitude: 39.925539, longitude: 116.549037),
            CLLocationCoordinate2D(latitude: 39.925539, longitude: 116.460859),
            CLLocationCoordinate2D(latitude: 39.795479, longitude: 116.180859),
            CLLocationCoordinate2D(latitude: 39.788467, longitude: 116.460859),
            CLLocationCoordinate2D(latitude: 39.795479, longitude: 116.396786)]
        
        let polyline2: MAPolyline = MAPolyline(coordinates: &lineCoordinates2, count: UInt(lineCoordinates2.count))
        let selectablePolyline2: SelectableOverlay = SelectableOverlay(overlay: polyline2);
        overlays.append(selectablePolyline2)
        
        // polygon
        var polygonCoordinates: [CLLocationCoordinate2D] = [
            CLLocationCoordinate2D(latitude: 39.981892, longitude: 116.293413),
            CLLocationCoordinate2D(latitude: 39.987600, longitude: 116.391842),
            CLLocationCoordinate2D(latitude: 39.933187, longitude: 116.417932),
            CLLocationCoordinate2D(latitude: 39.904653, longitude: 116.338255)]
        
        let polygon: MAPolygon = MAPolygon(coordinates: &polygonCoordinates, count: UInt(polygonCoordinates.count))
        let selectablePolygon: SelectableOverlay = SelectableOverlay(overlay: polygon);
        overlays.append(selectablePolygon)
        
    }
    
    //MARK: - MAMapViewDelegate
    
    func mapView(_ mapView: MAMapView!, didSingleTappedAt coordinate: CLLocationCoordinate2D) {
        
        for (index, overlay) in mapView.overlays.enumerated().reversed() {
            if (overlay as AnyObject).isKind(of: SelectableOverlay.self) {
                let selectableOverlay: SelectableOverlay = overlay as! SelectableOverlay;
                
                let renderer: MAOverlayPathRenderer = self.mapView.renderer(for: selectableOverlay) as! MAOverlayPathRenderer
                let mapPoint = MAMapPointForCoordinate(coordinate)
                let distance = self.mapPointsPerPointInViewAtCurrentZoomLevel()
                
                // 判断是否选中了overlay
                if isOverlayWithLineWidthContainsPoint(selectableOverlay.overlay, distance, mapPoint) {
                    // selected
                    selectableOverlay.isSelected = !selectableOverlay.isSelected
                    
                    // change color
                    renderer.strokeColor = selectableOverlay.isSelected ? selectableOverlay.selectedColor : selectableOverlay.regularColor
                    renderer.fillColor = selectableOverlay.isSelected ? selectableOverlay.selectedColor : selectableOverlay.regularColor
                    
                    // 修改顺序
                    self.mapView.exchangeOverlay(at: UInt(index), withOverlayAt: UInt(self.mapView.overlays.count - 1))
                    
                }
                
                
            }
        }
    }
    
    func mapView(_ mapView: MAMapView!, rendererFor overlay: MAOverlay!) -> MAOverlayRenderer! {
        
        if overlay.isKind(of: SelectableOverlay.self) {
            let selectableOverlay: SelectableOverlay = overlay as! SelectableOverlay;
            let actualOverlay: MAOverlay! = selectableOverlay.overlay;
         
            if actualOverlay.isKind(of: MACircle.self) {
                let renderer: MACircleRenderer = MACircleRenderer(overlay: actualOverlay)
                renderer.lineWidth = 8.0
                renderer.fillColor = selectableOverlay.isSelected ? selectableOverlay.selectedColor : selectableOverlay.regularColor
                
                return renderer
            }
            if actualOverlay.isKind(of: MAPolyline.self) {
                let renderer: MAPolylineRenderer = MAPolylineRenderer(overlay: actualOverlay)
                renderer.lineWidth = 8.0
                renderer.strokeColor = selectableOverlay.isSelected ? selectableOverlay.selectedColor : selectableOverlay.regularColor
                
                return renderer
            }
            if actualOverlay.isKind(of: MAPolygon.self) {
                let renderer: MAPolygonRenderer = MAPolygonRenderer(overlay: actualOverlay)
                renderer.lineWidth = 8.0
                renderer.fillColor = selectableOverlay.isSelected ? selectableOverlay.selectedColor : selectableOverlay.regularColor
                
                return renderer
            }
            
        }
        
        return nil
    }
    
    //MARK: - Utility
    
    func mapPointsPerPointInViewAtCurrentZoomLevel() -> Double {
        return self.mapView.metersPerPointForCurrentZoom * MAMapPointsPerMeterAtLatitude(self.mapView.centerCoordinate.latitude)
    }
}

