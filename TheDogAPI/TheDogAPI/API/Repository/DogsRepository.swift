//
//  DogsRepository.swift
//  TheDogAPI
//
//  Created by Gustavo Quenca on 02/08/2023.
//

import UIKit

protocol DogsRepositoryProtocol {
    func fetchRandomDog(page: Int, limit: Int, completion: @escaping ([Dog]?, Error?) -> Void)
}

class DogsRepository: DogsRepositoryProtocol {
    
    func fetchRandomDog(page: Int = 1, limit: Int = 10, completion: @escaping ([Dog]?, Error?) -> Void) {
        let urlString = "https://api.thedogapi.com/v1/images/search?limit=\(limit)&page=\(page)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("live_zjNhV7lkUdTG2BtpJD9fvdi8TqZcjjyIMiEeZxgfphr3VGFbeFLOTP8dixl8vUr6", forHTTPHeaderField: "x-api-key")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Data was not retrieved"]))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print(json)
                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }

            do {
                let decoder = JSONDecoder()
                var dogs = try decoder.decode([Dog].self, from: data)
                let group = DispatchGroup() // Create a DispatchGroup to manage the multiple async calls
                
                for (index, dog) in dogs.enumerated() {
                    group.enter() // Enter the group for each async call
                    
                    self.fetchDogDetails(byId: dog.id) { (dogDetails, error) in
                        if let error = error {
                            print("Error fetching dog details:", error)
                        } else if let dogDetails = dogDetails {
                            var updatedDog = dog
                            updatedDog.breeds = dogDetails.breeds
                            dogs[index] = updatedDog
                            print("Dog details:", dogDetails)
                        }
                        group.leave() // Leave the group when the async call is finished
                    }
                }
                
                group.notify(queue: .main) {
                    // All async calls have finished; now call the completion handler with the updated dogs array
                    completion(dogs, nil)
                }
                
            } catch let decodingError {
                completion(nil, decodingError)
            }
        }

        task.resume()
    }
    
    func fetchDogDetails(byId id: String, completion: @escaping (Dog?, Error?) -> Void) {
        let urlString = "https://api.thedogapi.com/v1/images/\(id)"
        guard let url = URL(string: urlString) else {
            completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }

            guard let data = data else {
                completion(nil, NSError(domain: "No data", code: 0, userInfo: nil))
                return
            }

            do {
                let decoder = JSONDecoder()
                let catDetails = try decoder.decode(Dog.self, from: data)
                completion(catDetails, nil)
            } catch let decodeError {
                completion(nil, decodeError)
            }
        }.resume()
    }
}
