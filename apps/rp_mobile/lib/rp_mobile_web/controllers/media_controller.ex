defmodule RpMobileWeb.MediaController do
  @moduledoc :false

  use RpMobileWeb, :controller

  alias RpMobileWeb.FallbackController
  alias RpMobileWeb.Plug.RequestValidator
  alias RpCore.Validator.UploadMediaValidator

  # action_fallback FallbackController

  plug RequestValidator, [validator: UploadMediaValidator] when action in [:create]

  ##### Public #####

  @spec create(Conn.t(), map) :: Conn.t()
  def create(%{assigns: %{version: :v1}} = conn, %{"attestator" => attestator_str, "doc" => doc_str, "type" => photo_type_str, "file" => file}) do
    with {:ok, attestator} <- attestator(attestator_str),
    {:ok, doc} <- document(doc_str),
    {:ok, photo_type} <- photo_type(photo_type_str),
    user_address <- conn.assigns.account_address,
    {:ok, path, session_tag} <- RpCore.store_media(user_address, doc, attestator, [{photo_type, file}]) do
      render(conn, "v1.create.json", media: path)
    else
      {:error, reason} -> send_resp(conn, :unprocessable_entity, reason)
    end
  end

  ##### Private #####

  defp attestator(type) do
    case type do
      "Veriff.me" -> {:ok, :veriff_me}
      _ -> {:error, "Unknown attestator"}
    end
  end

  defp document(type) do
    case type do
      "ID_CARD" -> {:ok, :id_card}
      _ -> {:error, "Unknown document"}
    end
  end

  defp photo_type(type) do
    case type do
      "face" -> {:ok, :face}
      "back" -> {:ok, :back}
      "front" -> {:ok, :front}
      _ -> {:error, "Unknown media type"}
    end
  end
end
