//
//  AddTripVC.swift
//  Trippy_MVCExample
//
//  Created by Chintan Maisuriya on 01/08/20.
//  Copyright © 2020 Chintan. All rights reserved.
//

import UIKit
import MapKit
import SDWebImage


class AddTripVC: UIViewController, MKMapViewDelegate
{
    
    //MARK: - Variables & Constants
    
    private var imagePicker     : ImagePicker?  = nil
    private var dobDatePicker   : UIDatePicker? = { return Utils.getDatepicker(pickerMode: .date) }()


    private var isComeToEditTrip    : Bool  = false
    private var tripInfoToEdit      : Trip?
    private var tripRequest         : TripRequest = TripRequest()
    
    let tripValidation = AddEditTripValidations()
    
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var lblNavigationTitleOutlet     : UILabelX!
    @IBOutlet weak var scrollFormOutlet             : UIScrollView!
    @IBOutlet weak var txtTitleOutlet               : UITextFieldX!
    @IBOutlet weak var txtDateOutlet                : UITextFieldX!
    @IBOutlet weak var lblLocationIndicatorOutlet   : UILabelX!
    @IBOutlet weak var mapOutlet                    : MKMapView!
    @IBOutlet weak var cvPhotosOutlet               : UICollectionView!
    @IBOutlet weak var cvPhotosHeightConstant       : NSLayoutConstraint!
    @IBOutlet weak var btnSaveOutlet                : UIButton!
    @IBOutlet weak var btnDeleteOutlet              : UIButton!
    
    
    //MARK: -
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.initialConfiguration()
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        self.cvPhotosHeightConstant.constant = self.cvPhotosOutlet.contentSize.height //self.view.width * 0.275
    }
    
    
    //MARK: - IBActions
    
    @IBAction func btnCloseAction(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btnSaveAction(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        let validationResponse = self.tripValidation.validateRequest(request: self.tripRequest)
        guard validationResponse.isValid else {
            Utils.showToast(title: "Oops!", subtitle: validationResponse.error?.localizedDescription ?? validationResponse.message ?? "Something went wrong", icon: UIImage(systemName: "exclamationmark.triangle.fill"), buttonIcon: nil)
            return
        }
        
        if (self.isComeToEditTrip)
        {
            self.editTrip()
        }
        else
        {
            self.addTrip()
        }
    }
    
    
    @IBAction func btnDeleteAction(_ sender: UIButton)
    {
        self.displayDeleteRequestAlert()
    }
    
    
    /*
     // MARK: - Navigation
     */
}


//MARK: - Firebase Methods

