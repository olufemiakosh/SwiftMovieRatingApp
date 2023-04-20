//
//  MovieDetailViewController.swift
//  OMDB Search
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var yearLabel: UILabel!
    
    @IBOutlet weak var typeLabel: UILabel!
    
    @IBOutlet weak var genreLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var directorLabel: UILabel!
    
    @IBOutlet weak var writerLabel: UILabel!
    
    @IBOutlet weak var imdbRating: UILabel!
    
    @IBOutlet weak var countryLabel: UILabel!
    
    @IBOutlet weak var plotTextView: UITextView!
    
    var selectedMovie: MovieResult? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        fetchMovieDetails { [weak self] (movieDetails) in
            print(movieDetails)
            DispatchQueue.main.async {
                self!.showData(movieDetails: movieDetails)
            }
        }
    }
    
    func fetchMovieDetails(completionHandler: @escaping (ImdbMovieResult) -> Void) {
        var urlString = "https://www.omdbapi.com/?apikey=5ea0f2d4"
        urlString += "&i=\(self.selectedMovie!.imdbID)"
        
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
            let movieDetails = try? JSONDecoder().decode(ImdbMovieResult.self, from: data) {
            completionHandler(movieDetails)
          }
        })
        task.resume()
    }

    func showData(movieDetails: ImdbMovieResult) {
        self.titleLabel.text = movieDetails.Title
        self.yearLabel.text = "Year:\(movieDetails.Year)"
        self.typeLabel.text = "Type:\(movieDetails.Type.capitalized)"
        self.genreLabel.text = "Genre:\(movieDetails.Genre)"
        self.ratingLabel.text = "Rated:\(movieDetails.Rated)"
        self.directorLabel.text = "Director:\(movieDetails.Director)"
        self.writerLabel.text = "Writer:\(movieDetails.Writer)"
        self.imdbRating.text = "IMDB Rating:\(movieDetails.imdbRating)"
        self.countryLabel.text = "Country:\(movieDetails.Country)"
        self.plotTextView.text = "Plot:\(movieDetails.Plot)"
        
        self.loadImage(url: movieDetails.Poster)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func loadImage(url: String) {
        DispatchQueue.global().async {
            print(url)
            let url = URL(string: url)!
            let data = try? Data(contentsOf: url)
            DispatchQueue.main.async {
                self.posterImageView.image = UIImage(data: data!)
            }
        }
    }

}
