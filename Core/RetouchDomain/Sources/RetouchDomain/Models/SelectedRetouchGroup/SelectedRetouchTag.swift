public final class SelectedRetouchTag: Decodable {
    public let id: String
    public let retouchTagId: String
    public let retouchTagTitle: String
    public let retouchTagPrice: Int
    public var retouchTagDescription: String?

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
}
