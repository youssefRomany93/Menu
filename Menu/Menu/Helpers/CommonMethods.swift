//
//  AppDelegate.swift
//  Menu
//
//  Created by YoussefRomany on 16/12/2020.
//  Copyright © 2020 FoodicsCompany. All rights reserved.
//

import UIKit
import SystemConfiguration
import IBAnimatable
import Alamofire
import SwiftMessages
import Toast_Swift
import Kingfisher

public var screenWidth:CGFloat { get { return UIScreen.main.bounds.size.width } }
public var screenHeight:CGFloat { get { return UIScreen.main.bounds.size.height } }
public var isIpad: Bool { get { return UIScreen.main.traitCollection.horizontalSizeClass == .regular } }
public var iphoneXFactor:CGFloat { get {return ((screenWidth * 1.00) / 1080.0)*3} }
public var deviceID:String { get { return (UIDevice.current.identifierForVendor?.uuidString) ?? "" } }
public let window = UIApplication.shared.keyWindow
var iPhoneFactorX: CGFloat = (UIScreen.main.bounds.size.width*1.00/1080.0)*3
public var topPadding: CGFloat = 0*iPhoneFactorX
public var globalTopPadding: CGFloat = 0*iPhoneFactorX
public var globalTopPaddingMain: CGFloat = 0*iPhoneFactorX
public var globalBottomPadding: CGFloat = 0*iPhoneFactorX
public var countryId: Int = 1

let fahimIPhoneFactorX : CGFloat = (UIScreen.main.bounds.width/1080.0)*3.0


public func displayAlert(_ title: String,_ messeg:String,forController controller:UIViewController? = nil){
    guard let controller = controller ?? getCurrentViewController() else {
        return
    }
    let alert = UIAlertController(title: title, message: messeg, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: localizedSitringFor(key: "yes"), style: UIAlertAction.Style.default, handler: nil))
    DispatchQueue.main.async(execute: {
        controller.present(alert, animated: true, completion: nil)
    })
}


//MARK: - corner radius
func cornerRadius(view: UIView ,radi: Float){
    view.layer.cornerRadius = CGFloat(Float(view.layer.bounds.height) / (radi))
}




//MARK: - Make Shadow
func makeShadow(view: UIView , shadowRadius: Double , shadowOpacity: Double){
    view.layer.shadowColor = UIColor.black.cgColor
    view.layer.shadowOffset = CGSize(width: 0, height: 1)
    view.layer.shadowRadius = CGFloat(shadowRadius)
    view.layer.shadowOpacity = Float(shadowOpacity)
}


public func getFonts(){
    for family in UIFont.familyNames {
        print("\(family)")

        for name in UIFont.fontNames(forFamilyName: family) {
            print("   \(name)")
        }
    }
}

//MARK: - call number
public func makeCall(forNumber number:String)->Bool {
    if let url:URL = URL(string:"tel://\(number)") {
        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
            return true
        }
    }

    return false
}

//MARK:- Send whats app message
// add sechem to info list
/*
<key>LSApplicationQueriesSchemes</key>
<array>
   <string>whatsapp</string>
</array>
 */
public func openWhatsapp(forNumber number:String){
    let urlWhats = "whatsapp://send?phone=" + number
    if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
        if let whatsappURL = URL(string: urlString) {
            if UIApplication.shared.canOpenURL(whatsappURL){
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(whatsappURL)
                }
            }
            else {
                print("Install Whatsapp")
            }
        }
    }
}




//MARK: - copy string
public func makeCopy(ofString string:String){
    UIPasteboard.general.string = string
}


//MARK: - open url
public func ESOpen(url:URL)->Bool{
    //check if the url is valid
    if UIApplication.shared.canOpenURL(url) == true {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
        return true
    }
    //else will return false
    return false
}


/// share items like string or images to all available social media
///
/// - Parameters:
///   - items: the items to share
///   - controller: the controller that will be responsable for displaying the ActivityController
///   - types: the excluded activity types, default value is nil
func share(items:[Any], forController controller:UIViewController, excludedActivityTypes types:[UIActivity.ActivityType]? = nil) {
    let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
    activityViewController.popoverPresentationController?.sourceView = controller.view // so that iPads won't crash
    
    // exclude some activity types from the list (optional)
    activityViewController.excludedActivityTypes = types
    
    // present the view controller
    controller.present(activityViewController, animated: true, completion: nil)
}


