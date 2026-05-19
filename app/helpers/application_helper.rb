module ApplicationHelper
  def btn_primary(extra = nil)
    "inline-flex items-center justify-center gap-2 px-4 py-2.5 rounded-lg bg-indigo-600 text-white text-sm font-semibold shadow-sm hover:bg-indigo-700 focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2 transition #{extra}"
  end

  def btn_secondary(extra = nil)
    "inline-flex items-center justify-center gap-2 px-4 py-2.5 rounded-lg border border-slate-300 bg-white text-slate-700 text-sm font-semibold shadow-sm hover:bg-slate-50 transition #{extra}"
  end

  def btn_ghost(extra = nil)
    "inline-flex items-center text-sm font-medium text-indigo-600 hover:text-indigo-800 transition #{extra}"
  end

  def card_classes
    "bg-white rounded-xl border border-slate-200/80 shadow-sm"
  end

  def input_classes
    "block w-full rounded-lg border-slate-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 text-sm"
  end

  def application_status_color(status)
    {
      "applied" => "bg-sky-100 text-sky-800 ring-sky-200",
      "screening" => "bg-violet-100 text-violet-800 ring-violet-200",
      "interview" => "bg-amber-100 text-amber-800 ring-amber-200",
      "offer" => "bg-emerald-100 text-emerald-800 ring-emerald-200",
      "rejected" => "bg-red-100 text-red-800 ring-red-200",
      "hired" => "bg-teal-100 text-teal-800 ring-teal-200"
    }.fetch(status.to_s, "bg-slate-100 text-slate-800 ring-slate-200")
  end

  def job_status_color(status)
    {
      "draft" => "bg-slate-100 text-slate-700",
      "published" => "bg-emerald-100 text-emerald-800",
      "closed" => "bg-red-100 text-red-800"
    }.fetch(status.to_s, "bg-slate-100 text-slate-700")
  end

  def ats_score_color(score)
    return "text-slate-400" if score.nil?

    if score >= 75
      "text-emerald-600"
    elsif score >= 50
      "text-amber-600"
    else
      "text-red-600"
    end
  end

  def ats_score_bg(score)
    return "bg-slate-100" if score.nil?

    if score >= 75
      "bg-emerald-50 ring-emerald-200"
    elsif score >= 50
      "bg-amber-50 ring-amber-200"
    else
      "bg-red-50 ring-red-200"
    end
  end

  def role_badge_class(role)
    {
      "admin" => "bg-purple-100 text-purple-800",
      "recruiter" => "bg-indigo-100 text-indigo-800",
      "candidate" => "bg-cyan-100 text-cyan-800"
    }.fetch(role.to_s, "bg-slate-100 text-slate-700")
  end
end
