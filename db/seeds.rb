User.where(email: "admin@example.com").first_or_create! do |user|
  user.email = "admin@example.com"
  user.password = "secret"
  user.password_confirmation = "secret"
  user.admin = true
end
