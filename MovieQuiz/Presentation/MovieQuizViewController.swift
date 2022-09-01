/*
 Данная работа заняла у меня очень много времени. Я столкнулся с трудностями почти
 на каждом этапе.
 При этом задание из 3 спринта я сделал на пару минут, без чьей либо помощи.
 Так вышло, что от наставников вовремя помощь не получил,
 поэтому собирал с мира по коду :D,
 Я долго анализировал каждую функцию, сейчас мне все понятно процентов на 90%
 Макет реализован, приложение работает и не вылетает,
 тем не менее у меня есть 3 главных вопроса и я хотел бы получить на них ответ,
 заранее спасибо!
 
 1
 private func show(quiz step: QuizStepViewModel) {
 imageView.image = step.image
  textLabel.text = step.question
  counterLabel.text = step.questionNumber
imageView.layer.borderColor = UIColor.ypBlack.cgColor
}
 Я писал ее реализацию разными способами и все рабочие, но самый короткий оказался тот, где указывается step.формат
 imageView.image = step.image ( почему step??)
 
 2
 Рамка вокруг картинки.
 Каждый раз когда я нажимаю на да или нет, появляется цвет рамки, но при этом при переходе
 на следующий вопрос цвет не исчезает, я перепробовал разное, но не нашел ничего проще и понятнее, чем сделать изначально рамку черную, что то типа shadow эффект, поэтому при переходе на другой вопрос цсет с зеленого или красного меняется на черный, я понимаю, что это лишние действия, но по другому я не смог, увы.
 3
 Адаптация под Iphone 8 и старшt. Как бы я не старался, констренйты дают сбой при запуске на этих устройствах,я думаю, что решение выглядит как написание какого то расширения для этих устройств с указанием констрейнтов, но как его правильно написать пока не понял, и где его запускать( веротяно где то во ViewDidLoad)
 */



import UIKit

final class MovieQuizViewController: UIViewController {
    
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var textLabel: UILabel!
    
    @IBOutlet private weak var counterLabel: UILabel!
    
    @IBOutlet weak var yesButton: UIButton!
    
    @IBOutlet weak var noButton: UIButton!
    
    private var currentQuestionIndex: Int = 0
    
    private var correctAnswers: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        show(quiz: convert(model: questions[currentQuestionIndex]))
    }

    
    @IBAction func yesButtonClicked(_ sender: Any) {
    showAnswerResult(isCorrect: questions[currentQuestionIndex].correctAnswer == true)
    }
    
    @IBAction func noButtonClicked(_ sender: Any) {
    showAnswerResult(isCorrect: questions[currentQuestionIndex].correctAnswer != true)
    }
    
    private func show(quiz step: QuizStepViewModel) {
              imageView.image = step.image
               textLabel.text = step.question
               counterLabel.text = step.questionNumber
        imageView.layer.borderColor = UIColor.ypBlack.cgColor
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
                correctAnswers += 1
            }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
        self.showNextQuestionOrResults()
        }
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) {
            _ in
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            let firstQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel)
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 {
            let text = "Ваш результат: \(correctAnswers) из 10"
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            show(quiz: viewModel)
        } else {
            imageView.layer.borderColor = UIColor.ypBlack.cgColor
            currentQuestionIndex += 1
            let nextQuestion = questions[currentQuestionIndex]
            let viewModel = convert(model: nextQuestion)
            show(quiz: viewModel)
        }

    }
    
    struct QuizStepViewModel {
      let image: UIImage
      let question: String
      let questionNumber: String
    }

    struct QuizResultsViewModel {
      let title: String
      let text: String
      let buttonText: String
    }
    
    private struct QuizQuestion {
      let image: String
      let text: String
      let correctAnswer: Bool
    }

    private let questions: [QuizQuestion] = [
            QuizQuestion(
                image: "The Godfather",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),
            QuizQuestion(
                image: "The Dark Knight",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),
            QuizQuestion(
                image: "Kill Bill",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),
            QuizQuestion(
                image: "The Avengers",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),
            QuizQuestion(
                image: "Deadpool",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),
            QuizQuestion(
                image: "The Green Knight",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),
            QuizQuestion(
                image: "Old",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: false),
            QuizQuestion(
                image: "The Ice Age Adventures of Buck Wild",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: false),
            QuizQuestion(
                image: "Tesla",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: false),
            QuizQuestion(
                image: "Vivarium",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: false)
        ]
}


