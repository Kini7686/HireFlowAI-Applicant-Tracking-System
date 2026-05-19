class OpenAiFeedbackService
  def initialize(score:, matched_skills:, missing_skills:, job_title:)
    @score = score
    @matched_skills = matched_skills
    @missing_skills = missing_skills
    @job_title = job_title
  end

  def call
    return fallback_feedback unless api_available?

    client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])
    response = client.chat(
      parameters: {
        model: ENV.fetch("OPENAI_MODEL", "gpt-4o-mini"),
        messages: [
          { role: "system", content: "You are an ATS coach. Give concise hiring feedback in 2-3 sentences." },
          { role: "user", content: prompt }
        ],
        max_tokens: 200
      }
    )
    response.dig("choices", 0, "message", "content") || fallback_feedback
  rescue StandardError
    fallback_feedback
  end

  private

  def api_available?
    ENV["OPENAI_API_KEY"].present?
  end

  def prompt
    <<~PROMPT
      Job: #{@job_title}
      ATS Score: #{@score.round(1)}%
      Matched skills: #{@matched_skills.join(', ')}
      Missing skills: #{@missing_skills.join(', ')}
    PROMPT
  end

  def fallback_feedback
    parts = ["ATS match score: #{@score.round(1)}% for #{@job_title}."]
    parts << "Strong overlap on: #{@matched_skills.join(', ')}." if @matched_skills.any?
    parts << "Consider highlighting: #{@missing_skills.join(', ')}." if @missing_skills.any?
    parts << "Strong candidate profile." if @score >= 75
    parts << "Moderate fit — address skill gaps in your application." if @score < 75 && @score >= 50
    parts << "Low match — focus on building required skills." if @score < 50
    parts.join(" ")
  end
end
