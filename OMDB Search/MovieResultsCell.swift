//
//  MovieResultsCell.swift
//  OMDB Search
//

import UIKit

class MovieResultsCell: UITableViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imdbLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadImage(url: String) {
        DispatchQueue.global().async {
            print(url)
            let url = URL(string: url)!
            let data = try? Data(contentsOf: url)
            DispatchQueue.main.async {
                if((data) != nil){
                    self.posterImageView.image = UIImage(data: data!)
                }
            }
        }
    }
    
    func loadData(movie: MovieResult) {
        self.posterImageView.contentMode = .scaleAspectFill
        self.titleLabel.text = movie.Title
        self.imdbLabel.text = "IMDB: \(movie.imdbID)"
        self.yearLabel.text = "Year: \(movie.Year)"
        self.typeLabel.text = "Type: \(movie.Type.capitalized)"
        self.loadImage(url: movie.Poster)
        
    }

}