//MARK:-
///uses to handling starView to set star view rating,starSize ,filledColort , emptyBorderColor and to get raing after user set rate
//func handleStarView(forView rateView: CosmosView, withRate rate: Double,isTouch:Bool)
//{
//    rateView.settings.updateOnTouch = isTouch
//    rateView.settings.totalStars = 5
//    rateView.settings.fillMode = .full
//    rateView.rating = Double(rate)
//    rateView.settings.starSize = Double(screenWidth * 0.09)
//    rateView.settings.starMargin = 1.0
//}

//MARK: - dates

//get current date
public func getCurrentDate()->String{
    let format = DateFormatter()
    format.dateFormat = "dd-MM-yyyy-hh:mm:ss"
    format.locale = Locale(identifier: "en")
    let date = format.string(from: Date())
    return date
}

public func getDayName(_ dateString:String,formatString:String) -> String{
    if let date = getDateFromStringWithFormat(dateString, formatString: formatString) {
        let format = DateFormatter()
        format.dateFormat = "EE"
        return format.string(from: date)
    }
    return ""
}

// get Date And Time As String From String With Format
public func getDateAndTimeAsStringFromStringWithFormat(_ dateString:String,formatString:String)->(date:String,time:String)? {
    var output:(date:String,time:String)
    
    if let date = getDateFromStringWithFormat(dateString, formatString: formatString) {
        let format = DateFormatter()
        format.dateFormat = "d MMMM YYYY"
        
        if getCurrentDateWithFormat("d MMMM YYYY") == format.string(from: date) {
            output.date = "Today"
        }else{
            output.date = format.string(from: date)
        }
        
        format.dateFormat = "EEEE, h:mm a"
        format.amSymbol = "am"
        format.pmSymbol = "pm"
        
        output.time = format.string(from: date)
        return output
    }
    
    return nil
}

// get Date And Time As String From String With Format
public func getDateTimeAsStringFromStringWithFormat(_ dateString:String,formatString:String)-> String {
    
    var dateConvert = ""
    if let date = getDateFromStringWithFormat(dateString, formatString: formatString) {
        let format = DateFormatter()
        format.dateFormat = "dd-MMM-YYYY  hh:mm a"
       
        dateConvert = format.string(from: date)

        return dateConvert
    }
    
    return dateConvert
}


// get Current Date With Format
public func getCurrentDateWithFormat(_ formatString:String)->String{
    let format = DateFormatter()
    format.dateFormat = formatString
    format.locale = Locale(identifier: "en")
    let date = format.string(from: Date())
    return date
}

// get Date From String With Format
public func getDateFromStringWithFormat(_ dateString:String,formatString:String)->Date? {
    
    let format = DateFormatter()
    format.locale = Locale(identifier: "en")
    format.dateFormat = formatString
    let date = format.date(from: dateString)
    //        print("getDateFromStringWithFormat : \(date)")
    return date
}

public func UTCToLocal(date:String,localForamt: String = "yyyy-MM-dd HH:mm:ss.SSSS",returnFormat : String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = localForamt
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
    
    if let dt = dateFormatter.date(from: date) {
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = returnFormat
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
           
        return dateFormatter.string(from: dt)
    }
   return ""
}

//MARK: - images

/// convert image file to base64
///
/// - Parameter image: image file
/// - Returns: image string base64
public func convertImageToBase64(image: UIImage) -> String {
    let imageData = image.jpegData(compressionQuality: 0.5)
    //        strBase64 = (imageData?.base64EncodedString(options: .lineLength64Characters))!
    return  (imageData?.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters))!
}


//capture image for view
public func captureImageForView(_ _view:UIView)->UIImage {
    let frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
    UIGraphicsBeginImageContextWithOptions(frame.size, false, UIScreen.main.scale)
    _view.layer.render(in: UIGraphicsGetCurrentContext()!)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
}

//MARK: - alerts

