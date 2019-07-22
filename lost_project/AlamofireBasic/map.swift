//
//  map.swift
//  AlamofireBasic
//
//  Created by swuad_12 on 11/07/2019.
//  Copyright © 2019 swuad_12. All rights reserved.
//

import UIKit
//import CoreLocation
//import MapKit
import GoogleMaps
import GooglePlaces

class map: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate{
    
    @IBOutlet weak var viewBoard: UIBarButtonItem!
    
    @IBOutlet weak var fullviewBoard: UIBarButtonItem!
    
    var locationManager = CLLocationManager()
    
    let BRmarker = GMSMarker()
    let SecSiecmarker = GMSMarker()
    let FirSiecmarker = GMSMarker()
    let SRmarker = GMSMarker()
    let IDmarker = GMSMarker()
    let ADmarker = GMSMarker()
    let Gymmarker = GMSMarker()
    let NRBRmarker = GMSMarker()
    let Ftymarker = GMSMarker()
    let CLmarker = GMSMarker()
    let HSAmarker = GMSMarker()
    let ADTmarker = GMSMarker()
    let ARTmarker = GMSMarker()
    let STRmarker = GMSMarker()
    let GSmarker = GMSMarker()
    let LLmarker = GMSMarker()
    let JGSmarker = GMSMarker()
    
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    var selected_category:Int? = 0
    
