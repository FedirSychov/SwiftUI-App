//
//  CourseStore.swift
//  MySwiftUIApp
//
//  Created by Fedor Sychev on 18.09.2021.
//

import SwiftUI
import Contentful
import Combine

let client = Client(spaceId: "t1epo0019ep3", accessToken: "TlJd_lYXa0meZphO_9Okwsbvmbb6CBnSN2uTQuV2Wto")

func getArray(id: String, completion: @escaping([Entry]) -> ()) {
    let query = Query.where(contentTypeId: id)
    
    client.fetchArray(of: Entry.self, matching: query) { result in
        switch result {
        case .success(let array):
            DispatchQueue.main.async {
                completion(array.items)
            }
        case .failure(let error):
            print(error)
        }
    }
}

class courseStore: ObservableObject {
    @Published var courses: [Course] = courseData
    
    init() {
        let colors = [
            #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1),
            #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1),
            #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1),
            #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1),
            #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        ]
        var index = 0
        
        getArray(id: "course") { (items) in
            items.forEach { item in
                print(item.fields["title"] as! String)
                self.courses.append(Course(
                                        title: item.fields["title"] as! String,
                                        subtitle: item.fields["subtitle"] as! String,
                                        image: item.fields.linkedAsset(at: "image")?.url ?? URL(string: "")!,
                                        logo: #imageLiteral(resourceName: "Logo1"),
                                        color: colors[index],
                                        show: false)
                )
                index = index + 1
            }
        }
    }
}
