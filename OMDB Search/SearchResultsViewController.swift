//
//  SearchResultsViewController.swift
//  OMDB Search
//

import UIKit

class SearchResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var movies: [MovieResult] = []
    
    var searchFiltes: SearchFilters = SearchFilters()
    
    var selectedMovie: MovieResult? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        fetchFilms { [weak self] (searchResult) in
            print(searchResult.Search.count)
            self!.movies = searchResult.Search
            DispatchQueue.main.async {
                self!.tableView.reloadData()
            }
        }
    }
    
    func fetchFilms(completionHandler: @escaping (SearchResult) -> Void) {
        var urlString = "https://www.omdbapi.com/?apikey=5ea0f2d4&page=1"
        urlString += "&s=\(searchFiltes.title)"
        if(searchFiltes.type != ""){
            urlString += "&type=\(searchFiltes.type)"
        }
        if(searchFiltes.year != ""){
            urlString += "&y=\(searchFiltes.year)"
        }
        
        print(urlString)
        
        let url = URL(string: urlString)!

        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
          if let error = error {
            print("Error with fetching films: \(error)")
            return
          }
          
          guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
              print("Error with the response, unexpected status code: \(String(describing: response))")
            return
          }

          if let data = data,
            let searchResult = try? JSONDecoder().decode(SearchResult.self, from: data) {
            completionHandler(searchResult)
          }
        })
        task.resume()
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "showMovieDetail"){
            let nextVC = segue.destination as! MovieDetailViewController
            nextVC.selectedMovie = self.selectedMovie
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieResultsCell", for: indexPath as IndexPath) as! MovieResultsCell
        
        cell.loadData(movie: self.movies[indexPath.row])
        cell.selectionStyle = .none

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedMovie = self.movies[indexPath.row]
        self.performSegue(withIdentifier: "showMovieDetail", sender: self)
    }

}
