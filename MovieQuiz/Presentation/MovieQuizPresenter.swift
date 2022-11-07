import Foundation
import UIKit

final class MovieQuizPresenter {
    
    var currentQuestion: QuizQuestion?
    let questionsAmount: Int = 10
    var currentQuestionIndex: Int = 0
    var correctAnswers: Int = 0
    var questionFactory: QuestionFactoryProtocol?
    var staticService: StaticService? = StaticServiceImplementation()
    weak var viewController: MovieQuizViewController?
    lazy var alertPresenter = AlertPresenter(viewController: self.viewController)
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
     func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        viewController?.showAnswerResult(isCorrect:currentQuestion.correctAnswer == true)
    }
    
     func didAnswer(isCorrectAnswer: Bool) {
        if isCorrectAnswer {
                correctAnswers += 1
            }
        }
    
    func didRecieveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    func showNextQuestionOrResults() {
        if self.isLastQuestion() {
            guard let staticService = staticService else {return}
            staticService.store(correct: correctAnswers, total: questionsAmount)
            let text = """
            Ваш результат \(correctAnswers)/\(questionsAmount)
            Количество сыгранных квизов: \(staticService.gamesCount)
            Рекорд: \(staticService.bestGame.record())
            Средняя точность: \(String(format: "%.2f", staticService.totalAccuracy))%
            """
            let buttonText = "Сыграть ещё раз"
            let title = "Этот раунд окончен!"
            
            let resultModel = AlertModel(
                title: title,
                message: text,
                buttonText: buttonText)
            
            alertPresenter.showAlert(model: resultModel)
            
            restartGame()
            
            questionFactory?.requestNextQuestion()
            
        } else {
            switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func restartGame() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
}
