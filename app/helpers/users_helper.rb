module UsersHelper
	def gravatar_link(user)

		gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
		gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
		image_tag(gravatar_url, alt: user.name, class: "enter-block img-circle img-responsive")

	end
end
