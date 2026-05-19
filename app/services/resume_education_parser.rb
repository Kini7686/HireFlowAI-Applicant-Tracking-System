class ResumeEducationParser
  def initialize(text)
    @text = text.to_s
  end

  def call
    entries = []
    @text.scan(/(?:B\.?S\.?|B\.?A\.?|M\.?S\.?|MBA|Ph\.?D)[^\n]{0,80}/i).each do |match|
      entries << { degree: match.strip }
    end
    entries.presence || [{ degree: "Not detected", note: "Parsed from resume text" }]
  end
end
