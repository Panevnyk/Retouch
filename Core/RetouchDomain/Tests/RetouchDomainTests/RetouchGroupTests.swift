import Foundation
import Testing
@testable import RetouchDomain

@Suite(.tags(.model))
struct RetouchGroupTests {

    @Test
    func decodesFullValidJSON() throws {
        let json = """
        {
            "id": "g1",
            "title": "Face Retouch",
            "image": "face.png",
            "price": 100,
            "orderNumber": 1,
            "tags": [
                {
                    "id": "t1",
                    "title": "Smooth Skin",
                    "price": 20,
                    "orderNumber": 1
                }
            ]
        }
        """.data(using: .utf8)!

        let group = try JSONDecoder().decode(RetouchGroup.self, from: json)

        #expect(group.id == "g1")
        #expect(group.title == "Face Retouch")
        #expect(group.image == "face.png")
        #expect(group.price == 100)
        #expect(group.orderNumber == 1)
        #expect(group.tags.count == 1)
        #expect(group.tags.first?.title == "Smooth Skin")
    }

    @Test
    func decodesWithMissingTagsDefaultsToEmpty() throws {
        let json = """
        {
            "id": "g2",
            "title": "Hair Fix",
            "image": "hair.jpg",
            "price": 60,
            "orderNumber": 2,
            "tags": []
        }
        """.data(using: .utf8)!

        let group = try JSONDecoder().decode(RetouchGroup.self, from: json)

        #expect(group.tags.isEmpty)
    }

    @Test
    func throwsWhenFieldIsWrongType() {
        let json = """
        {
            "id": "g3",
            "title": "Body Adjust",
            "image": "body.png",
            "price": "free",
            "orderNumber": 3,
            "tags": []
        }
        """.data(using: .utf8)!

        #expect(throws: DecodingError.self, performing: {
            _ = try JSONDecoder().decode(RetouchGroup.self, from: json)
        })
    }

    @Test
    func defaultValuesAreUsedWhenNotDecoded() {
        let group = RetouchGroup(id: "1234", title: "Title", image: "image.png", price: 15, orderNumber: 4321, tags: [])

        #expect(group.id == "1234")
        #expect(group.title == "Title")
        #expect(group.image == "image.png")
        #expect(group.price == 15)
        #expect(group.orderNumber == 4321)
        #expect(group.tags.isEmpty)
    }
}
