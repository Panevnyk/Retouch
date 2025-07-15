import Foundation
import Testing
@testable import RetouchDomain

@Suite(.tags(.model))
struct PresentableRetouchGroupTests {

    @Test
    func initializesFromRetouchGroup() {
        let tag1 = RetouchTag(id: "1", title: "Smooth Skin", price: 10, orderNumber: 1)
        let group = RetouchGroup(id: "g1", title: "Face", image: "face.png", price: 30, orderNumber: 1, tags: [tag1])

        let presentable = PresentableRetouchGroup(retouchGroup: group)

        #expect(presentable.id == "g1")
        #expect(presentable.tags.count == 1)
        #expect(!presentable.isSelected)
        #expect(presentable.descriptionForDesigner == "")
    }

    @Test
    func selectsAndDeselectsTagsCorrectly() {
        let tag1 = RetouchTag(id: "1", title: "Smooth Skin", price: 10, orderNumber: 1)
        let tag2 = RetouchTag(id: "2", title: "Whiten Teeth", price: 12, orderNumber: 2, tagDescription: "make them shine")
        let group = RetouchGroup(id: "g2", title: "Smile", image: "image.png", price: 10, orderNumber: 1, tags: [tag1, tag2])

        let presentable = PresentableRetouchGroup(retouchGroup: group)

        presentable.update(by: 0, isOpened: true)
        presentable.update(by: 1, isOpened: true)

        #expect(presentable.selectedRetouchTags.count == 2)
        #expect(presentable.isSelected)
        #expect(presentable.descriptionForDesigner == "Smooth Skin, Whiten Teeth (make them shine)")

        presentable.update(by: 0, isOpened: false)

        #expect(presentable.selectedRetouchTags.count == 1)
        #expect(presentable.descriptionForDesigner == "Whiten Teeth (make them shine)")

        presentable.update(by: 1, isOpened: false)

        #expect(presentable.selectedRetouchTags.isEmpty)
        #expect(!presentable.isSelected)
        #expect(presentable.descriptionForDesigner == "")
    }

    @Test
    func equatableWorksCorrectly() {
        let tag = RetouchTag(id: "1", title: "Fix Hair", price: 5, orderNumber: 1, tagDescription: "side strands")
        let baseGroup = RetouchGroup(id: "g2", title: "Smile", image: "image.png", price: 10, orderNumber: 1, tags: [tag])

        let a = PresentableRetouchGroup(retouchGroup: baseGroup)
        let b = PresentableRetouchGroup(retouchGroup: baseGroup)

        #expect(a == b)

        a.update(by: 0, isOpened: true)

        #expect(a != b)

        b.update(by: 0, isOpened: true)

        #expect(a == b)
    }
}

