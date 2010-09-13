#ActionMailer::Base.smtp_settings = {
#  :address              => "smtp.jgoggl.es",
#  :port                 => 587,
#  :domain               => "jgoggl.es",
#  :user_name            => "spreads@jgoggl.es",
#  :password             => "jerktown08",
#  :authentication       => "plain",
#}

ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "gmail.com",
  :user_name            => "daniel.weaver",
  :password             => "jerktown08",
  :authentication       => "plain",
}