extension AddTripVC
{
    private func addTrip()
    {
        FBDatabaseManager.shared.addTrip(tripData: self.tripRequest) { [weak self] error in
            guard error == nil else {
                Utils.showToast(title: "Oops!", subtitle: error ?? "Unable to add trip", icon: UIImage(systemName: "exclamationmark.triangle.fill"), buttonIcon: nil)
                return
            }
            
            Utils.showToast(title: "Wow!", subtitle: "Trip added", icon: nil, buttonIcon: nil)
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    
    private func editTrip()
    {
        guard let tripInfo = self.tripInfoToEdit else {
            Utils.showToast(title: "Oops!", subtitle: "Something went wrong", icon: UIImage(systemName: "exclamationmark.triangle.fill"), buttonIcon: nil)
            return
        }
        
        FBDatabaseManager.shared.editTrip(tripID: tripInfo.id, tripData: self.tripRequest) { [weak self] error in
            guard error == nil else {
                Utils.showToast(title: "Oops!", subtitle: error ?? "Unable to edit trip", icon: UIImage(systemName: "exclamationmark.triangle.fill"), buttonIcon: nil)
                return
            }
            
            Utils.showToast(title: "", subtitle: "Trip updated", icon: nil, buttonIcon: nil)
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    
    private func deleteTrip()
    {
        guard let tripInfo = self.tripInfoToEdit else {
            Utils.showToast(title: "Oops!", subtitle: "Something went wrong", icon: nil, buttonIcon: nil)
            return
        }
        
        
        FBDatabaseManager.shared.deleteTrip(tripID: tripInfo.id, arrPhotos: self.tripRequest.images) { [weak self] error in
            guard error == nil else {
                Utils.showToast(title: "Oops!", subtitle: error ?? "Unable to delete trip", icon: UIImage(systemName: "exclamationmark.triangle.fill"), buttonIcon: nil)
                return
            }
            
            Utils.showToast(title: "", subtitle: "Trip deleted", icon: nil, buttonIcon: nil)
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    
    private func uploadImageToFBStorage(imageData: Data?, completion: @escaping (_ url: String?) -> Void)
    {
        guard let data = imageData else { return completion(nil)}
        
        FBStorageManager.shared.uploadImage(type: .tripImage, imageData: data, isShowLoader: true) { imageURL in
            
            guard let imageURL = imageURL else {
                print("There was a problem while uploading trip image, Please try again later!!!")
                completion(nil)
                return
            }
            
            completion(imageURL)
        }
    }
    
    
    private func deleteImageFromFBStorage(index: Int)
    {
        guard !(self.tripRequest.images.isEmpty) else { return }
        
        FBStorageManager.shared.deleteImage(url: self.tripRequest.images[index]) { [weak self] error in
            
            guard error == nil else {
                
                if (error?.contains("does not exist."))!
                {
                    self?.removeImageFromArray(index: index)
                }
                else
                {
                    Utils.showToast(title: "Oops!", subtitle: error ?? "Unable to delete trip image", icon: UIImage(systemName: "exclamationmark.triangle.fill"), buttonIcon: nil)
                }
                return
            }
            
            self?.removeImageFromArray(index: index)
        }
    }
}


//MARK: - CollectionView

extension AddTripVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.tripRequest.images.count + 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        guard let cvCell = collectionView.dequeueReusableCell(withReuseIdentifier: "tripImageCVCell", for: indexPath) as? tripImageCVCell else { return UICollectionViewCell() }
        
        if indexPath.item == self.tripRequest.images.count
        {
            cvCell.viewAddImageIndicatorOutlet.isHidden = false
        }
        else
        {
            cvCell.viewAddImageIndicatorOutlet.isHidden = true
            cvCell.sd_imageIndicator = SDWebImageActivityIndicator.medium
            cvCell.sd_imageIndicator?.startAnimatingIndicator()
            
            if let url = URL(string: self.tripRequest.images[indexPath.item])
            {
                cvCell.ivTripImageOutlet.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "mtpPost"), options: .highPriority){ (image, error, cache, url) in
                    cvCell.sd_imageIndicator?.stopAnimatingIndicator()
                }
            }
            
            cvCell.btnDeleteclick = {(_ aCell: tripImageCVCell) -> Void in
                self.deleteImageFromFBStorage(index: indexPath.item)
            }
        }
        
        return cvCell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        guard (indexPath.item == self.tripRequest.images.count) else { return }
        
        guard let imagePicker = self.imagePicker else {
            Utils.showToast(title: "Caution", subtitle: "Please initialise image picker", icon: UIImage(systemName: "exclamationmark.triangle.fill"))
            return
        }
        
        imagePicker.present(from: collectionView)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width                       = collectionView.width
        let padding: CGFloat            = 0
        let minimumItemSpacing: CGFloat = 4
        let availableWidth              = width - (padding * 3) - (minimumItemSpacing * 3)
        let itemWidth                   = availableWidth / 3
        
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
}

//MARK: -

extension AddTripVC
{
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool)
    {
        self.tripRequest.latitude   = Float(mapView.centerCoordinate.latitude)
        self.tripRequest.longitude  = Float(mapView.centerCoordinate.longitude)
        
        self.lookUpCurrentLocation(currentLocation: CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)) { placemark in
            guard let loc = placemark else { return }
            
            let reversedGeoLocation = ReversedGeoLocation(with: loc)
            self.tripRequest.address = reversedGeoLocation.formattedAddress
            self.updateLocationLabel(location: "Location (\(reversedGeoLocation.formattedAddress))")
        }
    }
}


//MARK:- Location Manager Delegate Methods...

extension AddTripVC: BBLocationManagerDelegate
{
    func getUserCurrentLocation()
    {
        self.updateLocationLabel(location: "Location fetching...")
        
        let bblocationManager = BBLocationManager.shared()
        bblocationManager?.delegate = self

        bblocationManager?.getCurrentLocation(completion: { (success, latLongAltitudeInfo, error) in
            
            guard error == nil else {
                self.updateLocationLabel(location: "Location fetching failed!")
                return
            }
            
            if let tempLatLongInfo = latLongAltitudeInfo
            {
                guard let latitude = tempLatLongInfo["latitude"] as? NSNumber, let longitude = tempLatLongInfo["longitude"] as? NSNumber, ((latitude.floatValue != 0) && (longitude.floatValue != 0)) else { return }
                self.setMapCenter(latitude: latitude.floatValue, longitude: longitude.floatValue)
            }
        })
    }
    
