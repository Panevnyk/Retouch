public final class SelectedRetouchGroup: Decodable {
    public let id: String
    public let retouchGroupId: String
    public let retouchGroupTitle: String
    public var selectedRetouchTags: [SelectedRetouchTag]
    public var descriptionForDesigner: String

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
}
