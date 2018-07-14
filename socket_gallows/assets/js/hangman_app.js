import HangmanSocket from "./hangman_socket"

window.onload = () => {
  let hangman = new HangmanSocket()
  hangman.connect()
}
