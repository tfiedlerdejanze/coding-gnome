import {Socket} from "phoenix"

export default class HangmanSocket {
  constructor() {
    this.socket = new Socket("/socket", {})
    this.socket.connect()
  }

  connect() {
    this.setup_channel()
    this.channel.on("tally", tally => {
      console.dir(tally)
    })
  }

  setup_channel() {
    this.channel = this.socket.channel("hangman:game", {})
    this.channel
      .join()
      .receive("ok", resp => {
        console.log("Connected", resp)
        this.fetch_tally()
      })
      .receive("error", resp => {
        console.error("Unable to join", resp)
        throw(resp)
      })
  }

  fetch_tally() {
    this.channel.push("tally", {})
  }
}
