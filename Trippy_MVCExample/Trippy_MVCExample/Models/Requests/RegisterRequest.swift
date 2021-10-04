//
//  RegisterRequest.swift
//  Trippy_MVCExample
//
//  Created by Chintan Maisuriya on 23/06/21.
//  Copyright © 2021 Chintan. All rights reserved.
//

import Foundation


struct RegisterRequest: Codable
{
    var id         : String = ""
    var name       : String = ""
    var email      : String = ""
    var password   : String = ""
    var imageURL   : String = ""
    var image      : UIImage? = nil
    
    private enum CodingKeys : String, CodingKey { case id, name, email, password, imageURL, image }
    
    
    internal init(id: String = "", name: String = "", email: String = "", password: String = "", imageURL: String = "", image: UIImage? = nil)
    {
        self.id             = id
        self.name           = name
        self.email          = email
        self.password       = password
        self.imageURL       = imageURL
        self.image          = image
    }
    
    
    var asDictionary : [String : Any] {
        let mirror = Mirror(reflecting: self)
        let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label:String?, value:Any) -> (String, Any)? in
            guard let label = label else { return nil }
            guard (!label.isEqualToString(find: "password") && !label.isEqualToString(find: "image")) else { return nil }
            return (label, value)
        }).compactMap { $0 })
        return dict
    }
    
    
    init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id) ?? ""
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        email = try container.decodeIfPresent(String.self, forKey: .email) ?? ""
        password = try container.decodeIfPresent(String.self, forKey: .password) ?? ""
        imageURL = try container.decodeIfPresent(String.self, forKey: .imageURL) ?? ""

        if let avatarData = try? container.decode(Data.self, forKey: .image)
        {
            image = UIImage(data: avatarData)
        }
    }
    
    func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(email, forKey: .email)
        try container.encode(password, forKey: .password)
        try container.encode(imageURL, forKey: .imageURL)

        if let avatarImage = image
        {
            let encodedImage = avatarImage.jpegData(compressionQuality: 0.75)
            try container.encode(encodedImage, forKey: .image)
        }
    }
}



extension Mirror
{
    func snakeKeyDictionary() -> [String: Any] {
        var dictionary = [String: Any]()
        for (key, value) in self.children {
            if let key = key {
                let snakeKey = key.replacingOccurrences(of: #"[A-Z]"#, with: "_$0", options: .regularExpression).lowercased()
                dictionary[snakeKey] = value
            }
        }
        return dictionary
    }
}
