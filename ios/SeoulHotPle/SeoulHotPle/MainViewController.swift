//
//  MainViewController
//  SeoulHotPle
//
//  Created by KimJingyu on 2017. 2. 17..
//  Copyright © 2017년 SeoulHotPle. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import FirebaseAuth
import FirebaseDatabase

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, UISearchBarDelegate , LocateOnTheMap, GMSAutocompleteFetcherDelegate, NetworkCallback {
    
    @IBOutlet weak var loadingBar: UIActivityIndicatorView!
    @IBOutlet weak var lbStationCnt: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: GMSMapView!

    @IBAction func btnReload(_ sender: Any) {
        print("갱신")
        lbStationCnt.text = "near by 0 stations"
        arrayOfCellData.removeAll()
        loadLocationData()
    }
    
    @IBAction func searchWithAddress(_ sender: AnyObject) {
        let searchController = UISearchController(searchResultsController: searchResultController)
        searchController.searchBar.delegate = self
        self.present(searchController, animated:true, completion: nil)
    }
    
    var resultsArray = [String]()
    
    var gmsFetcher: GMSAutocompleteFetcher!
    
    var searchResultController: SearchResultsController!
    
    var locationManager: CLLocationManager = CLLocationManager()
    
    var startLocation: CLLocation!
    
    var currentLocation: CLLocation?
    
    var camera = GMSCameraPosition.camera(withLatitude: 127.045234114824, longitude: 37.508011394423, zoom: 6)
    
    var gmsMapView : GMSMapView?
    
    var apiServiceModel : APIServiceModel?
    
    var arrayOfCellData = [Station]()
    
    var hotplechat = FIRDatabase.database().reference().child("hotplechat")
    
    /**
     Locate map with longitude and longitude after search location on UISearchBar
     
     - parameter lon:   longitude location
     - parameter lat:   latitude location
     - parameter title: title of address location
     */
    func locateWithLongitude(_ lon: Double, andLatitude lat: Double, andTitle title: String) {
        
        DispatchQueue.main.async { () -> Void in
            
            let position = CLLocationCoordinate2DMake(lat, lon)
            let marker = GMSMarker(position: position)
            
            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: 10)
            self.mapView.camera = camera
            
            marker.title = "Address : \(title)"
            marker.map = self.mapView
            
        }
        
    }
    
    /**
     Searchbar when text change
     
     - parameter searchBar:  searchbar UI
     - parameter searchText: searchtext description
     */
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        //        let placeClient = GMSPlacesClient()
        //
        //
        //        placeClient.autocompleteQuery(searchText, bounds: nil, filter: nil)  {(results, error: Error?) -> Void in
        //           // NSError myerr = Error;
        //            print("Error @%",Error.self)
        //
        //            self.resultsArray.removeAll()
        //            if results == nil {
        //                return
        //            }
        //
        //            for result in results! {
        //                if let result = result as? GMSAutocompletePrediction {
        //                    self.resultsArray.append(result.attributedFullText.string)
        //                }
        //            }
        //
        //            self.searchResultController.reloadDataWithArray(self.resultsArray)
        //
        //        }
        
        
        self.resultsArray.removeAll()
        gmsFetcher?.sourceTextHasChanged(searchText)
        
        
    }
    
    public func didFailAutocompleteWithError(_ error: Error) {
        //        resultText?.text = error.localizedDescription
    }
    
    /**
     * Called when autocomplete predictions are available.
     * @param predictions an array of GMSAutocompletePrediction objects.
     */
    public func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        //self.resultsArray.count + 1
        
        for prediction in predictions {
            
            if let prediction = prediction as GMSAutocompletePrediction!{
                self.resultsArray.append(prediction.attributedFullText.string)
            }
        }
        self.searchResultController.reloadDataWithArray(self.resultsArray)
        //   self.searchResultsTable.reloadDataWithArray(self.resultsArray)
        print(resultsArray)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    
        mapView?.isMyLocationEnabled = true
        mapView?.settings.compassButton = true
        
        
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: 37.5079943965216, longitude: 127.045255477494, zoom: 14.0)
        self.mapView.camera = camera
        
        
        apiServiceModel = APIServiceModel(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        arrayOfCellData.removeAll()
        lbStationCnt.text = "near by 0 stations"
        loadLocationData()
    }
    
    
    func networkResult(resultData: Any, code: Int) {
        if code == Constants.CODE_DAUM_COORDI {
            print("다음 api callback")
            let location = resultData as? [Double]
            Constants.CURRENT_LOCATION_WTM_X = location?.first
            Constants.CURRENT_LOCATION_WTM_Y = location?.last
            
            print(Constants.CURRENT_LOCATION_WTM_X!)
            
            //주변 역 검색
            apiServiceModel?.getStation(x: Constants.CURRENT_LOCATION_WTM_X!, y: Constants.CURRENT_LOCATION_WTM_Y!)
            
        }
        else if code == Constants.CODE_SEOUL_STATION {
            print("역정보 networkResult")
            arrayOfCellData = resultData as! [Station]
            lbStationCnt.text = "near by \(arrayOfCellData.count) stations"
            setPopulation()
            print("역정보 networkResult end")
        }
        else if code == Constants.CODE_RETURN_NIL {
            simpleAlert(title: "검색결과가 없습니다.", msg: "")
        }
    }
    
    override func networkFail() {
        loadingBar.stopAnimating()
    }
    
    func setPopulation() {
        hotplechat.observe(.value, with: { snapshot in
            if let dict = snapshot.value as? [String: AnyObject] {
                for (i, item) in self.arrayOfCellData.enumerated() {
                    let station = dict[item.statnNm!]
                    if let many = station?["many"] {
                        print(many)
                        self.arrayOfCellData[i].chatCnt = many as! Int?
                    }
                }
                self.tableView.reloadData()
            }
        })
        self.tableView.reloadData()
        loadingBar.stopAnimating()

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrayOfCellData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("MainTableViewCell", owner: self, options: nil)?.first as! MainTableViewCell
        
        cell.selectionStyle = .none
        
        cell.lbStationName.text = "\(arrayOfCellData[indexPath.row].subwayNm!): \(arrayOfCellData[indexPath.row].statnNm!)"
        
        if let chatCnt = arrayOfCellData[indexPath.row].chatCnt {
            print(chatCnt)

            cell.ChatPopular.text = "( \(chatCnt)명 )"
        }
        
        cell.btnGoChat.tag = indexPath.row
        cell.btnGoChat.addTarget(self, action: #selector(showAlertPicker(_:)), for: .touchUpInside)

        return cell
    }
    
    func showAlertPicker(_ sender: AnyObject) {
        let alertActionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel){ (alert:UIAlertAction) in
        }
        
        let chatbot = UIAlertAction(title: "챗봇", style: UIAlertActionStyle.default) { (alert: UIAlertAction) in
            if let station = self.arrayOfCellData[sender.tag!].statnNm{
                FIRAuth.auth()?.signInAnonymously() { (anonymousUser: FIRUser?, error) in
                    if error == nil {
                        print("FIRAUTH")
                        let newUser = FIRDatabase.database().reference().child("users").child(anonymousUser!.uid)
                        newUser.setValue(["displayname" : station, "id" : "\(anonymousUser!.uid)", "profileUrl" : ""])
                        Constants.CURRENT_STATION = station
                        let svc = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
                        self.navigationController?.show(svc, sender: nil)
                    } else {
                        print(error!)
                    }
                }
            }
        }
        
        let anonymousChat = UIAlertAction(title: "익명채팅", style: UIAlertActionStyle.default) { (alert: UIAlertAction) in
            if let station = self.arrayOfCellData[sender.tag!].statnNm{
                let svc = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
                svc.chatUrl = "\(Constants.CHAT_URL)/\(station)"
                self.navigationController?.show(svc, sender: nil)
            }
        }
        
        alertActionSheet.addAction(cancel)
        alertActionSheet.addAction(chatbot)
        alertActionSheet.addAction(anonymousChat)
        
        present(alertActionSheet, animated: true)
    }
    
    func loadLocationData(){
        locationManager.delegate = self
        startLocation = nil
        locationManager.startUpdatingLocation()
        tableView.reloadData()
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        self.loadingBar.startAnimating()

        print("현재 좌표")
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        locationManager.stopUpdatingLocation()
        manager.delegate = nil
        
        Constants.CURRENT_LOCATION_WGS84_X = locValue.latitude
        Constants.CURRENT_LOCATION_WGS84_Y = locValue.longitude
        
        locationManager.stopUpdatingLocation()
        //
        
//        let camera = GMSCameraPosition.camera(withLatitude: Constants.CURRENT_LOCATION_WGS84_X!, longitude: Constants.CURRENT_LOCATION_WGS84_Y!, zoom: 6)

        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: locValue.latitude, longitude: locValue.longitude, zoom: 14.0)
        self.mapView.camera = camera
        //좌표 전환
        //        &y=37.6353286&x=126.9285957
        apiServiceModel?.transCoor(x: locValue.longitude, y: locValue.latitude, fromCoord: "WGS84", toCoord: "WTM")
        
    }
    
}


