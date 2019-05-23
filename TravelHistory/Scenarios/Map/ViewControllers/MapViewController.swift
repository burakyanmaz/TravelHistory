//
//  FirstViewController.swift
//  TravelHistory
//
//  Created by Burak Yanmaz on 6.05.2019.
//  Copyright © 2019 Simpler. All rights reserved.
//

import UIKit
import MapKit
import Cluster
import GradientLoadingBar

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    private lazy var locationManager = LocationManager()
    private lazy var connectionRequester = Requester()
    private var venueSearchRepository: VenueSearchConnectionRepository?
    
    private lazy var gradientLoadingBar = GradientLoadingBar()
    private lazy var clusterManager: ClusterManager = { [unowned self] in
        let manager = ClusterManager()
        manager.delegate = self
        manager.maxZoomLevel = 17
        manager.minCountForClustering = 3
        manager.clusterPosition = .nearCenter
        return manager
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // MARK: - Get current location
        locationManager.getCurrentLocation { [weak self] (location) in
            if let theLocation = location {
                let region = (center: CLLocationCoordinate2D(latitude: CLLocationDegrees(theLocation.latitude), longitude: CLLocationDegrees(theLocation.longitude)), delta: 0.1)
                DispatchQueue.main.async {
                    self?.mapView.showsUserLocation = true
                    self?.mapView.region = .init(center: region.center, span: .init(latitudeDelta: region.delta, longitudeDelta: region.delta))
                }
            }
        }
        
        venueSearchRepository = VenueSearchConnectionRepository(aRequester: connectionRequester)
    }
    
    func setAnnotations(locations: [Location]) {
        locations.forEach { (aLocation) in
            let annotation = Annotation(coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(aLocation.latitude), longitude: CLLocationDegrees(aLocation.longitude)))
            DispatchQueue.main.async { [weak self] in
                self?.clusterManager.add(annotation)
            }
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.clusterManager.reload(mapView: strongSelf.mapView)
        }
    }
    
    func removeAnnotations() {
        clusterManager.removeAll()
        clusterManager.reload(mapView: mapView)
    }
}

extension MapViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // If the search text is not empty
        if let theText = searchBar.text,
            theText != "" {
            
            gradientLoadingBar.show()
            
            // MARK: - Get current location
            locationManager.getCurrentLocation { [weak self] (location) in
                if let theLocation = location {
                    // MARK: - Make a venue search
                    self?.venueSearchRepository?.searchVenues(for: theLocation, searchString: theText, completion: { (venueDTO) in
                        DispatchQueue.main.async {
                            self?.gradientLoadingBar.hide()
                        }
                        
                        if let theVenueDTO = venueDTO,
                            let theItems = theVenueDTO.results?.items {
                            var locations = [Location]()
                            for anItem in theItems {
                                if let aVenuePosisiton = anItem.position,
                                    aVenuePosisiton.count > 1 {
                                    let aLocation = Location(latitude: Float(aVenuePosisiton[0]), longitude: Float(aVenuePosisiton[1]), accuracy: 0)
                                    locations.append(aLocation)
                                }
                            }
                            
                            self?.setAnnotations(locations: locations)
                        } else {
                            // No venues, or error happened.
                            print("Error on getting the venues.")
                        }
                    })
                } else {
                    DispatchQueue.main.async {
                        self?.gradientLoadingBar.hide()
                    }
                }
            }
        } else { // If it is empty
            searchBar.shake(duration: 0.5)
        }
        
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        removeAnnotations()
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? ClusterAnnotation {
            let identifier = "Cluster"
            return mapView.annotationView(annotation: annotation, reuseIdentifier: identifier)
        } else if let annotation = annotation as? MeAnnotation {
            let identifier = "Me"
            let annotationView = mapView.annotationView(of: MKAnnotationView.self, annotation: annotation, reuseIdentifier: identifier)
            annotationView.image = .me
            return annotationView
        } else {
            let identifier = "Pin"
            let annotationView = mapView.annotationView(of: MKPinAnnotationView.self, annotation: annotation, reuseIdentifier: identifier)
            annotationView.pinTintColor = .green
            return annotationView
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        clusterManager.reload(mapView: mapView) { finished in
            print(finished)
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else { return }
        
        if let cluster = annotation as? ClusterAnnotation {
            var zoomRect = MKMapRect.null
            for annotation in cluster.annotations {
                let annotationPoint = MKMapPoint(annotation.coordinate)
                let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0, height: 0)
                if zoomRect.isNull {
                    zoomRect = pointRect
                } else {
                    zoomRect = zoomRect.union(pointRect)
                }
            }
            mapView.setVisibleMapRect(zoomRect, animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        views.forEach { $0.alpha = 0 }
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
            views.forEach { $0.alpha = 1 }
        }, completion: nil)
    }
}

extension MapViewController: ClusterManagerDelegate {
    
    private func cellSize(for zoomLevel: Double) -> Double? {
        return nil // default
    }
    
    func shouldClusterAnnotation(_ annotation: MKAnnotation) -> Bool {
        return !(annotation is MeAnnotation)
    }
    
}

extension MKMapView {
    func annotationView(annotation: MKAnnotation?, reuseIdentifier: String) -> MKAnnotationView {
        let annotationView = self.annotationView(of: ImageCountClusterAnnotationView.self, annotation: annotation, reuseIdentifier: reuseIdentifier)
        annotationView.countLabel.textColor = .green
        annotationView.image = .pin2
        return annotationView
    }
}

class MeAnnotation: Annotation {}