// display alert
public func displayAlert(_ messeg:String,forController controller:UIViewController? = nil){
    guard let controller = controller ?? getCurrentViewController() else {
        return
    }
    let alert = UIAlertController(title: "", message: messeg, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: localizedSitringFor(key: "ok"), style: UIAlertAction.Style.default, handler: nil))
    DispatchQueue.main.async(execute: {
        controller.present(alert, animated: true, completion: nil)
    })
}

// display alert with action
public func displayAlertWithAction(_ messeg:String,forController controller:UIViewController? = nil,_ Closure: @escaping () -> () ){
    guard let controller = controller ?? getCurrentViewController() else {
        return
    }
    let alert = UIAlertController(title: "", message: messeg, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: localizedSitringFor(key: "ok"), style: UIAlertAction.Style.default, handler: {(action) in Closure()  }))
    DispatchQueue.main.async(execute: {
        controller.present(alert, animated: true, completion: nil)
    })
}

// display alert with action
public func displayAlertConfirmation(_ title: String,_ body:String,forController controller:UIViewController? = nil,_ Closure: @escaping () -> () ){
    guard let controller = controller ?? getCurrentViewController() else {
        return
    }
    let alert = UIAlertController(title: title, message: body, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: localizedSitringFor(key: "yes"), style: .default, handler: {(action) in Closure()  }))
    alert.addAction(UIAlertAction(title: localizedSitringFor(key: "no"), style: .default, handler: nil))
    DispatchQueue.main.async(execute: {
        controller.present(alert, animated: true, completion: nil)
    })
}

public func checkLoginWithAlert () {
    displayAlertConfirmation(localizedSitringFor(key: "Attention"), localizedSitringFor(key: "notLogin")) {
          // go to login if user not login
          pushToView(withId: "LoginViewController")
      }
}

public func checkLoginWithoutAlert() {
    pushToView(withId: "LoginViewController")
}


//MARK: - internet

//check internet connection
public func isConnectedToNetwork() -> Bool {
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
            SCNetworkReachabilityCreateWithAddress(nil, $0)
        }
    }) else {
        return false
    }
    
    var flags: SCNetworkReachabilityFlags = []
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
        return false
    }
    
    let isReachable = flags.contains(.reachable)
    let needsConnection = flags.contains(.connectionRequired)
    
    return (isReachable && !needsConnection)
}

// MARK: - loader
public func showLoaderForController(_ controller:UIViewController){
    DispatchQueue.main.async(execute: {
        let loader = Bundle.main.loadNibNamed("LoaderView", owner: controller, options: nil)?.last as! LoaderView
        loader.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        loader.tag = 4000
        controller.view.addSubview(loader)
        loader.showLoader()
    })
}



public func hideLoaderForController(_ controller:UIViewController){
    DispatchQueue.main.async(execute: {
        if let view = controller.view.viewWithTag(4000) {
            view.removeFromSuperview()
        }
    })
}




/// Makes a progress bar with tag 5000
///   Don't call before making your loader
///
/// - Parameter controller: The view controller to present the bar on
public func makeProgressBar(_ controller : UIViewController) {
    // After this (to wait for loader creation)
    mainQueue {
        // Get loader
        let loader = controller.view.viewWithTag(4000)
        
        // Create a progress bar
        let progressBar = UIProgressView(progressViewStyle: .default)
        
        // Layout the progress bar
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.isHidden = false
        loader?.addSubview(progressBar)
        NSLayoutConstraint(item: progressBar, attribute: .centerX, relatedBy: .equal, toItem: loader, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: progressBar, attribute: .centerY, relatedBy: .equal, toItem: loader, attribute: .centerY, multiplier: 1, constant: 64).isActive = true
        NSLayoutConstraint(item: progressBar, attribute: .width, relatedBy: .equal, toItem: loader, attribute: .width, multiplier: 0.2, constant: 0).isActive = true
        
        // Give tag to use outside this function
        progressBar.tag = 5000
        
        // Prepare progress bar
        progressBar.setProgress(0, animated: false)
    }
    
}



//MARK: - Circle view
// to make an image in circle
func makecircle(image: UIView){// UIImageView){
    image.layer.cornerRadius = image.frame.size.width/2
    image.clipsToBounds = true
    //    image.layer.borderWidth = 3
    //    image.layer.borderColor = UIColor.white.cgColor
}


