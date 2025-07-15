public final class SelectedRetouchTag: Decodable {
    public var id: String
    public var retouchTagId: String
    public var retouchTagTitle: String
    public var retouchTagPrice: Int
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
