import Foundation
import Testing
@testable import RetouchDomain

@Suite(.tags(.model))
struct SelectedRetouchTagTests {

    @Test
    func decodesFullJSONCorrectly() throws {
        let json = """
        {
            "id": "tag1",
            "retouchTagId": "t001",
            "retouchTagTitle": "Skin Smoothing",
            "retouchTagPrice": 15,
            "retouchTagDescription": "Smooth out uneven skin tones."
        }
        """.data(using: .utf8)!

        let tag = try JSONDecoder().decode(SelectedRetouchTag.self, from: json)

        #expect(tag.id == "tag1")
        #expect(tag.retouchTagId == "t001")
        #expect(tag.retouchTagTitle == "Skin Smoothing")
        #expect(tag.retouchTagPrice == 15)
        #expect(tag.retouchTagDescription == "Smooth out uneven skin tones.")
    }

    @Test
    func decodesWhenDescriptionIsMissing() throws {
        let json = """
        {
            "id": "tag2",
            "retouchTagId": "t002",
            "retouchTagTitle": "Whitening",
            "retouchTagPrice": 10
        }
        """.data(using: .utf8)!

        let tag = try JSONDecoder().decode(SelectedRetouchTag.self, from: json)

        #expect(tag.id == "tag2")
        #expect(tag.retouchTagId == "t002")
        #expect(tag.retouchTagTitle == "Whitening")
        #expect(tag.retouchTagPrice == 10)
        #expect(tag.retouchTagDescription == nil)
    }

    @Test
    func throwsWhenRequiredFieldIsMissing() {
        let json = """
        {
            "id": "tag3",
            "retouchTagTitle": "Sharpen Eyes",
            "retouchTagPrice": 12
        }
        """.data(using: .utf8)!

        #expect(throws: DecodingError.self, performing: {
            _ = try JSONDecoder().decode(SelectedRetouchTag.self, from: json)
        })
    }

    @Test
    func throwsWhenPriceIsWrongType() {
        let json = """
        {
            "id": "tag4",
            "retouchTagId": "t004",
            "retouchTagTitle": "Enhance Lips",
            "retouchTagPrice": "twenty",
            "retouchTagDescription": "Make lips pop."
        }
        """.data(using: .utf8)!

        #expect(throws: DecodingError.self, performing: {
            _ = try JSONDecoder().decode(SelectedRetouchTag.self, from: json)
        })
    }
}

