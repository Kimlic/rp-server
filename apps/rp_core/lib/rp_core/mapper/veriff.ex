defmodule RpCore.Mapper.Veriff do

  @spec photo_atom_to_veriff(atom) :: binary
  def photo_atom_to_veriff(type) do
    case type do
      :face -> "face"
      :back -> "document-back"
      :front -> "document-front"
      _ -> throw "Unknown media type"
    end
  end

  @spec document_quorum_to_veriff(binary) :: binary
  def document_quorum_to_veriff(type) do
    case type do
      "documents.id_card" -> "ID_CARD"
      "documents.passport" -> "PASSPORT"
      "documents.driver_license" -> "DRIVERS_LICENSE"
      "documents.residence_permit_card" -> "RESIDENCE_PERMIT_CARD"
      _ -> throw "Unknown veriff document"
    end
  end
end