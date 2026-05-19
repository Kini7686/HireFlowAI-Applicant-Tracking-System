class ResumeExperienceParser
  def initialize(text)
    @text = text.to_s
  end

  def call
    years = @text.scan(/(\d+)\+?\s*years?/i).flatten.map(&:to_i)
    total_years = years.max || estimate_from_roles
    [{ years: total_years, summary: "Estimated from resume content" }]
  end

  private

  def estimate_from_roles
    role_count = @text.scan(/\b(engineer|developer|manager|analyst|designer)\b/i).size
    [role_count, 1].max * 2
  end
end
