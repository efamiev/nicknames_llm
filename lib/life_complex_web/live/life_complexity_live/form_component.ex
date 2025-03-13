defmodule LifeComplexWeb.LifeComplexityLive.FormComponent do
  use LifeComplexWeb, :live_component

  alias LifeComplex.Research

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage life_complexity records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="life_complexity-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:age]} type="number" label="Age" />
        <.input field={@form[:sex]} type="text" label="Sex" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Life complexity</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{life_complexity: life_complexity} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Research.change_life_complexity(life_complexity))
     end)}
  end

  @impl true
  def handle_event("validate", %{"life_complexity" => life_complexity_params}, socket) do
    changeset = Research.change_life_complexity(socket.assigns.life_complexity, life_complexity_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"life_complexity" => life_complexity_params}, socket) do
    save_life_complexity(socket, socket.assigns.action, life_complexity_params)
  end

  defp save_life_complexity(socket, :edit, life_complexity_params) do
    case Research.update_life_complexity(socket.assigns.life_complexity, life_complexity_params) do
      {:ok, life_complexity} ->
        notify_parent({:saved, life_complexity})

        {:noreply,
         socket
         |> put_flash(:info, "Life complexity updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_life_complexity(socket, :new, life_complexity_params) do
    case Research.create_life_complexity(life_complexity_params) do
      {:ok, life_complexity} ->
        notify_parent({:saved, life_complexity})

        {:noreply,
         socket
         |> put_flash(:info, "Life complexity created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
