defmodule GallowsWeb.HangmanView do
  use GallowsWeb, :view

  @responses %{
    :won => { :success, "You won!" },
    :lost => { :danger, "You lost." },
    :good_guess => { :success, "Good guess!" },
    :bad_guess => { :warning, "Bad guess." },
    :already_used => { :info, "you already tried that one." },
    :initializing => { :info, "Started new game. Good luck!" }
  }

  def display_message(state, turns_left) do
    @responses[state]
    |> alert(turns_left)
  end

  def display_letters(letters) do raw("""
    <h2 class="letters">
      #{Enum.join(letters, " ")}
    </h2>
    """)
  end

  def display_used(%{game_state: state}) when state in [:won, :lost], do: ""
  def display_used(%{used: letters}), do: Enum.join(letters, ", ")

  def display_form(state, _) when state in [:won, :lost], do: ""
  def display_form(state, conn) do
    form_for(conn, hangman_path(conn, :make_move), [ as: :make_move, method: :put ], fn f ->
      guess_field = text_input(f, :guess, autofocus: true)
      submit_button = submit("Make next move")
      [guess_field, submit_button]
    end)
  end

  def turn(left, target) when target >= left do
    "opacity: 1"
  end
  def turn(_, _), do: "opacity: 0"

  defp alert({class, message}, turns_left) do
    raw("""
    <div class="alert game-alert alert-#{class}">
      <small class="pull-right">Turns left: #{turns_left}</small>
      #{message}
    </div>
    """)
  end
  defp alert(_, _), do: ""
end
