class AtsScoringService
  Result = Struct.new(:score, :matched_skills, :missing_skills, :feedback, keyword_init: true)

  def initialize(resume_profile:, job:)
    @resume_profile = resume_profile
    @job = job
  end

  def call
    required = extract_required_skills
    resume_skills = @resume_profile&.skills_list || []
    matched = match_skills(required, resume_skills)
    missing = missing_skills(required, matched)
    skill_score = skill_overlap_score(required, matched)
    semantic_score = semantic_similarity_placeholder
    experience_score = experience_match_score
    score = calculate_score(skill_score, semantic_score, experience_score)
    feedback = generate_feedback(score, matched, missing)

    Result.new(
      score: score.round(2),
      matched_skills: matched.join(", "),
      missing_skills: missing.join(", "),
      feedback: feedback
    )
  end

  def calculate_score(skill_score, semantic_score, experience_score)
    (skill_score * 0.60) + (semantic_score * 0.25) + (experience_score * 0.15)
  end

  def extract_required_skills
    @job.required_skills_list
  end

  def match_skills(required, resume_skills)
    return [] if required.empty?

    required.select do |skill|
      resume_skills.any? { |rs| rs.include?(skill) || skill.include?(rs) }
    end
  end

  def missing_skills(required, matched)
    required - matched
  end

  private

  def skill_overlap_score(required, matched)
    return 50.0 if required.empty?

    (matched.size.to_f / required.size) * 100.0
  end

  def semantic_similarity_placeholder
    text = @resume_profile&.extracted_text.to_s.downcase
    keywords = @job.description.to_s.downcase.split(/\W+/).select { |w| w.length > 4 }.uniq.first(20)
    return 50.0 if keywords.empty?

    hits = keywords.count { |kw| text.include?(kw) }
    (hits.to_f / keywords.size) * 100.0
  end

  def experience_match_score
    years = Array(@resume_profile&.parsed_experience).sum do |exp|
      exp.is_a?(Hash) ? exp["years"].to_i : 0
    end
    min = @job.min_experience.to_i
    return 100.0 if min.zero?
    return 100.0 if years >= min
    return 50.0 if years >= min - 1

    (years.to_f / min) * 100.0
  end

  def generate_feedback(score, matched, missing)
    OpenAiFeedbackService.new(
      score: score,
      matched_skills: matched,
      missing_skills: missing,
      job_title: @job.title
    ).call
  end
end
