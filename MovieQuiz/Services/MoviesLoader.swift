import Foundation

protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

struct MoviesLoader: MoviesLoading {
    // MARK: - NetworkClient
    private let networkClient: NetworkRouting
    
    init(networkClient: NetworkRouting = NetworkClient()) {
        self.networkClient = networkClient
    }
    
    // MARK: - URL
    private var mostPopularMoviesUrl: URL {
        guard let url = URL(string: "https://imdb-api.com/en/API/Top250Movies/k_h7m0bhlk") else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }
    
    private enum DecodingError: Error {
        case errorInCode
    }
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
            switch result {
            case .failure(let error): handler(.failure(error))
            case .success(let data):
                let topMovieList = try? JSONDecoder().decode(MostPopularMovies.self, from: data)
                if let topMovieList = topMovieList {
                    handler(.success(topMovieList)) } else {
                        handler(.failure(DecodingError.errorInCode))
                    }
            }
        }
    }
}

