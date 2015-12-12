class User < ActiveRecord::Base


	has_many :tweets, dependent: :destroy
	has_many :active_relationships, class_name: "Relationship",
									foreign_key: "follower_id",
									dependent: :destroy
	

	has_many :passive_relationships, class_name: "Relationship",
									foreign_key: "followed_id",
									dependent: :destroy

	has_many :following, through: :active_relationships, source: :followed
	has_many :followers, through: :passive_relationships, source: :follower


	#in baza de date indexul este case sensitive
	before_save { self.email = email.downcase }


	validates :name					,presence: true
	validates :name					,length: { in: 3..20 }

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

	#trebuie sa returnez din angular si un camp cu numele email_confirmation
	#care o sa fie comparat cu email, verifica daca sunt egale
	#unicitatea emailului este garantata si de indexul unic din baza de date
	validates :email				,presence: true
	validates :email				,length: { in: 7..40 }
	validates :email				,confirmation: true
	validates :email				,uniqueness: { case_sensitive: false }
	validates :email				,format: { with: VALID_EMAIL_REGEX }


	validates :email_confirmation		,presence: true


	#o sa genereze campurile password si password_confirmation
	has_secure_password

	
	acts_as_messageable

	def feed
		#tweets.where("user_id = ?", id)
		tweets.where("user_id IN (?) OR user_id = ?", following_ids, id)
	end

	def follow(fl_user)
		active_relationships.create(followed_id: fl_user.id)
	end

	def unfollow(fl_user)
		active_relationships.find_by(followed_id: fl_user.id).destroy
	end

	def following?(fl_user)
		following.include?(fl_user)
	end

	def mailboxer_email(object)
	 #return the model's email here
	 return :email
	end

	def self.search(query)
	    # where(:title, query) -> This would return an exact match of the query
	    where("name like ? or email like ? or description like ?", "%#{query}%", "%#{query}%", "%#{query}%") 
	  end	


	
end
