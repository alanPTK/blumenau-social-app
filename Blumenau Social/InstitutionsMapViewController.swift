//
//  InstitutionsMapViewController.swift
//  Blumenau Social
//
//  Created by Alan Filipe Cardozo Fabeni on 24/08/19.
//  Copyright © 2019 Alan Filipe Cardozo Fabeni. All rights reserved.
//

import UIKit
import MapKit

class InstitutionsMapViewController: UIViewController {
    
    @IBOutlet weak var institutionsMapView: MKMapView!
    @IBOutlet weak var headerView: UIView!
    var selectedInstitutions: [Institution]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -26.9187, longitude: -49.066), span: span)
        
        institutionsMapView.setRegion(region, animated: true)
    }        
    
    func setupView() {
        headerView.layer.cornerRadius = 8
        institutionsMapView.layer.cornerRadius = 8
    }

    override func viewDidAppear(_ animated: Bool) {
        for institution in selectedInstitutions! {
            let annotation = MKPointAnnotation()
            let centerCoordinate = CLLocationCoordinate2D(latitude: institution.latitude, longitude: institution.longitude)
            annotation.coordinate = centerCoordinate
            annotation.title = institution.title            
            institutionsMapView.addAnnotation(annotation)
        }
    }
        
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
