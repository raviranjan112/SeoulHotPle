//
//  MainViewController
//  SeoulHotPle
//
//  Created by KimJingyu on 2017. 2. 17..
//  Copyright © 2017년 SeoulHotPle. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import FirebaseAuth
import FirebaseDatabase

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, NetworkCallback {
    
    @IBOutlet weak var lbStationCnt: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func btnReload(_ sender: Any) {
        print("갱신")
        loadLocationData()
        moveCamera()
    }
    
    @IBOutlet weak var mapView: UIView!
    var locationManager: CLLocationManager = CLLocationManager()
    var startLocation: CLLocation!
    var currentLocation: CLLocation?
    
    var camera = GMSCameraPosition.camera(withLatitude: 127.045234114824, longitude: 37.508011394423, zoom: 6)
    var gmsMapView : GMSMapView?
    
    var apiServiceModel : APIServiceModel?
    
    var arrayOfCellData = [Station]()
    
    var hotplechat = FIRDatabase.database().reference().child("hotplechat")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        gmsMapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        gmsMapView?.isMyLocationEnabled = true
        self.mapView = gmsMapView
        gmsMapView?.settings.compassButton = true
        
        apiServiceModel = APIServiceModel(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        arrayOfCellData.removeAll()
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
        print("현재 좌표")
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        locationManager.stopUpdatingLocation()
        manager.delegate = nil
        
        Constants.CURRENT_LOCATION_WGS84_X = locValue.latitude
        Constants.CURRENT_LOCATION_WGS84_Y = locValue.longitude
        
        locationManager.stopUpdatingLocation()
        //
        
        let camera = GMSCameraPosition.camera(withLatitude: Constants.CURRENT_LOCATION_WGS84_X!, longitude: Constants.CURRENT_LOCATION_WGS84_Y!, zoom: 6)

        //좌표 전환
        //        &y=37.6353286&x=126.9285957
        apiServiceModel?.transCoor(x: locValue.longitude, y: locValue.latitude, fromCoord: "WGS84", toCoord: "WTM")
        
    }
    
    func moveCamera() {
        DispatchQueue.main.async { () -> Void in
            
            let position = CLLocationCoordinate2DMake(Constants.CURRENT_LOCATION_WGS84_X!, Constants.CURRENT_LOCATION_WGS84_Y!)
            let marker = GMSMarker(position: position)
            
            let camera = GMSCameraPosition.camera(withLatitude: Constants.CURRENT_LOCATION_WGS84_X!, longitude: Constants.CURRENT_LOCATION_WGS84_Y!, zoom: 6)
            self.gmsMapView?.camera = camera
            
            self.gmsMapView?.animate(to: camera)
            self.mapView = self.gmsMapView

            marker.map = self.gmsMapView
            
        }
        
    }
}


