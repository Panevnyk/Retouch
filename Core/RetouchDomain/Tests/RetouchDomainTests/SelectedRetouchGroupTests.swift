import Foundation
import Testing
@testable import RetouchDomain

@Suite(.tags(.model))
struct SelectedRetouchGroupTests {
    
    @Test
    func decodesFullJSONCorrectly() throws {
        let json = """
        {
            "id": "group1",
            "retouchGroupId": "rg001",
            "retouchGroupTitle": "Face Retouching",
            "selectedRetouchTags": [
                { "id": "tag1", "retouchTagId": "1234", "retouchTagTitle": "Title", "retouchTagPrice": 10 },
                { "id": "tag2", "retouchTagId": "1234", "retouchTagTitle": "Title", "retouchTagPrice": 10 }
            ],
            "descriptionForDesigner": "Remove blemishes and smooth skin."
        }
        """.data(using: .utf8)!

        let decoded = try JSONDecoder().decode(SelectedRetouchGroup.self, from: json)

        #expect(decoded.id == "group1")
        #expect(decoded.retouchGroupId == "rg001")
        #expect(decoded.retouchGroupTitle == "Face Retouching")
        #expect(decoded.selectedRetouchTags.map(\.self.id) == [SelectedRetouchTag(id: "tag1").id, SelectedRetouchTag(id: "tag2").id])
        #expect(decoded.descriptionForDesigner == "Remove blemishes and smooth skin.")
    }

    @Test
    func decodesWithEmptyTagsWhenMissing() throws {
        let json = """
        {
            "id": "group2",
            "retouchGroupId": "rg002",
            "retouchGroupTitle": "Background Fix",
            "selectedRetouchTags": [],
            "descriptionForDesigner": "Fix background imperfections."
        }
        """.data(using: .utf8)!

        let decoded = try JSONDecoder().decode(SelectedRetouchGroup.self, from: json)

        #expect(decoded.id == "group2")
        #expect(decoded.retouchGroupId == "rg002")
        #expect(decoded.retouchGroupTitle == "Background Fix")
        #expect(decoded.selectedRetouchTags.isEmpty)
        #expect(decoded.descriptionForDesigner == "Fix background imperfections.")
    }

    @Test
    func throwsWhenRequiredFieldMissing() {
        let json = """
        {
            "id": "group3",
            "retouchGroupId": "rg003",
            "retouchGroupTitle": "Hair Fix"
        }
        """.data(using: .utf8)!

        #expect(throws: DecodingError.self, performing: {
            _ = try JSONDecoder().decode(SelectedRetouchGroup.self, from: json)
        })
    }

    @Test
    func throwsWhenWrongTypeUsed() {
        let json = """
        {
            "id": 123,
            "retouchGroupId": "rg004",
            "retouchGroupTitle": "Makeup",
            "selectedRetouchTags": [],
            "descriptionForDesigner": "Add light makeup."
        }
        """.data(using: .utf8)!

        #expect(throws: DecodingError.self, performing: {
            _ = try JSONDecoder().decode(SelectedRetouchGroup.self, from: json)
        })
    }
}

extension SelectedRetouchTag {
    convenience init(id: String) {
        self.init(
            id: id,
            retouchTagId: "1234",
            retouchTagTitle: "Test title",
            retouchTagPrice: 0,
            retouchTagDescription: nil
        )
    }
}
