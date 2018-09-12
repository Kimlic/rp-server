defmodule RpDashboardWeb.ErrorHelpers do

  def translate_error({msg, opts}) do
    if count = opts[:count] do
      Gettext.dngettext(RpDashboardWeb.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(RpDashboardWeb.Gettext, "errors", msg, opts)
    end
  end
end
