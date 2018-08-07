defmodule RpFrontWeb.ErrorHelpers do

  def translate_error({msg, opts}) do
    if count = opts[:count] do
      Gettext.dngettext(RpFrontWeb.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(RpFrontWeb.Gettext, "errors", msg, opts)
    end
  end
end
