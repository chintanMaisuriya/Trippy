//
//  EditProfileRequest.swift
//  Trippy_MVCExample
//
//  Created by Chintan Maisuriya on 29/06/21.
//  Copyright © 2021 Chintan. All rights reserved.
//

import Foundation


struct EditProfileRequest: Codable
{
    var name            : String = ""
    var imageURL        : String = ""
    var image           : UIImage? = nil
    var isImageUpdated  : Bool = false

    private enum CodingKeys : String, CodingKey { case name, imageURL, image, isImageUpdated }
    
    
    internal init(name: String = "", imageURL: String = "", image: UIImage? = nil, isImageUpdated: Bool = false)
    {
        self.name           = name
        self.imageURL       = imageURL
        self.image          = image
        self.isImageUpdated = isImageUpdated
    }
    
    
    var asDictionary : [String : Any] {
        let mirror = Mirror(reflecting: self)
        let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label:String?, value:Any) -> (String, Any)? in
            guard let label = label else { return nil }
            guard (!label.isEqualToString(find: "image") && !(label.isEqualToString(find: "isImageUpdated"))) else { return nil }
            
            if (label.isEqualToString(find: "imageURL") && ((value as? String ?? "").isEmpty))
            {
                return nil
            }

            return (label, value)
        }).compactMap { $0 })
        return dict
    }
    
    
    init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        imageURL = try container.decodeIfPresent(String.self, forKey: .imageURL) ?? ""
        isImageUpdated = try container.decodeIfPresent(Bool.self, forKey: .isImageUpdated) ?? false

        if let avatarData = try? container.decode(Data.self, forKey: .image)
        {
            image = UIImage(data: avatarData)
        }
    }
    
    func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(imageURL, forKey: .imageURL)
        try container.encode(isImageUpdated, forKey: .isImageUpdated)

        if let avatarImage = image
        {
            let encodedImage = avatarImage.jpegData(compressionQuality: 0.75)
            try container.encode(encodedImage, forKey: .image)
        }
    }
}
