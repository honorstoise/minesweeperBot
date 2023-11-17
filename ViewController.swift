//
//  ViewController.swift
//  Bombsweeper
//
//  Created by HPro2 on 10/13/21.
//
// I focused most on quality of life changes because the base assignment is just so so so so so bad compared to what I'm used to. changes are listed below
//1. Made different numbers different colors
//2. Made timer start on first click
//3. Made a fully functional pause button ;)
//4. changed color scheme to be closer to google minesweeper
//5. displays low time
//6. 
//
//
//



import UIKit

class ViewController: UIViewController {
    var boardSize: Int = 10
    var board: Board
    var buttons: [Button] = []
    var buttonMargin: CGFloat = 2.0
    var oneSecondTimer: Timer?
    var emptySquares = 0
    var time = 9999999999999
    
    var moves: Int = 0{
        didSet{
            movesLabel.text = "Moves: \(moves)"
        }
    }
    
    var timeTaken: Int = 0{
        didSet{
            timeLabel.text = "Time: \(timeTaken)"
        }
    }
    
    
    @IBOutlet weak var boardView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var movesLabel: UILabel!
    @IBOutlet weak var lowTimeTextField: UITextField!
    
    @IBAction func newGamePressed(_ sender: UIBarButtonItem) {
        print("New Game Pressed")
        startNewGame()
    }
    
    @IBAction func pausePressed(_ sender: UIBarButtonItem) {
        let ac = UIAlertController(title: "OOF !!!", message: "Pausing the game is for dirty cheaters do not pause the game or you will lose.", preferredStyle: .alert)
        let newGameAction = UIAlertAction(title: "New Game", style: UIAlertAction.Style.default) {
            UIAlertAction in self.startNewGame()
        }
        ac.addAction(newGameAction)
        present(ac, animated: true, completion: nil)
        endGame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        board = Board(size: boardSize)
        super.init(coder: aDecoder)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()    }
    
    override func viewDidAppear(_ animated: Bool) {
        initializeBoard()
        startNewGame()
    }

    func initializeBoard(){
        for row in 0..<boardSize{
            for column in 0..<boardSize{
                let square = board.squares[row][column]
                let buttonSize: CGFloat = (boardView.frame.width - buttonMargin * (CGFloat(boardSize - 1))) / CGFloat(boardSize)
                let button = Button(size: buttonSize, margin: buttonMargin, square: square)
                button.addTarget(self, action: #selector(self.buttonPressed(_:)), for: .touchUpInside)
                button.backgroundColor = UIColor.systemGreen
                boardView.addSubview(button)
                buttons.append(button)
            }
        }
    }
    
    @objc func buttonPressed(_ button: Button){
        if !button.square.isShowing{
            if moves == 0 {
                oneSecondTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.oneSecond), userInfo: nil, repeats: true)
            }
            print("Row: \(button.square.row) - Column: \(button.square.column)")
            button.setTitle(button.getLabel(), for: .normal)
            button.backgroundColor = UIColor.systemGreen
            if button.getLabel() == "1"{
                button.setTitleColor(UIColor.blue, for: .normal)
            }else if button.getLabel() == "2"{
                button.setTitleColor(UIColor.green, for: .normal)
            }else if button.getLabel() == "3"{
                button.setTitleColor(UIColor.red, for: .normal)
            }else if button.getLabel() == "4"{
                button.setTitleColor(UIColor.purple, for: .normal)
            }else if button.getLabel() == "5"{
                button.setTitleColor(UIColor.yellow, for: .normal)
            }else if button.getLabel() == "6"{
                button.setTitleColor(UIColor.cyan, for: .normal)
            }else if button.getLabel() == "7"{
                button.setTitleColor(UIColor.black, for: .normal)
            }else if button.getLabel() == "8"{
                button.setTitleColor(UIColor.orange, for: .normal)
            }
            moves += 1
            if button.square.isBomb{
                let ac = UIAlertController(title: "BOOM!", message: "You hit a 💣", preferredStyle: .alert)
                let newGameAction = UIAlertAction(title: "New Game", style: UIAlertAction.Style.default) {
                    UIAlertAction in self.startNewGame()
                }
                ac.addAction(newGameAction)
                present(ac, animated: true, completion: nil)
                endGame()
            }else{
                if button.square.adjBombs == 0{
                    checkForZeros(button: button)
                }
            }
            button.square.isShowing = true
            checkForWin()
        }
        
        for button in buttons{
            if button.square.adjBombs == board.countFilledSquares(square: button.square){
                
                var adjFills = board.getFilledNeighbors(square: button.square)
                for filled in adjFills {
                    filled.isFlagged = true
                    for button in buttons{
                        if (button.square.column == filled.column && button.square.row == filled.row){
                            button.backgroundColor = UIColor.red
                        }
                    }
                }
            }
        }
    }

    func startNewGame(){
        board.resetBoard()
        timeTaken = 0
        moves = 0
        emptySquares = 0
        for button in buttons{
            endGame()
            button.setTitle("", for: .normal)
            button.backgroundColor = UIColor.darkGray
        }
        
    }
    
    @objc func oneSecond(){
        timeTaken += 1
    }
    
    func endGame(){
        oneSecondTimer?.invalidate()
        oneSecondTimer = nil
    }
    
    func checkForZeros(button: Button){
        if !button.square.isShowing{
            button.square.isShowing = true
            button.backgroundColor = UIColor.systemGreen
            button.setTitle(button.getLabel(), for: .normal)
            if button.getLabel() == "1"{
                button.setTitleColor(UIColor.blue, for: .normal)
            }else if button.getLabel() == "2"{
                button.setTitleColor(UIColor.green, for: .normal)
            }else if button.getLabel() == "3"{
                button.setTitleColor(UIColor.red, for: .normal)
            }else if button.getLabel() == "4"{
                button.setTitleColor(UIColor.purple, for: .normal)
            }else if button.getLabel() == "5"{
                button.setTitleColor(UIColor.yellow, for: .normal)
            }else if button.getLabel() == "6"{
                button.setTitleColor(UIColor.cyan, for: .normal)
            }else if button.getLabel() == "7"{
                button.setTitleColor(UIColor.black, for: .normal)
            }else if button.getLabel() == "8"{
                button.setTitleColor(UIColor.orange, for: .normal)
            }
            if button.square.adjBombs == 0{
                for square in board.getNeighbors(square: button.square){
                    for button in buttons{
                        if button.square.row == square.row && button.square.column == square.column{
                            checkForZeros(button: button)
                        }
                    }
                }
            }
        }
    }
    
    func checkForWin(){
        emptySquares = 0
        for button in buttons{
            if button.square.isShowing == true{
                emptySquares += 1
            }
        }
        if (boardSize * boardSize) - board.bombs == emptySquares{
            let ac = UIAlertController(title: "Congratulations!", message: "You did not die!", preferredStyle: .alert)
            let newGameAction = UIAlertAction(title: "New Game", style: UIAlertAction.Style.default) {
                UIAlertAction in self.startNewGame()
            }
            ac.addAction(newGameAction)
            present(ac, animated: true, completion: nil)
            endGame()
            if(timeTaken < time){
                time = timeTaken
                lowTimeTextField.text = "LOW TIME: \(time)"
            }
        }
    }
    
}

