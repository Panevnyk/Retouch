//
//  SelectedRetouchGroup.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 23.02.2021.
//

public final class SelectedRetouchGroup: Decodable {
    public var id: String
    public var retouchGroupId: String
    public var retouchGroupTitle: String
    public var selectedRetouchTags: [SelectedRetouchTag]
    public var descriptionForDesigner: String
    
    // CodingKeys
    enum CodingKeys: String, CodingKey {
        case id, retouchGroupId, retouchGroupTitle, selectedRetouchTags, descriptionForDesigner
    }

    // MARK: - Init
    public init(id: String,
                retouchGroupId: String,
                retouchGroupTitle: String,
                selectedRetouchTags: [SelectedRetouchTag],
                descriptionForDesigner: String
    ) {
        self.id = id
        self.retouchGroupId = retouchGroupId
        self.retouchGroupTitle = retouchGroupTitle
        self.selectedRetouchTags = selectedRetouchTags
        self.descriptionForDesigner = descriptionForDesigner
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        retouchGroupId = try container.decode(String.self, forKey: .retouchGroupId)
        retouchGroupTitle = try container.decode(String.self, forKey: .retouchGroupTitle)

        selectedRetouchTags = (try? container.decode([SelectedRetouchTag].self, forKey: .selectedRetouchTags)) ?? []
        descriptionForDesigner = try container.decode(String.self, forKey: .descriptionForDesigner)
    }
}
