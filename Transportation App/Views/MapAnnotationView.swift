import MapKit

final class MapAnnotationView {
    static func createAnnotationView(for annotation: MKAnnotation, on mapView: MKMapView) -> MKAnnotationView? {
        switch annotation {
        case is StopAnnotation:
            return createStopAnnotationView(for: annotation, on: mapView)
        case is VehicleAnnotation:
            return createVehicleAnnotationView(for: annotation, on: mapView)
        default:
            return nil
        }
    }
    
    private static func createStopAnnotationView(for annotation: MKAnnotation, on mapView: MKMapView) -> MKAnnotationView {
        let identifier = "StopAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.image = UIImage(named: "stops")
        annotationView?.canShowCallout = true
        annotationView?.frame.size = CGSize(width: 30, height: 30)
        
        return annotationView!
    }
    
    private static func createVehicleAnnotationView(for annotation: MKAnnotation, on mapView: MKMapView) -> MKAnnotationView {
        let identifier = "VehicleAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.image = UIImage(named: "liveservice")
        annotationView?.canShowCallout = true
        annotationView?.frame.size = CGSize(width: 30, height: 30)
        
        return annotationView!
    }
} 
