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
  def create(%{assigns: %{version: :v1}} = conn, %{"attestator" => attestator_str, "doc" => doc_str, "type" => photo_type_str, 
  "file" => file, "first_name" => first_name, "last_name" => last_name, "country" => country, "device" => device, "udid" => udid}) do
    with {:ok, attestator} <- attestator(attestator_str),
    {:ok, doc} <- document(doc_str),
    {:ok, photo_type} <- photo_type(photo_type_str),
    user_address <- conn.assigns.account_address,
    {:ok, :created} <- RpCore.store_media(user_address, doc, attestator, first_name, last_name, country, device, udid, [{photo_type, file}]) do
      render(conn, "v1.create.json", media: "created")
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
      "PASSPORT" -> {:ok, :passport}
      "DRIVERS_LICENSE" -> {:ok, :driver_license}
      "RESIDENCE_PERMIT_CARD" -> {:ok, :residence_permit_card}
      _ -> {:error, "Unknown document"}
    end
  end

  defp photo_type(type) do
    case type do
      "face" -> {:ok, :face}
      "document-back" -> {:ok, :back}
      "document-front" -> {:ok, :front}
      _ -> {:error, "Unknown media type"}
    end
  end
end
