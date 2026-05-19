class ResumeTextExtractor
  def initialize(attachment)
    @attachment = attachment
  end

  def call
    return "" unless @attachment.attached?

    @attachment.open do |file|
      reader = PDF::Reader.new(file.path)
      reader.pages.map(&:text).join("\n")
    end
  rescue StandardError => e
    raise "PDF extraction failed: #{e.message}"
  end
end
