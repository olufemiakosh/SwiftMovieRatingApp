//
//  ViewController.swift
//  OMDB Search
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchField: UITextField!
    
    @IBOutlet weak var typeSegmentControl: UISegmentedControl!
    
    @IBOutlet weak var yearField: UITextField!
    
    @IBOutlet weak var plotSegment: UISegmentedControl!
    
    let movieTypes = ["movie", "series", ""]
    
    var searchFiltes: SearchFilters = SearchFilters()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "showMovieResults"){
            let nextVC = segue.destination as! SearchResultsViewController
            nextVC.searchFiltes = self.searchFiltes
        }
    }
    
    func fetchMovies() async throws -> [MovieResult]? {
        // Prepare the URL request.
        guard let url = URL(string: "https://www.omdbapi.com/?apikey=5ea0f2d4&s=harry&type=series&r=json") else { return nil }
        let request = URLRequest.init(url: url)
        
        // Fetch the remote data.
        let (data, _) = try await URLSession.shared.data(for: request)
        
        // Decode data to a CatFact object.
        let movies = try JSONDecoder().decode([MovieResult].self, from: data)
        
        // Return the fact string value.
        return movies
    }
    
    @IBAction func typeControlChanged(_ sender: Any) {
    }
    
    @IBAction func plotControlChanged(_ sender: Any) {
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        if(searchField.text == ""){
            return
        }
        
        searchFiltes.title = searchField.text!
        searchFiltes.year = yearField.text!
        searchFiltes.type = movieTypes[typeSegmentControl.selectedSegmentIndex]
        
        self.performSegue(withIdentifier: "showMovieResults", sender: self)
    }
    

}

