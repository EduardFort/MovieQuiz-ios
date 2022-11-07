import Foundation

class QuestionFactory: QuestionFactoryProtocol {
    
    private var delegate: QuestionFactoryDelegate?
    private let moviesLoader: MoviesLoading
    private var index = 0
    private var movies: [MostPopularMovie] = []
    
    init(delegate: QuestionFactoryDelegate?, moviesLoader: MoviesLoading) {
        self.delegate = delegate
        self.moviesLoader = moviesLoader
        
    }
    
    enum QuestionError: Error {
        case imageError
    }
    
    func loadData() {
        moviesLoader.loadMovies { result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else { return }
            
            var imageData = Data()
            
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.didFailToLoadData(with: QuestionError.imageError)
                    return
                }
            }
            
           let rating = Float(movie.rating) ?? 0
            
            let randomRate = (Float.random(in: 8.0...9.2) * 10).rounded() / 10
            
            let randomPhraseArray: [String] = ["больше","меньше"]
            
            let phrase = randomPhraseArray.randomElement()
            
            guard let phrase = phrase else {return}
            
            let text = "Рейтинг этого фильма \(phrase) чем \(randomRate)?"
            
            let correctAnswerIfMore = rating > randomRate
            
            let correctAnswerIfLess = rating < randomRate
            
            let correctAnswer = randomPhraseArray[0] == phrase ? correctAnswerIfMore : correctAnswerIfLess
           
            let question = QuizQuestion(image: imageData,
                                        text: text,
                                        correctAnswer: correctAnswer)
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didRecieveNextQuestion(question: question)
            }
            
        }
    }
    func resetIndex() {
        index = 0
    }
}


