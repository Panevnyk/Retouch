//
//  SelectedRetouchTag.swift
//  RetouchDesignSystem
//
//  Created by Panevnyk Vlad on 08.06.2021.
//

public final class SelectedRetouchTag: Decodable {
    public var id: String
    public var retouchTagId: String
    public var retouchTagTitle: String
    public var retouchTagPrice: Int
    public var retouchTagDescription: String?

    // CodingKeys
    enum CodingKeys: String, CodingKey {
        case id, retouchTagId, retouchTagTitle, retouchTagPrice, retouchTagDescription
    }
    
    // MARK: - Init
    public init(id: String,
                retouchTagId: String,
                retouchTagTitle: String,
                retouchTagPrice: Int,
                retouchTagDescription: String?
    ) {
        self.id = id
        self.retouchTagId = retouchTagId
        self.retouchTagTitle = retouchTagTitle
        self.retouchTagPrice = retouchTagPrice
        self.retouchTagDescription = retouchTagDescription
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        retouchTagId = try container.decode(String.self, forKey: .retouchTagId)
        retouchTagTitle = try container.decode(String.self, forKey: .retouchTagTitle)

        retouchTagPrice = try container.decode(Int.self, forKey: .retouchTagPrice)
        retouchTagDescription = try? container.decode(String?.self, forKey: .retouchTagDescription)
    }
}
