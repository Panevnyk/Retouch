import Foundation
import Testing
@testable import RetouchDomain

@Suite(.tags(.model))
struct RetouchTagTests {

    @Test
    func decodesWithAllFieldsPresent() throws {
        let json = """
        {
            "id": "tag1",
            "title": "Skin Smoothing",
            "price": 20,
            "orderNumber": 1,
            "tagDescription": "Removes blemishes and evens skin tone."
        }
        """.data(using: .utf8)!

        let tag = try JSONDecoder().decode(RetouchTag.self, from: json)

        #expect(tag.id == "tag1")
        #expect(tag.title == "Skin Smoothing")
        #expect(tag.price == 20)
        #expect(tag.orderNumber == 1)
        #expect(tag.tagDescription == "Removes blemishes and evens skin tone.")
    }

    @Test
    func decodesWithoutOptionalDescription() throws {
        let json = """
        {
            "id": "tag2",
            "title": "Teeth Whitening",
            "price": 15,
            "orderNumber": 2
        }
        """.data(using: .utf8)!

        let tag = try JSONDecoder().decode(RetouchTag.self, from: json)

        #expect(tag.id == "tag2")
        #expect(tag.title == "Teeth Whitening")
        #expect(tag.price == 15)
        #expect(tag.orderNumber == 2)
        #expect(tag.tagDescription == nil)
    }

    @Test
    func throwsWhenRequiredFieldMissing() {
        let json = """
        {
            "title": "Eyes Brightening",
            "price": 10,
            "orderNumber": 3
        }
        """.data(using: .utf8)!

        #expect(throws: DecodingError.self, performing: {
            _ = try JSONDecoder().decode(RetouchTag.self, from: json)
        })
    }

    @Test
    func throwsWhenFieldHasWrongType() {
        let json = """
        {
            "id": "tag4",
            "title": "Enhance Jawline",
            "price": "twenty",
            "orderNumber": 4
        }
        """.data(using: .utf8)!

        #expect(throws: DecodingError.self, performing: {
            _ = try JSONDecoder().decode(RetouchTag.self, from: json)
        })
    }

    @Test
    func equatableComparison() {
        let tagA = RetouchTag(id: "1", title: "A", price: 10, orderNumber: 1)
        tagA.tagDescription = "desc"

        let tagB = RetouchTag(id: "1", title: "A", price: 10, orderNumber: 1)
        tagB.tagDescription = "desc"

        let tagC = RetouchTag(id: "2", title: "B", price: 15, orderNumber: 2)

        #expect(tagA == tagB)
        #expect(tagA != tagC)
    }
}