    override func viewDidLoad(){
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setMarkerImage() {
        BRmarker.icon = UIImage(named: "marker")
        SecSiecmarker.icon = UIImage(named: "marker")
        FirSiecmarker.icon = UIImage(named: "marker")
        SRmarker.icon = UIImage(named: "marker")
        IDmarker.icon = UIImage(named: "marker")
        ADmarker.icon = UIImage(named: "marker")
        Gymmarker.icon = UIImage(named: "marker")
        NRBRmarker.icon = UIImage(named: "marker")
        Ftymarker.icon = UIImage(named: "marker")
        CLmarker.icon = UIImage(named: "marker")
        HSAmarker.icon = UIImage(named: "marker")
        ADTmarker.icon = UIImage(named: "marker")
        ARTmarker.icon = UIImage(named: "marker")
        STRmarker.icon = UIImage(named: "marker")
        GSmarker.icon = UIImage(named: "marker")
        LLmarker.icon = UIImage(named: "marker")
        JGSmarker.icon = UIImage(named: "marker")
    }
    
    override func loadView() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
//        locationManager.delegate = self
        
        
       // placesClient = GMSPlacesClient.shared()

        
//        let coor = locationManager
        
        self.viewBoard.isEnabled = false
        
        let camera = GMSCameraPosition.camera(withLatitude: 37.62767, longitude: 127.08978, zoom: 17.5)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        mapView.delegate = self
        self.locationManager.delegate = self
        self.view = mapView
//        mapView.isMyLocationEnabled = true
//        view = mapView
        
        BRmarker.position = CLLocationCoordinate2D(latitude: 37.627456, longitude: 127.088364)
        BRmarker.title = "바롬교육관"
        BRmarker.userData = 6
        BRmarker.icon = UIImage(named: "marker")
        BRmarker.map = mapView
        mapView.isMyLocationEnabled = true

        SecSiecmarker.position = CLLocationCoordinate2D(latitude: 37.629263, longitude: 127.090464)
        SecSiecmarker.title = "제2과학관"
        SecSiecmarker.userData = 2
        SecSiecmarker.icon = UIImage(named: "marker")
        SecSiecmarker.map = mapView

        FirSiecmarker.position = CLLocationCoordinate2D(latitude: 37.628974, longitude: 127.089635)
        FirSiecmarker.title = "제1과학관"
        FirSiecmarker.userData = 1
        FirSiecmarker.icon = UIImage(named: "marker")
        FirSiecmarker.map = mapView

        SRmarker.position = CLLocationCoordinate2D(latitude: 37.628892, longitude: 127.088932)
        SRmarker.title = "샬롬하우스"
        SRmarker.userData = 8
        SRmarker.icon = UIImage(named: "marker")
        SRmarker.map = mapView

        IDmarker.position = CLLocationCoordinate2D(latitude: 37.628023, longitude: 127.088589)
        IDmarker.title = "국제생활관"
        IDmarker.userData = 9
        IDmarker.icon = UIImage(named: "marker")
        IDmarker.map = mapView

        ADmarker.position = CLLocationCoordinate2D(latitude: 37.626784, longitude: 127.089535)
        ADmarker.title = "행정관"
        ADmarker.userData = 18
        ADmarker.icon = UIImage(named: "marker")
        ADmarker.map = mapView

        Gymmarker.position = CLLocationCoordinate2D(latitude: 37.625576, longitude: 127.088924)
        Gymmarker.title = "체육관"
        Gymmarker.userData = 11
        Gymmarker.icon = UIImage(named: "marker")
        Gymmarker.map = mapView
        
        NRBRmarker.position = CLLocationCoordinate2D(latitude: 37.628676, longitude: 127.090437)
        NRBRmarker.title = "누리관"
        NRBRmarker.userData = 3
        NRBRmarker.icon = UIImage(named: "marker")
        NRBRmarker.map = mapView
        
        Ftymarker.position = CLLocationCoordinate2D(latitude: 37.626276, longitude: 127.093087)
        Ftymarker.title = "50주년기념관"
        Ftymarker.userData = 4
        Ftymarker.icon = UIImage(named: "marker")
        Ftymarker.map = mapView
        
        CLmarker.position = CLLocationCoordinate2D(latitude: 37.628341, longitude: 127.091215)
        CLmarker.title = "중앙도서관"
        CLmarker.userData = 5
        CLmarker.icon = UIImage(named: "marker")
        CLmarker.map = mapView
        
        HSAmarker.position = CLLocationCoordinate2D(latitude: 37.628120, longitude: 127.092535)
        HSAmarker.title = "인문사회관"
        HSAmarker.userData = 7
        HSAmarker.icon = UIImage(named: "marker")
        HSAmarker.map = mapView
        
        ADTmarker.position = CLLocationCoordinate2D(latitude: 37.627521, longitude: 127.090384)
        ADTmarker.title = "대강당"
        ADTmarker.userData = 10
        ADTmarker.icon = UIImage(named: "marker")
        ADTmarker.map = mapView
        
        ARTmarker.position = CLLocationCoordinate2D(latitude: 37.629037, longitude: 127.091702)
        ARTmarker.title = "조형예술관"
        ARTmarker.userData = 12
        ARTmarker.icon = UIImage(named: "marker")
        ARTmarker.map = mapView
        
        STRmarker.position = CLLocationCoordinate2D(latitude: 37.626556, longitude: 127.089993)
        STRmarker.title = "별관"
        STRmarker.userData = 13
        STRmarker.icon = UIImage(named: "marker")
        STRmarker.map = mapView
        
        GSmarker.position = CLLocationCoordinate2D(latitude: 37.629007, longitude: 127.090846)
        GSmarker.title = "대학원"
        GSmarker.userData = 15
        GSmarker.icon = UIImage(named: "marker")
        GSmarker.map = mapView
        
        LLmarker.position = CLLocationCoordinate2D(latitude: 37.627214, longitude: 127.090310)
        LLmarker.title = "평생교육관"
        LLmarker.userData = 16
        LLmarker.icon = UIImage(named: "marker")
        LLmarker.map = mapView
        
        JGSmarker.position = CLLocationCoordinate2D(latitude: 37.626789, longitude: 127.090272)
        JGSmarker.title = "전문대학원관"
        JGSmarker.userData = 17
        JGSmarker.icon = UIImage(named: "marker")
        JGSmarker.map = mapView
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        mapView.delegate = self
        print("You tapped at")
        viewBoard.isEnabled = true
        
        setMarkerImage()
        
        marker.icon = UIImage(named: "marker_red")
        
        self.selected_category = marker.userData! as! Int
        return false
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return viewBoard.isEnabled
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         let destination = segue.destination as! ProductListVC
         destination.product_place = self.selected_category!
        
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        viewBoard.isEnabled = false
        setMarkerImage()
        
        self.selected_category = 0
    }

    @IBAction func showFullView(_ sender: Any) {
        self.selected_category = 0
        
        let storyBoard = self.storyboard!
        let ProductLVController = storyBoard.instantiateViewController(withIdentifier: "listView") as! ProductListVC
        // writeViewController.delegate = self
        //present(writeViewController, animated: true)
        self.navigationController?.pushViewController(ProductLVController, animated: true)
    }
}

