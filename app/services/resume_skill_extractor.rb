class ResumeSkillExtractor
  COMMON_SKILLS = %w[
    ruby rails javascript python java react vue angular sql postgresql redis
    docker kubernetes aws azure git rspec sidekiq hotwire stimulus tailwind
    html css node typescript go rust php swift kotlin machine\ learning ai
    leadership communication agile scrum rest api graphql microservices
  ].freeze

  def initialize(text)
    @text = text.to_s.downcase
  end

  def call
    found = COMMON_SKILLS.select { |skill| @text.match?(/\b#{Regexp.escape(skill)}\b/i) }
    found += @text.scan(/\b(ruby on rails|rails 7|postgres|sidekiq)\b/i).flatten.map(&:downcase)
    found.uniq.sort
  end
end
