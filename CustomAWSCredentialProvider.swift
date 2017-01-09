//  CustomAWSCredentialProvider.swift
//  Copyright © 2016 Medtronic. All rights reserved.

import UIKit
import SwiftyJSON
import AWSS3
import AWSCore.AWSCredentialsProvider
class CustomAWSCredentialProvider: AWSCredentials, AWSCredentialsProvider {
    var bucketName: String!
    var token: String!
    var awsAccessKey: String!
    var awsSecretKey: String!
    var awsExpiration: NSDate?
    var awsRegion: String!
    var expirationTime: String!
    static let sharedInstance = CustomAWSCredentialProvider(accessKey: "", secretKey: "", sessionKey: "", expiration: nil)
    override init(accessKey: String, secretKey: String, sessionKey: String?, expiration: NSDate?) {
        super.init()
        self.token = sessionKey
        self.awsAccessKey = accessKey
        self.awsSecretKey = secretKey
        self.awsExpiration = expiration
    }
    private static func sharedInstanceWith(accessKey: String, secretKey: String, sessionKey: String, expiration: NSDate) -> CustomAWSCredentialProvider {
        let instance = CustomAWSCredentialProvider.sharedInstance
        instance.token = sessionKey
        instance.awsAccessKey = accessKey
        instance.awsSecretKey = secretKey
        instance.awsExpiration = expiration
        return instance
    }
     func updateAWSInfo (jsonString: JSON) {

//        if(jsonString["cloudCredentialReport"].dictionary != nil)
        //{
             awsAccessKey               = jsonString["accessKey"].stringValue
             awsSecretKey               = jsonString["secretKey"].stringValue
             bucketName                 = jsonString["bucketName"].stringValue
             awsRegion                  = jsonString["region"].stringValue
             token                      = jsonString["token"].stringValue
             expirationTime             = jsonString["expirationTime"].stringValue

            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat =  "dd-MMM-yyyy HH:mm:ss"////03-Oct-2016 16:54:47
            dateFormatter.timeZone = NSTimeZone(name:"UTC")
            let date = dateFormatter.dateFromString(expirationTime)
            dateFormatter.timeZone = NSTimeZone.localTimeZone()
            let dateString      =     dateFormatter.stringFromDate(date!)
            awsExpiration =  dateFormatter.dateFromString(dateString)
            let credentialsProvider = CustomAWSCredentialProvider.sharedInstanceWith(awsAccessKey, secretKey: awsSecretKey, sessionKey: token, expiration: awsExpiration!)
            let configuration = AWSServiceConfiguration(region:AWSRegionType.APSoutheast1, credentialsProvider:credentialsProvider)
            AWSServiceManager.defaultServiceManager().defaultServiceConfiguration = configuration
        // }
    }
    func credentials() -> AWSTask {
        let credentials = AWSCredentials(accessKey: self.awsAccessKey, secretKey: self.awsSecretKey, sessionKey: self.token, expiration: self.awsExpiration)
        return AWSTask(result: credentials)
    }
     func invalidateCachedTemporaryCredentials() {

    }
}
