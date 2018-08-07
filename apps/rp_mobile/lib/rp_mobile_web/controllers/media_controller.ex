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
  def create(%{assigns: %{version: :v1}} = conn, %{"attestator" => attestator_str, "doc" => doc_str, "type" => type_str, "file" => file}) do
    attestator = case attestator_str do
      "Veriff.me" -> :veriff_me
      _ -> send_resp(conn, :unprocessable_entity, "Unknown attestator")
    end
    
    doc = case doc_str do
      "ID_CARD" -> :id_card
      _ -> send_resp(conn, :unprocessable_entity, "Unknown document")
    end

    type = case type_str do
      "face" -> :face
      "back" -> :back
      "front" -> :front
      _ -> send_resp(conn, :unprocessable_entity, "Unknown media type")
    end

    response = conn.assigns.account_address
    |> RpCore.store_media(doc, attestator, [{type, file}])
    
    case response do
      {:ok, path} -> render(conn, "v1.create.json", media: path)
      {:error, _reason} -> 
        IO.inspect "FINAL RESPONSE: #{inspect response}"
        send_resp(conn, :unprocessable_entity, "Blockchain transaction rejected")
    end
  end
end