func makecircleButton(but: UIButton){
    but.layer.cornerRadius = but.bounds.size.width * 0.5
    but.clipsToBounds = true
}



//MARK: - validation


//validate email
public func isValidEmail(_ testStr:String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    let result = emailTest.evaluate(with: testStr)
    return result
}


public func validateString(_ text:String?)->String {
    return text ?? ""
}

//Validate optional int
public func validateInt(_ val:Int?)->Int {
   return val ?? 0
}



// MARK: - Validation with effects


func animateValidationError(errorText : UILabel) {
    errorText.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
    UIView.animate(withDuration: 0.2, animations: {
        errorText.transform = CGAffineTransform(scaleX: 1, y: 1)
    }, completion: { _ in
        DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: DispatchTime.now().uptimeNanoseconds + (3 * NSEC_PER_SEC)), execute: {
            UIView.animate(withDuration: 0.2, animations: {
                errorText.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            }, completion: { _ in
                errorText.removeFromSuperview()
            })
        })
    })
}

func revealValidationError(over view : UIView, superView : UIView, text : String) {
    let errorText = UILabel()
    errorText.textColor = UIColor(white: 0, alpha: 0.8)
    errorText.text = text
    errorText.font = UIFont(name: "Helvetica Neue", size: 17)
    errorText.translatesAutoresizingMaskIntoConstraints = false
    errorText.isOpaque = true
    errorText.isHidden = false
    superView.addSubview(errorText)
    NSLayoutConstraint(item: errorText, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: errorText, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: -8).isActive = true
    animateValidationError(errorText: errorText)
}




//MARK: - dispatch queues
//delay to time
public func delay(_ delay: Double, closure: @escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}

public func mainQueue(_ closure: @escaping ()->()){
    DispatchQueue.main.async(execute: closure)
}

public func backgroundQueue(_ closure: @escaping ()->()){
    DispatchQueue.global(qos: .background).async {
        closure()
    }
}





//MARK: - active controller
// Returns the most recently presented UIViewController (visible)
public func getCurrentViewController() -> UIViewController? {
    
    // we must get the root UIViewController and iterate through presented views
    if let rootController = UIApplication.shared.keyWindow?.rootViewController {
        
        var currentController: UIViewController! = rootController
        
        // Each ViewController keeps track of the view it has presented, so we
        // can move from the head to the tail, which will always be the current view
        while( currentController.presentedViewController != nil ) {
            
            currentController = currentController.presentedViewController
        }
        return currentController
    }
    
    return nil
}

func goToView(withId:String, andStoryboard story:String = "Main", fromController controller:UIViewController? = nil) {
    let board = UIStoryboard(name: story, bundle: nil)
    let control = controller ?? getCurrentViewController() ?? UIViewController()
    control.present(board.instantiateViewController(withIdentifier: withId), animated: true, completion: nil)
}

/// go to view controller and make it the root view
///
/// - Parameter withId: the detination view controller id
func pushToView(withId:String){
    let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    rootviewcontroller.rootViewController = storyboard.instantiateViewController(withIdentifier: withId)
    let mainwindow = (UIApplication.shared.delegate?.window!)!
    UIView.transition(with: mainwindow, duration: 0.5, options: [.transitionFlipFromLeft], animations: nil, completion: nil)
}

public func goNavigation(controllerId: String, controller: UIViewController){
    
    let main = UIStoryboard(name: "Main", bundle: nil)
    let vc = main.instantiateViewController(withIdentifier: controllerId)
    controller.navigationController?.pushViewController(vc, animated: true)
    
}

//MARK: - Localization and languages
public func localizedSitringFor(key:String)->String {
    return NSLocalizedString(key, comment: "")
}


// MARK: - Convert Arabic numbers
public func getNSNumberFromString(_ text : String) -> NSNumber? {
    return NumberFormatter().number(from: text)
}

