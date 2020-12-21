//
//  AppDelegate.swift
//  Menu
//
//  Created by YoussefRomany on 16/12/2020.
//  Copyright © 2020 FoodicsCompany. All rights reserved.
//

import UIKit
import Alamofire
import MobileCoreServices


public protocol NetworkingHelperDeleget: NSObjectProtocol {
    func onHelper(getData data:DataResponse<String>,fromApiName name:String , withIdentifier id:String)
    func onHelper(getError error:String,fromApiName name:String , withIdentifier id:String)
}


class NetworkingHelper: NSObject {
    
    ///the network deleget , you must set before calling any method it to get the response.
    weak var deleget: NetworkingHelperDeleget?
    
    
    /// to request from server
    ///
    /// - Parameters:
    ///   - api: api name
    ///   - parm: parameter
    ///   - id: api id
    ///   - encoding: encoding description
    ///   - controller: controller description
    ///   - method: method description
    func connectWithHeaderTo(api:String , withParameters parm:[String:Any]? = nil , andIdentifier id:String = "",withEncoding encoding:ParameterEncoding = URLEncoding.queryString, forController controller:UIViewController? = nil, methodType method: HTTPMethod) {
        
        let headers = ["Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjlhZjhkYjhiYzQ2ZDNmNjk1MWI3MjQwM2I2Mjc5NjkzYjI1MWY4YzliMzJmOTc3YWEyNzk0YTU1NWFhY2I3MjE3ZWI2YjcwNGIyMjk5YmU2In0.eyJhdWQiOiI4Zjc4NjY2NC0wNTg5LTQ3MTgtODBkMS1lMTY4M2FmYmM3MjQiLCJqdGkiOiI5YWY4ZGI4YmM0NmQzZjY5NTFiNzI0MDNiNjI3OTY5M2IyNTFmOGM5YjMyZjk3N2FhMjc5NGE1NTVhYWNiNzIxN2ViNmI3MDRiMjI5OWJlNiIsImlhdCI6MTYwODEwMjY1MCwibmJmIjoxNjA4MTAyNjUwLCJleHAiOjE2Mzk2Mzg2NTAsInN1YiI6IjkxYmVmM2Q4LTcyYzYtNGQ5YS1hODAzLWUwZDEwMWVmODdhNiIsInNjb3BlcyI6WyJnZW5lcmFsLnJlYWQiXSwiYnVzaW5lc3MiOiI5MWJlZjNkOC03OTQ5LTQ0MjctOTg2NS1hYTI3MDVlNTYyOGQiLCJyZWZlcmVuY2UiOiIxMDAxMTEifQ.OxBVuOzdNqsowS1ebKSpn8vrfrsXR64VeN_cFzvZCVYI-s5meANJA3XHKX8THmIH3MlYYVz4zW41PfTWt1Klzmg9WcEcCuB30NncMS_UGdF3vcgSPc8RVxiGwzfj428HzSbjbM8P-ukg4TqcInYwDLKNaCOc5DEmXkdSbscUZazrBuK09ts74xBw9MhOk5E-ZCOsPm2Ts4ASHJ0m3qB2JI79IF3846iMHz8jpciYSBTkga37AlT7fef_Hxwrn1apxRIrb6rLKCV6zDr4ged2Ir9-GKjNSk1a_onUTHdP3-3_2lBEE51MFhX45qansnR2LDXUl-QMp9T0PDhWO9TR9QIwZJAsp1aFXW9S4E-Ok7566eDrplOHKVt5Tw08P9LefOK_Ob875ZsGpta56CzqMuVdlnJ7vnkbD_UuPlLquc1o9_yvOcu-Frk5QCNGNsyyzITobOvOwQ9TN24-BpDjq7s7debkDes5Sg6aVn4fmnVKkfDO44qJ9ppUPcOc2U8dh7voCJEry53lh9LPM6MiRmt8YBeiXDL8iRU2k_tcreJVEOtjRwkB-2m08jQ5DHDFrALNdvUFU6bgslbNSw9vKUiJbQrblwmohOR9fC-VtBPdVhQywyerNE1hs1jeFrHC2AZE-g2y5uQhVALYRxIy0-IBJgeh-jnCxpOsds_sOg0" ,"Content-Type": "application/json"]
        print("headers", headers)
        
        // JSONEncoding.default in body
        // URLEncoding.default if url and xxx
        Alamofire.request(api, method: method, parameters: parm, encoding:  encoding, headers: headers)
            .responseString { (response) in
                
            switch(response.result) {
            case.success(let data):
                print("success",data)
            case.failure(let error):
                print("Not Success",error)
            }
            self.handleResponse(response: response, forApi: api, andIdentifier: id)
        }
    }
   
    
    
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    //this method handle the response to check if the request has succeeded or not
    fileprivate func handleResponse(response:DataResponse<String> , forApi api:String , andIdentifier id:String){
        print("Response from api : \(api) , with Identifier : \(id)")
        print(response)

        print("responseStatus==",response.response?.statusCode ?? 0)
        
        switch response.result {
        case .success:
                self.deleget?.onHelper(getData: response, fromApiName: api, withIdentifier: id)

        case .failure:
            self.deleget?.onHelper(getError: "request failed", fromApiName: api, withIdentifier: id)
        }
    }
}


