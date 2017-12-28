//
//  ViewController.swift
//  upload_images

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    @IBOutlet var image: UIImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    @IBAction func selectPicture(_ sender: AnyObject)
    {
        let ImagePicker = UIImagePickerController()
        ImagePicker.delegate = self
        ImagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(ImagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        image.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func upload_request(_ sender: AnyObject)
    {
        UploadRequest()
    }
    
    func UploadRequest()
    {
        // let url = NSURL(string: "http://www.kaleidosblog.com/tutorial/upload.php")
        
        let url = URL(string: "http://192.168.1.109/Jahanvi/upload_image/upload.php")
        
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        
        let boundary = generateBoundaryString()
  
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        if (image.image == nil)
        {
            return
        }
        
        let image_data = UIImagePNGRepresentation(image.image!)
        
        if(image_data == nil)
        {
            return
        }

        let body = NSMutableData()
        
        let fname = "image1.png"
        let mimetype = "image/png"

        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"test\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("hi\r\n".data(using: String.Encoding.utf8)!)
        
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"file\"; filename=\"\(fname)\"\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append(image_data!)
        body.append("\r\n".data(using: String.Encoding.utf8)!)
        
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
    
        request.httpBody = body as Data
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (
            data, response, error) in
            
            guard ((data) != nil), let _:URLResponse = response, error == nil else
            {
                print("error")
                return
            }
            
            if let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            {
                print(dataString)
            }
        })
        task.resume()
    }
    
    func generateBoundaryString() -> String
    {
        return "Boundary-\(UUID().uuidString)"
    }
}


//With name

/*
<?php
error_reporting(0);

if (move_uploaded_file($_FILES['file']['tmp_name'], "image.png"))
{
    echo "File uploaded: ".$_FILES["file"]["name"];	
}
else
{
    echo "No Saved";
}
*/

// Without name
/*
<?php
error_reporting(0);

move_uploaded_file($_FILES["image"]["tmp_name"], $_FILES["image"]["name"]);
 
 $result = array();
 //$result["user"] = $user;
 $result["message"] = "Success!";
 //$result["files"] = $_FILES;
 //$result["post"] = $_POST;
 echo json_encode($result);
*/