public func intFromString(_ text : String?) -> Int? {
    if text == nil { return nil }
    if let n = getNSNumberFromString(text!) { return n.intValue } else { return nil }
}
public func uintFromString(_ text : String?) -> UInt? {
    if text == nil { return nil }
    if let n = getNSNumberFromString(text!) { return n.intValue >= 0 ? n.uintValue : nil } else { return nil }
}
public func doubleFromString(_ text : String?) -> Double? {
    if text == nil { return nil }
    if let n = getNSNumberFromString(text!) { return n.doubleValue } else { return nil }
}
public func decimalFromString(_ text : String?) -> NSDecimalNumber? {
    if text == nil { return nil }
    if let n = getNSNumberFromString(text!) { return NSDecimalNumber(decimal: n.decimalValue) } else { return nil }
}


/// bold part of label
public func attributedText(withString string: String, boldString: String, font: UIFont) -> NSAttributedString {
    let attributedString = NSMutableAttributedString(string: string,
                                                 attributes: [NSAttributedString.Key.font: font])
    let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: font.pointSize)]
    let range = (string as NSString).range(of: boldString)
    attributedString.addAttributes(boldFontAttribute, range: range)
    return attributedString
}

/// change background color for uiview nad change image for specific image view
///
/// - Parameters:
///   - view: UIView which its background color will be changed
///   - red: red value
///   - green: green value
///   - blue: blue value
///   - image: name of image
///   - imageView: UIImageView which its image will be changed
func changeBackGroundColor(forView view: AnimatableView, withRed red:Double , green: Double, blue: Double, andImage image: String = "", forimageView imageView: UIImageView = UIImageView())
{
    view.borderColor = UIColor(red: CGFloat(red/255.0), green: CGFloat(green/255.0), blue: CGFloat(blue/255.0), alpha: 1.0)
    imageView.image = UIImage(named: image)
}



//MARK: - handle message toast
public func displayMessage(message: String, messageError: Bool) {
    
    let view = MessageView.viewFromNib(layout: .cardView)
    if messageError == true {
        view.configureTheme(.error)
        view.configureTheme(backgroundColor: UIColor(hexString: "DB0000"), foregroundColor: .white)
    } else {
        view.configureTheme(.success)
        view.configureTheme(backgroundColor: UIColor(hexString: "31312F"), foregroundColor: .white)
        view.alpha = 0.8
        
    }
    
    view.iconImageView?.isHidden = true
    view.iconLabel?.isHidden = true
    view.titleLabel?.isHidden = true
    view.bodyLabel?.text = message
    view.titleLabel?.textColor = UIColor.white
    view.bodyLabel?.textColor = UIColor.white
    view.button?.isHidden = true
    view.bodyLabel?.font = UIFont(name: localizedSitringFor(key: "semiFont"), size: iphoneXFactor*40)
    view.alpha = 0.9
    var config = SwiftMessages.Config()
    config.presentationStyle = .bottom
    config.duration = .seconds(seconds: 4)
    SwiftMessages.show(config: config, view: view)
}

func showToast(toastView: UIView, toastTitle: String, toastText: String) {
    var toastStyle = ToastStyle()
    // this is just one of many style options
    toastStyle.backgroundColor = .red //UIColor(hexString: "ffffff")
    toastStyle.titleAlignment = .center
    toastStyle.titleFont = UIFont(name:  localizedSitringFor(key: "regFont"), size: 45*iphoneXFactor)!
    toastStyle.titleColor = UIColor(hexString: "000000")
    toastStyle.messageColor = UIColor(hexString: "000000")
    toastStyle.messageFont = UIFont(name: localizedSitringFor(key: "regFont"), size: 40*iphoneXFactor)!
    toastStyle.messageAlignment = .center
    
    toastView.hideAllToasts()
    
    toastView.makeToast(toastText, duration: 3.0, position: .bottom, title: toastTitle, image: nil, style: toastStyle, completion: nil)
}


/// get date as string from Seconds since 1970
///
/// - Parameters:
///   - fromSeconds: the seconds from 1970
///   - format: the date string format
/// - Returns: new date string
public func getDate(fromSeconds:Double, withFormat format:String)-> String {
    return getDateFormatter(withFormat: format).string(from: Date(timeIntervalSince1970: fromSeconds))
}