    func bbLocationManagerDidUpdateLocation(_ latLongAltitudeDictionary: [AnyHashable : Any]!)
    {
        //print("Current Location: \(latLongAltitudeDictionary.description)")
    }
    
    func bbLocationManagerDidUpdateGeocodeAdress(_ addressDictionary: [AnyHashable : Any]!)
    {
        //print("Current Location GeoCode/Address: \(addressDictionary!)")
    }
    
}


//MARK: -

extension AddTripVC: UITextFieldDelegate
{
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        switch textField.tag {
        case 101 : self.tripRequest.title   = textField.text ?? ""
        case 102 : self.tripRequest.date    = textField.text ?? ""
        default: break
        }
    }
}


extension AddTripVC: ImagePickerDelegate
{
    func didSelect(image: UIImage?)
    {
        guard let uploadData = image?.jpegData(compressionQuality: 1) else { return }
        
        self.uploadImageToFBStorage(imageData: uploadData) { [weak self] imageURL in
            if let strURL = imageURL { self?.appendImageToArray(strURL: strURL) }
        }
    }
}


//MARK: - Custom Functions

extension AddTripVC
{
    func editTripConfiguration(tripInfo: Trip?)
    {
        self.isComeToEditTrip = true
        self.tripInfoToEdit = tripInfo
    }
    
    
    private func initialConfiguration()
    {
        self.lblNavigationTitleOutlet.text  = getNavigationTitle()
        
        self.configureTextfield(self.txtTitleOutlet)
        self.configureTextfield(self.txtDateOutlet)
        self.setDatepicker(self.txtDateOutlet)
        
        self.configureButton(self.btnSaveOutlet)
        self.configureButton(self.btnDeleteOutlet)
        self.btnSaveOutlet.setTitle(getButtonTitle(), for: .normal)
        self.btnDeleteOutlet.isHidden           = !isComeToEditTrip
        self.cvPhotosHeightConstant.constant    = self.view.width * 0.275
        
        if self.isComeToEditTrip
        {
            self.setInfoToEdit()
        }
        else
        {
            self.configureMapView()
            self.getUserCurrentLocation()
            
            DispatchQueue.main.async { self.cvPhotosOutlet.reloadData() }
        }
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
    
    
    private func configureTextfield(_ textField: UITextField)
    {
        textField.layer.borderColor    = UIColor(named: "Color_Text4")?.cgColor
        textField.layer.borderWidth    = 1
        textField.delegate = self
    }
    
    
    private func configureButton(_ button: UIButton)
    {
        button.layer.cornerRadius = 6
        button.clipsToBounds      = true
    }
    
    
    private func configureMapView()
    {
        self.mapOutlet.delegate                 = self
        self.mapOutlet.showsUserLocation        = true
    }
    
    
    func getNavigationTitle() -> String
    {
        return isComeToEditTrip ? "Edit Trip" : "Add Trip"
    }
    
    
    func getButtonTitle() -> String
    {
        return isComeToEditTrip ? "EDIT" : "SAVE"
    }
    
    //---
    
    private func setDatepicker(_ textField: UITextField)
    {
        guard let dobDatePicker = dobDatePicker else { return }
        
        dobDatePicker.maximumDate  = Date()
        dobDatePicker.date         = Date()
        dobDatePicker.addTarget(self, action: #selector(updateDOBvalue(sender:)), for: .valueChanged)
        
        textField.inputView = dobDatePicker
        textField.keyboardToolbar.tintColor = UIColor(named: "Color_Text1")
        textField.addPreviousNextDoneOnKeyboardWithTarget(self, previousAction: #selector(previousAction(_:)), nextAction: #selector(nextAction(_:)), doneAction: #selector(selectDayAction(_:)), shouldShowPlaceholder: true)
    }
    
    
    @objc func previousAction(_ button: Any)
    {
        IQKeyboardManager.shared.goPrevious()
    }
    
    
    @objc func nextAction(_ button: Any)
    {
        IQKeyboardManager.shared.goNext()
    }
    
    
    @objc func updateDOBvalue(sender: UIDatePicker) -> Void
    {
        self.setDate()
    }
    
    
    @objc func selectDayAction(_ barButton: UIBarButtonItem)
    {
        self.setDate()
        view.endEditing(true)
    }
    
    
    private func setDate()
    {
        self.txtDateOutlet.text = ""

        guard let dobDatePicker = dobDatePicker else { return }
        self.txtDateOutlet.text = dobDatePicker.date.dateString("dd/MM/yyyy")
    }
    
    //--
    
    private func setInfoToEdit()
    {
        guard let tripInfo = self.tripInfoToEdit else { return }
        
        self.tripRequest.images.removeAll()
        self.tripRequest.images.append(contentsOf: tripInfo.images)
        self.tripRequest.title = tripInfo.title
        self.tripRequest.date = (tripInfo.date.isEmpty) ? Date().dateString("dd/MM/yyyy") : (tripInfo.date)
        
        DispatchQueue.main.async {
            self.cvPhotosOutlet.reloadData()
            self.cvPhotosHeightConstant.constant = self.cvPhotosOutlet.contentSize.height
        }
        
        self.txtTitleOutlet.text    = tripInfo.title
        self.txtDateOutlet.text     = tripInfo.date
        self.dobDatePicker?.date    = (tripInfo.date.isEmpty) ? Date() : (tripInfo.date.toDateTime(format: "dd/MM/yyyy") as Date)
        
        if ( (tripInfo.latitude != 0) && (tripInfo.longitude != 0) )
        {
            self.setMapCenter(latitude: (tripInfo.latitude as NSNumber).floatValue, longitude: (tripInfo.longitude as NSNumber).floatValue)
            self.configureMapView()
        }
        else
        {
            self.configureMapView()
            self.getUserCurrentLocation()
        }
    }
    
    
    private func displayDeleteRequestAlert()
    {
        let alrt = UIAlertController(title: "", message: "Sure you want to delete the trip?", preferredStyle: .alert)
        
        let alrtOkAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            self.deleteTrip()
        }
        
        let alrtCancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        alrt.addAction(alrtCancelAction)
        alrt.addAction(alrtOkAction)
        self.present(alrt, animated: true, completion: nil)
    }
    
    
    private func appendImageToArray(strURL: String)
    {
        self.tripRequest.images.append(strURL)
        
        DispatchQueue.main.async {
            self.cvPhotosOutlet.reloadData()
            self.view.layoutIfNeeded()
            self.view.layoutSubviews()
            self.cvPhotosHeightConstant.constant = self.cvPhotosOutlet.contentSize.height
        }
    }
    
    
    private func removeImageFromArray(index: Int)
    {
        self.tripRequest.images.remove(at: index)
        
        DispatchQueue.main.async {
            self.cvPhotosOutlet.reloadData()
            self.view.layoutIfNeeded()
            self.view.layoutSubviews()
            self.cvPhotosHeightConstant.constant = self.cvPhotosOutlet.contentSize.height
        }
    }
    
    //---
    
    private func lookUpCurrentLocation(currentLocation: CLLocation?, completionHandler: @escaping (CLPlacemark?) -> Void )
    {
        if let lastLocation = currentLocation
        {
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(lastLocation, completionHandler: { (placemarks, error) in
                if error == nil
                {
                    completionHandler(placemarks?.first)
                }
                else
                {
                    completionHandler(nil)
                }
            })
        }
        else
        {
            completionHandler(nil)
        }
    }
    
    
    private func updateLocationLabel(location: String)
    {
        self.lblLocationIndicatorOutlet.text = location
    }
    
    
    private func setMapCenter(latitude: Float, longitude: Float)
    {
        self.tripRequest.latitude    = latitude
        self.tripRequest.longitude   = longitude
        
        let initialLocation = CLLocation(latitude: CLLocationDegrees(self.tripRequest.latitude), longitude: CLLocationDegrees(self.tripRequest.longitude))
        self.mapOutlet.centerToLocation(initialLocation)
    }
    
    //---
}
