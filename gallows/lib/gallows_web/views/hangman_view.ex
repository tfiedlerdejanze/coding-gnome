defmodule GallowsWeb.HangmanView do
  use GallowsWeb, :view

  @responses %{
    :won => { :success, "You won!" },
    :lost => { :danger, "You lost." },
    :good_guess => { :success, "Good guess!" },
    :bad_guess => { :warning, "Bad guess." },
    :already_used => { :info, "You already tried that one." }
  }

  def display_message(state, turns_left) do
    @responses[state]
    |> alert(turns_left)
  end

  def display_letters(letters) do
    raw("""
    <h2 class="text-center letters">
      #{Enum.join(letters, " ")}
    </h2>
    """)
  end

  def display_form(state, _) when state in [:won, :lost], do: ""
  def display_form(state, conn) do
    form_for(conn, hangman_path(conn, :make_move), [ as: :make_move, method: :put ], fn f ->
      guess_field = text_input(f, :guess, autofocus: true)
      submit_button = submit("Make next move")
      [guess_field, submit_button]
    end)
  end


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
