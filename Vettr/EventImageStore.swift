//
//  EventImageStore.swift
//  Vettr
//
//  Created by Steven Schwab on 11/27/22.
//

import UIKit
import Supabase

class EventImageStore {
    lazy var client = SupabaseClient(supabaseURL: K.Supabase.projectURL, supabaseKey: K.Supabase.projectAPIkey)
    
    let cache = NSCache<NSString,UIImage>()
    
    // Extend the image store to save images to documents directory on phone as they are added and fetch them as they are needed
    // Create a URL in the documents directory using a given key
    func imageURL(forKey key: String) -> URL {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        
        return documentDirectory.appendingPathComponent(key)
    }
    
    // To save and load an image, copying the JPEG representation into a data buffer
    // Saving image data to filesystem
    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
        
        //Create full URL for image
        let url = imageURL(forKey: key)
        
        //Turn image into JPEG data
        if let data = image.jpegData(compressionQuality: 1.0) {
            //Write it to full URL
            do {
                try data.write(to: url)
            } catch {
                print("Error writing to full URL, \(error.localizedDescription)")
            }
        }
    }
    
    // Load image when it is requested, read in an image from a file, given a URL
    func image(forKey key: String) -> UIImage? {
        if let existingImage = cache.object(forKey: key as NSString) {
            return existingImage
        }
        
        //Create full URL for image and try to load from filesystem if not in cache
        let url = imageURL(forKey: key)
        guard let imageFromDisk = UIImage(contentsOfFile: url.path) else {
            return nil
        }
        
        cache.setObject(imageFromDisk, forKey: key as NSString)
        return imageFromDisk
    }
    
    // When an image is deleted from the store, it is also deleted from the filesystem
    func deleteImage(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
        
        let url = imageURL(forKey: key)
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print("Error removing the image from disk: \(error.localizedDescription)")
        }
    }
    
    func fetchEventImage(for event: Event, completion: @escaping (Result<UIImage, Error>) -> Void) async {
        
        // Checking if event image is in cache
        let photoKey = String(describing: event.id)
        if let image = image(forKey: photoKey) {
            OperationQueue.main.addOperation {
                //Pulling image from cache
                completion(.success(image))
            }
            return
        }
        
        do {
            let data = try await client
                .storage
                .from(id: "events")
                .download(path: "\(photoKey.lowercased())/\(photoKey.lowercased())")
            
            let result = self.processImageRequest(data: data)
            
            if let tempImage = result {
                //Store the image in the ImageStore for the event's UUID
                setImage(tempImage, forKey: photoKey)
                
                OperationQueue.main.addOperation {
                    //Pulling image from API
                    completion(.success(tempImage))
                }
            }

        } catch {
            print("There was an error fetching the event image, \(error.localizedDescription)")
        }

    }
    
    private func processImageRequest(data: Data?) -> UIImage? {
        guard let imageData = data, let image = UIImage(data: imageData) else {
            // Couldn't create an image
            return nil
        }
        
        return image
    }
}
