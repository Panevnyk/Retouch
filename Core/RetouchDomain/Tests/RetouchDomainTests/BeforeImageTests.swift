import Foundation
import Testing
@testable import RetouchDomain

@Suite(.tags(.model))
struct BeforeImageTests {
    @Test
    func decodesValidJSON() throws {
        let json = """
        {
            "image": "before.jpg"
        }
        """.data(using: .utf8)!

        let decoded = try JSONDecoder().decode(BeforeImage.self, from: json)

        #expect(decoded.image == "before.jpg")
    }

    @Test
    func decodingFailsWhenImageMissing() async throws {
        let json = "{}".data(using: .utf8)!

        #expect(throws: DecodingError.self, performing: {
            try JSONDecoder().decode(BeforeImage.self, from: json)
        })
    }

    @Test
    func decodingFailsWithWrongType() {
        let json = """
        {
            "image": 123
        }
        """.data(using: .utf8)!

        #expect(throws: DecodingError.self, performing: {
            try JSONDecoder().decode(BeforeImage.self, from: json)
        })
    }
}