/// get DateFormatter object in english locale
///
/// - Parameter format: the formatter you want , the default value is "dd-MM-yyyy-hh:mm:ss"
/// - Returns: the DateFormatter object
public func getDateFormatter(withFormat format:String? = nil) -> DateFormatter {
    let format:String = format == nil ? "dd-MM-yyyy-hh:mm:ss" : format!
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    dateFormatter.locale = Locale(identifier: "en")
    return dateFormatter
}




extension CALayer {

  func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {

    let border = CALayer()

    switch edge {
    case UIRectEdge.top:
        border.frame = CGRect(x: 0, y: 0, width: frame.width, height: thickness)

    case UIRectEdge.bottom:
        border.frame = CGRect(x:0, y: frame.height - thickness, width: frame.width, height:thickness)

    case UIRectEdge.left:
        border.frame = CGRect(x:0, y:0, width: thickness, height: frame.height)

    case UIRectEdge.right:
        border.frame = CGRect(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)

    default: do {}
    }

    border.backgroundColor = color.cgColor

    addSublayer(border)
 }
}

extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

extension String {
    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}




//public func handleError(forResponse response: DataResponse<String>) -> Bool{
//
//    print(response.response?.statusCode , "respHandelErrorStatuse")
////    if response.response?.statusCode == 400 || response.response?.statusCode == 404
//
//    if response.response?.statusCode != 200{
//        var myTextToShow : String = ""
//        
//        let data = response.data
//        do {
//            let regResp = try JSONDecoder().decode(ErrorResponse.self, from: data!)
//            let myResp : ErrorResponse = regResp
//            
//            var utf8Text = String(data: data!, encoding: .utf8)
//            
//            utf8Text = utf8Text!.replacingOccurrences(of: "\r", with: "")
//            utf8Text = utf8Text!.replacingOccurrences(of: "\n", with: "")
//            utf8Text = utf8Text!.replacingOccurrences(of: "\t", with: "")
//            utf8Text = utf8Text!.replacingOccurrences(of: "\"", with: "")
//            
//            print("utf8Text=2===\(utf8Text!)")
//            
//            var nArr1 = utf8Text!.split(separator: "]")
//            
//            if (nArr1.count>=1) {
//                utf8Text = "\(nArr1[0])"
//                
//                print("utf8Text=3===\(utf8Text!)")
//                
//                var nArr2 = utf8Text!.split(separator: "[")
//                
//                if (nArr2.count>=2) {
//                    utf8Text = "\(nArr2[1])"
//                }
//                
//            }
//            
//            utf8Text = utf8Text!.trimmingCharacters(in: .whitespacesAndNewlines)
//            
//            
//            myTextToShow = utf8Text!
//            
//        }  catch let jsonErr {
//            print("jsonErr=2==\(jsonErr)")
//            UserDefaults.standard.set("\((response.response?.statusCode)!)", forKey: "AppStatusCode")
//            UserDefaults.standard.synchronize()
//        }
//        
//        displayMessage(message: myTextToShow, messageError: true)
//        return myTextToShow != ""
//    }else{
//        return false
//    }
//}

func adjustDoublePrices(passedPrice : Double) -> String {
    return String(format: "%.3f", passedPrice)
}

public func randomString(length: Int) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String((0..<length).map{ _ in letters.randomElement()! })
}

public func setImageView(forImageView imageView: UIImageView, andURL url: String, andPlaceHolderImage placeholder: String){
    imageView.kf.indicatorType = .activity
    imageView.kf.setImage(with: URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""), placeholder: UIImage(named: placeholder))

}





class RTLCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override var flipsHorizontallyInOppositeLayoutDirection: Bool {
        return true
    }
 
}




public func formatNumbersToMK(numberToPass : Int) -> String {
    var finalString : String = "\(numberToPass)"
    
    if (numberToPass >= 1000 && numberToPass < 1000000) {
        finalString = "\(String(format: "%.1f", (Float(numberToPass)/1000.0))) K"
    }
    
    if (numberToPass >= 1000000) {
        finalString = "\(String(format: "%.1f", (Float(numberToPass)/1000000.0))) M"
    }
    
    print("finalString==\(numberToPass)==\(finalString)")
    
    return finalString
}
