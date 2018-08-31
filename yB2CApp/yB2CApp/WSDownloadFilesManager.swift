//
//  WSDownloadFilesManager.swift
//  UFS
//
//  Created by Prathibha Sundresh on 16/07/18.
//

import Foundation

class WSDownloadFilesManager: NSObject {
    
    func downloadVideo(urlString:String, PathName:String, success:@escaping (_ response:URL) -> Void, failure:@escaping (_ error:String) -> Void) {
        // Create destination URL
        let documentsUrl:URL =  (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL?)!
        let destinationFileUrl = documentsUrl.appendingPathComponent(PathName)
        
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: destinationFileUrl.path) {
            return;
        } else {
            //Create URL to the source file you want to download
            let fileURL = URL(string: urlString)
            
//            let sessionConfig = URLSessionConfiguration.background(withIdentifier: "background Download")
            let sessionConfig = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfig)
            
            let request = URLRequest(url:fileURL!)
            
            let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
                
                guard error == nil else {
                    print(error!)
                    return
                }
                if let tempLocalUrl = tempLocalUrl, error == nil {
                    // Success
                    if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                        
                        print("Successfully downloaded. Status code: \(statusCode)")
                    }
                    
                    do {
                        try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
                        success(tempLocalUrl)
                    } catch (let writeError) {
                        print("Error creating a file \(destinationFileUrl) : \(writeError)")
                    }
                    
                } else {
                    
                    failure("Error took place while downloading a file.")
                    print("Error took place while downloading a file. Error description: %@", error?.localizedDescription as Any);
                }
            }
            task.resume()
            
        }
    }
}
