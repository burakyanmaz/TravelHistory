//
//  MapKitExtensions.swift
//  TravelHistory
//
//  Created by Burak Yanmaz on 24.05.2019.
//  Copyright © 2019 Simpler. All rights reserved.
//

import UIKit
import MapKit

extension MKMapView {
    func annotationView<T: MKAnnotationView>(of type: T.Type, annotation: MKAnnotation?, reuseIdentifier: String) -> T {
        guard let annotationView = dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? T else {
            return type.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        }
        annotationView.annotation = annotation
        return annotationView
    }
}
