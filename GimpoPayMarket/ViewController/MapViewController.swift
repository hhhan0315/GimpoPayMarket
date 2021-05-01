//
//  MapViewController.swift
//  GimpoPayMarket
//
//  Created by rae on 2021/04/18.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationTitle(title: "지역화폐\n가맹점 찾기")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let data = UserSettings.shared.data else {
            return
        }
        
        for row in data {
            let lat = (row.refineWgs84Lat! as NSString).doubleValue
            let lng = (row.refineWgs84Logt! as NSString).doubleValue
            
            let location = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            
            let regionRadius: CLLocationDistance = 2000
            
            let coordinateRegion = MKCoordinateRegion(center: location, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
            
            self.map.setRegion(coordinateRegion, animated: true)
            
            let point = MKPointAnnotation()
            
            point.coordinate = location
            point.title = row.cmpnmNM
            
            self.map.addAnnotation(point)
        }
    }
    
}
